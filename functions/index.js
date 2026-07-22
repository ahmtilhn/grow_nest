const admin = require("firebase-admin");
const { setGlobalOptions } = require("firebase-functions/v2");
const { onDocumentCreated, onDocumentUpdated } = require("firebase-functions/v2/firestore");
const { HttpsError, onCall } = require("firebase-functions/v2/https");

admin.initializeApp();
setGlobalOptions({ region: "europe-west4", maxInstances: 2 });

const db = admin.firestore();
const messaging = admin.messaging();

exports.createFamilyInvite = onCall(async (request) => {
  const caller = requireVerifiedCallableUser(request);
  const familyId = cleanRequiredValue(request.data && request.data.familyId, 120, "familyId");
  const familyOwnerUserId = cleanRequiredValue(
    request.data && request.data.familyOwnerUserId,
    128,
    "familyOwnerUserId",
  );
  const invitedEmail = normalizeEmail(request.data && request.data.email);
  if (!invitedEmail) {
    throw new HttpsError("invalid-argument", "Geçerli bir e-posta girin.");
  }
  if (normalizeEmail(caller.email) === invitedEmail) {
    throw new HttpsError("invalid-argument", "Kendi hesabınıza davet gönderemezsiniz.");
  }

  const invitedUser = await authUserByEmail(invitedEmail);
  if (!invitedUser) {
    throw new HttpsError(
      "failed-precondition",
      "Bu e-posta ile kayıtlı bir kullanıcı yok. Önce uygulamaya kayıt olmalı.",
    );
  }

  const familyData = await requireCanInviteToFamily({
    familyId,
    callerUid: caller.uid,
    callerEmail: normalizeEmail(caller.email),
  });
  await assertUserIsNotInAnotherFamily({
    targetUid: invitedUser.uid,
    targetEmail: invitedEmail,
    requestedFamilyId: familyId,
  });

  const invitedByName = cleanOptionalValue(request.data && request.data.invitedByName, 80) ||
    caller.name ||
    caller.email ||
    "MiniAdımlar";
  const roleLabel = cleanOptionalValue(request.data && request.data.roleLabel, 60) || "Ebeveyn";
  const invitedDisplayName = cleanOptionalValue(request.data && request.data.invitedDisplayName, 80) || roleLabel;
  const permissions = normalizePermissions(request.data && request.data.permissions, roleLabel);
  const inviteId = `invite-${familyId}-${invitedEmail}`;
  const inviteRef = db.collection("familyInvites").doc(inviteId);
  const currentInvite = await inviteRef.get();
  if (currentInvite.exists) {
    const data = currentInvite.data() || {};
    if (data.status === "accepted") {
      throw new HttpsError("failed-precondition", "Bu kullanıcı zaten bu aileye eklenmiş.");
    }
    if (data.status === "pending") {
      throw new HttpsError("failed-precondition", "Bu kullanıcı için bekleyen bir davet zaten var.");
    }
  }

  const updatePayload = {
    invitedByName,
    invitedDisplayName,
    roleLabel,
    permissions,
    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
  };
  await inviteRef.set({
    id: inviteId,
    familyId,
    invitedEmail,
    invitedByUserId: caller.uid,
    familyOwnerUserId: familyData.ownerUserId || familyOwnerUserId,
    status: "pending",
    acceptedUserId: admin.firestore.FieldValue.delete(),
    respondedAt: admin.firestore.FieldValue.delete(),
    createdAt: currentInvite.exists
      ? currentInvite.data().createdAt || admin.firestore.FieldValue.serverTimestamp()
      : admin.firestore.FieldValue.serverTimestamp(),
    ...updatePayload,
  }, { merge: true });
  return { id: inviteId, invitedUserId: invitedUser.uid };
});

exports.notifyOnFamilyInviteCreated = onDocumentCreated("familyInvites/{inviteId}", async (event) => {
  const invite = event.data && event.data.data();
  if (!invite || invite.status !== "pending") return;
  const targetUsers = await usersByEmail(invite.invitedEmail);
  await createAndSendNotification({
    familyId: invite.familyId,
    targetUserIds: targetUsers.map((doc) => doc.id),
    createdBy: invite.invitedByUserId,
    type: "family_invite",
    title: "Aile daveti",
    body: `${invite.invitedByName || "Bir aile üyesi"} sizi aile profiline davet etti.`,
    payload: event.params.inviteId,
  });
});

exports.notifyOnFamilyInviteAccepted = onDocumentUpdated("familyInvites/{inviteId}", async (event) => {
  const before = event.data.before.data();
  const after = event.data.after.data();
  if (before.status === after.status) return;
  if (after.status === "declined" && before.status === "pending") {
    await createAndSendNotification({
      familyId: after.familyId,
      targetUserIds: [after.familyOwnerUserId || after.invitedByUserId].filter(Boolean),
      createdBy: after.acceptedUserId,
      type: "family_invite_declined",
      title: "Davet reddedildi",
      body: `${after.invitedDisplayName || after.invitedEmail} aile davetini reddetti.`,
      payload: event.params.inviteId,
    });
    return;
  }
  if (after.status !== "accepted") return;
  await createAndSendNotification({
    familyId: after.familyId,
    targetUserIds: [after.familyOwnerUserId || after.invitedByUserId].filter(Boolean),
    createdBy: after.acceptedUserId,
    type: "family_invite_accepted",
    title: "Davet kabul edildi",
    body: `${after.invitedDisplayName || after.invitedEmail} aile profiline katıldı.`,
    payload: event.params.inviteId,
  });
});

exports.notifyOnTrackerRecordCreated = onDocumentCreated("trackerRecords/{recordId}", async (event) => {
  const record = event.data && event.data.data();
  if (!record || !record.familyId || record.deletedAt) return;
  await notifyFamily({
    familyId: record.familyId,
    actorId: record.createdByUserId,
    visibilityPermission: permissionForRecordType(record.type),
    type: "family_record",
    title: "Yeni aile kaydı",
    body: `${actorName(record.createdByName)} ${record.title || "bir kayıt"} ekledi.`,
    payload: event.params.recordId,
  });
});

exports.notifyOnTrackerRecordUpdated = onDocumentUpdated("trackerRecords/{recordId}", async (event) => {
  const before = event.data.before.data();
  const after = event.data.after.data();
  if (!after.familyId) return;
  if (!before.deletedAt && after.deletedAt) {
    await notifyFamily({
      familyId: after.familyId,
      actorId: after.updatedByUserId,
      visibilityPermission: permissionForRecordType(after.type),
      type: "family_record_deleted",
      title: "Kayıt silindi",
      body: `${actorName(after.updatedByName || after.createdByName)} ${after.title || "bir kaydı"} sildi.`,
      payload: event.params.recordId,
    });
    return;
  }
  if (before.updatedAt && after.updatedAt && before.updatedAt.isEqual(after.updatedAt)) return;
  await notifyFamily({
    familyId: after.familyId,
    actorId: after.updatedByUserId,
    visibilityPermission: permissionForRecordType(after.type),
    type: "family_record_update",
    title: "Aile kaydı güncellendi",
    body: `${actorName(after.updatedByName || after.createdByName)} ${after.title || "bir kaydı"} güncelledi.`,
    payload: event.params.recordId,
  });
});

exports.notifyOnReminderCreated = onDocumentCreated("reminders/{reminderId}", async (event) => {
  const reminder = event.data && event.data.data();
  if (!reminder || !reminder.familyId || reminder.deletedAt) return;
  await notifyFamily({
    familyId: reminder.familyId,
    actorId: reminder.createdByUserId,
    visibilityPermission: permissionForReminderCategory(reminder.category),
    type: "family_reminder",
    title: "Yeni randevu/hatırlatıcı",
    body: `${actorName(reminder.createdByName)} ${reminder.title || "bir hatırlatıcı"} oluşturdu.`,
    payload: event.params.reminderId,
  });
});

exports.notifyOnReminderUpdated = onDocumentUpdated("reminders/{reminderId}", async (event) => {
  const before = event.data.before.data();
  const after = event.data.after.data();
  if (!after.familyId) return;
  if (!before.deletedAt && after.deletedAt) {
    await notifyFamily({
      familyId: after.familyId,
      actorId: after.updatedByUserId,
      visibilityPermission: permissionForReminderCategory(after.category),
      type: "family_reminder_deleted",
      title: "Hatırlatıcı silindi",
      body: `${actorName(after.updatedByName || after.createdByName)} ${after.title || "bir hatırlatıcıyı"} sildi.`,
      payload: event.params.reminderId,
    });
    return;
  }
  if (before.updatedAt && after.updatedAt && before.updatedAt.isEqual(after.updatedAt)) return;
  await notifyFamily({
    familyId: after.familyId,
    actorId: after.updatedByUserId,
    visibilityPermission: permissionForReminderCategory(after.category),
    type: "family_reminder_update",
    title: "Hatırlatıcı güncellendi",
    body: `${actorName(after.updatedByName || after.createdByName)} ${after.title || "bir hatırlatıcıyı"} güncelledi.`,
    payload: event.params.reminderId,
  });
});

exports.notifyOnVaccineUpdated = onDocumentUpdated("vaccineEvents/{vaccineId}", async (event) => {
  const before = event.data.before.data();
  const after = event.data.after.data();
  if (before.updatedAt && after.updatedAt && before.updatedAt.isEqual(after.updatedAt)) return;
  const familyId = await familyIdForBaby(after.babyId);
  if (!familyId) return;
  await notifyFamily({
    familyId,
    actorId: after.updatedByUserId,
    visibilityPermission: "viewVaccines",
    type: "family_vaccine_update",
    title: "Aşı takvimi güncellendi",
    body: `${actorName(after.updatedByName)} ${after.title || "bir aşı kaydını"} güncelledi.`,
    payload: event.params.vaccineId,
  });
});

async function notifyFamily({ familyId, actorId, visibilityPermission, type, title, body, payload }) {
  const targetUserIds = await notificationTargetsForFamily(familyId, actorId, visibilityPermission);
  await createAndSendNotification({
    familyId,
    targetUserIds,
    createdBy: actorId,
    type,
    title,
    body,
    payload,
  });
}

function requireVerifiedCallableUser(request) {
  if (!request.auth || !request.auth.uid) {
    throw new HttpsError("unauthenticated", "Oturum açmanız gerekiyor.");
  }
  if (request.auth.token.email_verified !== true) {
    throw new HttpsError("permission-denied", "E-posta doğrulaması gerekiyor.");
  }
  return {
    uid: request.auth.uid,
    email: request.auth.token.email || "",
    name: cleanOptionalValue(request.auth.token.name, 80),
  };
}

function cleanText(value) {
  return String(value || "")
    .trim()
    .replace(/\s+/g, " ");
}

function cleanRequiredValue(value, maxLength, field) {
  const text = cleanText(value);
  if (!text || text.length > maxLength) {
    throw new HttpsError("invalid-argument", `${field} geçersiz.`);
  }
  return text;
}

function cleanOptionalValue(value, maxLength) {
  if (value === undefined || value === null) return null;
  const text = cleanText(value);
  if (!text) return null;
  if (text.length > maxLength) {
    throw new HttpsError("invalid-argument", "Metin çok uzun.");
  }
  return text;
}

async function authUserByEmail(email) {
  try {
    return await admin.auth().getUserByEmail(email);
  } catch (error) {
    if (error && error.code === "auth/user-not-found") return null;
    throw error;
  }
}

async function requireCanInviteToFamily({ familyId, callerUid, callerEmail }) {
  const family = await db.collection("families").doc(familyId).get();
  if (!family.exists) {
    throw new HttpsError("failed-precondition", "Aile hesabı bulunamadı.");
  }
  const familyData = family.data() || {};
  if (familyData.ownerUserId === callerUid) return familyData;
  const invite = await db.collection("familyInvites")
    .where("familyId", "==", familyId)
    .where("status", "==", "accepted")
    .where("invitedEmail", "==", callerEmail)
    .limit(1)
    .get();
  if (!invite.empty) {
    const permissions = Array.isArray(invite.docs[0].data().permissions)
      ? invite.docs[0].data().permissions
      : [];
    if (permissions.includes("inviteUsers")) return familyData;
  }
  throw new HttpsError("permission-denied", "Bu aileye davet gönderme yetkiniz yok.");
}

async function assertUserIsNotInAnotherFamily({ targetUid, targetEmail, requestedFamilyId }) {
  const checks = await Promise.all([
    db.collection("families").where("ownerUserId", "==", targetUid).limit(1).get(),
    db.collection("families").where("partnerUserIds", "array-contains", targetUid).limit(1).get(),
    db.collection("families").where("partnerUserIds", "array-contains", targetEmail).limit(1).get(),
    db.collection("familyInvites")
      .where("acceptedUserId", "==", targetUid)
      .where("status", "==", "accepted")
      .limit(1)
      .get(),
    db.collection("familyInvites")
      .where("invitedEmail", "==", targetEmail)
      .where("status", "==", "accepted")
      .limit(1)
      .get(),
  ]);
  for (const snapshot of checks) {
    if (snapshot.empty) continue;
    const data = snapshot.docs[0].data() || {};
    const familyId = data.familyId || snapshot.docs[0].id;
    if (familyId === requestedFamilyId) {
      throw new HttpsError("failed-precondition", "Bu kullanıcı zaten bu aileye eklenmiş.");
    }
    throw new HttpsError(
      "failed-precondition",
      "Bu kullanıcı zaten başka bir aileye bağlı. Bir hesap yalnızca bir aileye eklenebilir.",
    );
  }
}

function normalizePermissions(value, roleLabel) {
  const allowed = new Set([
    "viewBaby", "viewFeeding", "viewDiaper", "viewSleep", "viewVaccines",
    "viewAppointments", "viewMemories", "viewNotifications", "viewStats",
    "addFeeding", "addDiaper", "manageSleep", "addGrowth", "addVaccine",
    "addAppointment", "addMemory", "saveArticle", "editRecords",
    "deleteRecords", "inviteUsers", "manageUserPermissions", "removeUsers",
    "editFamily", "editBaby", "deleteFamilyData",
  ]);
  const requested = Array.isArray(value)
    ? value.map((item) => String(item)).filter((item) => allowed.has(item))
    : [];
  if (requested.length > 0) return [...new Set(requested)].slice(0, 25);
  const normalizedRole = cleanText(roleLabel).toLocaleLowerCase("tr-TR");
  if (["bakıcı", "bakici", "caregiver"].includes(normalizedRole)) {
    return [
      "viewBaby", "viewFeeding", "viewDiaper", "viewSleep", "viewAppointments",
      "viewMemories", "viewNotifications", "addFeeding", "addDiaper",
      "manageSleep", "addAppointment", "addMemory",
    ];
  }
  if (["görüntüleyici", "goruntuleyici", "doktor", "view", "viewer"].includes(normalizedRole)) {
    return [
      "viewBaby", "viewFeeding", "viewDiaper", "viewSleep", "viewVaccines",
      "viewAppointments", "viewMemories", "viewNotifications", "viewStats",
    ];
  }
  return [
    "viewBaby", "viewFeeding", "viewDiaper", "viewSleep", "viewVaccines",
    "viewAppointments", "viewMemories", "viewNotifications", "viewStats",
    "addFeeding", "addDiaper", "manageSleep", "addGrowth", "addVaccine",
    "addAppointment", "addMemory", "saveArticle", "editRecords",
    "deleteRecords", "inviteUsers", "editBaby",
  ];
}

async function notificationTargetsForFamily(familyId, actorId, visibilityPermission) {
  const family = await db.collection("families").doc(familyId).get();
  if (!family.exists) return [];
  const familyData = family.data() || {};
  const ownerId = familyData.ownerUserId;
  const usersByEmailCache = new Map();
  const cachedUsersByEmail = async (email) => {
    const normalized = normalizeEmail(email);
    if (!normalized) return [];
    if (!usersByEmailCache.has(normalized)) {
      usersByEmailCache.set(normalized, await usersByEmail(normalized));
    }
    return usersByEmailCache.get(normalized);
  };
  const accepted = await db.collection("familyInvites")
    .where("familyId", "==", familyId)
    .where("status", "==", "accepted")
    .get();
  const targetUserIds = new Set();
  if (ownerId) targetUserIds.add(ownerId);
  const eligibleAcceptedEmails = new Set();
  let eligibleAcceptedCount = 0;
  for (const doc of accepted.docs) {
    const data = doc.data();
    if (!canReceiveFamilyNotifications(data, visibilityPermission)) continue;
    eligibleAcceptedCount += 1;
    if (data.acceptedUserId) {
      targetUserIds.add(data.acceptedUserId);
    }
    const invitedEmail = normalizeEmail(data.invitedEmail);
    if (invitedEmail) eligibleAcceptedEmails.add(invitedEmail);
    if (!data.acceptedUserId) {
      const currentUsers = await cachedUsersByEmail(invitedEmail);
      currentUsers.forEach((user) => targetUserIds.add(user.id));
    }
  }
  const canUsePartnerUidFallback = accepted.docs.length > 0 && eligibleAcceptedCount === accepted.docs.length;
  const partnerUserIds = Array.isArray(familyData.partnerUserIds) ? familyData.partnerUserIds : [];
  for (const partner of partnerUserIds) {
    const partnerKey = String(partner || "").trim();
    if (!partnerKey) continue;
    if (partnerKey.includes("@")) {
      const partnerEmail = normalizeEmail(partnerKey);
      if (!eligibleAcceptedEmails.has(partnerEmail)) continue;
      const currentUsers = await cachedUsersByEmail(partnerEmail);
      currentUsers.forEach((user) => targetUserIds.add(user.id));
    } else if (canUsePartnerUidFallback) {
      targetUserIds.add(partnerKey);
    }
  }
  if (actorId) targetUserIds.delete(actorId);
  return [...targetUserIds];
}

function canReceiveFamilyNotifications(invite, visibilityPermission) {
  const permissions = Array.isArray(invite.permissions) ? invite.permissions : [];
  if (visibilityPermission) return permissions.includes(visibilityPermission);
  return permissions.includes("viewNotifications");
}

async function createAndSendNotification({ familyId, targetUserIds, createdBy, type, title, body, payload }) {
  const cleanTargets = [...new Set((targetUserIds || []).filter(Boolean))];
  if (cleanTargets.length === 0) return;
  const notificationRef = db.collection("notifications").doc();
  const isReadBy = Object.fromEntries(cleanTargets.map((uid) => [uid, false]));
  const notification = {
    notificationId: notificationRef.id,
    familyId,
    targetUserIds: cleanTargets,
    createdBy: createdBy || null,
    type,
    category: "family",
    title,
    body,
    payload: payload || null,
    readBy: [],
    seenBy: [],
    isReadBy,
    isDeleted: false,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
  };
  const batch = db.batch();
  batch.set(notificationRef, notification);
  await batch.commit();
  const tokenEntries = await tokensForUsers(cleanTargets);
  if (tokenEntries.length === 0) {
    console.log(`No FCM tokens for notification ${notificationRef.id} (${type}).`);
    return;
  }
  const data = {
    notificationId: notificationRef.id,
    familyId: familyId || "",
    category: "family",
    type,
    payload: payload || "",
  };
  const alertTokens = tokenEntries
    .filter((entry) => entry.enabled)
    .map((entry) => entry.token);
  const syncTokens = shouldSendWidgetSync(type)
    ? tokenEntries.map((entry) => entry.token)
    : [];
  if (alertTokens.length > 0) {
    await sendFcmAndLog({
      tokens: alertTokens,
      notification: { title, body },
      data,
      android: {
        priority: "high",
        notification: { channelId: "mini_adimlar_soft_chime" },
      },
      apns: {
        payload: {
          aps: {
            sound: "default",
            badge: 1,
            contentAvailable: true,
          },
        },
      },
    }, notificationRef.id, type);
  }
  if (syncTokens.length > 0) {
    await sendFcmAndLog({
      tokens: syncTokens,
      data: {
        ...data,
        syncOnly: "true",
      },
      android: {
        priority: "high",
        collapseKey: familyId ? `family-${familyId}-widget-sync` : "family-widget-sync",
      },
      apns: {
        headers: {
          "apns-priority": "5",
          "apns-push-type": "background",
          "apns-collapse-id": familyId ? `family-${familyId}-widget-sync` : "family-widget-sync",
        },
        payload: {
          aps: {
            contentAvailable: true,
          },
        },
      },
    }, notificationRef.id, `${type}:sync`);
  }
}

async function familyIdForBaby(babyId) {
  if (!babyId) return null;
  const baby = await db.collection("babies").doc(babyId).get();
  return baby.exists ? baby.get("familyId") : null;
}

function permissionForRecordType(type) {
  switch (type) {
    case "feeding":
    case "solidFood":
    case "milkStock":
    case "water":
    case "vitamin":
      return "viewFeeding";
    case "diaper":
      return "viewDiaper";
    case "sleep":
      return "viewSleep";
    case "growth":
      return "viewStats";
    case "memory":
      return "viewMemories";
    case "appointment":
    case "reminder":
    case "health":
      return "viewAppointments";
    default:
      return "viewBaby";
  }
}

function shouldSendWidgetSync(type) {
  return [
    "family_record",
    "family_record_update",
    "family_record_deleted",
  ].includes(type);
}

function permissionForReminderCategory(category) {
  switch (category) {
    case "vaccine":
      return "viewVaccines";
    case "feeding":
    case "water":
    case "vitamin":
      return "viewFeeding";
    case "sleep":
      return "viewSleep";
    case "diaper":
      return "viewDiaper";
    case "appointment":
    case "health":
    case "medicine":
      return "viewAppointments";
    default:
      return "viewNotifications";
  }
}

async function tokensForUsers(userIds) {
  const tokens = new Map();
  for (const chunk of chunks(userIds, 30)) {
    const snapshot = await db.collection("notificationTokens")
      .where("userId", "in", chunk)
      .get();
    snapshot.forEach((doc) => {
      const data = doc.data();
      if (!data.token) return;
      const enabled = data.enabled !== false;
      tokens.set(data.token, (tokens.get(data.token) || false) || enabled);
    });
  }
  return [...tokens.entries()].map(([token, enabled]) => ({ token, enabled }));
}

async function usersByEmail(email) {
  if (!email) return [];
  const normalized = normalizeEmail(email);
  if (!normalized) return [];
  const snapshot = await db.collection("users")
    .where("email", "==", normalized)
    .limit(5)
    .get();
  const users = snapshot.docs.map((doc) => ({ id: doc.id }));
  if (users.length > 0) return users;
  try {
    const user = await admin.auth().getUserByEmail(normalized);
    return user && user.uid ? [{ id: user.uid }] : [];
  } catch (error) {
    if (error && error.code === "auth/user-not-found") return [];
    throw error;
  }
}

async function sendFcmAndLog(message, notificationId, type) {
  const response = await messaging.sendEachForMulticast(message);
  if (response.failureCount === 0) return;
  const failedCodes = response.responses
    .filter((item) => !item.success)
    .map((item) => item.error && item.error.code)
    .filter(Boolean);
  console.warn(
    `FCM notification ${notificationId} (${type}) sent with ${response.failureCount} failures: ${failedCodes.join(", ")}`,
  );
}

function normalizeEmail(email) {
  return String(email || "").trim().toLowerCase();
}

function chunks(items, size) {
  const result = [];
  for (let index = 0; index < items.length; index += size) {
    result.push(items.slice(index, index + size));
  }
  return result;
}

function actorName(name) {
  return String(name || "Bir aile üyesi").trim() || "Bir aile üyesi";
}

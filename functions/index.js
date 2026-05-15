const admin = require("firebase-admin");
const { setGlobalOptions } = require("firebase-functions/v2");
const { onDocumentCreated, onDocumentUpdated } = require("firebase-functions/v2/firestore");

admin.initializeApp();
setGlobalOptions({ region: "europe-west4", maxInstances: 2 });

const db = admin.firestore();
const messaging = admin.messaging();

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

async function notificationTargetsForFamily(familyId, actorId, visibilityPermission) {
  const family = await db.collection("families").doc(familyId).get();
  if (!family.exists) return [];
  const familyData = family.data() || {};
  const ownerId = familyData.ownerUserId;
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
    const currentUsers = await usersByEmail(invitedEmail);
    currentUsers.forEach((user) => targetUserIds.add(user.id));
  }
  const canUsePartnerUidFallback = accepted.docs.length > 0 && eligibleAcceptedCount === accepted.docs.length;
  const partnerUserIds = Array.isArray(familyData.partnerUserIds) ? familyData.partnerUserIds : [];
  for (const partner of partnerUserIds) {
    const partnerKey = String(partner || "").trim();
    if (!partnerKey) continue;
    if (partnerKey.includes("@")) {
      const partnerEmail = normalizeEmail(partnerKey);
      if (!eligibleAcceptedEmails.has(partnerEmail)) continue;
      const currentUsers = await usersByEmail(partnerEmail);
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

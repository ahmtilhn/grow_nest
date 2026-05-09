const admin = require("firebase-admin");
const { onDocumentCreated, onDocumentUpdated } = require("firebase-functions/v2/firestore");

admin.initializeApp();

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
  if (before.status === after.status || after.status !== "accepted") return;
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
  const ownerId = family.get("ownerUserId");
  const accepted = await db.collection("familyInvites")
    .where("familyId", "==", familyId)
    .where("status", "==", "accepted")
    .get();
  const targetUserIds = new Set([ownerId]);
  for (const doc of accepted.docs) {
    const data = doc.data();
    if (!canReceiveFamilyNotifications(data, visibilityPermission)) continue;
    if (data.acceptedUserId) {
      targetUserIds.add(data.acceptedUserId);
    }
    const currentUsers = await usersByEmail(data.invitedEmail);
    currentUsers.forEach((user) => targetUserIds.add(user.id));
  }
  if (actorId) targetUserIds.delete(actorId);
  return [...targetUserIds];
}

function canReceiveFamilyNotifications(invite, visibilityPermission) {
  return Array.isArray(invite.permissions) &&
    invite.permissions.includes("viewNotifications") &&
    (!visibilityPermission || invite.permissions.includes(visibilityPermission));
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
  if (familyId) {
    batch.set(
      db.collection("families").doc(familyId).collection("notifications").doc(notificationRef.id),
      notification,
    );
  }
  await batch.commit();
  const tokens = await tokensForUsers(cleanTargets, familyId);
  if (tokens.length === 0) return;
  await messaging.sendEachForMulticast({
    tokens,
    notification: { title, body },
    data: {
      notificationId: notificationRef.id,
      familyId: familyId || "",
      type,
      payload: payload || "",
    },
    android: {
      priority: "high",
      notification: { channelId: "mini_adimlar_soft_chime" },
    },
    apns: {
      payload: {
        aps: {
          sound: "default",
          badge: 1,
        },
      },
    },
  });
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

function permissionForReminderCategory(category) {
  switch (category) {
    case "vaccine":
      return "viewVaccines";
    case "appointment":
    case "health":
    case "medicine":
      return "viewAppointments";
    default:
      return "viewNotifications";
  }
}

async function tokensForUsers(userIds, familyId) {
  const tokens = new Set();
  for (const chunk of chunks(userIds, 30)) {
    const snapshot = await db.collection("notificationTokens")
      .where("userId", "in", chunk)
      .where("enabled", "==", true)
      .get();
    snapshot.forEach((doc) => {
      const data = doc.data();
      if (data.familyId && familyId && data.familyId !== familyId) return;
      if (data.token) tokens.add(data.token);
    });
  }
  return [...tokens];
}

async function usersByEmail(email) {
  if (!email) return [];
  const normalized = String(email).trim().toLowerCase();
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

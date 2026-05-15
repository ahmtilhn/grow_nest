const assert = require("node:assert/strict");
const fs = require("node:fs");
const path = require("node:path");

const {
  assertFails,
  assertSucceeds,
  initializeTestEnvironment,
} = require("@firebase/rules-unit-testing");
const {
  arrayRemove,
  arrayUnion,
  deleteField,
  doc,
  getDoc,
  setDoc,
  Timestamp,
  updateDoc,
  writeBatch,
} = require("firebase/firestore");

const projectId = "grownest-f4141";
const familyId = "family-owner";
const ownerUid = "owner-uid";
const ownerEmail = "owner@example.com";
const managerUid = "manager-uid";
const managerEmail = "manager@example.com";
const memberUid = "member-uid";
const memberEmail = "member@example.com";
const diaperUid = "diaper-uid";
const diaperEmail = "diaper@example.com";
const feedingUid = "feeding-uid";
const feedingEmail = "feeding@example.com";
const appointmentUid = "appointment-uid";
const appointmentEmail = "appointment@example.com";
const createdAt = Timestamp.fromDate(new Date("2026-02-01T08:00:00.000Z"));
const allPermissions = [
  "viewBaby",
  "viewFeeding",
  "viewDiaper",
  "viewSleep",
  "viewVaccines",
  "viewAppointments",
  "viewMemories",
  "viewNotifications",
  "viewStats",
  "addFeeding",
  "addDiaper",
  "manageSleep",
  "addGrowth",
  "addVaccine",
  "addAppointment",
  "addMemory",
  "saveArticle",
  "editRecords",
  "deleteRecords",
  "inviteUsers",
  "manageUserPermissions",
  "removeUsers",
  "editFamily",
  "editBaby",
  "deleteFamilyData",
];

let testEnv;

function inviteId(email) {
  return `invite-${familyId}-${email}`;
}

function auth(uid, email) {
  return testEnv.authenticatedContext(uid, {
    email,
    email_verified: true,
  });
}

function familyDoc(db) {
  return doc(db, "families", familyId);
}

function inviteDoc(db, email) {
  return doc(db, "familyInvites", inviteId(email));
}

async function seedFamily() {
  await testEnv.withSecurityRulesDisabled(async (context) => {
    const db = context.firestore();
    await setDoc(familyDoc(db), {
      id: familyId,
      ownerUserId: ownerUid,
      activeBabyId: "baby-owner",
      partnerUserIds: [
        managerEmail,
        managerUid,
        memberEmail,
        memberUid,
        diaperEmail,
        diaperUid,
        feedingEmail,
        feedingUid,
        appointmentEmail,
        appointmentUid,
      ],
      createdAt,
      updatedAt: createdAt,
    });
    await setDoc(inviteDoc(db, managerEmail), acceptedInvite({
      email: managerEmail,
      uid: managerUid,
      permissions: [
        "viewBaby",
        "viewNotifications",
        "manageUserPermissions",
        "removeUsers",
        "addVaccine",
      ],
    }));
    await setDoc(inviteDoc(db, memberEmail), acceptedInvite({
      email: memberEmail,
      uid: memberUid,
      permissions: [
        "viewBaby",
        "viewNotifications",
      ],
    }));
    await setDoc(inviteDoc(db, diaperEmail), acceptedInvite({
      email: diaperEmail,
      uid: diaperUid,
      permissions: [
        "viewBaby",
        "viewDiaper",
        "addDiaper",
      ],
    }));
    await setDoc(inviteDoc(db, feedingEmail), acceptedInvite({
      email: feedingEmail,
      uid: feedingUid,
      permissions: [
        "viewBaby",
        "viewFeeding",
        "addFeeding",
      ],
    }));
    await setDoc(inviteDoc(db, appointmentEmail), acceptedInvite({
      email: appointmentEmail,
      uid: appointmentUid,
      permissions: [
        "viewBaby",
        "viewAppointments",
        "addAppointment",
      ],
    }));
  });
}

function acceptedInvite({ email, uid, permissions }) {
  return {
    id: inviteId(email),
    familyId,
    invitedEmail: email,
    invitedByUserId: ownerUid,
    invitedByName: "Owner Parent",
    invitedDisplayName: "Family Member",
    roleLabel: "Caregiver",
    permissions,
    familyOwnerUserId: ownerUid,
    status: "accepted",
    acceptedUserId: uid,
    createdAt,
    updatedAt: createdAt,
    respondedAt: createdAt,
  };
}

function pendingInvite({ email, permissions = ["viewBaby"] }) {
  return {
    id: inviteId(email),
    familyId,
    invitedEmail: email,
    invitedByUserId: ownerUid,
    invitedByName: "Owner Parent",
    invitedDisplayName: "Family Member",
    roleLabel: "Caregiver",
    permissions,
    familyOwnerUserId: ownerUid,
    status: "pending",
    createdAt,
    updatedAt: createdAt,
  };
}

function userProfile({ uid, email, name }) {
  return {
    id: uid,
    email,
    displayName: name,
    emailVerified: true,
    avatarUrl: null,
    birthDate: null,
    phone: null,
    role: "Parent",
    language: "tr",
    theme: "light",
    verification: {
      status: "verified",
      updatedAt: createdAt,
    },
    createdAt,
    updatedAt: createdAt,
  };
}

function familyPayload() {
  return {
    id: familyId,
    ownerUserId: ownerUid,
    activeBabyId: null,
    partnerUserIds: [],
    createdAt,
    updatedAt: createdAt,
  };
}

function acceptMemberBatch(db, email, uid) {
  const batch = writeBatch(db);
  batch.update(inviteDoc(db, email), {
    status: "accepted",
    acceptedUserId: uid,
    respondedAt: Timestamp.now(),
    updatedAt: Timestamp.now(),
  });
  batch.update(familyDoc(db), {
    partnerUserIds: arrayUnion(email, uid),
    updatedAt: Timestamp.now(),
  });
  return batch;
}

function removeMemberBatch(db, email, uid) {
  const batch = writeBatch(db);
  batch.update(inviteDoc(db, email), {
    status: "declined",
    acceptedUserId: deleteField(),
    respondedAt: Timestamp.now(),
    updatedAt: Timestamp.now(),
  });
  batch.update(familyDoc(db), {
    partnerUserIds: arrayRemove(email, uid),
    updatedAt: Timestamp.now(),
  });
  return batch;
}

function permissionUpdate({ permissions = ["viewBaby", "viewNotifications"] } = {}) {
  return {
    invitedDisplayName: "Updated Member",
    roleLabel: "Updated Role",
    permissions,
    updatedAt: Timestamp.now(),
  };
}

function trackerRecord({ id, type, uid }) {
  return {
    id,
    familyId,
    babyId: "baby-owner",
    createdByUserId: uid,
    createdByName: "Family Member",
    updatedByUserId: uid,
    updatedByName: "Family Member",
    type,
    title: type === "diaper" ? "Diaper change" : "Bottle",
    value: type === "diaper" ? "Wet" : "90 ml",
    note: null,
    occurredAt: Timestamp.now(),
    createdAt: Timestamp.now(),
    updatedAt: Timestamp.now(),
    deletedAt: null,
  };
}

function reminder({ id, category, uid }) {
  return {
    id,
    familyId,
    title: category === "vaccine" ? "Vaccine" : "Appointment",
    category,
    time: Timestamp.now(),
    frequency: "once",
    notes: null,
    isActive: true,
    createdByUserId: uid,
    createdByName: "Family Member",
    updatedByUserId: uid,
    updatedByName: "Family Member",
    createdAt: Timestamp.now(),
    updatedAt: Timestamp.now(),
    deletedAt: null,
  };
}

async function run() {
  testEnv = await initializeTestEnvironment({
    projectId,
    firestore: {
      rules: fs.readFileSync(
        path.join(__dirname, "..", "..", "firestore.rules"),
        "utf8",
      ),
    },
  });

  try {
    const ownerDb = auth(ownerUid, ownerEmail).firestore();
    const memberDb = auth(memberUid, memberEmail).firestore();
    await assertSucceeds(setDoc(
      doc(ownerDb, "users", ownerUid),
      userProfile({ uid: ownerUid, email: ownerEmail, name: "Owner Parent" }),
    ));
    await assertSucceeds(setDoc(
      familyDoc(ownerDb),
      familyPayload(),
    ));
    await assertSucceeds(setDoc(
      doc(memberDb, "users", memberUid),
      userProfile({ uid: memberUid, email: memberEmail, name: "Family Member" }),
    ));
    await assertSucceeds(setDoc(
      inviteDoc(ownerDb, memberEmail),
      pendingInvite({ email: memberEmail, permissions: ["viewBaby"] }),
    ));
    await assertSucceeds(acceptMemberBatch(memberDb, memberEmail, memberUid).commit());
    let family = await getDoc(familyDoc(memberDb));
    assert(family.data().partnerUserIds.includes(memberEmail));
    assert(family.data().partnerUserIds.includes(memberUid));
    await assertSucceeds(removeMemberBatch(ownerDb, memberEmail, memberUid).commit());
    family = await getDoc(familyDoc(ownerDb));
    assert(!family.data().partnerUserIds.includes(memberEmail));
    assert(!family.data().partnerUserIds.includes(memberUid));
    await assertSucceeds(updateDoc(inviteDoc(ownerDb, memberEmail), {
      invitedByName: "Owner Parent",
      invitedDisplayName: "Family Member",
      roleLabel: "Caregiver",
      permissions: ["viewBaby", "viewNotifications"],
      status: "pending",
      acceptedUserId: deleteField(),
      respondedAt: deleteField(),
      updatedAt: Timestamp.now(),
    }));
    const resentInvite = await getDoc(inviteDoc(ownerDb, memberEmail));
    assert.equal(resentInvite.data().status, "pending");
    assert.equal(resentInvite.data().acceptedUserId, undefined);
    assert.equal(resentInvite.data().respondedAt, undefined);
    await assertSucceeds(acceptMemberBatch(memberDb, memberEmail, memberUid).commit());
    family = await getDoc(familyDoc(memberDb));
    assert(family.data().partnerUserIds.includes(memberEmail));
    assert(family.data().partnerUserIds.includes(memberUid));

    await testEnv.clearFirestore();
    await seedFamily();

    const managerDb = auth(managerUid, managerEmail).firestore();
    await assertFails(updateDoc(
      inviteDoc(memberDb, managerEmail),
      permissionUpdate({ permissions: ["viewBaby"] }),
    ));

    await assertSucceeds(updateDoc(
      inviteDoc(ownerDb, memberEmail),
      permissionUpdate({ permissions: allPermissions }),
    ));
    let updatedInvite = await getDoc(inviteDoc(ownerDb, memberEmail));
    assert.deepEqual(updatedInvite.data().permissions, allPermissions);

    await assertSucceeds(updateDoc(
      inviteDoc(managerDb, memberEmail),
      permissionUpdate({ permissions: ["viewBaby", "viewDiaper", "addDiaper"] }),
    ));
    updatedInvite = await getDoc(inviteDoc(managerDb, memberEmail));
    assert.deepEqual(updatedInvite.data().permissions, [
      "viewBaby",
      "viewDiaper",
      "addDiaper",
    ]);
    await assertFails(updateDoc(
      inviteDoc(managerDb, managerEmail),
      permissionUpdate({ permissions: allPermissions }),
    ));
    await assertFails(updateDoc(inviteDoc(ownerDb, memberEmail), {
      ...permissionUpdate(),
      permissions: [...allPermissions, "extraPermission"],
    }));

    await assertSucceeds(removeMemberBatch(ownerDb, memberEmail, memberUid).commit());
    family = await getDoc(familyDoc(ownerDb));
    assert(!family.data().partnerUserIds.includes(memberEmail));
    assert(!family.data().partnerUserIds.includes(memberUid));

    await seedFamily();

    await assertSucceeds(removeMemberBatch(managerDb, memberEmail, memberUid).commit());
    family = await getDoc(familyDoc(managerDb));
    assert(!family.data().partnerUserIds.includes(memberEmail));
    assert(!family.data().partnerUserIds.includes(memberUid));

    const unsafeBatch = writeBatch(managerDb);
    unsafeBatch.update(familyDoc(managerDb), {
      partnerUserIds: arrayUnion("new-member@example.com"),
      updatedAt: Timestamp.now(),
    });
    await assertFails(unsafeBatch.commit());

    const diaperDb = auth(diaperUid, diaperEmail).firestore();
    await assertSucceeds(setDoc(
      doc(diaperDb, "trackerRecords", "record-diaper-allowed"),
      trackerRecord({ id: "record-diaper-allowed", type: "diaper", uid: diaperUid }),
    ));
    await assertFails(setDoc(
      doc(diaperDb, "trackerRecords", "record-feeding-denied"),
      trackerRecord({ id: "record-feeding-denied", type: "feeding", uid: diaperUid }),
    ));

    const feedingDb = auth(feedingUid, feedingEmail).firestore();
    await assertSucceeds(setDoc(
      doc(feedingDb, "trackerRecords", "record-solid-food-allowed"),
      trackerRecord({ id: "record-solid-food-allowed", type: "solidFood", uid: feedingUid }),
    ));
    await assertFails(setDoc(
      doc(feedingDb, "trackerRecords", "record-health-denied"),
      trackerRecord({ id: "record-health-denied", type: "health", uid: feedingUid }),
    ));

    const appointmentDb = auth(appointmentUid, appointmentEmail).firestore();
    await assertSucceeds(setDoc(
      doc(appointmentDb, "trackerRecords", "record-health-allowed"),
      trackerRecord({ id: "record-health-allowed", type: "health", uid: appointmentUid }),
    ));
    await assertSucceeds(setDoc(
      doc(appointmentDb, "reminders", "reminder-health-allowed"),
      reminder({ id: "reminder-health-allowed", category: "health", uid: appointmentUid }),
    ));
    await assertFails(setDoc(
      doc(appointmentDb, "reminders", "reminder-vaccine-denied"),
      reminder({ id: "reminder-vaccine-denied", category: "vaccine", uid: appointmentUid }),
    ));

    await assertSucceeds(setDoc(
      doc(managerDb, "reminders", "reminder-vaccine-allowed"),
      reminder({ id: "reminder-vaccine-allowed", category: "vaccine", uid: managerUid }),
    ));
  } finally {
    await testEnv.cleanup();
  }
}

run().catch((error) => {
  console.error(error);
  process.exit(1);
});

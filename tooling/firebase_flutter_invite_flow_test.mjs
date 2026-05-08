import { initializeApp } from "firebase/app";
import {
  createUserWithEmailAndPassword,
  getAuth,
  signInWithEmailAndPassword,
} from "firebase/auth";
import {
  Timestamp,
  doc,
  deleteField,
  getFirestore,
  serverTimestamp,
  setDoc,
  updateDoc,
} from "firebase/firestore";

const app = initializeApp({
  apiKey: "AIzaSyD0aMyjo-GbgLaC8QtJZcMLXqbsTnHbuqg",
  authDomain: "grownest-f4141.firebaseapp.com",
  projectId: "grownest-f4141",
  appId: "1:496422631569:web:d00dd6cf1fad1cb333e730",
  messagingSenderId: "496422631569",
});

const auth = getAuth(app);
const db = getFirestore(app);

const runId = new Date().toISOString().replace(/[-:.TZ]/g, "").slice(0, 14);
const password = `Codex-${runId}-123456`;
const ownerEmail = `codex.flutter.owner.${runId}@example.com`;
const firstInviteeEmail = `codex.flutter.invitee.1.${runId}@example.com`;
const secondInviteeEmail = `codex.flutter.invitee.2.${runId}@example.com`;

async function createOrSignIn(email) {
  try {
    return (await createUserWithEmailAndPassword(auth, email, password)).user;
  } catch (error) {
    if (error.code !== "auth/email-already-in-use") throw error;
    return (await signInWithEmailAndPassword(auth, email, password)).user;
  }
}

async function asUser(email, action) {
  await signInWithEmailAndPassword(auth, email, password);
  return action(auth.currentUser);
}

async function syncUserLikeFlutter(user, localCreatedAt) {
  const ref = doc(db, "users", user.uid);
  const updatePayload = {
    displayName: "Flutter Owner",
    emailVerified: false,
    verification: { status: "pending", updatedAt: serverTimestamp() },
    avatarUrl: null,
    birthDate: null,
    phone: null,
    role: "Ebeveyn",
    language: "tr",
    theme: "light",
    updatedAt: serverTimestamp(),
  };
  const createPayload = {
    id: user.uid,
    email: user.email.trim().toLowerCase(),
    createdAt: Timestamp.fromDate(localCreatedAt),
    ...updatePayload,
  };
  await setCreatePayloadThenMutable(ref, createPayload, updatePayload);
}

async function syncFamilyLikeFlutter(user, familyId, babyId, localCreatedAt) {
  const ref = doc(db, "families", familyId);
  console.log(JSON.stringify({
    uid: user.uid,
    familyId,
    babyId,
    uidLength: user.uid.length,
    familyIdLength: familyId.length,
    babyIdLength: babyId.length,
  }));
  const updatePayload = {
    partnerUserIds: [],
    activeBabyId: babyId,
    updatedAt: serverTimestamp(),
  };
  const createPayload = {
    id: familyId,
    ownerUserId: user.uid,
    createdAt: Timestamp.fromDate(localCreatedAt),
    ...updatePayload,
  };
  await setCreatePayloadThenMutable(ref, createPayload, updatePayload);
}

async function syncBabyLikeFlutter(familyId, babyId, localCreatedAt) {
  const ref = doc(db, "babies", babyId);
  const updatePayload = {
    name: "Flutter Bebek",
    birthDate: Timestamp.fromDate(new Date("2026-01-01T00:00:00Z")),
    gender: null,
    birthWeight: null,
    birthHeight: null,
    birthHeadCircumference: null,
    currentWeight: null,
    currentHeight: null,
    currentHeadCircumference: null,
    updatedAt: serverTimestamp(),
  };
  const createPayload = {
    id: babyId,
    familyId,
    createdAt: Timestamp.fromDate(localCreatedAt),
    ...updatePayload,
  };
  await setCreatePayloadThenMutable(ref, createPayload, updatePayload);
}

async function setCreatePayloadThenMutable(ref, createPayload, updatePayload) {
  try {
    await setDoc(ref, createPayload);
  } catch (error) {
    try {
      await setDoc(ref, updatePayload, { merge: true });
    } catch (_) {
      throw error;
    }
  }
}

async function addFamilyPartnerLikeFlutter({
  familyId,
  familyOwnerUserId,
  invitedEmail,
  invitedByUserId,
}) {
  const normalized = invitedEmail.trim().toLowerCase();
  const inviteId = `invite-${familyId}-${normalized}`;
  const ref = doc(db, "familyInvites", inviteId);
  const updatePayload = {
    invitedByName: "Flutter Owner",
    invitedDisplayName: "Bakıcı Test",
    roleLabel: "Bakıcı",
    permissions: [
      "viewBaby",
      "viewFeeding",
      "viewNotifications",
      "addFeeding",
    ],
    updatedAt: serverTimestamp(),
  };
  const createPayload = {
    id: inviteId,
    familyId,
    invitedEmail: normalized,
    invitedByUserId,
    ...updatePayload,
    familyOwnerUserId,
    status: "pending",
    createdAt: serverTimestamp(),
  };
  try {
    await setDoc(ref, createPayload);
  } catch (error) {
    try {
      await updateDoc(ref, updatePayload);
    } catch (_) {
      try {
        await updateDoc(ref, {
          ...updatePayload,
          status: "pending",
          acceptedUserId: deleteField(),
          respondedAt: deleteField(),
        });
      } catch (_) {
        throw error;
      }
    }
  }
  return inviteId;
}

async function main() {
  const owner = await createOrSignIn(ownerEmail);
  await createOrSignIn(firstInviteeEmail);
  await createOrSignIn(secondInviteeEmail);

  const familyId = `family-${owner.uid}`;
  const babyId = `baby-${owner.uid}`;

  await asUser(ownerEmail, async (user) => {
    console.log("flutter-like: first sync and invite");
    console.log("flutter-like: sync user");
    await syncUserLikeFlutter(user, new Date("2026-01-02T00:00:00Z"));
    console.log("flutter-like: sync family");
    await syncFamilyLikeFlutter(
      user,
      familyId,
      babyId,
      new Date("2026-01-03T00:00:00Z"),
    );
    console.log("flutter-like: sync baby");
    await syncBabyLikeFlutter(
      familyId,
      babyId,
      new Date("2026-01-04T00:00:00Z"),
    );
    console.log("flutter-like: add first invite");
    await addFamilyPartnerLikeFlutter({
      familyId,
      familyOwnerUserId: user.uid,
      invitedEmail: firstInviteeEmail,
      invitedByUserId: user.uid,
    });

    console.log("flutter-like: resync existing docs with different local dates");
    console.log("flutter-like: resync user");
    await syncUserLikeFlutter(user, new Date("2030-01-02T00:00:00Z"));
    console.log("flutter-like: resync family");
    await syncFamilyLikeFlutter(
      user,
      familyId,
      babyId,
      new Date("2030-01-03T00:00:00Z"),
    );
    console.log("flutter-like: resync baby");
    await syncBabyLikeFlutter(
      familyId,
      babyId,
      new Date("2030-01-04T00:00:00Z"),
    );
    console.log("flutter-like: add second invite");
    await addFamilyPartnerLikeFlutter({
      familyId,
      familyOwnerUserId: user.uid,
      invitedEmail: secondInviteeEmail,
      invitedByUserId: user.uid,
    });
  });

  console.log(JSON.stringify({
    ok: true,
    runId,
    ownerEmail,
    firstInviteeEmail,
    secondInviteeEmail,
    familyId,
  }, null, 2));
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

import { initializeApp } from "firebase/app";
import {
  createUserWithEmailAndPassword,
  getAuth,
  signInWithEmailAndPassword,
} from "firebase/auth";
import {
  Timestamp,
  doc,
  getDoc,
  getFirestore,
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
const ownerEmail = `codex.sdk.owner.${runId}@example.com`;
const inviteeEmail = `codex.sdk.invitee.${runId}@example.com`;

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

async function main() {
  const owner = await createOrSignIn(ownerEmail);
  const invitee = await createOrSignIn(inviteeEmail);
  const familyId = `family-sdk-${runId}-${owner.uid}`;
  const babyId = `baby-sdk-${runId}`;
  const inviteId = `invite-${familyId}-${inviteeEmail}`;
  const now = Timestamp.now();

  await asUser(ownerEmail, async (user) => {
    console.log("sdk: owner writes user/family/baby/invite");
    await setDoc(doc(db, "users", user.uid), {
      id: user.uid,
      email: ownerEmail,
      displayName: "SDK Owner",
      emailVerified: false,
      avatarUrl: null,
      birthDate: null,
      phone: null,
      role: "Ebeveyn",
      language: "tr",
      theme: "light",
      verification: { status: "test" },
      createdAt: now,
      updatedAt: Timestamp.now(),
    });
    await setDoc(doc(db, "families", familyId), {
      id: familyId,
      ownerUserId: user.uid,
      partnerUserIds: [],
      activeBabyId: babyId,
      createdAt: now,
      updatedAt: Timestamp.now(),
    });
    await setDoc(doc(db, "babies", babyId), {
      id: babyId,
      familyId,
      name: "SDK Bebek",
      birthDate: Timestamp.fromDate(new Date("2026-01-01T00:00:00Z")),
      gender: null,
      birthWeight: null,
      birthHeight: null,
      birthHeadCircumference: null,
      currentWeight: null,
      currentHeight: null,
      currentHeadCircumference: null,
      createdAt: now,
      updatedAt: Timestamp.now(),
    });
    await setDoc(doc(db, "familyInvites", inviteId), {
      id: inviteId,
      familyId,
      invitedEmail: inviteeEmail,
      invitedByUserId: user.uid,
      invitedByName: "SDK Owner",
      invitedDisplayName: "SDK Görüntüleyici",
      roleLabel: "Görüntüleyici",
      permissions: ["viewBaby", "viewFeeding"],
      familyOwnerUserId: user.uid,
      status: "pending",
      createdAt: now,
      updatedAt: Timestamp.now(),
    });
  });

  await asUser(inviteeEmail, async (user) => {
    console.log("sdk: invitee writes user and reads invite");
    await setDoc(doc(db, "users", user.uid), {
      id: user.uid,
      email: inviteeEmail,
      displayName: "SDK Invitee",
      emailVerified: false,
      avatarUrl: null,
      birthDate: null,
      phone: null,
      role: "Bakıcı",
      language: "tr",
      theme: "light",
      verification: { status: "test" },
      createdAt: now,
      updatedAt: Timestamp.now(),
    });
    const pending = await getDoc(doc(db, "familyInvites", inviteId));
    if (!pending.exists()) throw new Error("Invitee cannot read pending invite");
    console.log("sdk: invitee accepts invite");
    await updateDoc(doc(db, "familyInvites", inviteId), {
      status: "accepted",
      acceptedUserId: user.uid,
      respondedAt: Timestamp.now(),
      updatedAt: Timestamp.now(),
    });
    const family = await getDoc(doc(db, "families", familyId));
    if (!family.exists()) throw new Error("Invitee cannot read accepted family");
  });

  await asUser(ownerEmail, async () => {
    console.log("sdk: owner updates invite permissions");
    await updateDoc(doc(db, "familyInvites", inviteId), {
      invitedDisplayName: "SDK Bakıcı",
      roleLabel: "Bakıcı",
      permissions: ["viewBaby", "viewFeeding", "addFeeding"],
      updatedAt: Timestamp.now(),
    });
  });

  await asUser(inviteeEmail, async (user) => {
    console.log("sdk: invitee writes allowed tracker record");
    const recordId = `sdk-record-${runId}`;
    await setDoc(doc(db, "trackerRecords", recordId), {
      id: recordId,
      familyId,
      babyId,
      createdByUserId: user.uid,
      createdByName: "SDK Bakıcı",
      updatedByUserId: user.uid,
      updatedByName: "SDK Bakıcı",
      type: "feeding",
      title: "Biberon",
      value: "120 ml",
      note: null,
      occurredAt: Timestamp.now(),
      createdAt: Timestamp.now(),
      updatedAt: Timestamp.now(),
      deletedAt: null,
    });
  });

  console.log(JSON.stringify({
    ok: true,
    runId,
    ownerEmail,
    inviteeEmail,
    familyId,
    inviteId,
  }, null, 2));
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

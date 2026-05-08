const apiKey = "AIzaSyD0aMyjo-GbgLaC8QtJZcMLXqbsTnHbuqg";
const projectId = "grownest-f4141";
const firestoreBase = `https://firestore.googleapis.com/v1/projects/${projectId}/databases/(default)/documents`;

const runId = new Date().toISOString().replace(/[-:.TZ]/g, "").slice(0, 14);
const password = `Codex-${runId}-123456`;
const ownerEmail = `codex.owner.${runId}@example.com`;
const inviteeEmail = `codex.invitee.${runId}@example.com`;

function stringValue(value) {
  return { stringValue: String(value) };
}

function boolValue(value) {
  return { booleanValue: Boolean(value) };
}

function timestampValue(value = new Date()) {
  return { timestampValue: value.toISOString() };
}

function arrayValue(values) {
  return { arrayValue: { values } };
}

function docFields(fields) {
  return { fields };
}

function docUrl(collection, id) {
  return `${firestoreBase}/${collection}/${encodeURIComponent(id)}`;
}

function bearer(token) {
  return { Authorization: `Bearer ${token}` };
}

async function requestJson(url, options = {}) {
  const response = await fetch(url, {
    ...options,
    headers: {
      "Content-Type": "application/json",
      ...(options.headers || {}),
    },
  });
  const text = await response.text();
  const body = text ? JSON.parse(text) : null;
  return { response, body };
}

async function authRequest(endpoint, payload) {
  const { response, body } = await requestJson(
    `https://identitytoolkit.googleapis.com/v1/accounts:${endpoint}?key=${apiKey}`,
    { method: "POST", body: JSON.stringify(payload) },
  );
  if (!response.ok) {
    throw new Error(`${endpoint} failed: ${JSON.stringify(body)}`);
  }
  return body;
}

async function createOrSignIn(email) {
  const payload = { email, password, returnSecureToken: true };
  const signup = await requestJson(
    `https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=${apiKey}`,
    { method: "POST", body: JSON.stringify(payload) },
  );
  if (signup.response.ok) return signup.body;
  if (signup.body?.error?.message !== "EMAIL_EXISTS") {
    throw new Error(`signUp failed: ${JSON.stringify(signup.body)}`);
  }
  return authRequest("signInWithPassword", payload);
}

async function patchDoc(collection, id, token, fields) {
  return requestJson(docUrl(collection, id), {
    method: "PATCH",
    headers: bearer(token),
    body: JSON.stringify(docFields(fields)),
  });
}

async function updateDoc(collection, id, token, fields) {
  const mask = Object.keys(fields)
    .map((field) => `updateMask.fieldPaths=${encodeURIComponent(field)}`)
    .join("&");
  return requestJson(`${docUrl(collection, id)}?${mask}`, {
    method: "PATCH",
    headers: bearer(token),
    body: JSON.stringify(docFields(fields)),
  });
}

async function getDoc(collection, id, token) {
  return requestJson(docUrl(collection, id), {
    method: "GET",
    headers: bearer(token),
  });
}

async function assertOk(label, result) {
  if (!result.response.ok) {
    throw new Error(`${label} failed: ${result.response.status} ${JSON.stringify(result.body)}`);
  }
  return result.body;
}

async function assertDenied(label, result) {
  if (result.response.status !== 403) {
    throw new Error(`${label} should be denied, got ${result.response.status} ${JSON.stringify(result.body)}`);
  }
}

async function queryNotifications(token, familyId, userId) {
  return requestJson(`${firestoreBase}:runQuery`, {
    method: "POST",
    headers: bearer(token),
    body: JSON.stringify({
      structuredQuery: {
        from: [{ collectionId: "notifications" }],
        where: {
          compositeFilter: {
            op: "AND",
            filters: [
              {
                fieldFilter: {
                  field: { fieldPath: "familyId" },
                  op: "EQUAL",
                  value: stringValue(familyId),
                },
              },
              {
                fieldFilter: {
                  field: { fieldPath: "targetUserIds" },
                  op: "ARRAY_CONTAINS",
                  value: stringValue(userId),
                },
              },
              {
                fieldFilter: {
                  field: { fieldPath: "isDeleted" },
                  op: "EQUAL",
                  value: boolValue(false),
                },
              },
            ],
          },
        },
      },
    }),
  });
}

async function main() {
  const owner = await createOrSignIn(ownerEmail);
  const invitee = await createOrSignIn(inviteeEmail);
  const now = new Date();
  const familyId = `family-live-${runId}-${owner.localId}`;
  const babyId = `baby-live-${runId}`;
  const inviteId = `invite-${familyId}-${inviteeEmail}`;
  const fakeToken = `test-token-${runId}-${"x".repeat(64)}`;

  await assertOk(
    "owner user write",
    await patchDoc("users", owner.localId, owner.idToken, {
      id: stringValue(owner.localId),
      email: stringValue(ownerEmail),
      displayName: stringValue("Codex Owner"),
      emailVerified: boolValue(false),
      avatarUrl: { nullValue: null },
      birthDate: { nullValue: null },
      phone: { nullValue: null },
      role: stringValue("Ebeveyn"),
      language: stringValue("tr"),
      theme: stringValue("light"),
      verification: { mapValue: { fields: { status: stringValue("test") } } },
      createdAt: timestampValue(now),
      updatedAt: timestampValue(),
    }),
  );
  await assertOk(
    "invitee user write",
    await patchDoc("users", invitee.localId, invitee.idToken, {
      id: stringValue(invitee.localId),
      email: stringValue(inviteeEmail),
      displayName: stringValue("Codex Invitee"),
      emailVerified: boolValue(false),
      avatarUrl: { nullValue: null },
      birthDate: { nullValue: null },
      phone: { nullValue: null },
      role: stringValue("Bakıcı"),
      language: stringValue("tr"),
      theme: stringValue("light"),
      verification: { mapValue: { fields: { status: stringValue("test") } } },
      createdAt: timestampValue(now),
      updatedAt: timestampValue(),
    }),
  );
  await assertOk(
    "family write",
    await patchDoc("families", familyId, owner.idToken, {
      id: stringValue(familyId),
      ownerUserId: stringValue(owner.localId),
      partnerUserIds: arrayValue([]),
      activeBabyId: stringValue(babyId),
      createdAt: timestampValue(now),
      updatedAt: timestampValue(),
    }),
  );
  await assertOk(
    "baby write",
    await patchDoc("babies", babyId, owner.idToken, {
      id: stringValue(babyId),
      familyId: stringValue(familyId),
      name: stringValue("Test Bebek"),
      birthDate: timestampValue(new Date("2026-01-01T00:00:00Z")),
      gender: { nullValue: null },
      birthWeight: { nullValue: null },
      birthHeight: { nullValue: null },
      birthHeadCircumference: { nullValue: null },
      currentWeight: { nullValue: null },
      currentHeight: { nullValue: null },
      currentHeadCircumference: { nullValue: null },
      createdAt: timestampValue(now),
      updatedAt: timestampValue(),
    }),
  );
  await assertOk(
    "notification token write",
    await patchDoc("notificationTokens", `${invitee.localId}-codex-${runId}`, invitee.idToken, {
      id: stringValue(`${invitee.localId}-codex-${runId}`),
      userId: stringValue(invitee.localId),
      familyId: { nullValue: null },
      token: stringValue(fakeToken),
      platform: stringValue("codex-rest-test"),
      enabled: boolValue(true),
      updatedAt: timestampValue(),
    }),
  );
  await assertOk(
    "invite write",
    await patchDoc("familyInvites", inviteId, owner.idToken, {
      id: stringValue(inviteId),
      familyId: stringValue(familyId),
      invitedEmail: stringValue(inviteeEmail),
      invitedByUserId: stringValue(owner.localId),
      invitedByName: stringValue("Codex Owner"),
      invitedDisplayName: stringValue("Görüntüleyici Test"),
      roleLabel: stringValue("Görüntüleyici"),
      permissions: arrayValue([stringValue("viewBaby"), stringValue("viewFeeding")]),
      familyOwnerUserId: stringValue(owner.localId),
      status: stringValue("pending"),
      createdAt: timestampValue(now),
      updatedAt: timestampValue(),
    }),
  );

  await assertOk("invitee can read pending invite", await getDoc("familyInvites", inviteId, invitee.idToken));
  await assertDenied(
    "invitee cannot write family record before accepting",
    await patchDoc("trackerRecords", `record-denied-before-${runId}`, invitee.idToken, {
      id: stringValue(`record-denied-before-${runId}`),
      familyId: stringValue(familyId),
      babyId: stringValue(babyId),
      createdByUserId: stringValue(invitee.localId),
      createdByName: stringValue("Codex Invitee"),
      updatedByUserId: stringValue(invitee.localId),
      updatedByName: stringValue("Codex Invitee"),
      type: stringValue("feeding"),
      title: stringValue("Biberon"),
      value: stringValue("90 ml"),
      note: { nullValue: null },
      occurredAt: timestampValue(),
      createdAt: timestampValue(),
      updatedAt: timestampValue(),
      deletedAt: { nullValue: null },
    }),
  );

  const acceptedAt = new Date();
  await assertOk(
    "invite accept",
    await updateDoc("familyInvites", inviteId, invitee.idToken, {
      status: stringValue("accepted"),
      acceptedUserId: stringValue(invitee.localId),
      respondedAt: timestampValue(acceptedAt),
      updatedAt: timestampValue(),
    }),
  );
  await assertOk("invitee can read accepted family", await getDoc("families", familyId, invitee.idToken));
  await assertDenied(
    "invitee cannot add feeding without addFeeding permission",
    await patchDoc("trackerRecords", `record-denied-permission-${runId}`, invitee.idToken, {
      id: stringValue(`record-denied-permission-${runId}`),
      familyId: stringValue(familyId),
      babyId: stringValue(babyId),
      createdByUserId: stringValue(invitee.localId),
      createdByName: stringValue("Codex Invitee"),
      updatedByUserId: stringValue(invitee.localId),
      updatedByName: stringValue("Codex Invitee"),
      type: stringValue("feeding"),
      title: stringValue("Biberon"),
      value: stringValue("90 ml"),
      note: { nullValue: null },
      occurredAt: timestampValue(),
      createdAt: timestampValue(),
      updatedAt: timestampValue(),
      deletedAt: { nullValue: null },
    }),
  );

  await assertOk(
    "owner updates invite permissions",
    await updateDoc("familyInvites", inviteId, owner.idToken, {
      invitedDisplayName: stringValue("Bakıcı Test"),
      roleLabel: stringValue("Bakıcı"),
      permissions: arrayValue([
        stringValue("viewBaby"),
        stringValue("viewFeeding"),
        stringValue("addFeeding"),
        stringValue("viewNotifications"),
      ]),
      updatedAt: timestampValue(),
    }),
  );
  const recordId = `record-allowed-${runId}`;
  await assertOk(
    "invitee can add feeding after permission update",
    await patchDoc("trackerRecords", recordId, invitee.idToken, {
      id: stringValue(recordId),
      familyId: stringValue(familyId),
      babyId: stringValue(babyId),
      createdByUserId: stringValue(invitee.localId),
      createdByName: stringValue("Bakıcı Test"),
      updatedByUserId: stringValue(invitee.localId),
      updatedByName: stringValue("Bakıcı Test"),
      type: stringValue("feeding"),
      title: stringValue("Biberon"),
      value: stringValue("120 ml"),
      note: { nullValue: null },
      occurredAt: timestampValue(),
      createdAt: timestampValue(),
      updatedAt: timestampValue(),
      deletedAt: { nullValue: null },
    }),
  );
  await assertOk("owner can read invitee record", await getDoc("trackerRecords", recordId, owner.idToken));

  await assertDenied(
    "client cannot create notification documents",
    await patchDoc("notifications", `client-forbidden-${runId}`, invitee.idToken, {
      notificationId: stringValue(`client-forbidden-${runId}`),
      familyId: stringValue(familyId),
      targetUserIds: arrayValue([stringValue(invitee.localId)]),
      createdBy: stringValue(owner.localId),
      type: stringValue("family_invite"),
      category: stringValue("family"),
      title: stringValue("Forbidden"),
      body: stringValue("Client create should fail"),
      payload: stringValue(inviteId),
      readBy: arrayValue([]),
      seenBy: arrayValue([]),
      isDeleted: boolValue(false),
      createdAt: timestampValue(),
      updatedAt: timestampValue(),
    }),
  );

  const notificationPolls = [];
  for (let attempt = 0; attempt < 6; attempt += 1) {
    const result = await queryNotifications(invitee.idToken, familyId, invitee.localId);
    notificationPolls.push({
      status: result.response.status,
      documents: Array.isArray(result.body)
        ? result.body.filter((item) => item.document).length
        : 0,
    });
    if (notificationPolls[notificationPolls.length - 1].documents > 0) break;
    await new Promise((resolve) => setTimeout(resolve, 1500));
  }

  console.log(JSON.stringify({
    ok: true,
    runId,
    ownerEmail,
    inviteeEmail,
    ownerUid: owner.localId,
    inviteeUid: invitee.localId,
    familyId,
    inviteId,
    permissionsFlow: "denied-before-accept, denied-before-addFeeding, allowed-after-update",
    notificationTokenWrite: "ok",
    clientNotificationCreate: "denied",
    functionNotificationPolls: notificationPolls,
  }, null, 2));
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../../domain/entities/app_entities.dart';
import '../sync/remote_sync_models.dart';

abstract class RemoteSyncService {
  bool get isEnabled;

  Future<void> syncUser(UserProfile user);
  Future<void> syncFamily(Family family);
  Future<void> syncBaby(BabyProfile baby);
  Future<void> syncPregnancy(PregnancyProfile pregnancy);
  Future<void> syncTrackerRecord(TrackerRecord record);
  Future<void> deleteTrackerRecord(String recordId);
  Future<void> syncReminder(
    ReminderItem reminder, {
    required String familyId,
    String? createdByName,
  });
  Future<void> deleteReminder(String reminderId);
  Future<void> syncVaccineEvent(VaccineEvent vaccine, {String? updatedByName});
  Future<void> addFamilyPartner({
    required String familyId,
    required String familyOwnerUserId,
    required String email,
    required String invitedByName,
    String? invitedDisplayName,
    String? roleLabel,
    List<FamilyPermission> permissions = const [],
  });
  Future<void> updateFamilyInvitePermissions({
    required FamilyInvite invite,
    String? invitedDisplayName,
    String? roleLabel,
    required List<FamilyPermission> permissions,
  });
  Future<void> removeFamilyMember(FamilyInvite invite);
  Future<void> acceptFamilyInvite(FamilyInvite invite);
  Future<void> declineFamilyInvite(FamilyInvite invite);
  Future<List<RemoteFamilyInvite>> fetchPendingFamilyInvites(String email);
  Future<List<RemoteFamilySummary>> fetchMyFamilies();
  Stream<RemoteFamilySummary> watchFamily(String familyId);
  Future<void> syncNotificationToken({
    required String token,
    required String platform,
    String? familyId,
    required bool notificationsEnabled,
  });
  Future<void> markNotificationRead(String notificationId);
}

class NoopRemoteSyncService implements RemoteSyncService {
  const NoopRemoteSyncService();

  @override
  bool get isEnabled => false;

  @override
  Future<void> syncUser(UserProfile user) async {}

  @override
  Future<void> syncFamily(Family family) async {}

  @override
  Future<void> syncBaby(BabyProfile baby) async {}

  @override
  Future<void> syncPregnancy(PregnancyProfile pregnancy) async {}

  @override
  Future<void> syncTrackerRecord(TrackerRecord record) async {}

  @override
  Future<void> deleteTrackerRecord(String recordId) async {}

  @override
  Future<void> syncReminder(
    ReminderItem reminder, {
    required String familyId,
    String? createdByName,
  }) async {}

  @override
  Future<void> deleteReminder(String reminderId) async {}

  @override
  Future<void> syncVaccineEvent(
    VaccineEvent vaccine, {
    String? updatedByName,
  }) async {}

  @override
  Future<void> addFamilyPartner({
    required String familyId,
    required String familyOwnerUserId,
    required String email,
    required String invitedByName,
    String? invitedDisplayName,
    String? roleLabel,
    List<FamilyPermission> permissions = const [],
  }) async {}

  @override
  Future<void> updateFamilyInvitePermissions({
    required FamilyInvite invite,
    String? invitedDisplayName,
    String? roleLabel,
    required List<FamilyPermission> permissions,
  }) async {}

  @override
  Future<void> removeFamilyMember(FamilyInvite invite) async {}

  @override
  Future<void> acceptFamilyInvite(FamilyInvite invite) async {}

  @override
  Future<void> declineFamilyInvite(FamilyInvite invite) async {}

  @override
  Future<List<RemoteFamilyInvite>> fetchPendingFamilyInvites(
    String email,
  ) async {
    return const [];
  }

  @override
  Future<List<RemoteFamilySummary>> fetchMyFamilies() async {
    return const [];
  }

  @override
  Stream<RemoteFamilySummary> watchFamily(String familyId) {
    return const Stream.empty();
  }

  @override
  Future<void> syncNotificationToken({
    required String token,
    required String platform,
    String? familyId,
    required bool notificationsEnabled,
  }) async {}

  @override
  Future<void> markNotificationRead(String notificationId) async {}
}

class FirebaseFirestoreSyncService implements RemoteSyncService {
  FirebaseFirestoreSyncService({
    firestore.FirebaseFirestore? firestoreInstance,
    firebase_auth.FirebaseAuth? auth,
  }) : _firestore = firestoreInstance ?? firestore.FirebaseFirestore.instance,
       _auth = auth ?? firebase_auth.FirebaseAuth.instance;

  final firestore.FirebaseFirestore _firestore;
  final firebase_auth.FirebaseAuth _auth;

  @override
  bool get isEnabled => true;

  firestore.CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection('users');

  firestore.CollectionReference<Map<String, dynamic>> get _families =>
      _firestore.collection('families');

  firestore.CollectionReference<Map<String, dynamic>> get _babies =>
      _firestore.collection('babies');

  firestore.CollectionReference<Map<String, dynamic>> get _pregnancies =>
      _firestore.collection('pregnancies');

  firestore.CollectionReference<Map<String, dynamic>> get _trackerRecords =>
      _firestore.collection('trackerRecords');

  firestore.CollectionReference<Map<String, dynamic>> get _familyInvites =>
      _firestore.collection('familyInvites');

  firestore.CollectionReference<Map<String, dynamic>> get _reminders =>
      _firestore.collection('reminders');

  firestore.CollectionReference<Map<String, dynamic>> get _vaccineEvents =>
      _firestore.collection('vaccineEvents');

  firestore.CollectionReference<Map<String, dynamic>> get _notifications =>
      _firestore.collection('notifications');

  firestore.CollectionReference<Map<String, dynamic>> get _notificationTokens =>
      _firestore.collection('notificationTokens');

  @override
  Future<void> syncUser(UserProfile user) async {
    final firebaseUser = _requireFirebaseUser();
    final ref = _users.doc(firebaseUser.uid);
    final updatePayload = <String, dynamic>{
      'displayName': user.name,
      'emailVerified': user.emailVerified,
      'verification': {
        'status': user.emailVerified ? 'verified' : 'pending',
        'updatedAt': firestore.FieldValue.serverTimestamp(),
      },
      'avatarUrl': user.avatarUrl,
      'birthDate': _timestampOrNull(user.birthDate),
      'phone': _blankToNull(user.phone),
      'role': _blankToNull(user.role),
      'language': user.language,
      'theme': user.theme,
      'updatedAt': firestore.FieldValue.serverTimestamp(),
    };
    final createPayload = {
      'id': firebaseUser.uid,
      'email': user.email.trim().toLowerCase(),
      'createdAt': firestore.Timestamp.fromDate(user.createdAt),
      ...updatePayload,
    };
    return _setCreatePayloadThenMutable(ref, createPayload, updatePayload);
  }

  @override
  Future<void> syncFamily(Family family) async {
    _requireFirebaseUser();
    final ref = _families.doc(family.id);
    final updatePayload = <String, dynamic>{
      'partnerUserIds': family.partnerUserIds
          .map((item) => item.trim().toLowerCase())
          .where((item) => item.isNotEmpty)
          .toSet()
          .toList(),
      'activeBabyId': family.activeBabyId,
      'updatedAt': firestore.FieldValue.serverTimestamp(),
    };
    final createPayload = {
      'id': family.id,
      'ownerUserId': family.ownerUserId,
      'createdAt': firestore.Timestamp.fromDate(family.createdAt),
      ...updatePayload,
    };
    return _setCreatePayloadThenMutable(ref, createPayload, updatePayload);
  }

  @override
  Future<void> syncBaby(BabyProfile baby) async {
    _requireFirebaseUser();
    final ref = _babies.doc(baby.id);
    final updatePayload = <String, dynamic>{
      'name': baby.name,
      'birthDate': firestore.Timestamp.fromDate(baby.birthDate),
      'gender': _blankToNull(baby.gender),
      'birthWeight': baby.birthWeight,
      'birthHeight': baby.birthHeight,
      'birthHeadCircumference': baby.birthHeadCircumference,
      'currentWeight': baby.currentWeight,
      'currentHeight': baby.currentHeight,
      'currentHeadCircumference': baby.currentHeadCircumference,
      'updatedAt': firestore.FieldValue.serverTimestamp(),
    };
    final createPayload = {
      'id': baby.id,
      'familyId': baby.familyId,
      'createdAt': firestore.Timestamp.fromDate(baby.createdAt),
      ...updatePayload,
    };
    return _setCreatePayloadThenMutable(ref, createPayload, updatePayload);
  }

  @override
  Future<void> syncPregnancy(PregnancyProfile pregnancy) {
    final firebaseUser = _requireFirebaseUser();
    return _pregnancies.doc(pregnancy.id).set({
      'id': pregnancy.id,
      'userId': firebaseUser.uid,
      'startDate': firestore.Timestamp.fromDate(pregnancy.startDate),
      'dueDate': firestore.Timestamp.fromDate(pregnancy.dueDate),
      'status': pregnancy.status,
      'birthCompletedAt': _timestampOrNull(pregnancy.birthCompletedAt),
      'updatedAt': firestore.FieldValue.serverTimestamp(),
    }, firestore.SetOptions(merge: true));
  }

  @override
  Future<void> syncTrackerRecord(TrackerRecord record) async {
    final firebaseUser = _requireFirebaseUser();
    final ref = _trackerRecords.doc(record.id);
    final updatePayload = <String, dynamic>{
      'updatedByUserId': firebaseUser.uid,
      'updatedByName': _blankToNull(
        record.updatedByName ?? record.createdByName,
      ),
      'type': record.type.name,
      'title': record.title,
      'value': _blankToNull(record.value),
      'note': _blankToNull(record.note),
      'occurredAt': firestore.Timestamp.fromDate(record.occurredAt),
      'updatedAt': firestore.Timestamp.fromDate(record.updatedAt),
      'deletedAt': null,
    };
    final createPayload = {
      'id': record.id,
      'familyId': record.familyId,
      'babyId': record.babyId,
      'createdByUserId': record.createdByUserId ?? firebaseUser.uid,
      'createdByName': _blankToNull(record.createdByName),
      'createdAt': firestore.Timestamp.fromDate(record.createdAt),
      ...updatePayload,
    };
    return _setCreatePayloadThenMutable(ref, createPayload, updatePayload);
  }

  @override
  Future<void> deleteTrackerRecord(String recordId) {
    final firebaseUser = _requireFirebaseUser();
    return _trackerRecords.doc(recordId).set({
      'updatedByUserId': firebaseUser.uid,
      'deletedAt': firestore.FieldValue.serverTimestamp(),
      'updatedAt': firestore.FieldValue.serverTimestamp(),
    }, firestore.SetOptions(merge: true));
  }

  @override
  Future<void> syncReminder(
    ReminderItem reminder, {
    required String familyId,
    String? createdByName,
  }) async {
    final firebaseUser = _requireFirebaseUser();
    final ref = _reminders.doc(reminder.id);
    final updatePayload = <String, dynamic>{
      'title': reminder.title,
      'category': reminder.category.name,
      'time': firestore.Timestamp.fromDate(reminder.time),
      'frequency': reminder.frequency,
      'notes': _blankToNull(reminder.notes),
      'isActive': reminder.isActive,
      'updatedByUserId': firebaseUser.uid,
      'updatedByName': _blankToNull(createdByName),
      'updatedAt': firestore.FieldValue.serverTimestamp(),
      'deletedAt': null,
    };
    final createPayload = {
      'id': reminder.id,
      'familyId': familyId,
      'createdByUserId': firebaseUser.uid,
      'createdByName': _blankToNull(createdByName),
      'createdAt': firestore.Timestamp.fromDate(reminder.createdAt),
      ...updatePayload,
    };
    return _setCreatePayloadThenMutable(ref, createPayload, updatePayload);
  }

  @override
  Future<void> deleteReminder(String reminderId) {
    final firebaseUser = _requireFirebaseUser();
    return _reminders.doc(reminderId).set({
      'updatedByUserId': firebaseUser.uid,
      'deletedAt': firestore.FieldValue.serverTimestamp(),
      'updatedAt': firestore.FieldValue.serverTimestamp(),
    }, firestore.SetOptions(merge: true));
  }

  @override
  Future<void> syncVaccineEvent(
    VaccineEvent vaccine, {
    String? updatedByName,
  }) async {
    final firebaseUser = _requireFirebaseUser();
    final ref = _vaccineEvents.doc(vaccine.id);
    final updatePayload = <String, dynamic>{
      'title': vaccine.title,
      'dose': vaccine.dose,
      'dueDate': firestore.Timestamp.fromDate(vaccine.dueDate),
      'status': vaccine.status.name,
      'notes': _blankToNull(vaccine.notes),
      'completedAt': _timestampOrNull(vaccine.completedAt),
      'updatedByUserId': firebaseUser.uid,
      'updatedByName': _blankToNull(updatedByName),
      'updatedAt': firestore.FieldValue.serverTimestamp(),
    };
    final createPayload = {
      'id': vaccine.id,
      'babyId': vaccine.babyId,
      'createdAt': firestore.Timestamp.fromDate(vaccine.createdAt),
      ...updatePayload,
    };
    return _setCreatePayloadThenMutable(ref, createPayload, updatePayload);
  }

  @override
  Future<void> addFamilyPartner({
    required String familyId,
    required String familyOwnerUserId,
    required String email,
    required String invitedByName,
    String? invitedDisplayName,
    String? roleLabel,
    List<FamilyPermission> permissions = const [],
  }) async {
    final firebaseUser = _requireFirebaseUser();
    final normalized = email.trim().toLowerCase();
    final displayName =
        _blankToNull(invitedByName) ??
        _blankToNull(firebaseUser.displayName) ??
        _blankToNull(firebaseUser.email) ??
        'MiniAdımlar';
    final effectiveRole = _blankToNull(roleLabel) ?? 'Ebeveyn';
    final effectiveDisplayName =
        _blankToNull(invitedDisplayName) ?? effectiveRole;
    final effectivePermissions =
        (permissions.isEmpty
                ? FamilyPermissionSets.defaultsForRole(effectiveRole)
                : permissions)
            .map((permission) => permission.name)
            .toSet()
            .toList();
    final ref = _familyInvites.doc(_inviteId(familyId, normalized));
    final updatePayload = <String, dynamic>{
      'invitedByName': displayName,
      'invitedDisplayName': effectiveDisplayName,
      'roleLabel': effectiveRole,
      'permissions': effectivePermissions,
      'updatedAt': firestore.FieldValue.serverTimestamp(),
    };
    final createPayload = <String, dynamic>{
      'id': ref.id,
      'familyId': familyId,
      'invitedEmail': normalized,
      'invitedByUserId': firebaseUser.uid,
      ...updatePayload,
      'familyOwnerUserId': familyOwnerUserId,
      'status': 'pending',
      'createdAt': firestore.FieldValue.serverTimestamp(),
    };
    try {
      await ref.set(createPayload);
    } catch (error) {
      try {
        await ref.update({
          ...updatePayload,
          'status': 'pending',
          'acceptedUserId': firestore.FieldValue.delete(),
          'respondedAt': firestore.FieldValue.delete(),
        });
      } catch (_) {
        Error.throwWithStackTrace(error, StackTrace.current);
      }
    }
  }

  @override
  Future<void> updateFamilyInvitePermissions({
    required FamilyInvite invite,
    String? invitedDisplayName,
    String? roleLabel,
    required List<FamilyPermission> permissions,
  }) {
    _requireFirebaseUser();
    final effectiveRole =
        _blankToNull(roleLabel) ?? invite.roleLabel ?? 'Ebeveyn';
    final effectiveDisplayName =
        _blankToNull(invitedDisplayName) ??
        invite.invitedDisplayName ??
        effectiveRole;
    return _familyInvites.doc(invite.id).update({
      'invitedDisplayName': effectiveDisplayName,
      'roleLabel': effectiveRole,
      'permissions': permissions
          .map((permission) => permission.name)
          .toSet()
          .toList(),
      'updatedAt': firestore.FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> removeFamilyMember(FamilyInvite invite) {
    _requireFirebaseUser();
    return _familyInvites.doc(invite.id).set({
      'status': 'declined',
      'acceptedUserId': firestore.FieldValue.delete(),
      'respondedAt': firestore.FieldValue.serverTimestamp(),
      'updatedAt': firestore.FieldValue.serverTimestamp(),
    }, firestore.SetOptions(merge: true));
  }

  @override
  Future<void> acceptFamilyInvite(FamilyInvite invite) {
    final firebaseUser = _requireFirebaseUser();
    return _familyInvites.doc(invite.id).update({
      'status': 'accepted',
      'acceptedUserId': firebaseUser.uid,
      'respondedAt': firestore.FieldValue.serverTimestamp(),
      'updatedAt': firestore.FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> declineFamilyInvite(FamilyInvite invite) {
    _requireFirebaseUser();
    return _familyInvites.doc(invite.id).update({
      'status': 'declined',
      'respondedAt': firestore.FieldValue.serverTimestamp(),
      'updatedAt': firestore.FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<List<RemoteFamilyInvite>> fetchPendingFamilyInvites(
    String email,
  ) async {
    _requireFirebaseUser();
    final normalized = email.trim().toLowerCase();
    final snapshot = await _familyInvites
        .where('invitedEmail', isEqualTo: normalized)
        .where('status', isEqualTo: 'pending')
        .limit(20)
        .get();
    return snapshot.docs.map(_remoteInviteFromDoc).toList();
  }

  @override
  Future<List<RemoteFamilySummary>> fetchMyFamilies() async {
    final firebaseUser = _requireFirebaseUser();
    final email = firebaseUser.email?.trim().toLowerCase() ?? '';
    final ownedSnapshot = await _families
        .where('ownerUserId', isEqualTo: firebaseUser.uid)
        .limit(5)
        .get();
    final acceptedByUserSnapshot = await _familyInvites
        .where('acceptedUserId', isEqualTo: firebaseUser.uid)
        .where('status', isEqualTo: 'accepted')
        .limit(20)
        .get();
    final acceptedByEmailSnapshot = email.isEmpty
        ? null
        : await _familyInvites
              .where('invitedEmail', isEqualTo: email)
              .where('status', isEqualTo: 'accepted')
              .limit(20)
              .get();
    final acceptedInviteDocs = _uniqueInviteDocs([
      ...acceptedByUserSnapshot.docs,
      ...?acceptedByEmailSnapshot?.docs,
    ]);
    await _relinkAcceptedInvitesToCurrentUser(acceptedInviteDocs, firebaseUser);
    final sentAcceptedSnapshot = await _familyInvites
        .where('invitedByUserId', isEqualTo: firebaseUser.uid)
        .where('status', isEqualTo: 'accepted')
        .limit(20)
        .get();

    final familyDocs =
        <String, firestore.DocumentSnapshot<Map<String, dynamic>>>{
          for (final doc in ownedSnapshot.docs) doc.id: doc,
        };
    for (final inviteDoc in acceptedInviteDocs) {
      final familyId = inviteDoc.data()['familyId'] as String?;
      if (familyId == null || familyDocs.containsKey(familyId)) continue;
      final familyDoc = await _families.doc(familyId).get();
      if (familyDoc.exists) familyDocs[familyId] = familyDoc;
    }

    final acceptedPartnerEmailsByFamily = <String, Set<String>>{};
    for (final doc in acceptedInviteDocs) {
      final data = doc.data();
      final familyId = data['familyId'] as String?;
      if (familyId == null || email.isEmpty) continue;
      acceptedPartnerEmailsByFamily.putIfAbsent(familyId, () => <String>{});
      acceptedPartnerEmailsByFamily[familyId]!.add(email);
    }
    for (final doc in sentAcceptedSnapshot.docs) {
      final data = doc.data();
      final familyId = data['familyId'] as String?;
      final invitedEmail = data['invitedEmail'] as String?;
      if (familyId == null || invitedEmail == null) continue;
      acceptedPartnerEmailsByFamily.putIfAbsent(familyId, () => <String>{});
      acceptedPartnerEmailsByFamily[familyId]!.add(invitedEmail);
    }

    final summaries = <RemoteFamilySummary>[];
    for (final doc in familyDocs.values.take(5)) {
      final data = doc.data();
      if (data == null) continue;
      final babySnapshot = await _babies
          .where('familyId', isEqualTo: doc.id)
          .limit(5)
          .get();
      final recordSnapshot = await _trackerRecords
          .where('familyId', isEqualTo: doc.id)
          .limit(60)
          .get();
      final reminderSnapshot = await _reminders
          .where('familyId', isEqualTo: doc.id)
          .limit(40)
          .get();
      final inviteDocs = data['ownerUserId'] == firebaseUser.uid
          ? (await _familyInvites
                    .where('familyId', isEqualTo: doc.id)
                    .limit(30)
                    .get())
                .docs
                .where((inviteDoc) => inviteDoc.data()['status'] != 'declined')
                .toList()
          : acceptedInviteDocs
                .where((inviteDoc) => inviteDoc.data()['familyId'] == doc.id)
                .toList();
      final partnerEmails = {
        ..._stringList(data['partnerUserIds']),
        ...?acceptedPartnerEmailsByFamily[doc.id],
      }.toList();
      final activeBabyId = data['activeBabyId'] as String?;
      final vaccineSnapshot = _blankToNull(activeBabyId) == null
          ? null
          : await _vaccineEvents
                .where('babyId', isEqualTo: activeBabyId)
                .limit(40)
                .get();
      final notificationSnapshot = await _notifications
          .where('familyId', isEqualTo: doc.id)
          .where('targetUserIds', arrayContains: firebaseUser.uid)
          .where('isDeleted', isEqualTo: false)
          .limit(80)
          .get();
      summaries.add(
        RemoteFamilySummary(
          id: doc.id,
          ownerUserId: data['ownerUserId'] as String? ?? '',
          activeBabyId: _blankToNull(activeBabyId),
          createdAt: _dateFrom(data['createdAt']) ?? DateTime.now(),
          partnerEmails: partnerEmails,
          invites: inviteDocs.map(_remoteInviteFromDoc).toList(),
          babies: babySnapshot.docs
              .map((babyDoc) => _remoteBaby(babyDoc, doc.id))
              .toList(),
          records: recordSnapshot.docs
              .map((recordDoc) => _remoteRecord(recordDoc, doc.id))
              .toList(),
          reminders: reminderSnapshot.docs.map(_remoteReminder).toList(),
          vaccines:
              vaccineSnapshot?.docs.map(_remoteVaccine).toList() ?? const [],
          notifications: notificationSnapshot.docs
              .map(_remoteNotification)
              .toList(),
        ),
      );
    }
    return summaries;
  }

  @override
  Stream<RemoteFamilySummary> watchFamily(String familyId) {
    final firebaseUser = _requireFirebaseUser();
    late StreamController<RemoteFamilySummary> controller;
    final subscriptions = <StreamSubscription<dynamic>>[];
    firestore.DocumentSnapshot<Map<String, dynamic>>? familyDoc;
    List<firestore.QueryDocumentSnapshot<Map<String, dynamic>>> babyDocs =
        const [];
    List<firestore.QueryDocumentSnapshot<Map<String, dynamic>>> recordDocs =
        const [];
    List<firestore.QueryDocumentSnapshot<Map<String, dynamic>>> reminderDocs =
        const [];
    List<firestore.QueryDocumentSnapshot<Map<String, dynamic>>> inviteDocs =
        const [];
    List<firestore.QueryDocumentSnapshot<Map<String, dynamic>>> vaccineDocs =
        const [];
    List<firestore.QueryDocumentSnapshot<Map<String, dynamic>>>
    notificationDocs = const [];
    String? watchedBabyId;
    StreamSubscription<dynamic>? vaccineSubscription;
    StreamSubscription<dynamic>? inviteSubscription;
    String? inviteWatchMode;

    Future<void> emit() async {
      final doc = familyDoc;
      final data = doc?.data();
      if (doc == null || data == null || !doc.exists) return;
      final activeBabyId = _blankToNull(data['activeBabyId'] as String?);
      final partnerEmails = {
        ..._stringList(data['partnerUserIds']),
        for (final invite in inviteDocs)
          if (invite.data()['invitedEmail'] is String)
            (invite.data()['invitedEmail'] as String).trim().toLowerCase(),
      }.toList();
      controller.add(
        RemoteFamilySummary(
          id: doc.id,
          ownerUserId: data['ownerUserId'] as String? ?? '',
          activeBabyId: activeBabyId,
          createdAt: _dateFrom(data['createdAt']) ?? DateTime.now(),
          partnerEmails: partnerEmails,
          invites: inviteDocs.map(_remoteInviteFromDoc).toList(),
          babies: babyDocs.map((doc) => _remoteBaby(doc, familyId)).toList(),
          records: recordDocs
              .map((doc) => _remoteRecord(doc, familyId))
              .toList(),
          reminders: reminderDocs.map(_remoteReminder).toList(),
          vaccines: vaccineDocs.map(_remoteVaccine).toList(),
          notifications: notificationDocs.map(_remoteNotification).toList(),
        ),
      );
    }

    void watchVaccines(String? babyId) {
      final normalized = _blankToNull(babyId);
      if (normalized == null || normalized == watchedBabyId) return;
      watchedBabyId = normalized;
      vaccineSubscription?.cancel();
      vaccineDocs = const [];
      vaccineSubscription = _vaccineEvents
          .where('babyId', isEqualTo: normalized)
          .limit(40)
          .snapshots()
          .listen((snapshot) {
            vaccineDocs = snapshot.docs;
            emit();
          }, onError: controller.addError);
    }

    void watchInvites({required bool owner}) {
      final mode = owner ? 'owner' : 'member';
      if (inviteWatchMode == mode) return;
      inviteWatchMode = mode;
      inviteSubscription?.cancel();
      inviteDocs = const [];
      firestore.Query<Map<String, dynamic>> query = _familyInvites
          .where('familyId', isEqualTo: familyId)
          .where('status', isEqualTo: 'accepted');
      if (!owner) {
        final email = firebaseUser.email?.trim().toLowerCase() ?? '';
        query = email.isEmpty
            ? query.where('acceptedUserId', isEqualTo: firebaseUser.uid)
            : query.where('invitedEmail', isEqualTo: email);
      }
      inviteSubscription = query.limit(30).snapshots().listen((snapshot) {
        inviteDocs = owner
            ? snapshot.docs
                  .where((doc) => doc.data()['status'] != 'declined')
                  .toList()
            : snapshot.docs;
        emit();
      }, onError: controller.addError);
    }

    controller = StreamController<RemoteFamilySummary>(
      onListen: () {
        subscriptions.add(
          _families.doc(familyId).snapshots().listen((snapshot) {
            final previousBabyId = watchedBabyId;
            familyDoc = snapshot;
            final nextBabyId = _blankToNull(
              snapshot.data()?['activeBabyId'] as String?,
            );
            if (nextBabyId != null && nextBabyId != previousBabyId) {
              watchVaccines(nextBabyId);
            }
            final familyData = snapshot.data();
            if (familyData != null) {
              watchInvites(
                owner: familyData['ownerUserId'] == firebaseUser.uid,
              );
            }
            emit();
          }, onError: controller.addError),
        );
        subscriptions.add(
          _babies
              .where('familyId', isEqualTo: familyId)
              .limit(5)
              .snapshots()
              .listen((snapshot) {
                babyDocs = snapshot.docs;
                if (watchedBabyId == null && snapshot.docs.isNotEmpty) {
                  watchVaccines(snapshot.docs.first.id);
                }
                emit();
              }, onError: controller.addError),
        );
        subscriptions.add(
          _trackerRecords
              .where('familyId', isEqualTo: familyId)
              .limit(80)
              .snapshots()
              .listen((snapshot) {
                recordDocs = snapshot.docs;
                emit();
              }, onError: controller.addError),
        );
        subscriptions.add(
          _reminders
              .where('familyId', isEqualTo: familyId)
              .limit(40)
              .snapshots()
              .listen((snapshot) {
                reminderDocs = snapshot.docs;
                emit();
              }, onError: controller.addError),
        );
        subscriptions.add(
          _notifications
              .where('familyId', isEqualTo: familyId)
              .where('targetUserIds', arrayContains: firebaseUser.uid)
              .where('isDeleted', isEqualTo: false)
              .limit(80)
              .snapshots()
              .listen((snapshot) {
                notificationDocs = snapshot.docs;
                emit();
              }, onError: controller.addError),
        );
      },
      onCancel: () async {
        for (final sub in subscriptions) {
          await sub.cancel();
        }
        await vaccineSubscription?.cancel();
        await inviteSubscription?.cancel();
      },
    );
    return controller.stream;
  }

  RemoteFamilyInvite _remoteInviteFromDoc(
    firestore.QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    return RemoteFamilyInvite(
      familyId: data['familyId'] as String? ?? '',
      invitedEmail: data['invitedEmail'] as String? ?? '',
      invitedByUserId: data['invitedByUserId'] as String? ?? '',
      invitedByName: data['invitedByName'] as String? ?? 'MiniAdımlar',
      ownerUserId:
          data['familyOwnerUserId'] as String? ??
          data['invitedByUserId'] as String? ??
          '',
      invitedDisplayName: data['invitedDisplayName'] as String?,
      roleLabel: data['roleLabel'] as String?,
      permissions: _stringList(data['permissions']),
      acceptedUserId: data['acceptedUserId'] as String?,
      status: data['status'] as String? ?? 'pending',
      createdAt: _dateFrom(data['createdAt']) ?? DateTime.now(),
      respondedAt: _dateFrom(data['respondedAt']),
    );
  }

  RemoteBabySummary _remoteBaby(
    firestore.QueryDocumentSnapshot<Map<String, dynamic>> doc,
    String fallbackFamilyId,
  ) {
    final baby = doc.data();
    return RemoteBabySummary(
      id: doc.id,
      familyId: baby['familyId'] as String? ?? fallbackFamilyId,
      name: baby['name'] as String? ?? 'Bebek',
      birthDate: _dateFrom(baby['birthDate']) ?? DateTime.now(),
      gender: baby['gender'] as String?,
      birthWeight: _doubleFrom(baby['birthWeight']),
      birthHeight: _doubleFrom(baby['birthHeight']),
      birthHeadCircumference: _doubleFrom(baby['birthHeadCircumference']),
      currentWeight: _doubleFrom(baby['currentWeight']),
      currentHeight: _doubleFrom(baby['currentHeight']),
      currentHeadCircumference: _doubleFrom(baby['currentHeadCircumference']),
      createdAt: _dateFrom(baby['createdAt']) ?? DateTime.now(),
    );
  }

  RemoteTrackerRecordSummary _remoteRecord(
    firestore.QueryDocumentSnapshot<Map<String, dynamic>> doc,
    String fallbackFamilyId,
  ) {
    final record = doc.data();
    return RemoteTrackerRecordSummary(
      id: doc.id,
      type: record['type'] as String? ?? 'health',
      title: record['title'] as String? ?? '',
      familyId: record['familyId'] as String? ?? fallbackFamilyId,
      babyId: record['babyId'] as String?,
      value: record['value'] as String?,
      note: record['note'] as String?,
      createdByUserId: record['createdByUserId'] as String?,
      createdByName: record['createdByName'] as String?,
      updatedByUserId: record['updatedByUserId'] as String?,
      updatedByName: record['updatedByName'] as String?,
      deletedAt: _dateFrom(record['deletedAt']),
      occurredAt: _dateFrom(record['occurredAt']) ?? DateTime.now(),
      createdAt: _dateFrom(record['createdAt']) ?? DateTime.now(),
      updatedAt: _dateFrom(record['updatedAt']) ?? DateTime.now(),
    );
  }

  RemoteReminderSummary _remoteReminder(
    firestore.QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final reminder = doc.data();
    return RemoteReminderSummary(
      id: doc.id,
      title: reminder['title'] as String? ?? 'Hatırlatıcı',
      category: reminder['category'] as String? ?? 'custom',
      time: _dateFrom(reminder['time']) ?? DateTime.now(),
      frequency: reminder['frequency'] as String? ?? 'daily',
      notes: reminder['notes'] as String?,
      isActive: reminder['isActive'] as bool? ?? true,
      familyId: reminder['familyId'] as String? ?? '',
      createdByUserId: reminder['createdByUserId'] as String?,
      createdByName: reminder['createdByName'] as String?,
      updatedByUserId: reminder['updatedByUserId'] as String?,
      updatedByName: reminder['updatedByName'] as String?,
      createdAt: _dateFrom(reminder['createdAt']) ?? DateTime.now(),
      updatedAt: _dateFrom(reminder['updatedAt']),
      deletedAt: _dateFrom(reminder['deletedAt']),
    );
  }

  RemoteVaccineSummary _remoteVaccine(
    firestore.QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final vaccine = doc.data();
    return RemoteVaccineSummary(
      id: doc.id,
      babyId: vaccine['babyId'] as String? ?? '',
      title: vaccine['title'] as String? ?? 'Aşı',
      dose: vaccine['dose'] as String? ?? '',
      dueDate: _dateFrom(vaccine['dueDate']) ?? DateTime.now(),
      status: vaccine['status'] as String? ?? 'upcoming',
      notes: vaccine['notes'] as String?,
      completedAt: _dateFrom(vaccine['completedAt']),
      updatedByUserId: vaccine['updatedByUserId'] as String?,
      updatedByName: vaccine['updatedByName'] as String?,
      createdAt: _dateFrom(vaccine['createdAt']) ?? DateTime.now(),
      updatedAt: _dateFrom(vaccine['updatedAt']),
    );
  }

  RemoteNotificationSummary _remoteNotification(
    firestore.QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    return RemoteNotificationSummary(
      id: doc.id,
      familyId: data['familyId'] as String? ?? '',
      type: data['type'] as String? ?? 'family_event',
      category: data['category'] as String? ?? 'family',
      title: data['title'] as String? ?? 'Aile bildirimi',
      body: data['body'] as String? ?? '',
      payload: data['payload'] as String?,
      createdBy: data['createdBy'] as String?,
      targetUserIds: _stringList(data['targetUserIds']),
      readBy: _stringList(data['readBy']),
      seenBy: _stringList(data['seenBy']),
      isDeleted: data['isDeleted'] as bool? ?? false,
      createdAt: _dateFrom(data['createdAt']) ?? DateTime.now(),
    );
  }

  @override
  Future<void> syncNotificationToken({
    required String token,
    required String platform,
    String? familyId,
    required bool notificationsEnabled,
  }) {
    final firebaseUser = _requireFirebaseUser();
    final tokenId = '${firebaseUser.uid}-${token.hashCode & 0x7fffffff}';
    return _notificationTokens.doc(tokenId).set({
      'id': tokenId,
      'userId': firebaseUser.uid,
      'uid': firebaseUser.uid,
      'familyId': _blankToNull(familyId),
      'token': token,
      'platform': platform,
      'enabled': notificationsEnabled,
      'updatedAt': firestore.FieldValue.serverTimestamp(),
    }, firestore.SetOptions(merge: true));
  }

  @override
  Future<void> markNotificationRead(String notificationId) {
    final firebaseUser = _requireFirebaseUser();
    return _notifications.doc(notificationId).set({
      'readBy': firestore.FieldValue.arrayUnion([firebaseUser.uid]),
      'seenBy': firestore.FieldValue.arrayUnion([firebaseUser.uid]),
      'updatedAt': firestore.FieldValue.serverTimestamp(),
    }, firestore.SetOptions(merge: true));
  }

  Future<void> _relinkAcceptedInvitesToCurrentUser(
    Iterable<firestore.QueryDocumentSnapshot<Map<String, dynamic>>> inviteDocs,
    firebase_auth.User firebaseUser,
  ) async {
    final email = firebaseUser.email?.trim().toLowerCase() ?? '';
    if (email.isEmpty) return;
    for (final doc in inviteDocs) {
      final data = doc.data();
      if (data['status'] != 'accepted') continue;
      final invitedEmail =
          (data['invitedEmail'] as String?)?.trim().toLowerCase() ?? '';
      if (invitedEmail != email || data['acceptedUserId'] == firebaseUser.uid) {
        continue;
      }
      try {
        await doc.reference.update({
          'acceptedUserId': firebaseUser.uid,
          'updatedAt': firestore.FieldValue.serverTimestamp(),
        });
      } catch (_) {
        // Email-based access still works after rules are deployed; relinking is
        // a best-effort repair for future notifications and UID-based queries.
      }
    }
  }

  List<firestore.QueryDocumentSnapshot<Map<String, dynamic>>> _uniqueInviteDocs(
    Iterable<firestore.QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) {
    final byId =
        <String, firestore.QueryDocumentSnapshot<Map<String, dynamic>>>{};
    for (final doc in docs) {
      byId[doc.id] = doc;
    }
    return byId.values.toList();
  }

  Future<void> _setCreatePayloadThenMutable(
    firestore.DocumentReference<Map<String, dynamic>> ref,
    Map<String, dynamic> createPayload,
    Map<String, dynamic> updatePayload,
  ) async {
    try {
      await ref.set(createPayload);
    } catch (error) {
      try {
        await ref.set(updatePayload, firestore.SetOptions(merge: true));
      } catch (_) {
        Error.throwWithStackTrace(error, StackTrace.current);
      }
    }
  }

  firebase_auth.User _requireFirebaseUser() {
    final user = _auth.currentUser;
    if (user == null) {
      throw StateError('Firebase oturumu bulunamadı.');
    }
    return user;
  }

  String _inviteId(String familyId, String email) => 'invite-$familyId-$email';

  firestore.Timestamp? _timestampOrNull(DateTime? value) {
    return value == null ? null : firestore.Timestamp.fromDate(value);
  }

  DateTime? _dateFrom(Object? value) {
    if (value is firestore.Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return null;
  }

  double? _doubleFrom(Object? value) {
    if (value is int) return value.toDouble();
    if (value is double) return value;
    return null;
  }

  List<String> _stringList(Object? value) {
    if (value is! Iterable) return const [];
    return value
        .map((item) => item.toString().trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }

  String? _blankToNull(String? value) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }
}

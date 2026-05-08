library dataconnect_generated;
import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

part 'get_my_profile.dart';

part 'list_my_families.dart';

part 'list_pending_invites_for_me.dart';

part 'get_my_pregnancy.dart';

part 'list_family_records.dart';

part 'upsert_current_user.dart';

part 'upsert_family.dart';

part 'add_family_partner.dart';

part 'accept_family_partner_invite.dart';

part 'decline_family_partner_invite.dart';

part 'upsert_baby.dart';

part 'upsert_pregnancy.dart';

part 'upsert_tracker_record.dart';







class ExampleConnector {
  
  
  GetMyProfileVariablesBuilder getMyProfile () {
    return GetMyProfileVariablesBuilder(dataConnect, );
  }
  
  
  ListMyFamiliesVariablesBuilder listMyFamilies () {
    return ListMyFamiliesVariablesBuilder(dataConnect, );
  }
  
  
  ListPendingInvitesForMeVariablesBuilder listPendingInvitesForMe ({required String email, }) {
    return ListPendingInvitesForMeVariablesBuilder(dataConnect, email: email,);
  }
  
  
  GetMyPregnancyVariablesBuilder getMyPregnancy () {
    return GetMyPregnancyVariablesBuilder(dataConnect, );
  }
  
  
  ListFamilyRecordsVariablesBuilder listFamilyRecords ({required String familyId, }) {
    return ListFamilyRecordsVariablesBuilder(dataConnect, familyId: familyId,);
  }
  
  
  UpsertCurrentUserVariablesBuilder upsertCurrentUser ({required String email, required String language, required String theme, }) {
    return UpsertCurrentUserVariablesBuilder(dataConnect, email: email,language: language,theme: theme,);
  }
  
  
  UpsertFamilyVariablesBuilder upsertFamily ({required String id, }) {
    return UpsertFamilyVariablesBuilder(dataConnect, id: id,);
  }
  
  
  AddFamilyPartnerVariablesBuilder addFamilyPartner ({required String familyId, required String email, }) {
    return AddFamilyPartnerVariablesBuilder(dataConnect, familyId: familyId,email: email,);
  }
  
  
  AcceptFamilyPartnerInviteVariablesBuilder acceptFamilyPartnerInvite ({required String familyId, required String email, }) {
    return AcceptFamilyPartnerInviteVariablesBuilder(dataConnect, familyId: familyId,email: email,);
  }
  
  
  DeclineFamilyPartnerInviteVariablesBuilder declineFamilyPartnerInvite ({required String familyId, required String email, }) {
    return DeclineFamilyPartnerInviteVariablesBuilder(dataConnect, familyId: familyId,email: email,);
  }
  
  
  UpsertBabyVariablesBuilder upsertBaby ({required String id, required String familyId, required String name, required Timestamp birthDate, }) {
    return UpsertBabyVariablesBuilder(dataConnect, id: id,familyId: familyId,name: name,birthDate: birthDate,);
  }
  
  
  UpsertPregnancyVariablesBuilder upsertPregnancy ({required String id, required Timestamp startDate, required Timestamp dueDate, required String status, }) {
    return UpsertPregnancyVariablesBuilder(dataConnect, id: id,startDate: startDate,dueDate: dueDate,status: status,);
  }
  
  
  UpsertTrackerRecordVariablesBuilder upsertTrackerRecord ({required String id, required String type, required String title, required Timestamp occurredAt, }) {
    return UpsertTrackerRecordVariablesBuilder(dataConnect, id: id,type: type,title: title,occurredAt: occurredAt,);
  }
  

  static ConnectorConfig connectorConfig = ConnectorConfig(
    'us-east4',
    'example',
    'grownest',
  );

  ExampleConnector({required this.dataConnect});
  static ExampleConnector get instance {
    
    return ExampleConnector(
        dataConnect: FirebaseDataConnect.instanceFor(
            connectorConfig: connectorConfig,
            
            sdkType: CallerSDKType.generated));
  }

  FirebaseDataConnect dataConnect;
}

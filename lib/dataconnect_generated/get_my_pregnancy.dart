part of 'generated.dart';

class GetMyPregnancyVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  GetMyPregnancyVariablesBuilder(this._dataConnect, );
  Deserializer<GetMyPregnancyData> dataDeserializer = (dynamic json)  => GetMyPregnancyData.fromJson(jsonDecode(json));
  
  Future<QueryResult<GetMyPregnancyData, void>> execute() {
    return ref().execute();
  }

  QueryRef<GetMyPregnancyData, void> ref() {
    
    return _dataConnect.query("GetMyPregnancy", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class GetMyPregnancyPregnancies {
  final String id;
  final Timestamp startDate;
  final Timestamp dueDate;
  final String status;
  final Timestamp? birthCompletedAt;
  GetMyPregnancyPregnancies.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  startDate = Timestamp.fromJson(json['startDate']),
  dueDate = Timestamp.fromJson(json['dueDate']),
  status = nativeFromJson<String>(json['status']),
  birthCompletedAt = json['birthCompletedAt'] == null ? null : Timestamp.fromJson(json['birthCompletedAt']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetMyPregnancyPregnancies otherTyped = other as GetMyPregnancyPregnancies;
    return id == otherTyped.id && 
    startDate == otherTyped.startDate && 
    dueDate == otherTyped.dueDate && 
    status == otherTyped.status && 
    birthCompletedAt == otherTyped.birthCompletedAt;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, startDate.hashCode, dueDate.hashCode, status.hashCode, birthCompletedAt.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['startDate'] = startDate.toJson();
    json['dueDate'] = dueDate.toJson();
    json['status'] = nativeToJson<String>(status);
    if (birthCompletedAt != null) {
      json['birthCompletedAt'] = birthCompletedAt!.toJson();
    }
    return json;
  }

  GetMyPregnancyPregnancies({
    required this.id,
    required this.startDate,
    required this.dueDate,
    required this.status,
    this.birthCompletedAt,
  });
}

@immutable
class GetMyPregnancyData {
  final List<GetMyPregnancyPregnancies> pregnancies;
  GetMyPregnancyData.fromJson(dynamic json):
  
  pregnancies = (json['pregnancies'] as List<dynamic>)
        .map((e) => GetMyPregnancyPregnancies.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetMyPregnancyData otherTyped = other as GetMyPregnancyData;
    return pregnancies == otherTyped.pregnancies;
    
  }
  @override
  int get hashCode => pregnancies.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['pregnancies'] = pregnancies.map((e) => e.toJson()).toList();
    return json;
  }

  GetMyPregnancyData({
    required this.pregnancies,
  });
}


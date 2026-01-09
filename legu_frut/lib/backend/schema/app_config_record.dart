import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class AppConfigRecord extends FirestoreRecord {
  AppConfigRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "popup_enabled" field.
  bool? _popupEnabled;
  bool get popupEnabled => _popupEnabled ?? false;
  bool hasPopupEnabled() => _popupEnabled != null;

  // "popup_title" field.
  String? _popupTitle;
  String get popupTitle => _popupTitle ?? '';
  bool hasPopupTitle() => _popupTitle != null;

  // "popup_desc_1" field.
  String? _popupDesc1;
  String get popupDesc1 => _popupDesc1 ?? '';
  bool hasPopupDesc1() => _popupDesc1 != null;

  // "popup_desc_2" field.
  String? _popupDesc2;
  String get popupDesc2 => _popupDesc2 ?? '';
  bool hasPopupDesc2() => _popupDesc2 != null;

  void _initializeFields() {
    _popupEnabled = snapshotData['popup_enabled'] as bool?;
    _popupTitle = snapshotData['popup_title'] as String?;
    _popupDesc1 = snapshotData['popup_desc_1'] as String?;
    _popupDesc2 = snapshotData['popup_desc_2'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('app_config');

  static Stream<AppConfigRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => AppConfigRecord.fromSnapshot(s));

  static Future<AppConfigRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => AppConfigRecord.fromSnapshot(s));

  static AppConfigRecord fromSnapshot(DocumentSnapshot snapshot) =>
      AppConfigRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static AppConfigRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      AppConfigRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'AppConfigRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is AppConfigRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createAppConfigRecordData({
  bool? popupEnabled,
  String? popupTitle,
  String? popupDesc1,
  String? popupDesc2,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'popup_enabled': popupEnabled,
      'popup_title': popupTitle,
      'popup_desc_1': popupDesc1,
      'popup_desc_2': popupDesc2,
    }.withoutNulls,
  );

  return firestoreData;
}

class AppConfigRecordDocumentEquality implements Equality<AppConfigRecord> {
  const AppConfigRecordDocumentEquality();

  @override
  bool equals(AppConfigRecord? e1, AppConfigRecord? e2) {
    return e1?.popupEnabled == e2?.popupEnabled &&
        e1?.popupTitle == e2?.popupTitle &&
        e1?.popupDesc1 == e2?.popupDesc1 &&
        e1?.popupDesc2 == e2?.popupDesc2;
  }

  @override
  int hash(AppConfigRecord? e) => const ListEquality()
      .hash([e?.popupEnabled, e?.popupTitle, e?.popupDesc1, e?.popupDesc2]);

  @override
  bool isValidKey(Object? o) => o is AppConfigRecord;
}

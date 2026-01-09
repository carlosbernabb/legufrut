import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class OrdersRecord extends FirestoreRecord {
  OrdersRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "userRef" field.
  DocumentReference? _userRef;
  DocumentReference? get userRef => _userRef;
  bool hasUserRef() => _userRef != null;

  // "createdAt" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  bool hasCreatedAt() => _createdAt != null;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  bool hasStatus() => _status != null;

  // "street" field.
  String? _street;
  String get street => _street ?? '';
  bool hasStreet() => _street != null;

  // "number" field.
  String? _number;
  String get number => _number ?? '';
  bool hasNumber() => _number != null;

  // "postalCode" field.
  String? _postalCode;
  String get postalCode => _postalCode ?? '';
  bool hasPostalCode() => _postalCode != null;

  // "neighborhood" field.
  String? _neighborhood;
  String get neighborhood => _neighborhood ?? '';
  bool hasNeighborhood() => _neighborhood != null;

  // "referenceNote" field.
  String? _referenceNote;
  String get referenceNote => _referenceNote ?? '';
  bool hasReferenceNote() => _referenceNote != null;

  // "subtotal" field.
  double? _subtotal;
  double get subtotal => _subtotal ?? 0.0;
  bool hasSubtotal() => _subtotal != null;

  // "shippingFee" field.
  double? _shippingFee;
  double get shippingFee => _shippingFee ?? 0.0;
  bool hasShippingFee() => _shippingFee != null;

  // "total" field.
  double? _total;
  double get total => _total ?? 0.0;
  bool hasTotal() => _total != null;

  // "location" field.
  LatLng? _location;
  LatLng? get location => _location;
  bool hasLocation() => _location != null;

  // "fullAddress" field.
  String? _fullAddress;
  String get fullAddress => _fullAddress ?? '';
  bool hasFullAddress() => _fullAddress != null;

  // "nombrecliente" field.
  String? _nombrecliente;
  String get nombrecliente => _nombrecliente ?? '';
  bool hasNombrecliente() => _nombrecliente != null;

  // "showorder" field.
  bool? _showorder;
  bool get showorder => _showorder ?? false;
  bool hasShoworder() => _showorder != null;

  // "driverRef" field.
  DocumentReference? _driverRef;
  DocumentReference? get driverRef => _driverRef;
  bool hasDriverRef() => _driverRef != null;

  // "driverTag" field.
  String? _driverTag;
  String get driverTag => _driverTag ?? '';
  bool hasDriverTag() => _driverTag != null;

  // "driverStatusText" field.
  String? _driverStatusText;
  String get driverStatusText => _driverStatusText ?? '';
  bool hasDriverStatusText() => _driverStatusText != null;

  // "driverStep" field.
  int? _driverStep;
  int get driverStep => _driverStep ?? 0;
  bool hasDriverStep() => _driverStep != null;

  // "userToken" field.
  String? _userToken;
  String get userToken => _userToken ?? '';
  bool hasUserToken() => _userToken != null;

  void _initializeFields() {
    _userRef = snapshotData['userRef'] as DocumentReference?;
    _createdAt = snapshotData['createdAt'] as DateTime?;
    _status = snapshotData['status'] as String?;
    _street = snapshotData['street'] as String?;
    _number = snapshotData['number'] as String?;
    _postalCode = snapshotData['postalCode'] as String?;
    _neighborhood = snapshotData['neighborhood'] as String?;
    _referenceNote = snapshotData['referenceNote'] as String?;
    _subtotal = castToType<double>(snapshotData['subtotal']);
    _shippingFee = castToType<double>(snapshotData['shippingFee']);
    _total = castToType<double>(snapshotData['total']);
    _location = snapshotData['location'] as LatLng?;
    _fullAddress = snapshotData['fullAddress'] as String?;
    _nombrecliente = snapshotData['nombrecliente'] as String?;
    _showorder = snapshotData['showorder'] as bool?;
    _driverRef = snapshotData['driverRef'] as DocumentReference?;
    _driverTag = snapshotData['driverTag'] as String?;
    _driverStatusText = snapshotData['driverStatusText'] as String?;
    _driverStep = castToType<int>(snapshotData['driverStep']);
    _userToken = snapshotData['userToken'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('orders');

  static Stream<OrdersRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => OrdersRecord.fromSnapshot(s));

  static Future<OrdersRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => OrdersRecord.fromSnapshot(s));

  static OrdersRecord fromSnapshot(DocumentSnapshot snapshot) => OrdersRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static OrdersRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      OrdersRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'OrdersRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is OrdersRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createOrdersRecordData({
  DocumentReference? userRef,
  DateTime? createdAt,
  String? status,
  String? street,
  String? number,
  String? postalCode,
  String? neighborhood,
  String? referenceNote,
  double? subtotal,
  double? shippingFee,
  double? total,
  LatLng? location,
  String? fullAddress,
  String? nombrecliente,
  bool? showorder,
  DocumentReference? driverRef,
  String? driverTag,
  String? driverStatusText,
  int? driverStep,
  String? userToken,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'userRef': userRef,
      'createdAt': createdAt,
      'status': status,
      'street': street,
      'number': number,
      'postalCode': postalCode,
      'neighborhood': neighborhood,
      'referenceNote': referenceNote,
      'subtotal': subtotal,
      'shippingFee': shippingFee,
      'total': total,
      'location': location,
      'fullAddress': fullAddress,
      'nombrecliente': nombrecliente,
      'showorder': showorder,
      'driverRef': driverRef,
      'driverTag': driverTag,
      'driverStatusText': driverStatusText,
      'driverStep': driverStep,
      'userToken': userToken,
    }.withoutNulls,
  );

  return firestoreData;
}

class OrdersRecordDocumentEquality implements Equality<OrdersRecord> {
  const OrdersRecordDocumentEquality();

  @override
  bool equals(OrdersRecord? e1, OrdersRecord? e2) {
    return e1?.userRef == e2?.userRef &&
        e1?.createdAt == e2?.createdAt &&
        e1?.status == e2?.status &&
        e1?.street == e2?.street &&
        e1?.number == e2?.number &&
        e1?.postalCode == e2?.postalCode &&
        e1?.neighborhood == e2?.neighborhood &&
        e1?.referenceNote == e2?.referenceNote &&
        e1?.subtotal == e2?.subtotal &&
        e1?.shippingFee == e2?.shippingFee &&
        e1?.total == e2?.total &&
        e1?.location == e2?.location &&
        e1?.fullAddress == e2?.fullAddress &&
        e1?.nombrecliente == e2?.nombrecliente &&
        e1?.showorder == e2?.showorder &&
        e1?.driverRef == e2?.driverRef &&
        e1?.driverTag == e2?.driverTag &&
        e1?.driverStatusText == e2?.driverStatusText &&
        e1?.driverStep == e2?.driverStep &&
        e1?.userToken == e2?.userToken;
  }

  @override
  int hash(OrdersRecord? e) => const ListEquality().hash([
        e?.userRef,
        e?.createdAt,
        e?.status,
        e?.street,
        e?.number,
        e?.postalCode,
        e?.neighborhood,
        e?.referenceNote,
        e?.subtotal,
        e?.shippingFee,
        e?.total,
        e?.location,
        e?.fullAddress,
        e?.nombrecliente,
        e?.showorder,
        e?.driverRef,
        e?.driverTag,
        e?.driverStatusText,
        e?.driverStep,
        e?.userToken
      ]);

  @override
  bool isValidKey(Object? o) => o is OrdersRecord;
}

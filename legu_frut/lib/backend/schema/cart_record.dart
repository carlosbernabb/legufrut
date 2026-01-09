import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CartRecord extends FirestoreRecord {
  CartRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "productRef" field.
  DocumentReference? _productRef;
  DocumentReference? get productRef => _productRef;
  bool hasProductRef() => _productRef != null;

  // "productName" field.
  String? _productName;
  String get productName => _productName ?? '';
  bool hasProductName() => _productName != null;

  // "pricePerKg" field.
  double? _pricePerKg;
  double get pricePerKg => _pricePerKg ?? 0.0;
  bool hasPricePerKg() => _pricePerKg != null;

  // "grams" field.
  double? _grams;
  double get grams => _grams ?? 0.0;
  bool hasGrams() => _grams != null;

  // "unitPrice" field.
  double? _unitPrice;
  double get unitPrice => _unitPrice ?? 0.0;
  bool hasUnitPrice() => _unitPrice != null;

  // "createdAt" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  bool hasCreatedAt() => _createdAt != null;

  // "unitType" field.
  String? _unitType;
  String get unitType => _unitType ?? '';
  bool hasUnitType() => _unitType != null;

  // "coverimage" field.
  String? _coverimage;
  String get coverimage => _coverimage ?? '';
  bool hasCoverimage() => _coverimage != null;

  // "userRef" field.
  DocumentReference? _userRef;
  DocumentReference? get userRef => _userRef;
  bool hasUserRef() => _userRef != null;

  // "CarritoVacio" field.
  bool? _carritoVacio;
  bool get carritoVacio => _carritoVacio ?? false;
  bool hasCarritoVacio() => _carritoVacio != null;

  void _initializeFields() {
    _productRef = snapshotData['productRef'] as DocumentReference?;
    _productName = snapshotData['productName'] as String?;
    _pricePerKg = castToType<double>(snapshotData['pricePerKg']);
    _grams = castToType<double>(snapshotData['grams']);
    _unitPrice = castToType<double>(snapshotData['unitPrice']);
    _createdAt = snapshotData['createdAt'] as DateTime?;
    _unitType = snapshotData['unitType'] as String?;
    _coverimage = snapshotData['coverimage'] as String?;
    _userRef = snapshotData['userRef'] as DocumentReference?;
    _carritoVacio = snapshotData['CarritoVacio'] as bool?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('cart');

  static Stream<CartRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => CartRecord.fromSnapshot(s));

  static Future<CartRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => CartRecord.fromSnapshot(s));

  static CartRecord fromSnapshot(DocumentSnapshot snapshot) => CartRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static CartRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      CartRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'CartRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is CartRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createCartRecordData({
  DocumentReference? productRef,
  String? productName,
  double? pricePerKg,
  double? grams,
  double? unitPrice,
  DateTime? createdAt,
  String? unitType,
  String? coverimage,
  DocumentReference? userRef,
  bool? carritoVacio,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'productRef': productRef,
      'productName': productName,
      'pricePerKg': pricePerKg,
      'grams': grams,
      'unitPrice': unitPrice,
      'createdAt': createdAt,
      'unitType': unitType,
      'coverimage': coverimage,
      'userRef': userRef,
      'CarritoVacio': carritoVacio,
    }.withoutNulls,
  );

  return firestoreData;
}

class CartRecordDocumentEquality implements Equality<CartRecord> {
  const CartRecordDocumentEquality();

  @override
  bool equals(CartRecord? e1, CartRecord? e2) {
    return e1?.productRef == e2?.productRef &&
        e1?.productName == e2?.productName &&
        e1?.pricePerKg == e2?.pricePerKg &&
        e1?.grams == e2?.grams &&
        e1?.unitPrice == e2?.unitPrice &&
        e1?.createdAt == e2?.createdAt &&
        e1?.unitType == e2?.unitType &&
        e1?.coverimage == e2?.coverimage &&
        e1?.userRef == e2?.userRef &&
        e1?.carritoVacio == e2?.carritoVacio;
  }

  @override
  int hash(CartRecord? e) => const ListEquality().hash([
        e?.productRef,
        e?.productName,
        e?.pricePerKg,
        e?.grams,
        e?.unitPrice,
        e?.createdAt,
        e?.unitType,
        e?.coverimage,
        e?.userRef,
        e?.carritoVacio
      ]);

  @override
  bool isValidKey(Object? o) => o is CartRecord;
}

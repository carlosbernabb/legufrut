import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class OrdersitemsRecord extends FirestoreRecord {
  OrdersitemsRecord._(
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

  // "unitType" field.
  String? _unitType;
  String get unitType => _unitType ?? '';
  bool hasUnitType() => _unitType != null;

  // "pricePerKg" field.
  double? _pricePerKg;
  double get pricePerKg => _pricePerKg ?? 0.0;
  bool hasPricePerKg() => _pricePerKg != null;

  // "grams" field.
  double? _grams;
  double get grams => _grams ?? 0.0;
  bool hasGrams() => _grams != null;

  // "qtyPieces" field.
  int? _qtyPieces;
  int get qtyPieces => _qtyPieces ?? 0;
  bool hasQtyPieces() => _qtyPieces != null;

  // "unitPrice" field.
  double? _unitPrice;
  double get unitPrice => _unitPrice ?? 0.0;
  bool hasUnitPrice() => _unitPrice != null;

  // "coverimage" field.
  String? _coverimage;
  String get coverimage => _coverimage ?? '';
  bool hasCoverimage() => _coverimage != null;

  DocumentReference get parentReference => reference.parent.parent!;

  void _initializeFields() {
    _productRef = snapshotData['productRef'] as DocumentReference?;
    _productName = snapshotData['productName'] as String?;
    _unitType = snapshotData['unitType'] as String?;
    _pricePerKg = castToType<double>(snapshotData['pricePerKg']);
    _grams = castToType<double>(snapshotData['grams']);
    _qtyPieces = castToType<int>(snapshotData['qtyPieces']);
    _unitPrice = castToType<double>(snapshotData['unitPrice']);
    _coverimage = snapshotData['coverimage'] as String?;
  }

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('ordersitems')
          : FirebaseFirestore.instance.collectionGroup('ordersitems');

  static DocumentReference createDoc(DocumentReference parent, {String? id}) =>
      parent.collection('ordersitems').doc(id);

  static Stream<OrdersitemsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => OrdersitemsRecord.fromSnapshot(s));

  static Future<OrdersitemsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => OrdersitemsRecord.fromSnapshot(s));

  static OrdersitemsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      OrdersitemsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static OrdersitemsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      OrdersitemsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'OrdersitemsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is OrdersitemsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createOrdersitemsRecordData({
  DocumentReference? productRef,
  String? productName,
  String? unitType,
  double? pricePerKg,
  double? grams,
  int? qtyPieces,
  double? unitPrice,
  String? coverimage,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'productRef': productRef,
      'productName': productName,
      'unitType': unitType,
      'pricePerKg': pricePerKg,
      'grams': grams,
      'qtyPieces': qtyPieces,
      'unitPrice': unitPrice,
      'coverimage': coverimage,
    }.withoutNulls,
  );

  return firestoreData;
}

class OrdersitemsRecordDocumentEquality implements Equality<OrdersitemsRecord> {
  const OrdersitemsRecordDocumentEquality();

  @override
  bool equals(OrdersitemsRecord? e1, OrdersitemsRecord? e2) {
    return e1?.productRef == e2?.productRef &&
        e1?.productName == e2?.productName &&
        e1?.unitType == e2?.unitType &&
        e1?.pricePerKg == e2?.pricePerKg &&
        e1?.grams == e2?.grams &&
        e1?.qtyPieces == e2?.qtyPieces &&
        e1?.unitPrice == e2?.unitPrice &&
        e1?.coverimage == e2?.coverimage;
  }

  @override
  int hash(OrdersitemsRecord? e) => const ListEquality().hash([
        e?.productRef,
        e?.productName,
        e?.unitType,
        e?.pricePerKg,
        e?.grams,
        e?.qtyPieces,
        e?.unitPrice,
        e?.coverimage
      ]);

  @override
  bool isValidKey(Object? o) => o is OrdersitemsRecord;
}

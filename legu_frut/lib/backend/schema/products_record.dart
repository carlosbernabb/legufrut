import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ProductsRecord extends FirestoreRecord {
  ProductsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  bool hasName() => _name != null;

  // "description" field.
  String? _description;
  String get description => _description ?? '';
  bool hasDescription() => _description != null;

  // "category" field.
  String? _category;
  String get category => _category ?? '';
  bool hasCategory() => _category != null;

  // "price" field.
  double? _price;
  double get price => _price ?? 0.0;
  bool hasPrice() => _price != null;

  // "unitType" field.
  String? _unitType;
  String get unitType => _unitType ?? '';
  bool hasUnitType() => _unitType != null;

  // "coverImage" field.
  String? _coverImage;
  String get coverImage => _coverImage ?? '';
  bool hasCoverImage() => _coverImage != null;

  // "createdTime" field.
  DateTime? _createdTime;
  DateTime? get createdTime => _createdTime;
  bool hasCreatedTime() => _createdTime != null;

  // "owner" field.
  DocumentReference? _owner;
  DocumentReference? get owner => _owner;
  bool hasOwner() => _owner != null;

  // "image" field.
  String? _image;
  String get image => _image ?? '';
  bool hasImage() => _image != null;

  // "docCart" field.
  DocumentReference? _docCart;
  DocumentReference? get docCart => _docCart;
  bool hasDocCart() => _docCart != null;

  // "saleType" field.
  String? _saleType;
  String get saleType => _saleType ?? '';
  bool hasSaleType() => _saleType != null;

  void _initializeFields() {
    _name = snapshotData['name'] as String?;
    _description = snapshotData['description'] as String?;
    _category = snapshotData['category'] as String?;
    _price = castToType<double>(snapshotData['price']);
    _unitType = snapshotData['unitType'] as String?;
    _coverImage = snapshotData['coverImage'] as String?;
    _createdTime = snapshotData['createdTime'] as DateTime?;
    _owner = snapshotData['owner'] as DocumentReference?;
    _image = snapshotData['image'] as String?;
    _docCart = snapshotData['docCart'] as DocumentReference?;
    _saleType = snapshotData['saleType'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('products');

  static Stream<ProductsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ProductsRecord.fromSnapshot(s));

  static Future<ProductsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ProductsRecord.fromSnapshot(s));

  static ProductsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      ProductsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ProductsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ProductsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ProductsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ProductsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createProductsRecordData({
  String? name,
  String? description,
  String? category,
  double? price,
  String? unitType,
  String? coverImage,
  DateTime? createdTime,
  DocumentReference? owner,
  String? image,
  DocumentReference? docCart,
  String? saleType,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'name': name,
      'description': description,
      'category': category,
      'price': price,
      'unitType': unitType,
      'coverImage': coverImage,
      'createdTime': createdTime,
      'owner': owner,
      'image': image,
      'docCart': docCart,
      'saleType': saleType,
    }.withoutNulls,
  );

  return firestoreData;
}

class ProductsRecordDocumentEquality implements Equality<ProductsRecord> {
  const ProductsRecordDocumentEquality();

  @override
  bool equals(ProductsRecord? e1, ProductsRecord? e2) {
    return e1?.name == e2?.name &&
        e1?.description == e2?.description &&
        e1?.category == e2?.category &&
        e1?.price == e2?.price &&
        e1?.unitType == e2?.unitType &&
        e1?.coverImage == e2?.coverImage &&
        e1?.createdTime == e2?.createdTime &&
        e1?.owner == e2?.owner &&
        e1?.image == e2?.image &&
        e1?.docCart == e2?.docCart &&
        e1?.saleType == e2?.saleType;
  }

  @override
  int hash(ProductsRecord? e) => const ListEquality().hash([
        e?.name,
        e?.description,
        e?.category,
        e?.price,
        e?.unitType,
        e?.coverImage,
        e?.createdTime,
        e?.owner,
        e?.image,
        e?.docCart,
        e?.saleType
      ]);

  @override
  bool isValidKey(Object? o) => o is ProductsRecord;
}

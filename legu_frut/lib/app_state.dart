import 'package:flutter/material.dart';
import '/backend/backend.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {}

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  String _selectedCategory = '';
  String get selectedCategory => _selectedCategory;
  set selectedCategory(String value) {
    _selectedCategory = value;
  }

  String _unitType = '';
  String get unitType => _unitType;
  set unitType(String value) {
    _unitType = value;
  }

  String _priceLabel = '';
  String get priceLabel => _priceLabel;
  set priceLabel(String value) {
    _priceLabel = value;
  }

  String _pickedImage = '';
  String get pickedImage => _pickedImage;
  set pickedImage(String value) {
    _pickedImage = value;
  }

  String _image1 = '';
  String get image1 => _image1;
  set image1(String value) {
    _image1 = value;
  }

  String _searchitem = '';
  String get searchitem => _searchitem;
  set searchitem(String value) {
    _searchitem = value;
  }

  List<String> _products = [];
  List<String> get products => _products;
  set products(List<String> value) {
    _products = value;
  }

  void addToProducts(String value) {
    products.add(value);
  }

  void removeFromProducts(String value) {
    products.remove(value);
  }

  void removeAtIndexFromProducts(int index) {
    products.removeAt(index);
  }

  void updateProductsAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    products[index] = updateFn(_products[index]);
  }

  void insertAtIndexInProducts(int index, String value) {
    products.insert(index, value);
  }

  double _subtotal = 0.0;
  double get subtotal => _subtotal;
  set subtotal(double value) {
    _subtotal = value;
  }

  List<LatLng> _driverPoints = [];
  List<LatLng> get driverPoints => _driverPoints;
  set driverPoints(List<LatLng> value) {
    _driverPoints = value;
  }

  void addToDriverPoints(LatLng value) {
    driverPoints.add(value);
  }

  void removeFromDriverPoints(LatLng value) {
    driverPoints.remove(value);
  }

  void removeAtIndexFromDriverPoints(int index) {
    driverPoints.removeAt(index);
  }

  void updateDriverPointsAtIndex(
    int index,
    LatLng Function(LatLng) updateFn,
  ) {
    driverPoints[index] = updateFn(_driverPoints[index]);
  }

  void insertAtIndexInDriverPoints(int index, LatLng value) {
    driverPoints.insert(index, value);
  }

  bool _buscador = false;
  bool get buscador => _buscador;
  set buscador(bool value) {
    _buscador = value;
  }

  bool _showPopup = true;
  bool get showPopup => _showPopup;
  set showPopup(bool value) {
    _showPopup = value;
  }

  bool _priceshow = false;
  bool get priceshow => _priceshow;
  set priceshow(bool value) {
    _priceshow = value;
  }

  bool _priceshowverduras = false;
  bool get priceshowverduras => _priceshowverduras;
  set priceshowverduras(bool value) {
    _priceshowverduras = value;
  }

  bool _priceshowabarrotes = false;
  bool get priceshowabarrotes => _priceshowabarrotes;
  set priceshowabarrotes(bool value) {
    _priceshowabarrotes = value;
  }

  bool _priceshowchiles = false;
  bool get priceshowchiles => _priceshowchiles;
  set priceshowchiles(bool value) {
    _priceshowchiles = value;
  }

  String _seletype = '';
  String get seletype => _seletype;
  set seletype(String value) {
    _seletype = value;
  }
}

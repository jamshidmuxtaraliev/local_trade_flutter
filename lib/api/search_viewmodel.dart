import 'dart:async';
import 'package:hive/hive.dart';
import 'package:local_trade_flutter/screens/models/category_model.dart';
import 'package:stacked/stacked.dart';
import '../../../api/api_service.dart';
import '../screens/models/product_model.dart';

class SearchViewModel extends BaseViewModel {
  final api = ApiService();

  StreamController<String> _errorStream = StreamController();

  Stream<String> get errorData {
    return _errorStream.stream;
  }

  StreamController<List<ProductModel>> _allProductStream = StreamController();

  Stream<List<ProductModel>> get allProductData {
    return _allProductStream.stream;
  }

  late final Box<ProductModel> box = Hive.box<ProductModel>('products_table');
  late final Box<CategoryModel> boxBrands = Hive.box<CategoryModel>('brands_table');
  var progressData = false;
  List<String> offerList = [];

  List<CategoryModel> categoryList = [];

  List<ProductModel> productList = [];

  void getProductList(String keyword) async {
    notifyListeners();
    productList = box.values.where((element) => element.tovar.toLowerCase().contains(keyword.toLowerCase())).toList();
    notifyListeners();
  }

  void getProductsByCategoryIdAndTovarIdOrKeyboard(String category, String keyword, String tovarId) async {
    notifyListeners();

    productList = box.values
        .where((element) =>
            (element.tovarId == tovarId) || (element.kategoriyaid == category) ||
            (element.tovar.toLowerCase().contains(keyword.toLowerCase())))
        .toList();

    notifyListeners();
  }

  @override
  void dispose() {
    _errorStream.close();
    super.dispose();
  }
}

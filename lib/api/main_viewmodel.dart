import 'dart:async';
import 'package:hive/hive.dart';
import 'package:local_trade_flutter/screens/models/category_model.dart';
import 'package:local_trade_flutter/screens/models/client_model.dart';
import 'package:local_trade_flutter/screens/models/make_order_model.dart';
import 'package:local_trade_flutter/screens/models/price_type_model.dart';
import 'package:local_trade_flutter/screens/models/product_model.dart';
import 'package:local_trade_flutter/services/boxes.dart';
import 'package:stacked/stacked.dart';

import '../../utils/pref_utils.dart';
import '../api/api_service.dart';
import '../screens/models/event_model.dart';
import '../screens/models/login_response.dart';
import '../services/event_bus.dart';
import '../utils/constants.dart';

class MainViewModel extends BaseViewModel {
  final api = ApiService();
  final StreamController<String> _errorStream = StreamController();

  final StreamController<LoginResponse> _loginConfirmStream = StreamController();

  Stream<LoginResponse> get loginConfirmData {
    return _loginConfirmStream.stream;
  }

  StreamController<LoginResponse> _userStream = StreamController();

  Stream<LoginResponse> get getUserData {
    return _userStream.stream;
  }

  StreamController<List<ProductModel>> _dbProductStream = StreamController();

  Stream<List<ProductModel>> get dbProductStreamData {
    return _dbProductStream.stream;
  }

  StreamController<List<CategoryModel>> _categoryDBStream = StreamController();

  Stream<List<CategoryModel>> get categoryDBData {
    return _categoryDBStream.stream;
  }

  StreamController<List<CategoryModel>> _categoryStream = StreamController();

  Stream<List<CategoryModel>> get categoryData {
    return _categoryStream.stream;
  }

  StreamController<List<ClientModel>> _clientStream = StreamController();

  Stream<List<ClientModel>> get clientStreamData {
    return _clientStream.stream;
  }

  StreamController<bool> _orderStream = StreamController();

  Stream<bool> get orderStreamData {
    return _orderStream.stream;
  }

  Stream<String> get errorData {
    return _errorStream.stream;
  }

  late final Box<ProductModel> box = Hive.box<ProductModel>('products_table');
  late final Box<CategoryModel> boxBrands = Hive.box<CategoryModel>('brands_table');

  var progressData = false;
  var progressProjectById = false;

  List<ProductModel> dbProductList = [];
  List<PriceTypeModel> priceTypeList = [];
  List<CategoryModel> categoryList = [];
  List<CategoryModel> dbCategoryList = [];
  List<ClientModel> clientList = [];

  void login(String login, String password) async {
    progressData = true;
    notifyListeners();
    final data = await api.login(login, password, _errorStream);
    if (data != null) {
      PrefUtils.setToken(data.token ?? "");
      PrefUtils.setUser(data);
      _loginConfirmStream.sink.add(data);
    }
    progressData = false;
    notifyListeners();
  }

  void getUser() async {
    progressData = true;
    notifyListeners();
    final data = await api.getUser(_errorStream);
    progressData = false;
    notifyListeners();
    if (data != null) {
      PrefUtils.setUser(data);
      _userStream.sink.add(data);
    }
  }

  void updateUser(
    String username,
    String password,
    String fullname,
    String phone_number,
    String email,
    String bio,
  ) async {
    progressData = true;
    notifyListeners();
    final data = await api.updateUser(username, password, fullname, phone_number, email, bio, _errorStream);
    if (data != null) {
      // PrefUtils.setUser(data);
      _loginConfirmStream.sink.add(data);
    }
    progressData = false;
    notifyListeners();
  }

  void getProductsFromURL() async {
    progressData = true;
    notifyListeners();
    final data = await api.getProducts(_errorStream);
    if (data.length != 0) {
      Box<ProductModel> boxProducts = Hive.box<ProductModel>('products_table');
      await boxProducts.clear();
      await boxProducts.addAll(data);
      eventBus.fire(EventModel(event: EVENT_UPDATE_PRODUCTS, data: 0));
      print("saved products to DB");
    }
    progressData = false;
    notifyListeners();
  }

  void getProductsByCategory(String categoryId) async {
    notifyListeners();
    dbProductList = (categoryId != "")
        ? box.values.where((element) => element.kategoriyaid == categoryId).toList()
        : box.values.toList();
    _dbProductStream.sink.add(dbProductList);
    notifyListeners();
  }

  void getProductsByBarcode(String barcode) async {
    notifyListeners();
    dbProductList = (barcode != "")
        ? box.values.where((element) => element.barcode.contains(barcode)).toList()
        : box.values.toList();
    _dbProductStream.sink.add(dbProductList);
    notifyListeners();
  }

  void getProductsByCategoryIdAndTovarIdOrKeyboard(String category, String keyword, String tovarId) async {
    notifyListeners();

    dbProductList = box.values
        .where((element) =>
            (element.tovarId == tovarId) ||
            (element.kategoriyaid == category) ||
            (element.tovar.toLowerCase().contains(keyword.toLowerCase())))
        .toList();

    notifyListeners();
  }

  //get price types
  void getType() async {
    progressData = true;
    notifyListeners();
    final data = await api.getType(_errorStream);
    priceTypeList = data;
    progressData = false;
    notifyListeners();
  }

  //get all categories
  void getCategoriesFromAPI() async {
    progressData = true;
    notifyListeners();
    final data = await api.getCategories(_errorStream);
    categoryList = data;
    if (data.isNotEmpty) {
      Box<CategoryModel> boxCategory = Hive.box<CategoryModel>('brands_table');
      await boxCategory.clear();
      await boxCategory.addAll(data);
      _categoryStream.sink.add(data);
      eventBus.fire(EventModel(event: EVENT_UPDATE_CATEGORIES, data: 0));
      print("saved categories to DB");
    }
    progressData = false;
    notifyListeners();
  }

  void getCategoriesByKeyword() async {
    notifyListeners();
    dbCategoryList = boxBrands.values.toList();
    _categoryDBStream.sink.add(dbCategoryList);
    notifyListeners();
  }

  //get Clientlar royhati
  void getClients() async {
    progressData = true;
    notifyListeners();
    final data = await api.getClients(
      _errorStream,
    );
    clientList = data;
    if (data.isNotEmpty) {
      _clientStream.sink.add(data);
    }
    progressData = false;
    notifyListeners();
  }

  void makeOrder(MakeOrderModel makeOrderModel) async {
    progressData = true;
    notifyListeners();
    final data = await api.makeOrder(
      makeOrderModel,
      _errorStream,
    );
    _orderStream.sink.add(data);
    progressData = false;
    notifyListeners();
  }

  // void getProductsByBrand(int brand_id) async {
  //   progressData = true;
  //   notifyListeners();
  //   final data = await api.getProductsByBrand(_errorStream, brand_id);
  //   priceVisible();
  //   productList = data;
  //   // _barChartStream.sink.add(data);
  //   progressData = false;
  //   notifyListeners();
  // }
  //
  // void getOffers() async {
  //   progressData = true;
  //   notifyListeners();
  //   final data = await api.getOffers(_errorStream);
  //   offerList = data;
  //   // if (data != null) {
  //   //   _locationListStream.sink.add(data);
  //   // }
  //   progressData = false;
  //   notifyListeners();
  // }
  //
  // //get filter element
  // void getFilterElements() async {
  //   progressData = true;
  //   notifyListeners();
  //   final data = await api.getFilterElements(_errorStream);
  //   if (data != null) {
  //     _filterElementStream.sink.add(data);
  //   }
  //   progressData = false;
  //   notifyListeners();
  // }
  //
  // //tovar narxi va ostatkani ko'rsatish yo ko'rsatmaslik
  // void priceVisible() async {
  //   progressData = true;
  //   notifyListeners();
  //   final data = await api.priceVisible(_errorStream);
  //   if (data != null) {
  //     PrefUtils.setVisibleData(data);
  //     _visibleStream.sink.add(data);
  //   }
  //   progressData = false;
  //   notifyListeners();
  // }
  //
  // void sendSMS(String phone) async {
  //   progressData = true;
  //   notifyListeners();
  //   final data = await api.sendSMS(_errorStream, phone);
  //   if (data != null) {
  //     _sendSmsStream.sink.add(data);
  //   }
  //   progressData = false;
  //   notifyListeners();
  // }
  //

  // void getAllProducts(
  //   int brand_id,
  //   int type_id,
  //   int razmer_id,
  //   int colour_id,
  //   int model_id,
  // ) async {
  //   progressData = true;
  //   notifyListeners();
  //   final data = await api.getAllProducts(
  //     brand_id,
  //     type_id,
  //     razmer_id,
  //     colour_id,
  //     model_id,
  //     _errorStream,
  //   );
  //   if (data != null) {
  //     _filterProductStream.sink.add(data);
  //   }
  //   filterProducts = data;
  //   progressData = false;
  //   notifyListeners();
  // }

  @override
  void dispose() {
    _errorStream.close();
    _loginConfirmStream.close();
    _userStream.close();
    // _connectedStream.close();
    super.dispose();
  }
}

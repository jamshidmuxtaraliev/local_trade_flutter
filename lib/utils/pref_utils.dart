import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../screens/models/basket_model.dart';
import '../screens/models/bdm_items_model.dart';
import '../screens/models/event_model.dart';
import '../screens/models/login_response.dart';
import '../screens/models/product_model.dart';
import '../services/event_bus.dart';
import 'constants.dart';

class PrefUtils {
  static SharedPreferences? _singleton;

  static const PREF_BDM_ITEMS = "bdm_items";
  static const PREF_SELECTED_BRANCH = "selected_branch";
  static const PREF_FAVORITES = "favorites";
  static const PREF_BASE_URL = "base_url";
  static const PREF_BASE_IMAGE_URL = "base_image_url";
  static const PREF_FCM_TOKEN = "fcm_token";
  static const PREF_TOKEN = "token";
  static const PREF_CATEGORY_LIST = "category_list";
  static const PREF_BASKET = "basket";
  static const PREF_USER = "user";
  static const PREF_IP = "pref_ip";
  static const PREF_PATH = "pref_path";
  static const PREF_TODAY = "PREF_TODAY";
  static const PREF_LANG = "lang";
  static const FIRST_RUN = "first_run";
  static const PREF_STORE = "store";
  static const PREF_LOCATION = "location";
  static const PREF_DRAWER = "drawer";
  static const PREF_TYPE = "price_type";
  static const TRADE_VERSION = "TRADE_VERSION";

  static SharedPreferences? getInstance() {
    return _singleton;
  }

  static initInstance() async {
    _singleton = await SharedPreferences.getInstance();
  }

  static BdmItemsModel? getBdmItems() {
    var json = _singleton?.getString(PREF_BDM_ITEMS);
    return json == null ? null : BdmItemsModel.fromJson(jsonDecode(json));
  }

  static Future<bool> setBdmItems(BdmItemsModel items) async {
    return _singleton!.setString(PREF_BDM_ITEMS, jsonEncode(items.toJson()));
  }

  static LoginResponse? getUser() {
    if (_singleton?.getString(PREF_USER) == null) {
      return null;
    } else {
      return LoginResponse.fromJson(jsonDecode(_singleton?.getString(PREF_USER) ?? ""));
    }
  }

  static Future<bool?> setUser(LoginResponse value) async {
    return _singleton?.setString(PREF_USER, jsonEncode(value.toJson()));
  }

  static Future<bool> setFirstRun(bool value) async{
    return _singleton!.setBool(FIRST_RUN, value);
  }

  static bool isFirstRun(){
    return _singleton?.getBool(FIRST_RUN)?? true;
  }

  static bool isLangSelected() {
    return _singleton?.getBool(LANG_SELECTED) ?? false;
  }

  static Future<bool> setLangSelected(bool value) async {
    return _singleton!.setBool(LANG_SELECTED, value);
  }

  static void clearLogout() async {
    _singleton!.remove(LANG_SELECTED);
    _singleton!.remove(FIRST_RUN);
    _singleton!.remove(PREF_TOKEN);
    _singleton!.remove(PREF_USER);
    _singleton!.remove(PREF_BASKET);
    _singleton!.remove(PREF_FAVORITES);
    _singleton!.remove(PREF_DRAWER);
  }

  static String getBaseUrl() {
    return _singleton?.getString(PREF_BASE_URL) ?? "";
  }

  static Future<bool> setBaseUrl(String value) async {
    return _singleton!.setString(PREF_BASE_URL, value);
  }

  static String getBaseImageUrl() {
    return _singleton?.getString(PREF_BASE_IMAGE_URL) ?? "";
  }

  static Future<bool> setBaseImageUrl(String value) async {
    return _singleton!.setString(PREF_BASE_IMAGE_URL, value);
  }

  static String getFCMToken() {
    return _singleton?.getString(PREF_FCM_TOKEN) ?? "";
  }

  static Future<bool> setFCMToken(String value) async {
    return _singleton!.setString(PREF_FCM_TOKEN, value);
  }

  static String getToken() {
    return _singleton?.getString(PREF_TOKEN) ?? "";
  }

  static Future<bool> setToken(String value) async {
    return _singleton!.setString(PREF_TOKEN, value);
  }

  static String getIp() {
    return _singleton?.getString(PREF_IP) ?? "";
  }

  static Future<bool> setIp(String value) async {
    return _singleton!.setString(PREF_IP, value);
  }

  static String getPath() {
    return _singleton?.getString(PREF_PATH) ?? "";
  }

  static Future<bool> setPath(String value) async {
    return _singleton!.setString(PREF_PATH, value);
  }

  static String getTodayDate() {
    return _singleton?.getString(PREF_TODAY) ?? "";
  }

  static Future<bool> setTodayDate(String value) async {
    return _singleton!.setString(PREF_TODAY, value);
  }

  static int getPriceType() {
    var json = _singleton?.getInt(PREF_TYPE);
    return json??1;
  }

  static Future<bool> setPriceType(int value) async {
    return _singleton!.setInt(PREF_TYPE, value);
  }

  static bool getTradeVersion() {
    var json = _singleton?.getBool(TRADE_VERSION);
    return json??true;
  }

  static Future<bool> setTradeVersion(bool value) async {
    return _singleton!.setBool(TRADE_VERSION, value);
  }

  static String getLang() {
    return _singleton?.getString(PREF_LANG) ?? DEFAULT_LANG_KEY;
  }

  static Future<bool> setLang(String value) async {
    return _singleton!.setString(PREF_LANG, value);
  }

  //FAVORITE

  static List<String> getFavoriteList() {
    return _singleton!.getStringList(PREF_FAVORITES) ?? [];
  }

  static Future<bool> setFavoriteProduct(ProductModel item) async {
    var items = getFavoriteList();
    if (items.contains(item.tovarId)) {
      items = items.where((element) => element != item.tovarId).toList();
    } else {
      items.add(item.tovarId);
    }
    return _singleton!.setStringList(PREF_FAVORITES, items);
  }

  //CART LIST

  static Future<bool> clearCart() async {
    var result = await _singleton!.setString(PREF_BASKET, jsonEncode([].toList()));
    // EventBus().fire(EventModel(EVENT_UPDATE_CART, true));
    return result;
  }

  static List<BasketModel> getCartList() {
    var json = _singleton?.getString(PREF_BASKET);
    if (json == null) {
      return [];
    }
    var items = (jsonDecode(json) as List<dynamic>).map((js) => BasketModel.fromJson(js));
    return items.toList();
  }

  static double getCartCount(String id) {
    final items = PrefUtils.getCartList().where((element) => element.id == id).toList();
    return items.isNotEmpty ? items.first.count : 0.0;
  }

  static Future<bool> addToCart(BasketModel item) async {
    var items = getCartList();

    if (item.count == 0) {
      var index = 0;
      var removeIndex = -1;

      for (var element in items) {
        if (element.id == item.id) {
          removeIndex = index;
        }
        index++;
      }
      if (removeIndex > -1) {
        items.removeAt(removeIndex);
      }
    } else {
      var isHave = false;
      for (var element in items) {
        if (element.id == item.id) {
          element.count = item.count;
          element.price = item.price;
          element.totalPrice = item.totalPrice;

          isHave = true;
        }
      }

      if (!isHave) {
        items.add(item);
      }
    }

    var r = await _singleton!.setString(PREF_BASKET, jsonEncode(items.map((item) => item.toJson()).toList()));
    eventBus.fire(EventModel( event: EVENT_UPDATE_CART, data:items.length ));
    return r;
  }


  static void clearAll() async {
    final pref = await SharedPreferences.getInstance();
    await pref.clear();
  }
}

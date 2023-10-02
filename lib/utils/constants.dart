

import '../screens/models/product_model.dart';

const SECRET_NAME = "ToysMall";
const APP_TYPE = "";// client
const BASE_BDM_URL = "http://isti.uz/mobiles/load_config/";

const BASE_URL = "http://192.168.88.166:8080/bazaTestSavdo/hs/bazaTestSavdo/";
const BASE_IMAGE_URL = "http://185.196.213.71:5001/api/v1/admin-app/uploads/";

const UZ_LANG_KEY = "uz";
const RU_LANG_KEY = "ru";
const DEFAULT_LANG_KEY = UZ_LANG_KEY;
const LANG_SELECTED = "lang_selected";

const EVENT_UPDATE_CART = 1;
const EVENT_UPDATE_BADGE = 2;
const EVENT_UPDATE_PRODUCTS = 3;
const EVENT_UPDATE_CATEGORIES = 4;
const EVENT_LOG_OUT = 5;
const EVENT_BARCODE = 6;

class Constants {
  // static List<OrderModel> orderList = [];
  static List<ProductModel> updateCart = [];
}

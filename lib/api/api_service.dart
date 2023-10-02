import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:local_trade_flutter/screens/models/client_model.dart';
import 'package:local_trade_flutter/screens/models/product_model.dart';

import '../../main.dart';
import '../../utils/constants.dart';
import '../../utils/pref_utils.dart';
import '../screens/models/base_model.dart';
import '../screens/models/category_model.dart';
import '../screens/models/event_model.dart';
import '../screens/models/login_response.dart';
import '../screens/models/make_order_model.dart';
import '../screens/models/price_type_model.dart';
import '../services/event_bus.dart';

class ApiService {
  final dio = Dio();

  ApiService() {
    // dio.options.baseUrl = BASE_URL;
    dio.options.baseUrl = PrefUtils.getBaseUrl();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers.addAll({
      'Content-Type': 'application/json',
      'Authorization': 'Basic ${base64Encode(utf8.encode('mobiles:123'))}',
      'token': PrefUtils.getToken(),
      // 'store_id' : PrefUtils.getUser()?.store_id??"",
      'device': Platform.operatingSystem,
      'lang': PrefUtils.getLang(),
      'X-MobileLang': PrefUtils.getLang(),
      'X-Mobile-Type': "android",
      'Connection': "close",
    });
    dio.interceptors.add(MyApp.alice.getDioInterceptor());
  }

  String wrapError(DioException error) {
    if (kDebugMode) {
      return error.message ?? "Error";
    }
    switch (error.type) {
      case DioExceptionType.unknown:
        return "Network error.";
      case DioExceptionType.cancel:
        return "So'rov yuborib bo'lmadi.";
      case DioExceptionType.connectionTimeout:
        return "Serverga murojaat qilish vaqti tugadi. Tarmoqqa ulanishda muammo!";
      case DioExceptionType.badCertificate:
        return "Server bilan xavfsiz aloqa o'rnatib bo'lmadi.";
      case DioExceptionType.receiveTimeout:
        return "Kutish vaqti tugadi. Tarmoqqa ulanishda muammo!";
      case DioExceptionType.sendTimeout:
        return "Serverga murojaat qilish vaqti tugadi. Tarmoqqa ulanishda muammo!";
      case DioExceptionType.badResponse:
        return "Serverdan yaroqli javob olib bo'lmadi";
      default:
        return "Ko'zda tutilmagan xatolik !";
    }
    return error.message ?? "Ko'zda tutilmagan xatolik !";
  }

  BaseModel wrapResponse(Response response) {
    if (response.statusCode == 200) {
      final data = BaseModel.fromJson(response.data);
      if (!data.error) {
        return data;
      } else {
        if (data.error_code == 405) {
          eventBus.fire(EventModel(event: EVENT_LOG_OUT, data: 0));
          // PrefUtils.setToken("");
        }
      }
      return data;
    } else {
      return BaseModel(
        false,
        response.statusMessage ?? "Unknown error ${response.statusCode}",
        -1,
        null,
      );
    }
  }

  Future<LoginResponse?> login(String login, String password, StreamController<String> errorStream) async {
    try {
      final response = await dio.post("AuthToken",
          data: jsonEncode({
            "login": login,
            "password": password,
          }));
      final baseData = wrapResponse(response);
      if (!baseData.error) {
        return LoginResponse.fromJson(baseData.data);
      } else {
        errorStream.sink.add(baseData.message ?? "Error");
      }
    } on DioException catch (e) {
      errorStream.sink.add(wrapError(e));
    }
    return null;
  }

  Future<LoginResponse?> getUser(StreamController<String> errorStream) async {
    try {
      final response = await dio.get(
        "getUser",
      );
      final baseData = wrapResponse(response);
      if (!baseData.error) {
        return LoginResponse.fromJson(baseData.data);
      } else {
        errorStream.sink.add(baseData.message ?? "Error");
      }
    } on DioException catch (e) {
      errorStream.sink.add(wrapError(e));
    }
    return null;
  }

  Future<LoginResponse?> updateUser(String username, String password, String fullname, String phoneNumber, String email,
      String bio, StreamController<String> errorStream) async {
    try {
      final response = await dio.post("users/update",
          //queryParameters: {"phone": phone}
          data: jsonEncode({
            "username": username,
            "password": password,
            "fullname": fullname,
            "phone_number": phoneNumber,
            "email": email,
            "bio": bio
          }));
      final baseData = wrapResponse(response);
      if (!baseData.error) {
        return LoginResponse.fromJson(baseData.data);
      } else {
        errorStream.sink.add(baseData.message ?? "Error");
      }
    } on DioError catch (e) {
      errorStream.sink.add(wrapError(e));
    }
    return null;
  }

  Future<List<ProductModel>> getProducts(StreamController<String> errorStream) async {
    try {
      final response = await dio.get("TovarList",
          queryParameters: {"skladId": PrefUtils.getUser()?.skladId, "type": PrefUtils.getPriceType()});
      final baseData = wrapResponse(response);
      if (!baseData.error) {
        var items = (baseData.data as List<dynamic>).map((json) => ProductModel.fromJson(json)).toList();

        var favorites = PrefUtils.getFavoriteList();
        for (var item in items) {
          item.favorite =
              favorites.where((element) => item.tovarId == element).isNotEmpty;
        }

        return items;

      } else {
        errorStream.sink.add(baseData.message ?? "Error");
      }
    } on DioException catch (e) {
      errorStream.sink.add(wrapError(e));
    }
    return [];
  }

  Future<List<PriceTypeModel>> getType(StreamController<String> errorStream,) async {
    try {
      final response = await dio.get("getType");
      final baseData = wrapResponse(response);
      if (!baseData.error) {
        return (baseData.data as List<dynamic>).map((json) => PriceTypeModel.fromJson(json)).toList();
      } else {
        errorStream.sink.add(baseData.message ?? "Error");
      }
    } on DioException catch (e) {
      errorStream.sink.add(wrapError(e));
    }
    return [];
  }

  //get categories list
  Future<List<CategoryModel>> getCategories(StreamController<String> errorStream) async {
    try {
      final response = await dio.get("TovarKategoriya", queryParameters: {"skladId": PrefUtils.getUser()?.skladId });
      final baseData = wrapResponse(response);
      if (!baseData.error) {
        return (baseData.data as List<dynamic>).map((json) => CategoryModel.fromJson(json)).toList();
      } else {
        errorStream.sink.add(baseData.message ?? "Error");
      }
    } on DioException catch (e) {
      errorStream.sink.add(wrapError(e));
    }
    return [];
  }


//getBranches for rating
Future<List<ClientModel>> getClients(StreamController<String> errorStream) async {
  try {
    final response = await dio.get("KlientList", queryParameters: {"skladId": PrefUtils.getUser()?.skladId });
    final baseData = wrapResponse(response);
    if (!baseData.error) {
      return (baseData.data as List<dynamic>).map((json) => ClientModel.fromJson(json)).toList();
    } else {
      errorStream.sink.add(baseData.message ?? "Error");
    }
  } on DioException catch (e) {
    errorStream.sink.add(wrapError(e));
  }
  return [];
}


//ishchini baholash
  Future<bool> makeOrder(MakeOrderModel makeOrderModel, StreamController<String> errorStream) async {
    try {
      final response = await dio.post("Dok_Bron", data: jsonEncode({
        "clientId":makeOrderModel.clientId,
        "login":makeOrderModel.login,
        "orderType":makeOrderModel.orderType,
        "products":makeOrderModel.products,
        "type":makeOrderModel.type
      }));
      final baseData = wrapResponse(response);
      if (baseData.error == false) {
        return true;
      } else {
        errorStream.sink.add(baseData.message ?? "Error");
      }
    } on DioException catch (e) {
      errorStream.sink.add(wrapError(e));
    }
    return false;
  }

// //get filter elements
// Future<FilterElementModel?> getFilterElements(StreamController<String> errorStream) async {
//   try {
//     final response = await dio.get("getFilterElements");
//     final baseData = wrapResponse(response);
//     if (!baseData.error) {
//       return FilterElementModel.fromJson(baseData.data);
//     } else {
//       errorStream.sink.add(baseData.message ?? "Error");
//     }
//   } on DioException catch (e) {
//     errorStream.sink.add(wrapError(e));
//   }
//   return null;
// }
//
// //get filter elements
// Future<VisibleModel?> priceVisible(StreamController<String> errorStream) async {
//   try {
//     final response = await dio.get("Visible");
//     final baseData = wrapResponse(response);
//     if (!baseData.error) {
//       return VisibleModel.fromJson(baseData.data);
//     } else {
//       errorStream.sink.add(baseData.message ?? "Error");
//     }
//   } on DioException catch (e) {
//     errorStream.sink.add(wrapError(e));
//   }
//   return null;
// }
//
// //getEmployes for rating
// Future<List<EmployeModel>> getWorkerByBranches(StreamController<String> errorStream, int Dep_id) async {
//   try {
//     final response = await dio.get("getWorkerByDep", queryParameters: ({"Dep_id" : Dep_id,}));
//     final baseData = wrapResponse(response);
//     if (!baseData.error) {
//       return (baseData.data as List<dynamic>).map((json) => EmployeModel.fromJson(json)).toList();
//     } else {
//       errorStream.sink.add(baseData.message ?? "Error");
//     }
//   } on DioException catch (e) {
//     errorStream.sink.add(wrapError(e));
//   }
//   return [];
// }
//
// //getEmployes for rating
// Future<List<TurnModel>> getTurn(StreamController<String> errorStream,) async {
//   try {
//     print("phone is ${PrefUtils.getUser()?.phone}");
//     final response = await dio.get("getTurn",
//         queryParameters: ({
//           "phone": PrefUtils.getUser()?.phone,
//           // "phone": "+998942712519",
//         }));
//     final baseData = wrapResponse(response);
//     if (!baseData.error) {
//       return (baseData.data as List<dynamic>).map((json) => TurnModel.fromJson(json)).toList();
//     } else {
//       errorStream.sink.add(baseData.message ?? "Error");
//     }
//   } on DioException catch (e) {
//     errorStream.sink.add(wrapError(e));
//   }
//   return [];
// }
//

// //get all products with filter
// Future<List<ProductModel>> getAllProducts(int brand_id, int type_id, int razmer_id, int colour_id, int model_id,
//     StreamController<String> errorStream) async {
//   try {
//     final response = await dio.post("getAllProducts", data: jsonEncode({
//       "brand_id": brand_id,
//       "type_id": type_id,
//       "razmer_id": razmer_id,
//       "colour_id": colour_id,
//       "model_id": model_id,
//     }));
//     final baseData = wrapResponse(response);
//     if (baseData.error == false) {
//       return (baseData.data as List<dynamic>).map((json) => ProductModel.fromJson(json)).toList();;
//     } else {
//       errorStream.sink.add(baseData.message ?? "Error");
//     }
//   } on DioException catch (e) {
//     errorStream.sink.add(wrapError(e));
//   }
//   return [];
// }
}

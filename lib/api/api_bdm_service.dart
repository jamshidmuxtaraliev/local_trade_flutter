import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../main.dart';
import '../../utils/constants.dart';
import '../../utils/pref_utils.dart';
import '../screens/models/base_bdm_model.dart';
import '../screens/models/bdm_items_model.dart';

class ApiBdmService {
  final dio = Dio();

  ApiBdmService() {
    dio.options.baseUrl = BASE_BDM_URL;

    dio.options.headers.addAll({
          'token': PrefUtils.getToken(),
          'device': Platform.operatingSystem,
          'Content-Type': 'application/json'
        },);
    dio.interceptors.add(MyApp.alice.getDioInterceptor());
  }

  BaseBdmModel wrapResponse(Response response) {
    if (response.statusCode == 200) {
      final data = BaseBdmModel.fromJson(response.data);
      return data;
    } else {
      return BaseBdmModel(
          true,
          response.statusMessage ?? "Unknown error ${response.statusCode}",
          null);
    }
  }

  String wrapError(DioException error){
    if(kDebugMode){
      return error.message??"Error";
    }
    switch(error.type){
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
      default:return"Ko'zda tutilmagan xatolik !";
    }
    return error.message??"Ko'zda tutilmagan xatolik !";
  }

  Future<BdmItemsModel?> loadConfig(String path, StreamController<String> errorStream) async {
    try {
      final response = await dio.get(path);
      final baseData = wrapResponse(response);
      if (!baseData.error) {
        return BdmItemsModel.fromJson(baseData.items);
      } else {
        errorStream.sink.add(baseData.message ?? "Error");
      }
    } on DioException catch (e) {
      errorStream.sink.add(wrapError(e));
    }
    return null;
  }

}

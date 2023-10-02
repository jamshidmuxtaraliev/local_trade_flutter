import 'dart:async';
import 'dart:io';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:stacked/stacked.dart';

import '../../api/api_bdm_service.dart';
import '../../utils/constants.dart';
import '../../utils/pref_utils.dart';
import '../models/bdm_items_model.dart';

class SplashViewModel extends BaseViewModel {
  final api = ApiBdmService();

  StreamController<String> _errorStream = StreamController();

  Stream<String> get errorData {
    return _errorStream.stream;
  }

  StreamController<BdmItemsModel> _bdmItemsStream = StreamController();

  Stream<BdmItemsModel> get bdmItemsData {
    return _bdmItemsStream.stream;
  }

  var progressData = false;
  void loadConfig(String path) async {
    progressData = true;
    notifyListeners();
    await PrefUtils.initInstance();
    var data = await api.loadConfig(path,_errorStream);
    if (data != null) {
      // if (data.apps.where((element) => element.name == APP_TYPE).isNotEmpty) {

        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        if (Platform.isAndroid &&
            ((int.tryParse(packageInfo.buildNumber) ?? 0) <
                (int.tryParse(data.client_version_code) ?? 0))) {
          _errorStream.sink.add("Iltimos, ilovaning yangi versiyasini yuklab oling!");
          progressData = false;
          notifyListeners();
          return;
        }
        
        await PrefUtils.setBdmItems(data);
        // await PrefUtils.setBaseUrl("http://${data.ipaddress}:${data.ipport}/${data.href_address}/");
        await PrefUtils.setBaseUrl("http://${PrefUtils.getIp()}:8080/${PrefUtils.getPath()}/hs/${PrefUtils.getPath()}/");

        // await PrefUtils.setBaseUrl("http://${data.ipaddress}:${data.ipport}/img/${data.secret_name}/");
        await PrefUtils.setBaseImageUrl("http://${PrefUtils.getIp()}:8080/img/${PrefUtils.getPath()}/");

        _bdmItemsStream.sink.add(data);
      // } else {
      //   _errorStream.sink.add("Ilovadan foydalanib bo'lmaydi!");
      // }
    }
    progressData = false;
    notifyListeners();
  }



  @override
  void dispose() {
    _errorStream.close();
    super.dispose();
  }
}

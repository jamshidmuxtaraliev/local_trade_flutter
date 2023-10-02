import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:local_trade_flutter/screens/login/login_screen.dart';
import 'package:local_trade_flutter/screens/splash/splash_viewmodel.dart';
import 'package:local_trade_flutter/utils/colors.dart';
import 'package:local_trade_flutter/utils/pref_utils.dart';
import 'package:ntp/ntp.dart';
import 'package:stacked/stacked.dart';

import '../../generated/assets.dart';
import '../../utils/utils.dart';
import '../main/main_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {
  final TextEditingController _ipController = TextEditingController(text: '192.168.0.0');
  final TextEditingController _keyController = TextEditingController(text: "ToysMall");
  double _width = 30;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 200), () {
      setState(() {
        _width = 300;
      });
    });
  }

  Future<void> checkAll(SplashViewModel viewModel) async {
    if (PrefUtils.getIp() == "") {
      inputIpAddress(viewModel);
    } else if (PrefUtils.getPath() == "") {
      inputPath(viewModel);
    } else {
      var date = DateFormat('dd.MM.yyyy').format(await NTP.now());
      if (PrefUtils.getTodayDate() == "" || PrefUtils.getTodayDate() != date){
        viewModel.loadConfig(PrefUtils.getPath());
      }else{
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (_) => (PrefUtils.getToken() != "") ? MainScreen() : LoginScreen()),
                (route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SplashViewModel>.reactive(
      viewModelBuilder: () {
        return SplashViewModel();
      },
      builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: Colors.black54,
          body: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: AnimatedContainer(
                  transformAlignment: Alignment.center,
                  duration: const Duration(milliseconds: 1500),
                  width: _width,
                  height: _width,
                  alignment: Alignment.center,
                  child: const Image(
                    height: 300,
                    width: 300,
                    image: AssetImage(Assets.iconsLocallogo),
                  ),
                  onEnd: () async {
                    checkAll(viewModel);
                  },
                ),
              ),
              Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 20),
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(
                      color: AppColors.COLOR_PRIMARY,
                    ),
                  ))
            ],
          ),
        );
      },
      onViewModelReady: (viewModel) {
        viewModel.bdmItemsData.listen((event) async {
          var date = DateFormat('dd.MM.yyyy').format(await NTP.now());
          await PrefUtils.setTodayDate(date);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (_) => (PrefUtils.getToken() != "") ? MainScreen() : LoginScreen()),
                  (route) => false);
        });
      },
    );
  }

  void inputIpAddress(SplashViewModel viewModel) {
    final focusNode = FocusNode();
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(2, -2),
                    spreadRadius: 0,
                    blurRadius: 0,
                  ),
                  BoxShadow(
                    // color: Colors.purple,
                    offset: Offset(-2, -2),
                    spreadRadius: 0,
                    blurRadius: 0,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "IP addressni kiriting: ",
                    style: TextStyle(
                        letterSpacing: 1,
                        fontFamily: 'Roboto',
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  TextField(
                    controller: _ipController,
                    decoration: const InputDecoration(
                      focusColor: Colors.black,
                      hintText: 'Enter some text',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      //[focusedBorder], displayed when [TextField, InputDecorator.isFocused] is true
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2),
                      ),
                    ),
                    focusNode: focusNode,
                    cursorColor: Colors.black,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      child: const Text('Saqlash', style: TextStyle(color: Colors.white, fontSize: 16)),
                      onPressed: () {
                        if (_ipController.text == "") {
                          return;
                        } else {
                          PrefUtils.setIp(_ipController.text);
                          Navigator.pop(context);
                          checkAll(viewModel);
                        }
                      }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void inputPath(SplashViewModel viewModel) {
    final focusNode = FocusNode();
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    // color: Colors.purple,
                    offset: Offset(2, -2),
                    spreadRadius: 0,
                    blurRadius: 0,
                  ),
                  BoxShadow(
                    // color: Colors.purple,
                    offset: Offset(-2, -2),
                    spreadRadius: 0,
                    blurRadius: 0,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Maxfiy so\'zni kiriting: ",
                    style: TextStyle(
                        letterSpacing: 1,
                        fontFamily: 'Roboto',
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  TextField(
                    controller: _keyController,
                    decoration: const InputDecoration(
                      focusColor: Colors.black,
                      hintText: 'Maxfiy so\'znikiriting',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      //[focusedBorder], displayed when [TextField, InputDecorator.isFocused] is true
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2),
                      ),
                    ),
                    focusNode: focusNode,
                    cursorColor: Colors.black,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      child: const Text('Saqlash',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w500,
                          )),
                      onPressed: () async {
                        if (_keyController.text == "") {
                          Fluttertoast.showToast(msg: "Ma'lumotlarni to'ldiring !");
                          return;
                        }  else{
                          PrefUtils.setPath(_keyController.text);
                          await PrefUtils.setBaseUrl("http://${PrefUtils.getIp()}:8080/${PrefUtils.getPath()}/hs/${PrefUtils.getPath()}/");
                          Navigator.pop(context);
                          checkAll(viewModel);
                        }
                      }),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        child: const Text(
                          "IP manzilni sozlash",
                          style: TextStyle(decoration: TextDecoration.underline,
                              letterSpacing: 1, fontFamily: 'Roboto', fontWeight: FontWeight.w500, fontSize: 14),
                        ),
                        onTap: (){
                          PrefUtils.clearAll();
                          Navigator.pop(context);
                          checkAll(viewModel);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

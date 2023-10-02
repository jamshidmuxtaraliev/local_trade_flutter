import 'package:flutter/material.dart';
import 'package:local_trade_flutter/screens/main/main_screen.dart';
import 'package:local_trade_flutter/utils/utils.dart';
import 'package:stacked/stacked.dart';

import '../../api/main_viewmodel.dart';
import '../../generated/assets.dart';
import '../../utils/colors.dart';
import '../../utils/custom_views.dart';
import '../../utils/pref_utils.dart';
import '../splash/splash_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var activeButton = false;
  var loginController = TextEditingController(text: "admin");
  var passwordController = TextEditingController(text: "123");

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: ViewModelBuilder.reactive(
      viewModelBuilder: () {
        return MainViewModel();
      },
      builder: (context, viewModel, child) {
        return Scaffold(
          // resizeToAvoidBottomInset : false,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 60,
                  ),
                  Image.asset(
                    Assets.iconsLocallogo,
                    height: 130,
                    width: 130,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  const Text("Tizimga kirish",
                      textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 28,
                  ),
                  CustomViews.buildTextField(
                    "Login",
                    "Loginni kiriting",
                    cursorColor: AppColors.BLACK,
                    controller: loginController,
                    inputType: TextInputType.text,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomViews.buildTextField(
                    "Parol",
                    "Parolni kiriting",
                    cursorColor: AppColors.BLACK,
                    controller: passwordController,
                    textInputAction: TextInputAction.done,
                    inputType: TextInputType.text,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: getScreenWidth(context),
                    height: 48,
                    child: (viewModel.progressData)
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.COLOR_GREY,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0))),
                            onPressed: () {
                              if (loginController.text.length < 3 || passwordController.text.length < 3) {
                                showWarning(context, "Kerakli maydonlarni to'ldiring !");
                              } else {
                                viewModel.login(loginController.text, passwordController.text);
                              }
                            },
                            child: const Text("Kirish",
                                style: TextStyle(color: Colors.white, fontSize: 20, letterSpacing: 1))),
                  ),
                  TextButton(
                      onPressed: () {
                        PrefUtils.clearAll();
                        Navigator.pushAndRemoveUntil(
                            context, MaterialPageRoute(builder: (_) => SplashScreen()), (route) => false);
                      },
                      child: const Text(
                        "Tarmoqni sozlash",
                        style: TextStyle(color: AppColors.GRAY_COLOR, decoration: TextDecoration.underline),
                      ))
                ],
              ),
            ),
          ),
        );
      },
      onViewModelReady: (viewModel) {
        viewModel.errorData.listen((event) {
          showError(context, event);
        });

        viewModel.loginConfirmData.listen((event) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => MainScreen()));
        });
      },
    ));
  }
}

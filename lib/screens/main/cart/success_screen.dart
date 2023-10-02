import 'package:flutter/material.dart';
import 'package:local_trade_flutter/screens/main/main_screen.dart';
import 'package:local_trade_flutter/utils/colors.dart';
import 'package:provider/provider.dart';

import '../../../generated/assets.dart';
import '../../../services/providers.dart';
import '../../../utils/utils.dart';

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({Key? key}) : super(key: key);

  @override
  _SuccessScreenState createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<Providers>(
      builder: ( context, provider,  child) {
        return Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Buyurtmangiz qabul qilindi!",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.LIGHT_BLACK),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Image.asset(
                    Assets.imagesSuccess,
                    width: 200,
                    height: 200,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  const Text(
                    "Xizmatlarimizdan foydalanganingiz uchun rahmat",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: AppColors.LIGHT_BLACK),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  GestureDetector(
                    onTap: () {
                      provider.setIndex(0);
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx)=>MainScreen()));
                    },
                    child: Container(
                      width: getScreenWidth(context),
                      height: 45,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(top: 0, left: 12, right: 12, bottom: 8),
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(6)), color: AppColors.LIGHT_BLACK),
                      child: const Text(
                        "Asosiy oynaga qaytish",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'colors.dart';

void setOrientation(bool or) {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(or ? [DeviceOrientation.portraitUp] : [DeviceOrientation.landscapeLeft])
      .then((_) {});
}

void startScreenF(BuildContext context, StatefulWidget stl) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => stl));
}

void startScreenS(BuildContext context, StatelessWidget stl) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => stl));
}

void finishScreen(BuildContext context) {
  Navigator.pop(context);
}

String formatHHMMSS(int seconds) {
  // int hours = (seconds / 3600).truncate();
  seconds = (seconds % 3600).truncate();
  int minutes = (seconds / 60).truncate();

  // String hoursStr = (hours).toString().padLeft(2, '0');
  String minutesStr = (minutes).toString().padLeft(1, '0');
  String secondsStr = (seconds % 60).toString().padLeft(2, '0');

  // if (hours == 0) {
  //   return "$minutesStr:$secondsStr";
  // }
//$hoursStr:
  return "$minutesStr:$secondsStr";
}

void clearFocus(BuildContext context) {
  FocusScope.of(context).requestFocus(FocusNode()); //remove focus
}

String getChars(String words, int limitTo) {
  List<String> names = words.split(" ");
  String initials = '';
  for (var i = 0; i < names.length; i++) {
    initials += names[i][0];
    if (i >= limitTo - 1) return initials;
  }
  return initials;
}

String getCurrentDateTime() {
  var now = DateTime.now();
  var formatter = DateFormat('yyyy.MM.dd');
  String formattedDate = formatter.format(now);
  print(formattedDate); // 2016-01-25
  return formattedDate;
}

double getScreenHeight(context) {
  return MediaQuery.of(context).size.height;
}

double getScreenWidth(context) {
  return MediaQuery.of(context).size.width;
}

void vibrateMedium() {
  HapticFeedback.mediumImpact();
}

void vibrateLight() {
  HapticFeedback.lightImpact();
}

void vibrateHeavy() {
  HapticFeedback.heavyImpact();
}

void showSnackeBar(BuildContext context, String message) {
  ScaffoldMessenger.maybeOf(context)?.showSnackBar(SnackBar(content: Text(message)));
}

TextStyle asTextStyle(
    {String? fontFamily, Color? color, double? size, FontWeight? fontWeight, List<Shadow>? shadow, TextOverflow? overflow}) {
  color = color ?? AppColors.WHITE;
  return TextStyle(
      fontFamily: fontFamily?? "regular",
      color: color,
      fontSize: size ?? 14,
      shadows: shadow,
      overflow: overflow,
      fontWeight: fontWeight);
}

showMyBottomSheet(
    BuildContext context,
    Widget child, {
      EdgeInsets? margin,
      double? topRadiuses,
      Color? backgroundColor,
      Color? borderColor,
      bool? isDismissible,
      double? borderWidth,
      double? minHeight,
    }) async {
  topRadiuses ??= 16;
  backgroundColor ??= Colors.white;
  margin ??= EdgeInsets.all(8);
  borderColor ??= AppColors.COLOR_PRIMARY;
  borderWidth ??= 1.0;
  minHeight ??= 10;
  isDismissible ??= true;

  return showModalBottomSheet(
    context: context,
    isDismissible: isDismissible,
    barrierColor: AppColors.COLOR_GREY.withOpacity(0.8),
    isScrollControlled: true,
    // only work on showModalBottomSheet function
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(topRadiuses), topRight: Radius.circular(topRadiuses)),
        side: BorderSide(
          width: borderWidth,
          color: borderColor,
        )),
    builder: (context) => Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: backgroundColor,
          boxShadow: [
            BoxShadow(
              color: AppColors.GRAY_COLOR,
              blurRadius: 8,
              offset: Offset(1, 1), // Shadow position
            ),
          ],
          borderRadius:
          BorderRadius.only(topRight: Radius.circular(topRadiuses!), topLeft: Radius.circular(topRadiuses)),
          shape: BoxShape.rectangle,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: margin,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        width: 60,
                        height: 10,
                        decoration: BoxDecoration(color: AppColors.LIGHT_GRAY_COLOR, borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.clear_rounded,color: AppColors.WHITE,)),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 16, right: 4, left: 4),
                      child: child,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ),
  );
}

Widget showMyProgress() {
  return Container(
      alignment: Alignment.center,
      color: Colors.black.withAlpha(90),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: AppColors.COLOR_PRIMARY, blurRadius: 150, spreadRadius: 1, blurStyle: BlurStyle.normal)],
          color: AppColors.COLOR_PRIMARY.withAlpha(100),
          borderRadius: BorderRadius.circular(8),
        ),
        child: CircularProgressIndicator(
          color: Colors.white,
          backgroundColor: AppColors.LIGHT_GRAY_COLOR,
        ),
      ));
}

Future<void> showError(BuildContext context, String message, {Function? pressOk}) async {
  var size = MediaQuery.of(context).size;
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    barrierColor: AppColors.COLOR_PRIMARY.withAlpha(10), //this works
    builder: (BuildContext context) {
      return Align(
        alignment: Alignment.center,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaY: 4, sigmaX: 4),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Align(
                alignment: Alignment.center,
                child: Container(
                    padding: const EdgeInsets.all(8),
                    width: size.width * 0.8,
                    decoration: BoxDecoration(
                        color: AppColors.COLOR_PRIMARY.withAlpha(500),
                        borderRadius: const BorderRadius.all(Radius.circular(16)),
                        gradient: const LinearGradient(
                            colors: [Colors.black45, Colors.black87],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 16),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.error_outlined,
                              size: 36,
                              color: Colors.red,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    "Xatolik !!!",
                                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 4),
                                  Text(message,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                      maxLines: 10,
                                      overflow: TextOverflow.ellipsis),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                                onPressed: () {
                                  if (pressOk != null) {
                                    pressOk();
                                    Navigator.pop(context);
                                  } else {
                                    Navigator.pop(context);
                                  }
                                },
                                child: const Text(
                                  "Ha",
                                  style: TextStyle(color: Colors.white),
                                ))
                          ],
                        )
                      ],
                    )),
              ),
            ),
          ),
        ),
      );
    },
  );
}

Future<void> showWarning(BuildContext context, String message,
    {Function? pressOk, bool? noButton, bool? forSingOut}) async {
  var size = MediaQuery.of(context).size;
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    barrierColor: AppColors.COLOR_PRIMARY.withAlpha(10), //this works
    builder: (BuildContext context) {
      return Align(
        alignment: Alignment.center,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaY: 8, sigmaX: 8),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Align(
                alignment: Alignment.center,
                child: Container(
                    padding: const EdgeInsets.all(8),
                    width: size.width * 0.8,
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(16)),
                        gradient: const LinearGradient(
                            colors: [Colors.black45, Colors.black87],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 16),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(width: 8),
                            const Icon(
                              Icons.warning_rounded,
                              size: 36,
                              color: Colors.orange,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    "Diqqat !!!",
                                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 4),
                                  Text(message,
                                      style: const TextStyle(color: Colors.white, fontSize: 16),
                                      maxLines: 10,
                                      overflow: TextOverflow.ellipsis)
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Visibility(
                                  visible: noButton != null ? true : false,
                                  child: const Text(
                                    "Нет",
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                )),
                            TextButton(
                                onPressed: () async {
                                  if (pressOk != null) {
                                    pressOk();
                                    if (forSingOut != true) {
                                      Navigator.pop(context);
                                    }
                                  } else {
                                    Navigator.pop(context);
                                  }
                                },
                                child: const Text(
                                  "OK",
                                  style: const TextStyle(color: Colors.white),
                                ))
                          ],
                        )
                      ],
                    )),
              ),
            ),
          ),
        ),
      );
    },
  );
}

Future<void> showSuccess(BuildContext context, String message, {Function? pressOk, bool? isDismisible}) async {
  var size = MediaQuery.of(context).size;
  return showDialog<void>(
    context: context,
    barrierDismissible: isDismisible??false,
    barrierColor: AppColors.COLOR_PRIMARY.withAlpha(10), //this works
    builder: (BuildContext context) {
      return Align(
        alignment: Alignment.center,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaY: 4, sigmaX: 4),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Align(
                alignment: Alignment.center,
                child: Container(
                    padding: const EdgeInsets.all(8),
                    width: size.width * 0.8,
                    decoration: BoxDecoration(
                        color: AppColors.COLOR_PRIMARY.withAlpha(500),
                        borderRadius: const BorderRadius.all(Radius.circular(16)),
                        gradient: const LinearGradient(
                            colors: [Colors.black45, Colors.black87],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 16),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.cloud_done_outlined,
                              size: 36,
                              color: Colors.green,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    "Muvaffaqiyatli.",
                                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 4),
                                  Text(message,
                                      style: const TextStyle(color: Colors.white, fontSize: 16),
                                      maxLines: 10,
                                      overflow: TextOverflow.ellipsis)
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                                onPressed: () {
                                  if (pressOk != null) {
                                    pressOk();
                                    Navigator.pop(context);
                                  } else {
                                    Navigator.pop(context);
                                  }
                                },
                                child: const Text(
                                  "OK",
                                  style: TextStyle(color: Colors.white),
                                ))
                          ],
                        )
                      ],
                    )),
              ),
            ),
          ),
        ),
      );
    },
  );
}

Widget rowText(String value, String value2,
    {double? fontSize, double? sizedBox, Color? color, FontWeight? fontWeight}) {
  sizedBox ??= 4;
  fontSize ??= 16;
  color ??= Colors.black;
  fontWeight ??= FontWeight.w500;
  return Column(
    children: [
      SizedBox(height: sizedBox),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(value, style: TextStyle(fontSize: fontSize, fontWeight: fontWeight, color: color)),
        Flexible(
            child: Text(value2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: fontSize, fontWeight: fontWeight, color: color)))
      ])
    ],
  );
}

showMyGeneralDialog(
    BuildContext context,
    String title, {
      Alignment? alignment,
      Color? backgraoundColor,
      Function? pressOk,
      Function? pressNo,
      String? textOk,
      String? textNo,
    }) async {
  backgraoundColor ??= Colors.white;
  return showGeneralDialog(
    barrierLabel: "Label",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.7),
    transitionDuration: const Duration(milliseconds: 500),
    context: context,
    pageBuilder: (context, anim1, anim2) {
      alignment ??= Alignment.center;
      return Align(
        alignment: alignment!,
        child: Container(
          margin: EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: backgraoundColor,
              border: Border.all(width: 1, color: Colors.white),
              borderRadius: BorderRadius.all(const Radius.circular(8))),
          child: Material(
              color: AppColors.TRANSPARENT,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 12, top: 12),
                          child: Icon(
                            Icons.clear,
                            size: 24,
                            color: Colors.grey,
                          ),
                        ),
                      )),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        textAlign: TextAlign.center,
                        title,
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: 26),
                      Container(
                        margin: EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Container(
                                height: 44,
                                decoration:
                                BoxDecoration(color: AppColors.LIGHT_GRAY_COLOR, borderRadius: BorderRadius.circular(6)),
                                child: TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      textNo ?? "Yo'q",
                                      style: TextStyle(color: AppColors.COLOR_PRIMARY, fontSize: 16, fontWeight: FontWeight.w700),
                                    )),
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Container(
                                height: 44,
                                decoration: BoxDecoration(color: AppColors.COLOR_PRIMARY, borderRadius: BorderRadius.circular(6)),
                                child: TextButton(
                                    onPressed: () {
                                      if (pressOk != null) {
                                        pressOk();
                                        Navigator.pop(context);
                                      } else {
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: Text(
                                      textOk ?? "Ha",
                                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                                    )),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              )),
        ),
      );
    },
    transitionBuilder: (context, anim1, anim2, child) {
      return SlideTransition(
        position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim1),
        child: child,
      );
    },
  );
}

Future<void> showConfirmDialog(BuildContext context, String message, {Function? pressOk, bool? noButton, bool? forSingOut}) async {
  var size = MediaQuery.of(context).size;
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    barrierColor: AppColors.COLOR_PRIMARY.withAlpha(10), //this works
    builder: (BuildContext context) {
      return Align(
        alignment: Alignment.center,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaY: 8, sigmaX: 8),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: InkWell(
              onTap: () {
                // Navigator.pop(context);
              },
              child: Align(
                alignment: Alignment.center,
                child: Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                        gradient: LinearGradient(
                            colors: [Colors.black45, Colors.black87],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          height: 24,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 48,right: 48, top: 16,bottom: 8),
                          child: Text(message ,
                              style: TextStyle(color: AppColors.WHITE, fontSize: 20, fontFamily: "semibold"),
                              maxLines: 10,

                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis),
                        ),
                        SizedBox(height: 8,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 44,
                              width: size.width * 0.3,
                              decoration: BoxDecoration(
                                border: Border.all(width: 1, color: Colors.grey),
                                borderRadius: const BorderRadius.all(Radius.circular(8)),
                              ),
                              child: TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Visibility(
                                    visible: noButton != null ? true : false,
                                    child: Text(
                                      "YO'Q",
                                      style: TextStyle(color: AppColors.WHITE,fontSize: 18),
                                    ),
                                  )),
                            ),
                            SizedBox(width: 16,),
                            Container(
                              height: 44,
                              width: size.width * 0.3,
                              decoration: BoxDecoration(
                                border: Border.all(width: 1, color: Colors.grey),
                                borderRadius: const BorderRadius.all(Radius.circular(8)),
                              ),
                              child: TextButton(
                                  style: ButtonStyle(overlayColor:
                                  MaterialStateProperty.all(AppColors.COLOR_PRIMARY.withOpacity(.2))),
                                  onPressed: () {
                                    if (pressOk != null) {
                                      pressOk();
                                      if (forSingOut != true) {
                                        Navigator.pop(context);
                                      }
                                    } else {
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: Text(
                                    "HA",
                                    style: const TextStyle(color: AppColors.WHITE,fontSize: 18),
                                  )),
                            )

                          ],
                        ),
                        SizedBox(height: 16,)
                      ],
                    )),
              ),
            ),
          ),
        ),
      );
    },
  );
}


Widget showAsProgress({
  Color? color
}) {
  color ??= AppColors.BLACK.withAlpha(90);
  return Container(
      alignment: Alignment.center,
      color: color,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          boxShadow: const [BoxShadow(color: AppColors.COLOR_PRIMARY, blurRadius: 150, spreadRadius: 1, blurStyle: BlurStyle.normal)],
          // border: Border.all(color: WHITE, width: 1),
          color: AppColors.COLOR_GREY.withAlpha(100),
          borderRadius: BorderRadius.circular(8),
        ),
        child: CircularProgressIndicator(
          color: AppColors.WHITE,
          backgroundColor: AppColors.COLOR_GREY,
        ),
      ));
}

Widget showWorkScreenProgress() {
  return Container(
      alignment: Alignment.center,
      color: AppColors.COLOR_GREY,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          boxShadow: const [BoxShadow(color: AppColors.COLOR_PRIMARY, blurRadius: 150, spreadRadius: 1, blurStyle: BlurStyle.normal)],
          // border: Border.all(color: WHITE, width: 1),
          color: AppColors.COLOR_GREY.withAlpha(100),
          borderRadius: BorderRadius.circular(8),
        ),
        child: CircularProgressIndicator(
          color: AppColors.WHITE,
          backgroundColor: AppColors.COLOR_GREY,
        ),
      ));
}

import 'dart:ui';

// import 'package:intl/src/intl/number_format.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:local_trade_flutter/utils/colors.dart';




// import '../utils/app_colors.dart';
// import '../utils/enum.dart';

/*
flutter packages pub run build_runner build --delete-conflicting-outputs

delete all the gradle temp files

flutter packages pub run build_runner build.
 */

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}

extension CustomStringCapitalize on String {
  String getShortName() => isNotEmpty
      ? trim()
          .split(' ')
          .map((l) => l.characters.firstOrNull?.toUpperCase() ?? "")
          .take(3)
          .join()
      : '';
}



extension CustomDouble on double {
  String formattedAmountString() {
    return NumberFormat.currency(locale: "uz", symbol: "")
        .format(this)
        .replaceAll(",00", "");
  }
}

extension CustomInt on int {
  String formattedAmount({bool? withSymbol}) {
    withSymbol = withSymbol ?? true;
    var summa = _thousandDecimalFormat(toDouble());
    if (withSymbol) {
      summa = summa + (" so‘m");
    }
    return summa;
  }

  double fixed({int? fix}) {
    fix ??= 2;
    return double.parse(toStringAsFixed(fix));
  }
}

extension CustomStringAmount on String {
  String formattedAmount({bool? withSymbol}) {
    withSymbol ??= true;
    var summa = _thousandDecimalFormat(parseToDouble());
    if (withSymbol) {
      summa = summa + (" so‘m");
    }
    return summa;
  }

  double parseToDouble() {
    var value = replaceAll(" ", "");
    var item = double.parse(value.isEmpty ? "0" : value);
    return item;
  }

  String phoneFormatter() {
    if (isEmpty) {
      return this;
    }
    var sb = StringBuffer();
    var temp = StringBuffer(toString());

    if (temp.length >= 9) {
      var phone = temp.toString().substring(temp.length - 9, temp.length);
      var chars = phone.replaceAll(RegExp(r'\D+'), '').split('');
      sb.write("+998 (");
      for (int i = 0; i < chars.length; i++) {
        switch (i) {
          case 2:
            sb.write(") ");
            break;
          case 5:
            sb.write(" ");
            break;
          case 7:
            sb.write(" ");
            break;
        }
        sb.write(chars[i]);
      }
      return sb.toString();
    } else {
      return toString();
    }
  }

  String phoneReplace() {
    return replaceAll(" ", "").replaceAll("(", "").replaceAll(")", "");
  }
}

String _thousandDecimalFormat(double? value) {
  var afterDot = 2;

  var num = value.toString();
  var numberDecimal = num.substring(num.indexOf('.') + 1);
  final numberInteger = List.from(num.substring(0, num.indexOf('.')).split(''));
  int index = numberInteger.length - 3;
  while (index > 0) {
    numberInteger.insert(index, ' ');
    index -= 3;
  }
  if (numberDecimal.length > afterDot) {
    numberDecimal = numberDecimal.substring(0, afterDot);
  }
  return int.parse(numberDecimal) > 0 ? "${numberInteger.join()}.$numberDecimal" : numberInteger.join();
}

// extension CustomDouble on double {
//   String formattedAmount4Digits({bool? withSymbol, Currency? currency}) {
//     withSymbol = withSymbol ?? false;
//     var summa = NumberFormat("#,##0.0###").format(this).replaceAll(",", " ");
//     if (withSymbol) {
//       summa = summa + (" ${_typeCur(currency)}");
//     }
//     return summa;
//   }

//   String formattedAmount2Digits({bool? withSymbol, Currency? currency}) {
//     withSymbol = withSymbol ?? false;
//     var summa = NumberFormat("#,##0.0#").format(this).replaceAll(",", " ");
//     if (withSymbol) {
//       summa = summa + (" ${_typeCur(currency)}");
//     }
//     return summa;
//   }
// }

// extension CustomStringAmount on String {
//   String formattedAmount4Digits({bool? withSymbol, Currency? currency}) {
//     withSymbol ??= false;
//     var summa =
//         NumberFormat("#,##0.0###").format(parseToDouble()).replaceAll(",", " ");
//     if (withSymbol) {
//       summa = summa + (" ${_typeCur(currency)}");
//     }
//     return summa;
//   }

//   String formattedAmount2Digits({bool? withSymbol, Currency? currency}) {
//     withSymbol = withSymbol ?? false;
//     var summa =
//         NumberFormat("#,##0.0#").format(parseToDouble()).replaceAll(",", " ");
//     if (withSymbol) {
//       summa = summa + (" ${_typeCur(currency)}");
//     }
//     return summa;
//   }
// }

extension CustomStringToDouble on String {
  double parseToDouble() {
    var value = replaceAll(" ", "");
    var item = double.parse(value.isEmpty ? "0" : value);
    return item;
  }
}

// dynamic _typeCur(Currency? currency) {
//   var type = "";
//   currency ??= Currency.SUM;
//   switch (currency) {
//     case Currency.DOLLAR:
//       type = "\$";
//       break;
//     case Currency.SUM:
//       type = "сум";
//       break;
//   }
//   return type;
// }

// extension CustomAmount on String {
//   String formattedAmount({bool? withSymbol}) {
//     withSymbol = withSymbol ?? false;
//     var summa = NumberFormat("#,##0.##").format(this).replaceAll(",", " ");
//     if (withSymbol) {
//       summa = summa + (" сум");
//     }
//     return summa;
//   }
// }

enum DeviceType { Phone, Tablet }

DeviceType getDeviceType() {
  final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
  return data.size.shortestSide < 550 ? DeviceType.Phone : DeviceType.Tablet;
}

Color getColor(String color) {
  switch (color) {
    case "color_bmd":
      return AppColors.BACKGROUND_COLOR;
    case "color_1":
      return Colors.white;
    case "color_2":
      return Colors.black;
    case "color_3":
      return Colors.grey;
    case "color_4":
      return HexColor.fromHex("#DCEFD3");
    case "color_5":
      return HexColor.fromHex("#CFE1F0");
    case "color_6":
      return HexColor.fromHex("#EEE0C9");
    case "color_7":
      return HexColor.fromHex("#DDDAF4");
    case "color_8":
      return HexColor.fromHex("#F5BCC7");
    case "color_9":
      return HexColor.fromHex("#EFCE94");
    case "color_10":
      return Colors.blueAccent;
    case "color_11":
      return Colors.grey.shade300;
  }
  return Colors.white;
}

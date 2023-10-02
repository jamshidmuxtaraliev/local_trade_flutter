import 'package:flutter/services.dart';

class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '', selection: const TextSelection.collapsed(offset: 0));
    }

    String value;
    value = newValue.text.toString();

    if (value.split(".").length > 2) {
      return oldValue;
    }

    if (value.startsWith(".")) {
      return newValue.copyWith(text: '0.', selection: const TextSelection.collapsed(offset: 2));
    }

    if (value.startsWith("0") && !value.startsWith("0.")) {
      return newValue.copyWith(text: '', selection: const TextSelection.collapsed(offset: 0));
    }

    if (value.contains(".") && value.length > value.indexOf(".") + 3) {
      return newValue.copyWith(
          text: value.substring(0, value.indexOf(".") + 3),
          selection: TextSelection.collapsed(offset: (value.substring(0, value.indexOf(".") + 3)).length));
    }

    var str = getDecimalFormattedString(newValue.text.toString().replaceAll(" ", ""));

    int selectionIndex = newValue.text.length - newValue.selection.extentOffset;

    return TextEditingValue(
        text: str.toString(),
        selection: TextSelection.collapsed(
          offset: str.length - selectionIndex,
        ));
  }
}

String getDecimalFormattedString(String value) {
  var lst = 0;
  if (value.contains(".")) {
    lst = value.split(".")[1].length;
  }

  var str1 = value;
  var str2 = "";
  if (lst > 0) {
    str1 = value.split(".")[0];
    str2 = value.split(".")[1];
  }
  var str3 = "";
  var i = 0;
  var j = -1 + str1.length;
  if (str1[-1 + str1.length] == '.') {
    j--;
    str3 = ".";
  }
  var k = j;
  while (true) {
    if (k < 0) {
      if (str2.isNotEmpty) str3 = "$str3.$str2";
      return str3;
    }
    if (i == 3) {
      str3 = " $str3";
      i = 0;
    }
    str3 = str1[k] + str3;
    i++;
    k--;
  }
}

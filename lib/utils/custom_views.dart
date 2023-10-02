import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/thousands_formatter.dart';

extension CustomViews on Widget {
  static Widget buildTextField(String title, String hint,
      {TextEditingController? controller,
        TextInputType? inputType,
        Color? textColor,
        Color? cursorColor,
        TextInputAction? textInputAction,
        TextCapitalization? textCapitalization,
        bool thousandFormat = false,
        bool obscureText = false,
        bool enabled = true,
        Function? onChanged,
        TextInputFormatter? textInputFormatter,
        bool? autoFocus}) {
    autoFocus ??= false;
    textColor ??= Colors.black;
    textInputAction ??= TextInputAction.next;
    textCapitalization ??= TextCapitalization.none;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16, color: textColor, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 8),
        TextField(
          cursorColor: cursorColor,
          autofocus: autoFocus,
          textCapitalization: textCapitalization,
          controller: controller,
          onTap: () {
            if (controller != null) {
              if (controller.text == ("0.0")) {
                controller.selection = TextSelection(baseOffset: 0, extentOffset: controller.value.text.length);
              }
            }
          },
          onChanged: (text) {
            if (onChanged != null) {
              onChanged(text);
            }
          },
          style: TextStyle(color: enabled ? Colors.black : AppColors.GRAY_COLOR, fontSize: 15, fontWeight: FontWeight.w400),
          textInputAction: textInputAction,
          keyboardType: inputType,
          obscureText: obscureText,
          enabled: enabled,
          inputFormatters: textInputFormatter != null
              ? [textInputFormatter]
              : thousandFormat
              ? [FilteringTextInputFormatter.deny(RegExp('[^0-9. ]')), ThousandsSeparatorInputFormatter()]
              : [],
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(color: AppColors.BLACK),
            ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: AppColors.LIGHT_GRAY),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: AppColors.LIGHT_GRAY),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.LIGHT_GRAY),
                borderRadius: BorderRadius.circular(4),
              ),
              filled: true,
              hintStyle: TextStyle(color: AppColors.HINT_COLOR, fontSize: 15, fontWeight: FontWeight.w300),
              hintText: hint,
              fillColor: AppColors.WHITE),
        )
      ],
    );
  }

  static Widget ipAddressTextField(String title, String hint,
      {TextEditingController? controller,
      TextInputType? inputType,
      Color? textColor,
      TextInputAction? textInputAction,
      TextCapitalization? textCapitalization,
      bool thousandFormat = false,
      bool obscureText = false,
      bool enabled = true,
      Function? onChanged,
      TextInputFormatter? textInputFormatter,
      bool? autoFocus}) {
    autoFocus ??= false;
    textColor ??= Colors.black;
    textInputAction ??= TextInputAction.next;
    textCapitalization ??= TextCapitalization.none;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16, color: textColor, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 8),
        TextField(
          autofocus: autoFocus,
          textCapitalization: textCapitalization,
          controller: controller,
          onTap: () {
            if (controller != null) {
              if (controller.text == ("0.0")) {
                controller.selection = TextSelection(baseOffset: 0, extentOffset: controller.value.text.length);
              }
            }
          },
          onChanged: (text) {
            if (onChanged != null) {
              onChanged(text);
            }
          },
          style: TextStyle(color: enabled ? Colors.black : AppColors.GRAY_COLOR, fontSize: 15, fontWeight: FontWeight.w400),
          textInputAction: textInputAction,
          keyboardType: inputType,
          obscureText: obscureText,
          enabled: enabled,
          inputFormatters: textInputFormatter != null
              ? [textInputFormatter]
              : thousandFormat
                  ? [FilteringTextInputFormatter.deny(RegExp('[^0-9. ]')), ThousandsSeparatorInputFormatter()]
                  : [],
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: AppColors.LIGHT_GRAY_COLOR),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: AppColors.LIGHT_GRAY_COLOR),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.LIGHT_GRAY_COLOR),
                borderRadius: BorderRadius.circular(4),
              ),
              filled: true,
              hintStyle: TextStyle(color: AppColors.HINT_COLOR, fontSize: 15, fontWeight: FontWeight.w300),
              hintText: hint,
              fillColor: AppColors.LIGHT_GRAY_COLOR),
        )
      ],
    );
  }

  static Widget buildBalanceTextField(BuildContext context, String title, String hint,
      {required VoidCallback onTapIcon,
      TextEditingController? controller,
      TextInputType? inputType,
      Color? textColor,
      TextInputAction? textInputAction,
      TextCapitalization? textCapitalization,
      bool thousandFormat = false,
      bool obscureText = false,
      bool enabled = true,
      Function? onChanged,
      MaskTextInputFormatter? maskTextInputFormatter}) {
    textColor ??= Colors.black;
    textInputAction ??= TextInputAction.next;
    textCapitalization ??= TextCapitalization.none;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16, color: textColor, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.only(right: 2, left: 2, top: 4, bottom: 4),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: AppColors.LIGHT_GRAY_COLOR),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  textCapitalization: textCapitalization,
                  controller: controller,
                  onTap: () {
                    if (controller != null) {
                      if (controller.text == ("0.0")) {
                        controller.selection = TextSelection(baseOffset: 0, extentOffset: controller.value.text.length);
                      }
                    }
                  },
                  onChanged: (text) {
                    if (onChanged != null) {
                      onChanged(text.toString());
                    }
                  },
                  style:
                      TextStyle(color: enabled ? Colors.black : AppColors.GRAY_COLOR, fontSize: 15, fontWeight: FontWeight.w400),
                  textInputAction: textInputAction,
                  keyboardType: inputType,
                  obscureText: obscureText,
                  enabled: enabled,
                  inputFormatters: maskTextInputFormatter != null
                      ? [maskTextInputFormatter]
                      : thousandFormat
                          ? [FilteringTextInputFormatter.deny(RegExp('[^0-9. ]')), ThousandsSeparatorInputFormatter()]
                          : [],
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      filled: true,
                      hintStyle: TextStyle(color: AppColors.HINT_COLOR, fontSize: 15, fontWeight: FontWeight.w300),
                      hintText: hint,
                      fillColor: AppColors.LIGHT_GRAY_COLOR),
                ),
              ),
              InkWell(
                onTap: () {
                  FocusScope.of(context).unfocus();
                  onTapIcon();
                },
                child: Container(
                    width: 36,
                    height: 36,
                    padding: EdgeInsets.all(9),
                    child: Icon(CupertinoIcons.equal_square_fill, color: AppColors.COLOR_PRIMARY)),
              )
            ],
          ),
        )
      ],
    );
  }

  static Widget buildSearchTextField(String hint,
      {TextEditingController? controller,
      Widget? leadingIcon,
      TextInputType? inputType,
      Function? onChanged,
      MaskTextInputFormatter? maskTextInputFormatter}) {
    leadingIcon ??= ImageIcon(
      AssetImage("assets/images/search.png"),
      color: AppColors.COLOR_PRIMARY,
    );
    return Container(
        margin: EdgeInsets.only(bottom: 16),
        padding: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: AppColors.LIGHT_GRAY_COLOR),
        child: Row(
          children: [
            Container(margin: EdgeInsets.symmetric(vertical: 16), child: leadingIcon),
            SizedBox(width: 2),
            Expanded(
              child: TextField(
                controller: controller,
                onChanged: (text) {
                  if (onChanged != null) {
                    onChanged(text);
                  }
                },
                keyboardType: inputType,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    filled: true,
                    hintStyle:
                        TextStyle(color: AppColors.HINT_COLOR, fontSize: 15, fontWeight: FontWeight.w400, fontFamily: "Raleway"),
                    hintText: hint,
                    fillColor: AppColors.LIGHT_GRAY_COLOR),
              ),
            )
          ],
        ));
  }

  static Widget buildSearchWithButton(
      {required BuildContext context,
      required String hint,
      required Function onTap,
      required bool? progress,
      TextEditingController? controller,
      Widget? leadingIcon,
      TextInputType? inputType,
      Function? onChanged,
      MaskTextInputFormatter? maskTextInputFormatter}) {
    progress ??= false;
    leadingIcon ??= ImageIcon(
      AssetImage("assets/images/search.png"),
      color: AppColors.COLOR_PRIMARY,
    );
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: AppColors.LIGHT_GRAY_COLOR),
                child: Row(
                  children: [
                    Container(margin: EdgeInsets.symmetric(vertical: 16), child: leadingIcon),
                    SizedBox(width: 2),
                    Expanded(
                      child: TextField(
                        keyboardType: inputType,
                        controller: controller,
                        onChanged: (text) {
                          if (onChanged != null) {
                            onChanged(text);
                          }
                        },
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            filled: true,
                            hintStyle: TextStyle(
                                color: AppColors.HINT_COLOR, fontSize: 15, fontWeight: FontWeight.w400, fontFamily: "Raleway"),
                            hintText: hint,
                            fillColor: AppColors.LIGHT_GRAY_COLOR),
                      ),
                    ),
                    progress
                        ? Container(
                            width: 24,
                            height: 24,
                            margin: EdgeInsets.symmetric(vertical: 16),
                            child: Lottie.asset("assets/lottie/loading.json"))
                        : Container(),
                  ],
                )),
          ),
          SizedBox(width: 8),
          InkWell(
            onTap: () {
              FocusScope.of(context).unfocus();
              onTap();
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 18, horizontal: 10),
              decoration: BoxDecoration(color: AppColors.COLOR_PRIMARY, borderRadius: BorderRadius.circular(4)),
              child: Text(
                "Топинг",
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          )
        ],
      ),
    );
  }

  static Widget buildActionTextField(
    String title,
    String hint,
    String? selectedData, {
    Function? onTap,
    IconData? iconData,
    Color? textColor,
  }) {
    textColor ??= Colors.black;
    iconData ??= Icons.chevron_right_rounded;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title,
            style: TextStyle(fontSize: 16, color: textColor, fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis),
        SizedBox(height: 8),
        (onTap != null)
            ? InkWell(
                onTap: () {
                  onTap();
                },
                child: _actionTextField(title, hint, selectedData, iconData: iconData),
              )
            : _actionTextField(title, hint, selectedData, iconData: iconData),
      ],
    );
  }

  static Widget _actionTextField(String title, String hint, String? selectedData, {IconData? iconData}) {
    return Container(
      padding: EdgeInsets.only(top: 16, bottom: 16, left: 8, right: 8),
      decoration: BoxDecoration(
          border: Border.all(color: selectedData == null ? AppColors.LIGHT_GRAY_COLOR : AppColors.COLOR_PRIMARY),
          borderRadius: BorderRadius.circular(4),
          color: AppColors.LIGHT_GRAY_COLOR),
      child: Row(
        children: [
          if (selectedData == null)
            Expanded(
                child: Text(
              hint,
              style: TextStyle(color: AppColors.HINT_COLOR, fontSize: 15, fontWeight: FontWeight.w300),
            )),
          if (selectedData != null)
            Expanded(
                child: Text(
              selectedData,
              style: TextStyle(fontSize: 15, color: AppColors.COLOR_PRIMARY, fontWeight: FontWeight.w500),
            )),
          Icon(
            iconData,
            color: selectedData == null ? AppColors.GRAY_COLOR : AppColors.COLOR_PRIMARY,
          )
        ],
      ),
    );
  }

  static Widget buildMoreTextField(String title, String hint,
      {TextEditingController? controller,
      bool enabled = true,
      IconData? prefixIcon,
      Color? textColor,
      int? maxLine,
      Function? onChanged}) {
    textColor ??= Colors.black;
    maxLine ??= 2;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16, color: textColor, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          textInputAction: TextInputAction.newline,
          keyboardType: TextInputType.multiline,
          maxLines: maxLine,
          enabled: enabled,
          onChanged: (text) {
            if (onChanged != null) {
              onChanged(text);
            }
          },
          decoration: InputDecoration(
              prefixIcon: prefixIcon != null
                  ? Icon(
                      prefixIcon,
                      color: Colors.grey.shade500,
                    )
                  : null,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: AppColors.LIGHT_GRAY_COLOR),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: AppColors.LIGHT_GRAY_COLOR),
              ),
              filled: true,
              hintStyle: TextStyle(color: AppColors.HINT_COLOR, fontSize: 15, fontWeight: FontWeight.w300),
              hintText: hint,
              fillColor: AppColors.LIGHT_GRAY_COLOR),
        )
      ],
    );
  }

  static Widget buildSelectCategory(String text, Widget icon) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(color: AppColors.LIGHT_GRAY_COLOR, borderRadius: BorderRadius.circular(6)),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.only(top: 13, bottom: 13, left: 16),
            child: icon,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 16), child: Icon(Icons.arrow_drop_down, color: Colors.black))
        ],
      ),
    );
  }

  static Widget buildNetworkImage(String? url,
      {double? height, double? width, BoxFit? fit, double? radius, double? paddingPlaceHolder}) {
    radius ??= 4;
    paddingPlaceHolder ??= 16;
    print(BASE_IMAGE_URL + (url ?? ""));
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: CachedNetworkImage(
        imageUrl: BASE_IMAGE_URL + (url ?? ""),
        placeholder: (context, url) => Center(
            child: Container(
                height: 20,
                width: 20,
                child: const CircularProgressIndicator(
                  color: Colors.grey,
                ))),
        errorWidget: (context, url, error) => Container(
            padding: EdgeInsets.all(paddingPlaceHolder!), child: Image.asset("assets/images/placeholder.png")),
        height: height,
        width: width,
        fit: fit ?? BoxFit.cover,
      ),
    );
  }
}

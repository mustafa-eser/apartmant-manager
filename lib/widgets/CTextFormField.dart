import 'package:apartmantmanager/Global/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Container CTextFormField({
  required String labelText,
  required TextEditingController controller,
  required BuildContext? context,
  TextStyle? labelStyle,
  EdgeInsetsGeometry? contentPadding,
  InputBorder? border,
  InputBorder? focusedBorder,
  InputBorder? enabledBorder,
  int? maxLines,
  int? minLines,
  FormFieldValidator<String>? validator,
  TextInputType? keyboardType,
  TextInputAction? textInputAction,
  bool obscureText = false,
  bool? enabled,
  String? hintText,
  Widget? suffix,
  Widget? prefix,
  bool? isPhone,
  BoxDecoration? boxDecoration,
  bool? latinExpressionKeyboard,
  String? errorText,
  void Function()? onTap,
  Function(String text)? onChange,
}) {
  return Container(
    decoration: boxDecoration ??
        BoxDecoration(
            color: Colors.white,
            borderRadius: borderRadius10,
            boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.5), spreadRadius: 1, blurRadius: 5, offset: Offset(0, 3))]),
    child: TextFormField(
      controller: controller,
      onChanged: (value) {
        if (onChange != null) {
          onChange(value);
        }
      },
      onTap: onTap,
      decoration: InputDecoration(
          errorText: errorText,
          labelText: labelText,
          suffix: suffix,
          hoverColor: GlobalConfig.primaryColor,
          prefix: prefix,
          focusColor: GlobalConfig.primaryColor,
          labelStyle: k25Gilroy(context!, color: Colors.black),
          contentPadding: contentPadding ?? paddingAll10,
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: k25Gilroy(context, color: Colors.grey)),
      inputFormatters:
          latinExpressionKeyboard != null ? (latinExpressionKeyboard == true ? [FilteringTextInputFormatter.allow(RegExp('[a-zA-ZıİçÇşŞöÖüÜğĞ]'))] : []) : [],
      maxLines: maxLines,
      minLines: minLines,
      validator: validator ??
          (value) {
            if (value!.isEmpty) {
              return 'Please enter some text'.tr();
            }
            return null;
          },
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      enabled: enabled,
    ),
  );
}

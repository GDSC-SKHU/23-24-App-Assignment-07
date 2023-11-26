import 'package:flutter/material.dart';
import 'package:flutter_cfmid_1/common/const/colors.dart';
import 'package:flutter_validator/flutter_validator.dart';

class CustomTextFormField extends StatelessWidget {
  final String? hintText;
  final String? errorText;
  final bool obscureText;
  final bool? autofocus;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;

  const CustomTextFormField({
    super.key,
    required this.onChanged,
    this.hintText,
    this.errorText,
    this.obscureText = false,
    this.autofocus = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    //material.dart에서 기본적으로 가저온것
    const baseBorder = OutlineInputBorder(
        borderSide: BorderSide(color: INPUT_BORDER_COLOR, width: 1.0));
    //underlineInputBorder()있다

    return TextFormField(
      cursorColor: PRIMARY_COLOR,
      //비밀번호 입력할떄
      obscureText: obscureText,
      //눌러야지 커서뜬다 true하면 자동으로 올라온다
      autofocus: false,
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(20), //텍스트필드안에서 커서 패딩
          hintText: hintText,
          errorText: errorText,
          hintStyle: const TextStyle(color: BODY_TEXT_COLOR, fontSize: 14),
          fillColor: INPUT_BG_COLOR, //텍스트필드살짝 회색 적용되어있다
          //false -배경색 없음
          //true -배경색 있음
          filled: true,
          border: baseBorder, //input 기본 스타일 세팅
          focusedBorder: baseBorder.copyWith(
              //눌렀을떄 copyWith 특성복사  포커스  (텍스트필드디자인하기12:00)
              borderSide: baseBorder.borderSide.copyWith(
            color: PRIMARY_COLOR,
          ))),
    );
  }
}

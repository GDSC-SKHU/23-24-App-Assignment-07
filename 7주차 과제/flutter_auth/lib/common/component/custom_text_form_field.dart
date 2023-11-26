import 'package:flutter/material.dart';
import 'package:flutter_auth/common/const/colors.dart';

class CustomTextFormField extends StatelessWidget {
  final String? hintText;
  final String? errorText;
  final bool obscureText;
  final bool autoFocus;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;

  const CustomTextFormField({
    super.key,
    this.hintText,
    this.errorText,
    this.obscureText = false,
    this.autoFocus = false,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    const baseborder = OutlineInputBorder(
        borderSide: BorderSide(
      color: INPUT_BORDER_COLOR,
      width: 1.0,
    ));

    return TextFormField(
      cursorColor: PRIMARY_COLOR,

      // 비밀번호 입력시
      obscureText: obscureText,

      // 화면에 텍스트필드가 들어왔을 때 바로 커서가 들어오는 지
      autofocus: autoFocus,

      // 값이 바뀔 때마다 실행되는 콜백
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(20),
        errorText: errorText,
        hintText: hintText,
        hintStyle: const TextStyle(
          color: BODY_TEXT_COLOR,
          fontSize: 14.0,
        ),
        fillColor: INPUT_BG_COLOR,

        // false - 배경색 없음
        // true - 배경색 있음
        filled: true,

        // 모든 Input 상태의 기본 스타일 세팅
        border: baseborder,

        // 선택되지 않았을 때 상태
        enabledBorder: baseborder,

        // 선택되었을 때 상태
        focusedBorder: baseborder.copyWith(
          borderSide: baseborder.borderSide.copyWith(
            color: PRIMARY_COLOR,
          ),
        ),
      ),
    );
  }
}
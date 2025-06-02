import 'package:flutter/material.dart';
import 'package:gtaos/utils/colors.dart';

class CustomTextInputField extends StatefulWidget {
  const CustomTextInputField(
      {Key? key,
      required this.title,
      required this.hintText,
      required this.controller,
      this.inputType = TextInputType.name,
      this.inputAction = TextInputAction.next,
      this.validator,
      this.readOnly = false,
      this.obscureText = false,
      this.type = TextFieldType.Text,
      this.prefix,
      this.errorText,
      this.maxLength,
      this.onTap,
      this.onChanged,
      this.prefixIconSize = 22,
      this.prefixIconColor,
      this.maxLines,
      this.borderRadius = 50,
      this.bottomMargin = 16,
      this.leading,
      this.onEditingComplete,
      this.enableCounterText = false,
      this.fontSize = 16,
      this.isRequired = false,
      this.autofocus = false,
      this.onFocusChange,
      this.suffix,
      this.fillColor,
      this.labelColor})
      : super(key: key);
  final String title, hintText;
  final TextEditingController controller;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final String? Function(String?)? validator;
  final bool readOnly, obscureText;
  final TextFieldType type;
  final IconData? prefix;
  final String? errorText;
  final int? maxLength;
  final Function()? onTap;
  final Function(String)? onChanged;
  final double prefixIconSize;
  final Color? prefixIconColor;
  final int? maxLines;
  final double borderRadius;
  final double bottomMargin;
  final Widget? leading;
  final Function()? onEditingComplete;
  final bool enableCounterText;
  final double fontSize;
  final bool isRequired;
  final Function(bool)? onFocusChange;
  final Color? labelColor;
  final Widget? suffix;
  final bool? autofocus;
  final Color? fillColor;
  @override
  _CustomTextInputFieldState createState() => _CustomTextInputFieldState();
}

class _CustomTextInputFieldState extends State<CustomTextInputField> {
  bool _isObscureText = false;

  @override
  void initState() {
    super.initState();
    _isObscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.only(bottom: widget.bottomMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title.isNotEmpty)
            Container(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                        text: widget.title,
                        style: _theme.textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: widget.fontSize,
                            letterSpacing: 0.28,
                            color: widget.labelColor),
                        children: [
                          if (widget.isRequired)
                            TextSpan(
                              text: "*",
                              style: _theme.textTheme.titleMedium!.copyWith(
                                fontWeight: FontWeight.w400,
                                fontSize: widget.fontSize,
                                letterSpacing: 0.28,
                                color: Colors.red,
                              ),
                            ),
                        ]),
                  ),
                  if (widget.leading != null) widget.leading!
                ],
              ),
            ),
          Stack(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Focus(
                      onFocusChange: widget.onFocusChange,
                      child: TextFormField(
                        autofocus: widget.autofocus ?? false,
                        controller: widget.controller,
                        textInputAction: widget.inputAction,
                        keyboardType: widget.inputType,
                        validator: widget.validator,
                        cursorColor: _theme.primaryColor,
                        maxLength: widget.maxLength,
                        readOnly: widget.readOnly,
                        obscureText: _isObscureText,
                        textCapitalization: TextCapitalization.sentences,
                        onTap: widget.onTap ?? () {},
                        maxLines: widget.type == TextFieldType.Password
                            ? 1
                            : widget.maxLines,
                        style: _theme.textTheme.titleMedium!.copyWith(
                            // color:  const Color(0xFF000000),
                            letterSpacing: 0.2,
                            color: Appcolors.blackDark,
                            fontWeight: FontWeight.w600,
                            fontSize: 18),
                        onChanged: widget.onChanged,
                        onEditingComplete: () {
                          if (widget.inputAction == TextInputAction.done) {
                            FocusScope.of(context).unfocus();
                          } else {
                            FocusScope.of(context).nextFocus();
                          }
                          if (widget.onEditingComplete != null) {
                            widget.onEditingComplete!();
                          }
                        },
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                      isDense: true,
                      // hintText: "Message" ,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10.0),
                      hintStyle: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        
                      ),
                    
                      border: OutlineInputBorder(
                        
                        borderRadius: BorderRadius.circular(12),
                        // borderSide: BorderSide(color: Colors.grey.shade200),
                        borderSide: BorderSide(color: Color(0XFFE2E2E2)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        // borderSide: BorderSide(color: Colors.grey.shade400),
                        borderSide: BorderSide(color: Color(0XFFE2E2E2)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      errorStyle: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 11,
                        color: Colors.red,
                      ),
                     ),
                        // decoration: InputDecoration(
                        //   errorText: widget.errorText,
                        //   counterText: widget.enableCounterText ? null : "",
                        //   counterStyle: _theme.textTheme.bodyLarge!.copyWith(
                        //     fontSize: 10,
                        //     letterSpacing: 0.1,
                        //   ),
                        //   errorStyle: _theme.textTheme.bodyLarge!.copyWith(
                        //     color: Colors.red,
                        //     letterSpacing: 0.2,
                        //     fontSize: 10,
                        //     fontWeight: FontWeight.w400,
                        //   ),
                        //   prefixIcon: widget.prefix == null
                        //       ? null
                        //       : Padding(
                        //           padding: const EdgeInsets.all(16.0),
                        //           child: Icon(
                        //             widget.prefix,
                        //             size: widget.prefixIconSize,
                        //             color: widget.prefixIconColor,
                        //           ),
                        //         ),
                        //   hintText: widget.hintText,
                        //   hintStyle: _theme.textTheme.bodyMedium!.copyWith(
                        //       letterSpacing: 0.2,
                        //       color: const Color(0xFF000000).withOpacity(0.6)),
                        //   fillColor: widget.fillColor ??
                        //       _theme.scaffoldBackgroundColor,
                        //   filled: widget.fillColor != null,
                        //   border: _border(),
                        //   focusedBorder: _border(),
                        //   enabledBorder: _border(),
                        //   errorBorder: _border(isErrorBorder: true),
                        //   suffix: widget.suffix,
                        // ),
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                right: 8,
                top: 4,
                child: widget.type == TextFieldType.Text
                    ? Container()
                    : IconButton(
                        onPressed: () {
                          setState(() {
                            _isObscureText = !_isObscureText;
                          });
                        },
                        icon: SizedBox(
                          height: 30,
                          width: 30,
                          child: Icon(
                            _isObscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Appcolors.disabledButton,
                          ),
                        ),
                      ),
              )
            ],
          )
        ],
      ),
    );
  }

  OutlineInputBorder _border({bool isErrorBorder = false}) {
    return OutlineInputBorder(
      
      borderRadius: BorderRadius.circular(widget.borderRadius),
      borderSide: BorderSide(
        color: isErrorBorder
            ? Colors.red
            : Appcolors.disabledButton.withOpacity(0.24),
      ),
    );
  }
}

enum TextFieldType { Text, Password }

import 'package:flutter/material.dart';
import 'package:gtaos/widgets/loading_overlay.dart';
import 'package:gtaos/helper/network.dart';
import 'package:gtaos/utils/colors.dart';
import 'package:gtaos/utils/validart.dart';
import 'package:gtaos/widget/gradient_scaffold.dart';
import 'package:gtaos/widget/other_widgets.dart';
import 'package:gtaos/widget/textfield.dart';

class ChangePassWord extends StatefulWidget {
  const ChangePassWord({super.key});

  @override
  State<ChangePassWord> createState() => _ChangePassWordState();
}

class _ChangePassWordState extends State<ChangePassWord> {
  final TextEditingController _password = TextEditingController();
  final TextEditingController _newpassword = TextEditingController();
  final TextEditingController _verifypassword = TextEditingController();
  var pass = "", newPassword = "", verifypassword = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GradientScaffold(
      child: Column(
        children: <Widget>[
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
                color: Colors.white,
              ),
              Text(
                "Change Password",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ],
          ),
          SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomTextInputField(
              controller: _password,
              labelColor: Colors.white,
              fillColor: Colors.white,
              title: "Current Password",
              hintText: "Current Password",
              obscureText: true,
              onChanged: (v) {
                pass = v.trim();
                setState(() {});
              },
              type: TextFieldType.Password,
              validator: (val) =>
                  FormValidator.validateFieldNotEmpty(val, "Password"),
              borderRadius: 14,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomTextInputField(
              onChanged: (v) {
                newPassword = v.trim();
                setState(() {});
              },
              controller: _newpassword,
              labelColor: Colors.white,
              fillColor: Colors.white,
              title: "New Password",
              hintText: "New Password",
              obscureText: true,
              type: TextFieldType.Password,
              validator: (val) =>
                  FormValidator.validateFieldNotEmpty(val, "Password"),
              borderRadius: 14,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomTextInputField(
              onChanged: (v) {
                verifypassword = v.trim();
                setState(() {});
              },
              controller: _verifypassword,
              labelColor: Colors.white,
              fillColor: Colors.white,
              title: "Confirm Password",
              hintText: "Confirm Password",
              obscureText: true,
              type: TextFieldType.Password,
              validator: (val) =>
                  FormValidator.validateFieldNotEmpty(val, "Password"),
              borderRadius: 14,
            ),
          ),
          SizedBox(height: 10),
          AppButton(
              textColor: canChangePass ? Appcolors.primary2 : Colors.white60,
              text: "Change",
              color: Appcolors.primary1,
              shadowColor: Appcolors.primary2,
              onTap: !canChangePass
                  ? null
                  : () async {
                      LoadingOverlay.show(context);
                      try {
                        var res =
                            await networkCaller.changPass(pass, newPassword);
                        if (res) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Successfully changed password")),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Old Password does not match")),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(e.toString())),
                        );
                      }
                    })
        ],
      ),
    ));
  }

  bool get canChangePass =>
      pass.length > 5 &&
      newPassword.length > 5 &&
      verifypassword.length > 5 &&
      newPassword.trim() == verifypassword.trim();
}

import 'dart:developer';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:image_picker/image_picker.dart';
import 'package:local_auth/local_auth.dart';
import 'package:gtaos/helper/network.dart';
import 'package:gtaos/model/attendancestatus.dart';
import 'package:gtaos/model/tasklist.dart';
import 'package:gtaos/utils/colors.dart';
import 'package:gtaos/utils/validart.dart';
import 'package:gtaos/views/home.dart';
import 'package:gtaos/widget/gradient_scaffold.dart';
import 'package:gtaos/widget/other_widgets.dart';
import 'package:gtaos/widget/textfield.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gtaos/views/actualhome.dart';
import 'package:gtaos/widgets/loading_overlay.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, this.changemode = false});
  final bool changemode;
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AttendanceStatus? attendanceStatus;
  final LocalAuthentication auth = LocalAuthentication();
  AttendanceMiniObject? datum;
  String email = "", pass = "";
  EmpTaskList? empTaskList;
  bool? hasAttended;
  bool isAdminLogin = false;
  bool loggedOut = true;
  bool appLoaded = false;
  XFile? photo;
  TaskListDatum? taskListDatum;
  bool uploading = false, attendanceSent = false;
  var user;

  bool? _canCheckBiometrics;
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  _SupportState _supportState = _SupportState.unknown;
final TextEditingController _domainController = TextEditingController();
  bool _showDomainField = false; // To toggle domain field visibility
  @override
  void initState() {
    super.initState();
    // networkCaller.removeUser();
    if (!widget.changemode) {
      Future.delayed(Duration.zero, () async {
        LoadingOverlay.show(context);
        await validateLogin();
        LoadingOverlay.dismiss();

        appLoaded = true;
        if (mounted) setState(() {});
      });
    } else {
      appLoaded = true;
      if (mounted) setState(() {});
    }
    if (!kIsWeb) {
      auth.isDeviceSupported().then((bool isSupported) => setState(() =>
          _supportState = isSupported
              ? _SupportState.supported
              : _SupportState.unsupported));
    }
    if (kDebugMode) {
      //email = "vediyappan.v@gleantech.co.in";
      //pass = "Vediya!@2024";
      email = "ceo@gleantech.com";
      pass = "Ceogts@24";
    }
  _domainController.text = AppConfig.domain;
    // Only show domain field if in debug mode or no domain is set
    _showDomainField = kDebugMode || AppConfig.domain.isEmpty;
    _email.text = email;
    _password.text = pass;
  }
Future<void> _saveDomain() async {
    if (_domainController.text.trim().isNotEmpty) {
      await AppConfig.setDomain(_domainController.text.trim());
      setState(() {
        _showDomainField = false;
      });
      BotToast.showText(text: "Domain updated successfully");
    }
  }

  validateLogin() async {
    user = networkCaller.getUser();
    loggedOut = user == null;

    if (!loggedOut) {
      await networkCaller.checkAttendance();
      if (!networkCaller.isAdminMode) {
        attendanceStatus = await networkCaller.getAttendanceStatus();
        empTaskList = await networkCaller.getTaskList();
        hasAttended = networkCaller.attendanceChecker?.data.attendance ?? false;
        if (hasAttended ?? false) {
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen()));
        }
      } else {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen()));
      }
    }
  }

  bool get canLogin => email.length > 5 && pass.length > 5;
    InputDecoration _getInputDecoration(String labelText, {String? hintText}) {
    return InputDecoration(
      isDense: true,
      hintText: hintText,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 20,vertical: 12.0),
      hintStyle: TextStyle(
        fontFamily: 'Raleway',
        fontSize: 14,
        color: Colors.grey.shade600,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide:
            BorderSide(color: Appcolors.primary2), // Highlight on focus
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      errorStyle: const TextStyle(
        fontFamily: 'Raleway',
        fontSize: 11,
        color: Colors.red,
      ),
      labelText: labelText,
      labelStyle: TextStyle(color: Colors.grey.shade700),
    );
  }
Widget uploadImage() {
  return GradientScaffold(
    child: SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;

          return Padding(
            padding: const EdgeInsets.fromLTRB(0,150,0,0),
            child:  Stack(
              
              children: [ 
             
              
              Container(
               height: MediaQuery.of(context).size.height ,
                    decoration: BoxDecoration(
                  // color: Colors.white,
                  gradient: LinearGradient(
                colors: [
                  Colors.white,
                    Colors.white
                  // Color(0xFF89c236), // primary2
                  // Color(0xFFa7d74f), // light green
                  // Color(0xFFc9f39f),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ), 
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60))
                ),
              // elevation: 8,
              // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: ListView(
                  children: [
                    /// Logout tile
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.logout, color: Colors.redAccent),
                      title: const Text("Logout", style: TextStyle(fontWeight: FontWeight.w600)),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (c) => AlertDialog(
                            title: const Text("Are you sure?", style: TextStyle(fontWeight: FontWeight.bold)),
                            content: const Text("This will log you out."),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
                              FilledButton.tonal(
                                style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
                                onPressed: () async {
                                  Navigator.pop(context);
                                  await networkCaller.removeUser();
                                    await AppConfig.clearDomain();
    await networkCaller.removeUser();
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(builder: (_) => LoginScreen()),
                                    (route) => false,
                                  );
                                },
                                child: const Text("Logout", style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 40),

                    /// Image display
                    Center(
                      child: photo != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: kIsWeb
                                  ? Image.network(photo!.path, height: 200, width: 200, fit: BoxFit.cover)
                                  : Image.file(File(photo!.path), height: 200, width: 200, fit: BoxFit.cover),
                            )
                          : ImagePlaceholder(onPressed: () {}, size: 200),
                    ),

                    const SizedBox(height: 30),

                    /// Selfie button
                    Center(
                      child: SizedBox(
                        width: isMobile ? double.infinity : 320,
                        child: FilledButton.icon(
                          icon: Icon(photo != null ? Icons.refresh : Icons.camera_alt),
                          label: Text(photo != null ? "Change Image" : "Take Selfie"),
                          style: FilledButton.styleFrom(
                            backgroundColor: Appcolors.primary1,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () async {
                            pickImage() async {
                              photo = await ImagePicker().pickImage(
                                source: ImageSource.camera,
                                preferredCameraDevice: kDebugMode ? CameraDevice.rear : CameraDevice.front,
                                requestFullMetadata: true,
                                imageQuality: 50,
                              );
                              setState(() {});
                            }

                            if (!kIsWeb && _supportState == _SupportState.supported) {
                              await _checkBiometrics();
                              if (_canCheckBiometrics!) {
                                var res = await _authenticateWithBiometrics();
                                if (res ?? false) pickImage();
                              } else {
                                pickImage();
                              }
                            } else {
                              pickImage();
                            }
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// Dropdowns
                    if (attendanceStatus != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: DropdownButtonFormField<AttendanceMiniObject>(
                          value: datum,
                          decoration: _getInputDecoration("Mark Attendance"),
                          items: attendanceStatus!.data!
                              .map((e) => DropdownMenuItem(value: e, child: Text(e.name ?? "-")))
                              .toList(),
                          onChanged: (val) {
                            datum = val;
                            setState(() {});
                          },
                        ),
                      ),

                    if (empTaskList != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: DropdownButtonFormField<TaskListDatum>(
                          value: taskListDatum,
                          decoration: _getInputDecoration("Select Task"),
                          items: empTaskList!.data!
                              .map((e) => DropdownMenuItem(value: e, child: Text(e.subject ?? "-")))
                              .toList(),
                          onChanged: (val) {
                            taskListDatum = val;
                            setState(() {});
                          },
                        ),
                      ),

                    const SizedBox(height: 30),

                    /// Save button
                    Center(
                      child: SizedBox(
                        width: isMobile ? double.infinity : 240,
                        height: 50,
                        child: FilledButton.icon(
                          icon: const Icon(Icons.save_alt),
                          label: const Text("Save", style: TextStyle(fontSize: 16)),
                          style: FilledButton.styleFrom(
                            backgroundColor: Appcolors.primary2,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 3,
                            shadowColor: Appcolors.primary2.withOpacity(0.3),
                          ),
                          onPressed: photo != null && datum != null
                              ? () async {
                                  setState(() => uploading = true);
                                  LoadingOverlay.show(context);

                                  var byte = await photo!.readAsBytes();
                                  var result = await networkCaller.uploadPhoto(
                                    kIsWeb ? byte : photo!.path, datum, taskListDatum,
                                  );

                                  if (kDebugMode) {
                                    BotToast.showText(
                                        text: result["data"].toString(), duration: const Duration(seconds: 3));
                                  }

                                  LoadingOverlay.dismiss();
                                  setState(() {
                                    uploading = false;
                                    hasAttended = true;
                                    attendanceSent = true;
                                  });

                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(builder: (_) => HomeScreen()),
                                  );
                                }
                              : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),],)
          );
        },
      ),
    ),
  );
}

  InputDecoration _formDecoration(String hint) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  Future<bool?> _authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
        localizedReason:
            'Scan your fingerprint (or face or whatever) to authenticate',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } on PlatformException catch (e) {
      print(e);

      return null;
    }
    log(authenticated.toString());

    return authenticated;
  }

  Future<void> _checkBiometrics() async {
    late bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
      print(e);
    }
    if (!mounted) {
      return;
    }

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!appLoaded) {
      return GradientScaffold(
          child: SizedBox(height: MediaQuery.of(context).size.height));
    }
    if (user == null || loggedOut) {
      return GradientScaffold(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                // horizontal: MediaQuery.of(context).size.width * 0.04,
                // vertical: 20,
              ),
              child: Column(
                mainAxisAlignment : MainAxisAlignment.center,
               
                children: <Widget>[
                 SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                  // Add domain configuration section
             
              
                  Container( // Wrapped the content in a Card
                    // elevation: 8,
                    // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    height: MediaQuery.of(context).size.height ,
                    decoration: BoxDecoration(
                  // color: Colors.white,
                  gradient: LinearGradient(
                colors: [
                  Colors.white,
                    Colors.white
                  // Color(0xFF89c236), // primary2
                  // Color(0xFFa7d74f), // light green
                  // Color(0xFFc9f39f),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ), 
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60))
                ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0), // Added padding inside the card
                      child: Column(
                        children: [
                          Image.asset(
          'asset/brand_icon.png',
          width: 100,
          height: 100,
        ),
                          Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Stack(
                                children: [
                                  AnimatedPositioned(
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                    left: isAdminLogin
                                        ? MediaQuery.of(context).size.width * 0.3
                                        : 0,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width * 0.4,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Appcolors.primary2,
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                    ),
                                  ),
                                  
                                  Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              isAdminLogin = false;
                                              if (kDebugMode) {
                                                email = "vediyappan.v@gleantech.co.in";
                                                pass = "Vediya!@2024";
                                              }
                                              _email.text = email;
                                              _password.text = pass;
                                            });
                                          },
                                          child: Center(
                                            child: Text(
                                              "Employee Login",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: isAdminLogin
                                                    ? Color.fromARGB(221, 98, 96, 96)
                                                    : Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              isAdminLogin = true;
                                              if (kDebugMode) {
                                                email = "ceo@gleantech.com";
                                                pass = "Ceogts@24";
                                              }
                                              _email.text = email;
                                              _password.text = pass;
                                            });
                                          },
                                          child: Center(
                                            child: Text(
                                              "Admin Login",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: isAdminLogin
                                                    ? Colors.white
                                                    : const Color.fromARGB(221, 98, 96, 96),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                           if (_showDomainField) ...[
                        CustomTextInputField(
                          controller: _domainController,
                          labelColor: Colors.black,
                          fillColor: Colors.white,
                          title: "Server URL",
                          hintText: "https://yourdomain.com",
                          inputType: TextInputType.url,
                          borderRadius: 14,
                          suffix: IconButton(
                            icon: Icon(Icons.save, color: Appcolors.primary2),
                            onPressed: _saveDomain,
                          ),
                        ),
                        SizedBox(height: 10),
                      ] else ...[
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _showDomainField = true;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.link, size: 20, color: Colors.grey.shade600),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    AppConfig.domain,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade700,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Icon(Icons.edit, size: 18, color: Appcolors.primary2),
                              ],
                            ),
                          ),
                        ),
                         SizedBox(height: 10),
                      ],
                      // SizedBox(height: 20),
                
                          CustomTextInputField(
                            controller: _email,
                            labelColor: Colors.black,
                            fillColor: Colors.white,
                            title: "Username",
                            hintText: "Your Username",
                            inputType: TextInputType.emailAddress,
                            validator: (val) => FormValidator.validateEmail(val),
                            borderRadius: 14,
                            onChanged: (val) {
                              email = val.trim();
                              setState(() {});
                            },
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                          CustomTextInputField(
                            controller: _password,
                            labelColor: Colors.black,
                            fillColor: Colors.white,
                            title: "Password",
                            hintText: "Your Password",
                            obscureText: true,
                            type: TextFieldType.Password,
                            validator: (val) =>
                                FormValidator.validateFieldNotEmpty(val, "Password"),
                            borderRadius: 14,
                            onChanged: (val) {
                              pass = val.trim();
                              setState(() {});
                            },
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.01),

                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.black,
                                padding: EdgeInsets.zero,
                              ),
                              onPressed: () {
                                var con = TextEditingController();
                                var loading = false;
                                showDialog(
                                  context: context,
                                  builder: (_) => StatefulBuilder(
                                    builder: ((context, setState) => SimpleDialog(
                                          // title: const Text("Reset Password"),
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(
                                                "Reset Password",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: TextField(
                                                autofocus: true,
                                                controller: con,
                                                decoration: const InputDecoration(
                                                    hintText: "Enter email",
                                                    label: Text(
                                                      "Email",
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black),
                                                    )),
                                              ),
                                            ),
                                            SizedBox(height: MediaQuery.of(context).size.height * 0.01),

                                            Padding(
                                              padding: const EdgeInsets.all(6.0),
                                              child: ElevatedButton(
                                                  onPressed: () async {
                                                    if (con.text.contains("@")) {
                                                      try {
                                                        setState(() {
                                                          loading = true;
                                                        });
                                                        var res = await networkCaller
                                                            .sendPasswordResetEmail(
                                                                con.text.trim(),
                                                                isAdminLogin);
                                                        setState(() {
                                                          loading = false;
                                                        });
                                                        BotToast.showText(
                                                            contentColor: Colors.green,
                                                            duration:
                                                                Duration(seconds: 3),
                                                            text: res);

                                                        Navigator.pop(context);
                                                      } catch (e) {
                                                        setState(() {
                                                          loading = false;
                                                        });

                                                        BotToast.showText(
                                                            contentColor: Colors.red,
                                                            text: e.toString());
                                                      }
                                                    } else {
                                                      BotToast.showText(
                                                          contentColor: Colors.red,
                                                          text:
                                                              "Enter Valid Email address");
                                                    }
                                                  },
                                                  child: loading
                                                      ? FittedBox(
                                                          child: SizedBox(
                                                              height: 20,
                                                              width: 20,
                                                              child:
                                                                  const CircularProgressIndicator(
                                                                backgroundColor:
                                                                    Colors.black,
                                                              )))
                                                      : Text(
                                                          "Reset Password",
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color: Colors.black),
                                                        )),
                                            )
                                          ],
                                        )),
                                  ),
                                );
                              },
                              child: const Text(
                                "Forgot password?",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                          Center(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: AppButton(
                                text: "Log In",
                                shadowColor: Appcolors.primary2,
                                onTap: !canLogin
                                    ? null
                                    : () async {
                                        LoadingOverlay.show(context);
                                        user = await networkCaller.login(
                                            email, pass, isAdminLogin);

                                        if (user != null) {
                                          if (isAdminLogin) {
                                            LoadingOverlay.dismiss();
                                            Navigator.of(context).pushReplacement(
                                                MaterialPageRoute(
                                                    builder: (_) => HomeScreen()));
                                          } else {
                                            await validateLogin();
                                          }

                                          loggedOut = false;

                                          LoadingOverlay.dismiss();

                                          setState(() {});
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('Failed to login, Please check email or password'),
                                            ),
                                          );
                                        }
                                      },
                                color: Appcolors.primary2,
                                textColor: canLogin ? Colors.white : Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return uploadImage();
    }
  }
}

enum _SupportState {
  unknown,
  supported,
  unsupported,
}


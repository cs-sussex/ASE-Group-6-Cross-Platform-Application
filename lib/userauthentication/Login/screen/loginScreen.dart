// ignore: file_names
// ignore: file_names

// ignore: file_names
// ignore_for_file: avoid_print

/*
  Author Pooja
 */
import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mylocation/network/RestClient.dart';
import 'package:mylocation/userauthentication/Login/model/LoginPOJO.dart';
import 'package:mylocation/userauthentication/registration/screen/registrationScreen.dart';
import 'package:mylocation/util/appconstants/AppConstants.dart';
import 'package:mylocation/util/ui/AlertDialog.dart';
import 'package:mylocation/util/ui/CurvePainter.dart';
import 'package:mylocation/util/ui/sizeConfig.dart';
import 'package:mylocation/util/validation/userValidation.dart';
import 'package:dio/dio.dart';
import 'package:mylocation/util/localstorage/UserAuthSharedPreferences.dart';
import 'package:mylocation/util/InternetConnectivity/InternetStatus.dart';
import '../../../usersettings/SettingsScreen.dart';

const String routeName = "LoginScreenStates";
var dio = Dio()..options.baseUrl = AppConstants.BASE_URL;
RestClient restApiClient = RestClient(dio);
AppConstants appConstants = AppConstants();

class LoginScreenStates extends StatefulWidget {
  const LoginScreenStates({Key? key}) : super(key: key);

  @override
  _LoginScreenStatesState createState() => _LoginScreenStatesState();
}

extension ParseToString on ConnectivityResult {
  String toValue() {
    return toString().split('.').last;
  }
}

class _LoginScreenStatesState extends State<LoginScreenStates> {
  final TextEditingController emailIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isInternetOffline = true; // to check internet connectivity
  late StreamSubscription _connectivitySubscription;
  Map _source = {ConnectivityResult.none: false};
  final InternetStatus _connectivity = InternetStatus.instance;
  final _loginFormKey = GlobalKey<FormState>();
  bool invisible = true;
  final textFieldFocusNode = FocusNode();
  bool _obscured = false;

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
      if (textFieldFocusNode.hasPrimaryFocus)
        // ignore: curly_braces_in_flow_control_structures
        return; // If focus is on text field, dont unfocus
      textFieldFocusNode.canRequestFocus =
          false; // Prevents focus if tap on eye
    });
  }

  @override
  void initState() {
    super.initState();
    _connectivity.initialise();
    _connectivity.myStream.listen((source) {
      setState(() => _source = source);
    });
  }

  @override
  dispose() {
    super.dispose();
    _connectivitySubscription.cancel();
  }

  Widget loaderWidget() {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          height: 10,
        ),
        const SizedBox(
          width: 90,
          height: 90,
          child: CircularProgressIndicator(
            backgroundColor: Colors.blueGrey,
            strokeWidth: 20,
          ),
        ),
        const SizedBox(
          height: 3,
        ),
        Container(
            padding: const EdgeInsets.all(15.0),
            child: GestureDetector(onTap: () {})),
      ],
    ));
  }

  late LoginPOJO loginPOJO;
  late LoginPOJO loginResponse;

  Future signInUser(LoginPOJO loginPOJO) async {
    restApiClient.loginUser(loginPOJO).then((LoginPOJO responses) async {
      print("response is ${responses.toString()}");
      if (responses.toJson().isNotEmpty) {
        loginPOJO = responses;
        UserAuthSharedPreferences.instance
            .setStringValue("email", responses.email);
        UserAuthSharedPreferences.instance.setBoolValue("login", true);
        UserAuthSharedPreferences.instance
            .setStringValue("id", responses.userID);
        UserAuthSharedPreferences.instance
            .setStringValue("token", responses.token);
        print(loginPOJO.toJson().toString());
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const SettingsScreen()));
      }
    }).whenComplete(() {
      debugPrint("complete:");
    }).catchError((onError) {
      UserAuthFailedDialogBox(context, AppConstants.UserAuthFailed);
      debugPrint("errors:${onError.toString()}");
    });
  }

  @override
  Widget build(BuildContext context) {
    String internetStatus;
    switch (_source.keys.toList()[0]) {
      case ConnectivityResult.mobile:
        internetStatus = 'Mobile: Online';
        isInternetOffline = true;

        break;
      case ConnectivityResult.wifi:
        internetStatus = 'WiFi: Online';
        isInternetOffline = true;

        break;
      case ConnectivityResult.none:
        isInternetOffline = false;

        break;
      default:
        isInternetOffline = true;

        internetStatus = 'Offline';
    }

    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(
        builder: (context, orientation) {
          SizeConfig().init(constraints, orientation);
          return Scaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: Colors.white,
              body: Container(
                  color: Colors.transparent,
                  child: CustomPaint(
                      painter: CurvePainter(),
                      child: SizedBox(
                          height: SizeConfig.heightMultiplier * 100,
                          width: SizeConfig.widthMultiplier * 100,
                          child: Stack(children: [
                            SingleChildScrollView(
                                child: Container(
                                    height: SizeConfig.heightMultiplier * 90,
                                    width: SizeConfig.widthMultiplier * 100,
                                    padding: const EdgeInsets.all(30.0),
                                    child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Center(
                                              child: Form(
                                            key: _loginFormKey,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Container(
                                                  height: SizeConfig
                                                          .heightMultiplier *
                                                      8,
                                                  width: SizeConfig
                                                          .widthMultiplier *
                                                      90,
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: const Text(
                                                    "Sign In",
                                                    textAlign: TextAlign.center,
                                                    textScaleFactor: 1.5,
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ),
                                                TextFormField(
                                                  keyboardType:
                                                      TextInputType.text,
                                                  controller: emailIdController,
                                                  validator: (value) {
                                                    if (UserValidation
                                                            .validateEmail(
                                                                emailIdController
                                                                    .text) ==
                                                        false) {
                                                      return 'Please enter valid email Id';
                                                    } else if (UserValidation
                                                            .emptyFiledValidation(
                                                                emailIdController
                                                                    .text) ==
                                                        false) {
                                                      return 'Please enter your email id';
                                                    }
                                                    return null;
                                                  },
                                                  decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor: Colors.white70,
                                                    hintStyle: TextStyle(
                                                        color:
                                                            Colors.grey[800]),
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.0)),
                                                    floatingLabelBehavior:
                                                        FloatingLabelBehavior
                                                            .never, //Hides label on focus or if filled
                                                    labelText: "Email Id",
                                                    isDense:
                                                        true, // Reduces height a bit
                                                    prefixIcon: const Icon(
                                                        Icons.email,
                                                        size: 24),
                                                    suffixIcon: const Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              0, 0, 4, 0),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 12,
                                                ),
                                                TextFormField(
                                                  controller:
                                                      passwordController,

                                                  validator: (value) {
                                                    if (UserValidation
                                                            .emptyFiledValidation(
                                                                passwordController
                                                                    .text) ==
                                                        false) {
                                                      return 'Please enter your password';
                                                    }
                                                    return null;
                                                  },

                                                  keyboardType: TextInputType
                                                      .visiblePassword,
                                                  obscureText: _obscured,
                                                  // focusNode: textFieldFocusNode,
                                                  decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor: Colors.white70,
                                                    hintStyle: TextStyle(
                                                        color:
                                                            Colors.grey[800]),
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.0)),
                                                    floatingLabelBehavior:
                                                        FloatingLabelBehavior
                                                            .never, //Hides label on focus or if filled
                                                    labelText: "Password",
                                                    isDense:
                                                        true, // Reduces height a bit
                                                    prefixIcon: const Icon(
                                                        Icons.lock_rounded,
                                                        size: 24),
                                                    suffixIcon: Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(0, 0, 4, 0),
                                                      child: GestureDetector(
                                                        onTap: _toggleObscured,
                                                        child: Icon(
                                                          _obscured
                                                              ? Icons
                                                                  .visibility_rounded
                                                              : Icons
                                                                  .visibility_off_rounded,
                                                          size: 24,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                ElevatedButton(
                                                  style: ButtonStyle(
                                                      shape: MaterialStateProperty
                                                          .all<
                                                              RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.0),
                                                    ),
                                                  )),
                                                  onPressed: () async {
                                                    String? token = "";
                                                    String? userID = "";
                                                    if (isInternetOffline ==
                                                        false) {
                                                      UserAuthFailedDialogBox(
                                                          context,
                                                          AppConstants
                                                              .NoInternetConnection);
                                                    } else if (_loginFormKey
                                                        .currentState!
                                                        .validate()) {
                                                      UserAuthSharedPreferences
                                                          .instance
                                                          .getStringValue("id")
                                                          .then((value) =>
                                                              setState(() {
                                                                AppConstants
                                                                        .userId =
                                                                    value;
                                                                print("values id" +
                                                                    AppConstants
                                                                        .userId
                                                                        .toString());
                                                              }));

                                                      loginPOJO = LoginPOJO(
                                                          emailIdController.text
                                                              .trim(),
                                                          passwordController
                                                              .text
                                                              .trim(),
                                                          token,
                                                          userID);

                                                      signInUser(loginPOJO)
                                                          .then((value) {
                                                        loaderWidget();
                                                      });
                                                    }
                                                    //);
                                                  },
                                                  child: Ink(
                                                    decoration:
                                                        const BoxDecoration(
                                                      gradient: LinearGradient(
                                                          colors: [
                                                            Colors.blue,
                                                            Colors.cyan,
                                                            Colors.blue
                                                          ]),
                                                    ),
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              18),
                                                      constraints:
                                                          BoxConstraints(
                                                        minWidth: SizeConfig
                                                                .widthMultiplier *
                                                            96,
                                                      ),
                                                      child: const Text(
                                                        'Login',
                                                        textAlign:
                                                            TextAlign.center,
                                                        textScaleFactor: 1.0,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                GestureDetector(
                                                    onTap: () {
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  const RegistrationScreen()));
                                                    },
                                                    child: Container(
                                                      height: SizeConfig
                                                              .heightMultiplier *
                                                          8,
                                                      width: SizeConfig
                                                              .widthMultiplier *
                                                          90,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      child: const Text(
                                                        "New user ?  Click here",
                                                        textScaleFactor: 1.1,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          )),
                                        ]))),

                            //
                          ])

                          // ),
                          ))));

          //)
        },
      );
    });
  }
}

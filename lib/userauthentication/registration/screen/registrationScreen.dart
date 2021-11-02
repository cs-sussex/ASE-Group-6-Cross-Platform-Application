import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mylocation/network/RestClient.dart';
import 'package:mylocation/userauthentication/registration/model/RegistrationPOJO.dart';
import 'package:mylocation/userauthentication/Login/screen/loginScreen.dart';
import 'package:mylocation/util/InternetConnectivity/InternetStatus.dart';
import 'package:mylocation/util/appconstants/AppConstants.dart';
import 'package:mylocation/util/ui/AlertDialog.dart';
import 'package:mylocation/util/ui/CurvePainter.dart';
import 'package:mylocation/util/ui/sizeConfig.dart';
import 'package:mylocation/util/validation/userValidation.dart';
import 'package:mylocation/util/appconstants/AppConstants.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:mylocation/util/localstorage/UserAuthSharedPreferences.dart';

const String routeName = "RegistrationScreen";
var dio = Dio()..options.baseUrl = AppConstants.BASE_URL;
RestClient restApiClient = RestClient(dio);

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: false,
      body: RegistrationScreenStates(),
    );
  }
}

class RegistrationScreenStates extends StatefulWidget {
  const RegistrationScreenStates({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

extension ParseToString on ConnectivityResult {
  String toValue() {
    return toString().split('.').last;
  }
}

class _RegistrationScreenState extends State<RegistrationScreenStates> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  late String firstName, lastName, email, password = "", confirmPassword = "";

  final _registrationFormKey = GlobalKey<FormState>();

  bool invisible = true;

  bool isInternetOffline = true; // to check internet connectivity
  late StreamSubscription _connectivitySubscription;
  Map _source = {ConnectivityResult.none: false};
  final InternetStatus _connectivity = InternetStatus.instance;

  final textFieldFocusNode = FocusNode();
  bool _obscured = false;

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
      if (textFieldFocusNode.hasPrimaryFocus) {
        return;
      } // If focus is on text field, dont unfocus
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

  void signUpUser(RegistrationPOJO registrationPOJO) async {
    await restApiClient
        .registerUser(registrationPOJO)
        .then((RegistrationPOJO responses) async {
      if (responses.toJson().isNotEmpty) {
        // ignore: await_only_futures
        await responses;
        registrationPOJO = responses;
        UserAuthSharedPreferences.instance.setStringValue("id", responses.id);
        UserAuthSharedPreferences.instance
            .setStringValue("email", responses.email);
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const LoginScreenStates()));
      }
    }).whenComplete(() {
      debugPrint("complete:");
    }).catchError((onError) {
      UserAuthFailedDialogBox(context, AppConstants.UserAuthFailed);
      debugPrint("error:${onError.toString()}");
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
                                            key: _registrationFormKey,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                TextFormField(
                                                  keyboardType:
                                                      TextInputType.text,
                                                  controller:
                                                      firstNameController,
                                                  validator: (value) {
                                                    if (UserValidation
                                                            .emptyFiledValidation(
                                                                firstNameController
                                                                    .text) ==
                                                        false) {
                                                      return 'Please enter your first name';
                                                    }
                                                    return null;
                                                  },
                                                  decoration: InputDecoration(
                                                      prefixIcon: const Icon(
                                                          Icons.person_add,
                                                          size: 24),
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.0),
                                                      ),
                                                      filled: true,
                                                      hintStyle: TextStyle(
                                                          color:
                                                              Colors.grey[800]),
                                                      hintText: "First Name",
                                                      fillColor:
                                                          Colors.white70),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                TextFormField(
                                                  keyboardType:
                                                      TextInputType.text,
                                                  controller:
                                                      lastNameController,
                                                  decoration: InputDecoration(
                                                      prefixIcon: const Icon(
                                                          Icons
                                                              .person_add_alt_1,
                                                          size: 24),
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.0),
                                                      ),
                                                      filled: true,
                                                      hintStyle: TextStyle(
                                                          color:
                                                              Colors.grey[800]),
                                                      hintText: "Last Name",
                                                      fillColor:
                                                          Colors.white70),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                TextFormField(
                                                  controller: emailController,
                                                  validator: (value) {
                                                    if (UserValidation
                                                            .validateEmail(
                                                                emailController
                                                                    .text) ==
                                                        false) {
                                                      return 'Please enter valid email Id';
                                                    } else if (UserValidation
                                                            .emptyFiledValidation(
                                                                emailController
                                                                    .text) ==
                                                        false) {
                                                      return 'Please enter your email id';
                                                    }
                                                    return null;
                                                  },
                                                  decoration: InputDecoration(
                                                      prefixIcon: const Icon(
                                                          Icons.email,
                                                          size: 24),
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.0),
                                                      ),
                                                      filled: true,
                                                      hintStyle: TextStyle(
                                                          color:
                                                              Colors.grey[800]),
                                                      hintText: "E-Mail",
                                                      fillColor:
                                                          Colors.white70),
                                                ),
                                                const SizedBox(
                                                  height: 10,
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
                                                    } else if (UserValidation
                                                            .validatePasswordLength(
                                                                passwordController
                                                                    .text) ==
                                                        false) {
                                                      return 'Your password should be more tha 4 character';
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
                                                TextFormField(
                                                  controller:
                                                      confirmPasswordController,
                                                  validator: (value) {
                                                    if (UserValidation
                                                            .validatePassword(
                                                                passwordController
                                                                    .text,
                                                                confirmPasswordController
                                                                    .text) ==
                                                        false) {
                                                      return 'Password does not match';
                                                    } else if (UserValidation
                                                            .emptyFiledValidation(
                                                                confirmPasswordController
                                                                    .text) ==
                                                        false) {
                                                      return 'Please enter your confirm password';
                                                    }

                                                    return null;
                                                  },
                                                  keyboardType: TextInputType
                                                      .visiblePassword,
                                                  obscureText: _obscured,
                                                  //focusNode: textFieldFocusNode,
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
                                                    labelText:
                                                        "Confirm Password",
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

                                                  //style: ButtonStyle.lerp(a, b, t),
                                                  onPressed: () async {
                                                    if (isInternetOffline ==
                                                        false) {
                                                      UserAuthFailedDialogBox(
                                                          context,
                                                          AppConstants
                                                              .NoInternetConnection);
                                                    } else if (_registrationFormKey
                                                        .currentState!
                                                        .validate()) {
                                                      if (isInternetOffline ==
                                                          false) {
                                                        UserAuthFailedDialogBox(
                                                            context,
                                                            AppConstants
                                                                .NoInternetConnection);
                                                      }

                                                      RegistrationPOJO
                                                          registrationPOJO =
                                                          RegistrationPOJO(
                                                              firstNameController
                                                                  .text
                                                                  .trim(),
                                                              lastNameController
                                                                  .text
                                                                  .trim(),
                                                              emailController
                                                                  .text
                                                                  .trim(),
                                                              passwordController
                                                                  .text
                                                                  .trim(),
                                                              "");

                                                      Center(
                                                          child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          const SizedBox(
                                                            width: 90,
                                                            height: 90,
                                                            child:
                                                                CircularProgressIndicator(
                                                              backgroundColor:
                                                                  Colors
                                                                      .blueGrey,
                                                              strokeWidth: 20,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 3,
                                                          ),
                                                          Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .all(
                                                                      15.0),
                                                              child: const Text(
                                                                "Loading..",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    color: Colors
                                                                        .white),
                                                              )),
                                                        ],
                                                      ));
                                                      signUpUser(
                                                          registrationPOJO);
                                                    }
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
                                                        'Registration',
                                                        textAlign:
                                                            TextAlign.center,
                                                        textScaleFactor: 1.0,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )),
                                        ]

                                        ))),

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

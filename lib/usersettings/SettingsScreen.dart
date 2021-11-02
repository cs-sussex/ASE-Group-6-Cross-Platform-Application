import 'package:flutter/material.dart';
import 'package:mylocation/util/appconstants/AppConstants.dart';
import 'package:mylocation/util/localstorage/UserAuthSharedPreferences.dart';
import 'package:mylocation/util/ui/sizeConfig.dart';

import '../userauthentication/Login/screen/loginScreen.dart';

const String routeName = "SettingsScreen";

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool lockInBackground = true;
  bool notificationsEnabled = true;
  late String userName = "";

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        SizeConfig().init(constraints, orientation);
        return Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.white,
          body: buildSettingsList(),
        );
      });
    });
  }

  Widget buildSettingsList() {
    return SizedBox(
        height: SizeConfig.heightMultiplier * 100,
        width: SizeConfig.widthMultiplier * 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,



            children: [
          Container(
              alignment: Alignment.center,

              // height: SizeConfig.heightMultiplier*4,
              width: SizeConfig.widthMultiplier * 90,
              child: Card(
                  elevation: 4,
                  child: Column(
                    children: [
                      Container(
                        color: Colors.white38,

                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          )),
                          onPressed: () {
                            //UserAuthSharedPreferences.instance.removeValue("email");
                            UserAuthSharedPreferences.instance
                                .setBoolValue("login", false);
                            UserAuthSharedPreferences.instance.removeAll();

                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => const LoginScreenStates()));
                          },
                          child: Ink(
                            decoration: const BoxDecoration(),
                            child: Container(
                              padding: const EdgeInsets.all(18),
                              constraints: BoxConstraints(
                                minWidth: SizeConfig.widthMultiplier * 96,
                              ),
                              child: const Text(
                                'Logout',
                                textAlign: TextAlign.center,
                                textScaleFactor: 1.0,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  )))
        ]));
  }
}

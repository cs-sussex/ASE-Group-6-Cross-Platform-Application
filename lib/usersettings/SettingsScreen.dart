// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:mylocation/showmylocation.dart';
// import 'package:mylocation/util/appconstants/AppConstants.dart';
import 'package:mylocation/util/localstorage/UserAuthSharedPreferences.dart';
import 'package:mylocation/util/ui/sizeConfig.dart';
import 'package:mylocation/location/LocationPOJO.dart';
import '../userauthentication/Login/screen/loginScreen.dart';

const String routeName = 'SettingsScreen';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool lockInBackground = true;
  bool notificationsEnabled = true;
  late String userName = "";

  get child => null;

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

  late LocationPOJO locationPOJO;
  late LocationPOJO locationResponse;

  Future locationUpdate(LocationPOJO locationPOJO) async {
    restApiClient
        .saveLocation(locationPOJO)
        .then((LocationPOJO responses) async {
      print("response is ${responses.userId.toString()}");
      if (responses.toJson().isNotEmpty) {
        locationPOJO = responses;
        UserAuthSharedPreferences.instance
            .setStringValue("user", responses.userId);
        // UserAuthSharedPreferences.instance.setBoolValue("login", true);
        UserAuthSharedPreferences.instance
            .setStringValue("location_name", responses.location_name);
        UserAuthSharedPreferences.instance
            .setStringValue("colour", responses.colour);
        print(locationPOJO.toJson().toString());
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const SettingsScreen()));
      }
    }).whenComplete(() {
      debugPrint("complete:");
    }).catchError((onError) {
      // UserAuthFailedDialogBox(context, AppConstants.UserAuthFailed);
      debugPrint("errors:${onError.toString()}");
    });
  }

  Widget buildSettingsList() {
    return SizedBox(
        height: SizeConfig.heightMultiplier * 100,
        width: SizeConfig.widthMultiplier * 100,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
              alignment: Alignment.center,

              // height: SizeConfig.heightMultiplier*4,
              width: SizeConfig.widthMultiplier * 90,
              child: Card(
                  elevation: 4,
                  child: Column(
                    children: [
                      Text(
                        "Here" + userName,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: SizeConfig.textMultiplier * 3),
                      ),
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
                                builder: (_) => const ShowMyLocation()
                                //LoginScreenStates()
                                ));
                          }, // handle your onPressed code inside this function

                          child: Ink(
                            decoration: const BoxDecoration(),
                            child: Container(
                              padding: const EdgeInsets.all(18),
                              constraints: BoxConstraints(
                                minWidth: SizeConfig.widthMultiplier * 96,
                              ),
                              child: const Text(
                                'SEE MAP',
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

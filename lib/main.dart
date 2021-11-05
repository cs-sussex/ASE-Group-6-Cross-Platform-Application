import 'package:flutter/material.dart';
import 'package:mylocation/location/model/LocationScreen/AllLocationScreen.dart';
import 'package:mylocation/showmylocation.dart';
import 'package:mylocation/userauthentication/Login/screen/loginScreen.dart';
import 'package:mylocation/userauthentication/registration/screen/registrationScreen.dart';
import 'package:mylocation/usersettings/SettingsScreen.dart';
import 'package:mylocation/util/localstorage/UserAuthSharedPreferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool? loginFlag;

  routePageDirection() async {
    await UserAuthSharedPreferences.instance
        .getBoolValue("login")
        .then((value) {
      loginFlag = value;
    });

    if (loginFlag == null) {
      UserAuthSharedPreferences.instance.getBoolValue("login").then((value) {
        // setState(() {
        loginFlag = value;
      });
    } else if (loginFlag != null && loginFlag == true) {
      return const SettingsScreen();
    } else if (loginFlag == false) {
      return const LoginScreenStates();
    }
  }

//}
  runApp(MaterialApp(home: await routePageDirection(),
      routes: <String, WidgetBuilder>{
     'LoginScreenStates': (context) =>loginFlag==true? const SettingsScreen(): const LoginScreenStates(),
    'SettingsScreen':(context)=> loginFlag==true? const SettingsScreen(): const LoginScreenStates(),
     'RegistrationScreen':(context)=>const RegistrationScreen(),
        'AllLocationsState':(context) =>const AllLocationsState(),
        'ShowMyLocation':(context)=>const ShowMyLocation()
  }
      ));


}

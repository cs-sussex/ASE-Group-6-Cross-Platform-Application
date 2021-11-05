import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mylocation/network/RestClient.dart';
import 'package:mylocation/usersettings/SettingsScreen.dart';
import 'package:mylocation/util/appconstants/AppConstants.dart';
import 'package:dio/dio.dart';
import 'package:mylocation/util/localstorage/UserAuthSharedPreferences.dart';
import 'package:mylocation/util/ui/CurvePainter.dart';
import 'package:mylocation/util/ui/sizeConfig.dart';
import '';
import '../GetAllLocationPOJO.dart';
import 'AllLocationWidget.dart';

const String routeName = "AllLocationsState";
var dio = Dio()..options.baseUrl = AppConstants.BASE_URL;
RestClient restApiClient = RestClient(dio);
AppConstants appConstants = AppConstants();

class AllLocationsState extends StatefulWidget {
  const AllLocationsState({Key? key}) : super(key: key);

  @override
  _AllLocationsState createState() => _AllLocationsState();
}

class _AllLocationsState extends State<AllLocationsState> {
  String token = "";

  getToken() async {
    await UserAuthSharedPreferences.instance
        .getStringValue("token")
        .then((value) {
      token = value;
    });
  }

  @override
  void initState() {
    super.initState();
    getToken().whenComplete(() {
      setState(() {});
    });
  }

  List<GetAllLocationPOJO>? getAllLocations;

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();

    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(
        builder: (context, orientation) {
          SizeConfig().init(constraints, orientation);
          return Scaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: Colors.white,
              body: Container(
                height: SizeConfig.heightMultiplier * 100,
                width: SizeConfig.widthMultiplier * 100,
                color: Colors.transparent,
                child: CustomPaint(
                    painter: CurvePainter(),
                    child: SizedBox(
                        height: SizeConfig.heightMultiplier * 100,
                        width: SizeConfig.widthMultiplier * 100,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                                width: SizeConfig.widthMultiplier * 100,

                                child: Row(children: [


                                  Container(
                                    //height: 50,


                                    padding: const EdgeInsets.all(5.0),
                                    color: Colors.transparent,
                                    width: 60,

                                    child: FloatingActionButton(
                                      child: const Icon(Icons.arrow_back_ios),
                                      onPressed: ()
                                      async {

                                        Navigator.of(context).push(MaterialPageRoute(

                                            builder: (_) => const SettingsScreen()));



                                      },
                                      heroTag: null,
                                    ),
                                  ),


                                  Container(

                                    height: SizeConfig.heightMultiplier * 7,
                                    padding: const EdgeInsets.all(10.0),
                                    child: const Text(
                                      "All Locations",
                                      textAlign: TextAlign.center,
                                      textScaleFactor: 1.3,
                                      style: TextStyle(
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),])),
                            FutureBuilder(
                                future: token.isNotEmpty
                                    ? restApiClient
                                        .getAllLocations("Bearer " + token)
                                        .then((responses) async {
                                        if (responses.isNotEmpty) {
                                          getAllLocations = responses;
                                        }
                                      }).whenComplete(() {
                                        debugPrint("complete:");
                                      }).catchError((onError) {
                                        debugPrint(
                                            "errors ae there:${onError.toString()}");
                                      })
                                    : getToken(),
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (snapshot.hashCode == 0) {

                                  } else {

                                  }

                                  if (getAllLocations?.length == null) {
                                    return Center(
                                        child: SizedBox(
                                            height:
                                                SizeConfig.heightMultiplier *
                                                    20,
                                            child:
                                            const Text(
                                              "No locations found :(",
                                              textAlign: TextAlign.center,
                                              textScaleFactor: 1.5,
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),));
                                  } else {
                                    return Column(
                                      children: <Widget>[
                                        SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: allLocationWidget(
                                              getAllLocations!),
                                        )

                                        //     footerWidget()
                                      ],
                                    );
                                  }
                                })
                          ],
                        ))),
              ));

          //)
        },
      );
    });
  }
}

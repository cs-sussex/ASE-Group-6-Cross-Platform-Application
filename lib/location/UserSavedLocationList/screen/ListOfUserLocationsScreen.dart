import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mylocation/location/model/GetAllLocationPOJO.dart';
import 'package:mylocation/location/model/LocationScreen/AllLocationWidget.dart';
import 'package:mylocation/network/RestClient.dart';
import 'package:mylocation/usersettings/SettingsScreen.dart';
import 'package:mylocation/util/appconstants/AppConstants.dart';
import 'package:dio/dio.dart';
import 'package:mylocation/util/localstorage/UserAuthSharedPreferences.dart';
import 'package:mylocation/util/ui/CurvePainter.dart';
import 'package:mylocation/util/ui/sizeConfig.dart';
import '';

const String routeName = "ListOfUserLocationStates";
var dio = Dio()..options.baseUrl = AppConstants.BASE_URL;
RestClient restApiClient = RestClient(dio);
AppConstants appConstants = AppConstants();

class ListOfUserLocationStates extends StatefulWidget {
  const ListOfUserLocationStates({Key? key}) : super(key: key);

  @override
  _AllLocationsState createState() => _AllLocationsState();
}

class _AllLocationsState extends State<ListOfUserLocationStates> {
  String token = "";
  String userId = "";


  getToken() async {
    await UserAuthSharedPreferences.instance
        .getStringValue("token")
        .then((value) {
      token = value;
    });
  }



  getUserId() async {
    await UserAuthSharedPreferences.instance
        .getStringValue("id")
        .then((value) {
      userId = value;
    });
  }

  @override
  void initState() {
    super.initState();
    getToken().whenComplete(() {
      setState(() {});
    });

    getUserId().whenComplete(() {
      setState(() {});
    });
  }








  Future deleteUserLocation(String locationId) async {
    restApiClient.deleteUserLocation("Bearer " + token,locationId).then((value) async {

      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const ListOfUserLocationStates()));


    }).whenComplete(() {
      debugPrint("complete:");
    }).catchError((onError) {
      debugPrint("errors:${onError.toString()}");
    });
  }







  Widget allLocationWidget(List<GetAllLocationPOJO> getAllLocationPOJO) {
    return Align(
        alignment: Alignment.topCenter,
        child: Directionality(
            textDirection: TextDirection.ltr,
            child: Container(
                height: SizeConfig.heightMultiplier * 80,
                color: Colors.white,
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: getAllLocationPOJO == null
                        ? 0
                        : getAllLocationPOJO.length,
                    itemBuilder: (context, index) {

                      return GestureDetector(
                        onTap: () {},
                        child: Container(
                            padding: EdgeInsets.only(
                                left: 1 * SizeConfig.heightMultiplier,
                                right: 1 * SizeConfig.heightMultiplier,
                                bottom: 1 * SizeConfig.heightMultiplier),
                            child: Column(
                              children: <Widget>[
                                Container(
                                 // height: SizeConfig.heightMultiplier * 40,
                                  width: SizeConfig.widthMultiplier * 95,
                                  padding: EdgeInsets.all(10.0),

                                  child: Card(
                                    elevation: 4,
                                    child: Column(children: [
                                      Container(
                                        alignment: Alignment.topLeft,
                                        padding: EdgeInsets.all(5.0),
                                        child: Text(
                                          getAllLocationPOJO[index]
                                              .user
                                              .firstname +
                                              " " +
                                              getAllLocationPOJO[index]
                                                  .user
                                                  .lastname,
                                          textScaleFactor: 1.3,

                                          //  textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.topLeft,
                                        padding: EdgeInsets.all(5.0),
                                        child: Text(
                                          getAllLocationPOJO[index].location_name,
                                          textScaleFactor: 1.3,

                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.topLeft,
                                        padding: EdgeInsets.all(5.0),
                                        child: Text(
                                          getAllLocationPOJO[index]
                                              .latitude
                                              .toString() +
                                              "," +
                                              getAllLocationPOJO[index]
                                                  .latitude
                                                  .toString(),
                                          textScaleFactor: 1.3,

                                          //  textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.topLeft,
                                        padding: EdgeInsets.all(5.0),
                                        child: Text(
                                          getAllLocationPOJO[index].user.firstname +" " +  getAllLocationPOJO[index].user.lastname ,
                                          textScaleFactor: 1.3,

                                          //  textAlign: TextAlign.center,
                                        ),
                                      ),



                                    Container(
                                        height: 45,
                                        width: 110,
                                        padding:  EdgeInsets.all(5.0),
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(5.0),
                                                ),
                                              )),
                                          onPressed: () async {
                                            //deleteUserLocation(getAllLocationPOJO[index].id);


                                            DeleteLocationdDialogBox(context, getAllLocationPOJO[index].id,
                                                "Are yu sure want to delete this location");




                                          },
                                          child: Ink(
                                            decoration: const BoxDecoration(
                                              gradient: LinearGradient(
                                                  colors: [Colors.blue, Colors.cyan, Colors.blue]),
                                            ),
                                            child: Container(
                                              child: const Text(
                                                'Delete',
                                                textAlign: TextAlign.center,
                                                textScaleFactor: 1.0,
                                              ),
                                            ),
                                          ),
                                        ),












                                    )]),
                                  ),

                                )
                              ],
                            )),
                      );
                    }))));
  }






  DeleteLocationdDialogBox(BuildContext context, String locationId,String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Expanded(
          child: AlertDialog(
            //title: Text('Welcome'),
            content: Text(message),
            actions: [
              Container(
                height: 40,
                width: 80,
                child: ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      )),
                  onPressed: () async {
                    deleteUserLocation(locationId);
                  },
                  child: Ink(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.blue, Colors.cyan, Colors.blue]),
                    ),
                    child: Container(
                      child: const Text(
                        'Ok',
                        textAlign: TextAlign.center,
                        textScaleFactor: 1.0,
                      ),
                    ),
                  ),
                ),
              ),


              Container(
                height: 40,
                width: 80,
         child:ElevatedButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                )),
            onPressed: () async {
              Navigator.of(context).pop();

            },
            child: Ink(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.blue, Colors.cyan, Colors.blue]),
              ),
              child: Container(
                child: const Text(
                  'Cancel',
                  textAlign: TextAlign.center,
                  textScaleFactor: 1.0,
                ),
              ),
            ),
          ),
        )
            ],
          ),
        );
      },
    );
  }





















  List<GetAllLocationPOJO>? getUserAllLocations;

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
                                "Your Locations",
                                textAlign: TextAlign.center,
                                textScaleFactor: 1.3,
                                style: TextStyle(
                                  color: Colors.black87,
                                ),
                              ),
                            ),])),
                            FutureBuilder(
                                future: token.isNotEmpty && userId.isNotEmpty
                                    ? restApiClient
                                    .getUserAllLocations("Bearer " + token,userId)
                                    .then((responses) async {
                                  if (responses.isNotEmpty) {
                                    getUserAllLocations = responses;
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

                                  if (getUserAllLocations?.length == null) {
                                    return Center(
                                        child: SizedBox(
                                            height:
                                            SizeConfig.heightMultiplier *
                                                20,
                                            child:
                                            Center( child: Container(
                                              height: SizeConfig
                                                  .heightMultiplier *
                                                  8,
                                              width: SizeConfig
                                                  .widthMultiplier *
                                                  90,
                                              padding: const EdgeInsets.all(
                                                  10.0),
                                              child: const Text(
                                                "No saved location found :(",
                                                textAlign: TextAlign.center,
                                                textScaleFactor: 1.5,
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),),));
                                  } else {
                                    return Column(
                                      children: <Widget>[
                                        SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: allLocationWidget(
                                              getUserAllLocations!)
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

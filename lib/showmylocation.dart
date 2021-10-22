// ignore_for_file: prefer_if_null_operators, avoid_print, unnecessary_null_comparison

import 'dart:async';
import 'dart:io';
// ignore: import_of_legacy_library_into_null_safe

import 'package:background_location/background_location.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class MyLocation extends StatelessWidget {
  static const routeName = '/ShowMyLocation';

  const MyLocation({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ShowMyLocation(),
    );
  }
}

class ShowMyLocation extends StatefulWidget {
  const ShowMyLocation({Key? key}) : super(key: key);

  @override
  _ShowMyLocationState createState() => _ShowMyLocationState();
}

extension ParseToString on ConnectivityResult {
  String toValue() {
    return toString().split('.').last;
  }
}

class _ShowMyLocationState extends State<ShowMyLocation> {
  bool isInternetOffline = true; // to check internet connectivity
  late LatLng currentLocationPoint =
      const LatLng(0, 0); // show current location on map
  late GoogleMapController mapController; //googleMap
  TextEditingController currentLocationTextController = TextEditingController();
  late Position locationCurrentPosition; //location current position
  late CameraPosition _cameraPosition;
  final Set<Marker> _markers = {};
  late bool mapLoader = true;
  late bool locationServiceEnabled = false; //location service
  late bool refreshLocation = true;
  late int locationPermissionFlag = 0;
  late int extraFlag = 0;

  /* locationPermissionFlag 1=Location permission granted
       locationPermissionFlag 2=nLocation permission denied
      */

  late ConnectivityResult internetConnectivityResult;
  late LocationPermission permission;
  late String loaderString;
  MapType _currentMapType = MapType.normal;
  late StreamSubscription _connectivitySubscription;
  Map _source = {ConnectivityResult.none: false};
  final MyConnectivity _connectivity = MyConnectivity.instance;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    // if (_markers.isNotEmpty) {
    //   controller.showMarkerInfoWindow(MarkerId('currentLocations'));
    // }
  }

  //Async method for retrieving user location
  Future<Position> _getGeoLocationPosition() async {
    // Test if location services are enabled.
    locationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    permission = await Geolocator.checkPermission();

    if (locationPermissionFlag != 1) {
      if (permission == LocationPermission.whileInUse) {
        print("I am inside Location services are whileInUse");
        setState(() {
          locationPermissionFlag = 1;
          mapLoader = false;
        });
      }
    }

    if (locationPermissionFlag != 1) {
      if (permission == LocationPermission.always) {
        print("I am inside Location services are Always");

        setState(() {
          locationPermissionFlag = 1;

          mapLoader = false;
        });
      }
    }

    if (!locationServiceEnabled) {
      print("I am inside Location services are disabled");
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();
      setState(() {
        mapLoader = false;
        locationPermissionFlag = 2;
      });
      return Future.error('Location services are disabled.');
    }
    // if (permission == LocationPermission.denied) {
    //   permission = await Geolocator.requestPermission();
    //
    //   if (permission == LocationPermission.denied) {
    //     // Permissions are denied, next time you could try
    //     // requesting permissions again (this is also where
    //     // Android's shouldShowRequestPermissionRationale
    //     // returned true. According to Android guidelines
    //     // your App should show an explanatory UI now.
    //     return Future.error('Location permissions are denied');
    //   }
    // }
    if (permission == LocationPermission.deniedForever) {
      print("I am inside Location services are deniedForever");

      await Geolocator.openLocationSettings();

      permission = await Geolocator.requestPermission();

      setState(() {
        mapLoader = false;
        locationPermissionFlag = 2;
        locationServiceEnabled = false;
      });
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Widget circle() {
    return const CircularProgressIndicator();
  }

  Future _fetchCurrentLocation() async {
    locationCurrentPosition = await _getGeoLocationPosition();

    // }
    /*
         locationPermissionFlag =1  defines user granted location permission
     */

    /*
           getting current location latitude,longitude
       */

    currentLocationPoint = LatLng(
        locationCurrentPosition.latitude, locationCurrentPosition.longitude);

    /*
          function to show address using latitude,longitude
       */
    showAddress(currentLocationPoint.latitude, currentLocationPoint.longitude);
    print("currentLocationPoint" + currentLocationPoint.toString());

    //  currentLocationPoint = LatLng(
    // currentLocationPoint.latitude, currentLocationPoint.longitude);

    return currentLocationPoint;
  }

  @override
  void initState() {
    super.initState();

    _connectivity.initialise();
    _connectivity.myStream.listen((source) {
      setState(() => _source = source);
    });

    _fetchCurrentLocation();
  }

  @override
  dispose() {
    super.dispose();
    _connectivitySubscription.cancel();
    BackgroundLocation.stopLocationService();
  }

  void changeMapType() {
    setState(() {
      _currentMapType = (_currentMapType == MapType.normal)
          ? MapType.satellite
          : MapType.normal;
    });
  }

  Future showAddress(
      double? locationLatitudePoint, double? locationLongitudePoint) async {
    locationLatitudePoint = currentLocationPoint.latitude;
    locationLongitudePoint = currentLocationPoint.longitude;

    if (locationServiceEnabled == true) {
      locationPermissionFlag = 3;
      extraFlag = 1;
      mapLoader = false;
    }

    List<Placemark> currentPlace = await placemarkFromCoordinates(
        currentLocationPoint.latitude, currentLocationPoint.longitude);
    Placemark place = currentPlace[0];
    currentLocationTextController.text = place.name.toString() +
        "," +
        place.locality.toString() +
        "," +
        place.street.toString() +
        "," +
        place.postalCode.toString();

    print(place.postalCode.toString());

    _markers.add(Marker(
      markerId: MarkerId("currentLocations"),
      draggable: true,
      visible: true,
      infoWindow: InfoWindow(
          title: locationLatitudePoint.toString() +
              ", " +
              locationLongitudePoint.toString()),
      position:
          LatLng(currentLocationPoint.latitude, currentLocationPoint.longitude),
      icon: BitmapDescriptor.defaultMarker,
    ));

    if (locationServiceEnabled) {
      //if (flag==2) {
      print("inside   BitmapDescriptor" +
          currentLocationPoint.latitude.toString());
      _cameraPosition = CameraPosition(
          target: LatLng(
              currentLocationPoint.latitude, currentLocationPoint.longitude),
          zoom: 13.0);
      mapController
          .animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
/*
     check internet connection
 */
    String string = "";

    print("mapLoader  mapLoader()" + mapLoader.toString());

    switch (_source.keys.toList()[0]) {
      case ConnectivityResult.mobile:
        string = 'Mobile: Online';
        isInternetOffline = true;

        break;
      case ConnectivityResult.wifi:
        string = 'WiFi: Online';
        isInternetOffline = true;

        break;
      case ConnectivityResult.none:
        isInternetOffline = false;

        break;
      default:
        isInternetOffline = true;

        string = 'Offline';
    }

    print("currentLocationPoint()" + currentLocationPoint.toString());

    print("internet()" + locationPermissionFlag.toString());

    /*
        if  _fetchCurrentLocation(); failed to load current location from initState() due
        to location permission was denied then
        these conditions will check if permission is granted which means serviceEnabled==true
        if permission is granted and we get location already then locationPermissionFlag will be set as 3
        in showAddress() function
        */

    if (locationPermissionFlag != 2) {
      print("In locationPermissionFlag != 3  ");
      setState(() {
        mapLoader == false;
      });
      _fetchCurrentLocation();
    } else if (locationPermissionFlag == 2) {
      _fetchCurrentLocation();
    }

    return
        /*
       check if internet connection is available
     */
        isInternetOffline == false
            ? Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      color: Colors.blueGrey[700],
                      padding: const EdgeInsets.all(15.0),
                      child: const Text(
                        "No internet connection...",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      )),
                ],
              ))
            : Scaffold(

                //appBar: AppBar(
                //title: const Text('You Are Here:'),
                backgroundColor: Colors.blueGrey[700],
                // ),

                body: mapLoader == true &&
                        currentLocationPoint == const LatLng(0.0, 0.0)
                    ? Center(
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
                              child: const Text(
                                "Fetching your current location...",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              )),
                        ],
                      ))
                    // Display Progress Indicator

                    //)

                    : Stack(
                        children: [
                          GoogleMap(
                            onMapCreated: _onMapCreated,
                            padding:
                                const EdgeInsets.only(bottom: 100, left: 15),
                            // <--- padding added here

                            indoorViewEnabled: true,
                            myLocationButtonEnabled: false,

                            zoomGesturesEnabled: true,

                            mapType: _currentMapType,
                            mapToolbarEnabled: true,

                            zoomControlsEnabled: true,
                            markers: _markers,

                            onCameraMove: (position) {
                              setState(() {});
                            },

                            initialCameraPosition: CameraPosition(
                              target: LatLng(currentLocationPoint.latitude,
                                  currentLocationPoint.longitude),
                              zoom: 13.00,
                            ),
                          ),

                          /*
             if serviceEnabled true means location permission granted. initially the longitude,latitude will be 0.0
              so below condition  will show loader until location latitude is not updated to current location
         */

                          if (currentLocationPoint.longitude == 0.0)
                            Center(
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
                                    child: const Text(
                                      "Fetching your current location..",
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white),
                                    )),
                              ],
                            )),
                          mapLoader != true &&
                                  currentLocationPoint.longitude == 0.0
                              ? Container()
                              : Positioned(
                                  bottom: 10.0,
                                  right: 10.0,
                                  child: Row(
                                    children: [
                                      Container(
                                        //height: 50,
                                        padding: const EdgeInsets.all(5.0),
                                        color: Colors.transparent,

                                        child: FloatingActionButton(
                                          backgroundColor: Colors.blueGrey,
                                          child: const Icon(Icons.map_rounded),
                                          onPressed: changeMapType,
                                          heroTag: null,
                                        ),
                                        alignment: Alignment.bottomRight,
                                      ),
                                      Container(
                                        //height: 50,
                                        padding: const EdgeInsets.all(5.0),
                                        color: Colors.transparent,
                                        alignment: Alignment.bottomCenter,

                                        child: refreshLocation
                                            ? ElevatedButton(
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all<
                                                              Color>(
                                                          Colors.blueGrey),
                                                ),
                                                onPressed: () async {
                                                  setState(() {
                                                    refreshLocation = false;
                                                  });
                                                  await BackgroundLocation
                                                      .setAndroidNotification(
                                                    title:
                                                        'Background service is running',
                                                    message:
                                                        'Background location in progress',
                                                    icon: '@mipmap/ic_launcher',
                                                  );
                                                  await BackgroundLocation
                                                      .startLocationService(
                                                          distanceFilter: 5.0);
                                                  /*
                                  this function will gives us a real time location streaming
                             */
                                                  BackgroundLocation
                                                      .getLocationUpdates(
                                                          (location) async {
                                                    showAddress(
                                                        location.latitude,
                                                        location.longitude);
                                                  });
                                                },
                                                child: const Text(
                                                    'Start real time Location'))
                                            : Container(
                                                //height: 50,
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                color: Colors.transparent,

                                                child: FloatingActionButton(
                                                  backgroundColor:
                                                      Colors.blueGrey,
                                                  child: const Icon(
                                                    Icons.stop,
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      refreshLocation = true;
                                                    });
                                                    BackgroundLocation
                                                        .stopLocationService();
                                                    print("STOPPED");
                                                  },
                                                  heroTag: null,
                                                ),
                                                alignment:
                                                    Alignment.bottomCenter,
                                              ),
                                      ),
                                      Container(
                                        //height: 50,
                                        padding: const EdgeInsets.all(5.0),
                                        color: Colors.transparent,

                                        child: FloatingActionButton(
                                          backgroundColor: Colors.blueGrey,
                                          child: const Icon(
                                            Icons.zoom_in,
                                          ),
                                          onPressed: () {
                                            if (mapController != null) {
                                              _cameraPosition = CameraPosition(
                                                  target: LatLng(
                                                      currentLocationPoint
                                                          .latitude,
                                                      currentLocationPoint
                                                          .longitude),
                                                  zoom: 13.0);
                                              mapController.animateCamera(
                                                  CameraUpdate
                                                      .newCameraPosition(
                                                          _cameraPosition));
                                            }
                                          },
                                          heroTag: null,
                                        ),
                                        alignment: Alignment.bottomRight,
                                      ),
                                    ],
                                  ),
                                ),
                          mapLoader != true &&
                                  currentLocationPoint.longitude == 0.0
                              ? Container()
                              : Positioned(
                                  top: 15.0,
                                  right: 15.0,
                                  left: 15.0,
                                  child: Container(
                                    //height:double.infinity,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3.0),
                                      color: Colors.white,
                                      boxShadow: const [
                                        BoxShadow(
                                            color: Colors.grey,
                                            offset: Offset(1.0, 5.0),
                                            blurRadius: 10,
                                            spreadRadius: 3)
                                      ],
                                    ),
                                    child: TextField(
                                      enabled: false,

                                      cursorColor: Colors.black,
                                      controller: currentLocationTextController,
                                      autofocus: false,
                                      maxLines: null,
                                      //style: const TextStyle(fontSize: 0.5),
                                      decoration: InputDecoration(
                                        icon: Container(
                                          margin: const EdgeInsets.only(
                                              left: 20, top: 0),
                                          width: 10,
                                          height: 10,
                                          child: const Icon(
                                            Icons.location_on,
                                            color: Colors.green,
                                          ),
                                        ),
                                        hintText: "Fetching your location...",
                                        labelText: "Your current location",
                                        border: InputBorder.none,
                                        contentPadding:
                                            const EdgeInsets.fromLTRB(
                                                15.0, 15.0, 15.0, 15.0),
                                      ),
                                    ),
                                  ),
                                ),
                        ],
                      ));
  }
}
//);

class MyConnectivity {
  MyConnectivity._();

  static final _instance = MyConnectivity._();

  static MyConnectivity get instance => _instance;
  final _connectivity = Connectivity();
  final _controller = StreamController.broadcast();

  Stream get myStream => _controller.stream;

  void initialise() async {
    ConnectivityResult result = await _connectivity.checkConnectivity();
    _checkStatus(result);
    _connectivity.onConnectivityChanged.listen((result) {
      _checkStatus(result);
    });
  }

  void _checkStatus(ConnectivityResult result) async {
    bool isOnline = false;
    try {
      final result = await InternetAddress.lookup('example.com');
      isOnline = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      isOnline = false;
    }
    _controller.sink.add({result: isOnline});
  }

  void disposeStream() => _controller.close();
}

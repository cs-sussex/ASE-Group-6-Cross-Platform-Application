// ignore_for_file: prefer_if_null_operators, avoid_print, unnecessary_null_comparison

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
// ignore: import_of_legacy_library_into_null_safe
// import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'util/ConnectionStatusSingleton.dart';

class MyLocation extends StatelessWidget {
  // static const routeName = '/PublisherDetailsState';
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

class _ShowMyLocationState extends State<ShowMyLocation> {
  late StreamSubscription _connectionChangeStream;

  bool isOffline = false;
  bool currentLocation = false;
  late LatLng _center = const LatLng(0, 0);
  late GoogleMapController mapController;
  TextEditingController currentLocationTextController = TextEditingController();
  late Position position;
  late CameraPosition _cameraPosition;
  final Set<Marker> _markers = {};
  late bool mapLoader = true;

  void _onMapCreated(GoogleMapController controller) {
    setState(() {});
    mapController = controller;
  }

  MapType _currentMapType = MapType.normal;

  void connectionChanged(dynamic hasConnection) {
    setState(() {
      isOffline = !hasConnection;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchCurrentLocation();
  }

  @override
  dispose() {
    super.dispose();
  }

  void changeMapType() {
    setState(() {
      _currentMapType = (_currentMapType == MapType.normal)
          ? MapType.satellite
          : MapType.normal;
    });
  }

  void savelocation() {
    setState(() {
      _currentMapType = (_currentMapType == MapType.normal)
          ? MapType.satellite
          : MapType.normal;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey[700],
        body: mapLoader == true
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
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      )),
                ],
              ))
            // Display Progress Indicator

            //)
            : Stack(
                children: [
                  GoogleMap(
                    onMapCreated: _onMapCreated,
                    padding: const EdgeInsets.only(bottom: 100, left: 15),
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
                      target: _center,
                      zoom: 13.00,
                    ),
                  ),
                  mapLoader == true
                      ? Container()
                      : Positioned(
                          bottom: 10.0,
                          right: 10.0,
                          child: Row(
                            children: [
                              // save location button
                              Container(
                                //height: 50,
                                padding: const EdgeInsets.all(5.0),
                                color: Colors.transparent,

                                child: FloatingActionButton(
                                  backgroundColor: Colors.blueGrey,
                                  child: const Icon(Icons.save_rounded),
                                  onPressed: changeMapType,
                                  heroTag: null,
                                ),
                                alignment: Alignment.bottomRight,
                              ),
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
                                padding: const EdgeInsets.all(10.0),
                                color: Colors.transparent,

                                child: FloatingActionButton(
                                  backgroundColor: Colors.blueGrey,
                                  child: const Icon(
                                    Icons.zoom_in,
                                  ),
                                  onPressed: () {
                                    if (mapController != null) {
                                      _cameraPosition = CameraPosition(
                                          target: LatLng(_center.latitude,
                                              _center.longitude),
                                          zoom: 13.0);
                                      mapController.animateCamera(
                                          CameraUpdate.newCameraPosition(
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
                  Positioned(
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
                            margin: const EdgeInsets.only(left: 20, top: 0),
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
                              const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ));
    //);
  }

  //Async method for retrieving user location
  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;

    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    //   // ignore: unrelated_type_equality_checks

    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.

    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      mapLoader = false;
      print("finally");
    });

    return position;
  }

  Future _fetchCurrentLocation() async {
    await _getGeoLocationPosition();

    _center = LatLng(position.latitude, position.longitude);
    var bitmapIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(48, 48)),
        'assets/images/marker.png');

    List<Placemark> currentPlace =
        await placemarkFromCoordinates(position.latitude, position.longitude);
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
      markerId: const MarkerId("currentLocation"),
      draggable: true,
      visible: true,
      position: _center,
      icon: BitmapDescriptor.defaultMarker,
    ));

    setState(() {
      if (mapLoader && mapController != null) {
        print("inside" + position.latitude.toString());
        _cameraPosition = CameraPosition(
            target: LatLng(position.latitude, position.longitude), zoom: 13.0);
        mapController
            .animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));
      }
    });

    return position;
  }
}

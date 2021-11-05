import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mylocation/location/model/GetAllLocationPOJO.dart';
import 'package:mylocation/util/ui/sizeConfig.dart';

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
                               // height: SizeConfig.heightMultiplier * 23,
                                width: SizeConfig.widthMultiplier * 90,

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
                                        getAllLocationPOJO[index].user.email,
                                        textScaleFactor: 1.3,

                                        //  textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ]),
                                ),

                              )
                            ],
                          )),
                    );
                  }))));
}

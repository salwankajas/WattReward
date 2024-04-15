import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ev/util/currentLoc.dart';
import 'package:ev/util/route.dart';
import 'package:url_launcher/url_launcher.dart';

late var point;

class CustomMarker {
  late LatLng points;
  late LatLng currPoints;
  late String name;
  double? distance;
  List<LatLng>? routes;
  late BuildContext context;
  late GlobalKey<ScaffoldState> _scaffoldKey;
  late StreamController<PersistentBottomSheetController?> streamControllers;
  PersistentBottomSheetController? controller;
  late StreamController<List<LatLng>> streamControllersRoutes;
  CustomMarker(
      String name,
      LatLng point,
      GlobalKey<ScaffoldState> _scaffoldKey,
      StreamController<PersistentBottomSheetController?> streamControllers,
      StreamController<List<LatLng>> streamControllersRoutes) {
    this.name = name;
    this.points = point;
    this._scaffoldKey = _scaffoldKey;
    this.streamControllers = streamControllers;
    this.streamControllersRoutes = streamControllersRoutes;
  }
  getController() {
    return controller;
  }

  markerBuilder(double _marker) {
    return Marker(
      width: _marker,
      height: _marker,
      rotate: true,
      point: points,
      child: Container(
        alignment: Alignment.center,
        child: IconButton(
          icon: Image.asset(
            "assets/images/icon/ev_location.png",
            width: _marker,
            height: _marker,
          ),
          onPressed: () async {
            await locationRequest();
            Position currLoc = await determinePosition();
            currPoints = LatLng(currLoc.latitude, currLoc.longitude);
            // print(currLoc);
            if (routes == null) {
              (List<LatLng>, double) res = await getRoute(currPoints, points);
              routes = res.$1;
              distance = res.$2;
            }
            // print(routes);
            streamControllersRoutes.add(routes!);
            // controller;
            controller = _scaffoldKey.currentState!.showBottomSheet(
                backgroundColor: Colors.transparent,
                elevation: 0, (BuildContext context) {
              return Container(
                padding: EdgeInsets.all(8.0),
                color: Colors.transparent,
                width: MediaQuery.of(context).size.width - 30,
                height: 240,
                child: Container(
                    padding: const EdgeInsets.all(8.0),
                    width: MediaQuery.of(context).size.width - 30,
                    alignment: Alignment.center,
                    height: 220,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: const [
                          BoxShadow(
                            offset: Offset(2, 2),
                            blurRadius: 12,
                            color: Color.fromRGBO(0, 0, 0, 0.16),
                          )
                        ]),
                    child: Column(
                      children: [
                        Container(
                          height: 80,
                          // color: Colors.red,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  width: 0.8,
                                  color: Colors.grey.withOpacity(0.5)),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 20,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    name,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  SizedBox(
                                    height: 14,
                                  ),
                                  Row(
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Iconsax.location,
                                            size: 16,
                                          ),
                                          SizedBox(width: 4),
                                          Text((distance! / 1000)
                                                  .toStringAsFixed(2) +
                                              "km"),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 18,
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Iconsax.car,
                                            size: 16,
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                              "${Duration(minutes: (((distance! / 1000) / 50) * 60).ceil()).inMinutes}min"),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(width: 20),
                              Container(
                                  height: 50,
                                  width: 50,
                                  child: Material(
                                      shape: CircleBorder(),
                                      color: Color.fromARGB(255, 95, 190,
                                          98), // Set the border radius),
                                      child: InkWell(
                                        customBorder: new CircleBorder(),
                                        onTap: () async {
                                          var uri = Uri.parse(
                                              "http://maps.google.com/maps?saddr=${currPoints.latitude},${currPoints.longitude},&daddr=${points.latitude},${points.longitude}'");
                                          if (await canLaunchUrl(uri)) {
                                            await launchUrl(uri);
                                          } else {
                                            throw 'Could not launch ${uri.toString()}';
                                          }
                                        },
                                        child: Center(
                                            child: const Icon(
                                          Iconsax.send_2,
                                          color: Colors.white,
                                          size: 32,
                                        )),
                                      ))),
                              SizedBox(
                                width: 10,
                              )
                            ],
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Expanded(child: Container()),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                "3 Chargers",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: Colors.green),
                              ),
                            ),
                          ],
                        ),
                        Container(
                                width: MediaQuery.of(context).size.width,
                                // height: 30,
                                padding: const EdgeInsets.all(10.0),
                                // color: Colors.black,
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                        width: 0.8,
                                        color: Colors.grey.withOpacity(0.5)),
                                  ),
                                ),),
                        // Expanded(
                            // child:
                          //    Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          // children: [
                            Container(
                                width: MediaQuery.of(context).size.width,
                                height: 55,
                                padding: const EdgeInsets.all(12.0),
                                // color: Colors.black,
                                // decoration: BoxDecoration(
                                //   border: Border(
                                //     top: BorderSide(
                                //         width: 0.8,
                                //         color: Colors.grey.withOpacity(0.5)),
                                //   ),
                                // ),
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 80),
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ),
                                      minimumSize: Size(300, 80),
                                      textStyle: TextStyle(fontSize: 14),
                                      foregroundColor: Colors.green,
                                      side: BorderSide(color: Colors.green),
                                    ),
                                    child: Text("Offers",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700)),
                                    onPressed: () => {},
                                  ),
                                )),
                          // ],
                        // )
                        // )
                      ],
                    )),
              );
            });
            streamControllers.add(controller);
          },
        ),
      ),
    );
  }
}

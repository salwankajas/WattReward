import 'dart:async';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ev/util/currentLoc.dart';
import 'package:ev/util/route.dart';

late var point;

class CustomMarker {
  late LatLng points;
  late LatLng currPoints;
  double? distance;
  List<LatLng>? routes;
  late BuildContext context;
  late GlobalKey<ScaffoldState> _scaffoldKey;
  late StreamController<PersistentBottomSheetController<dynamic>?>
      streamControllers;
  PersistentBottomSheetController? controller;
  late StreamController<List<LatLng>> streamControllersRoutes;
  CustomMarker(
      LatLng point,
      GlobalKey<ScaffoldState> _scaffoldKey,
      StreamController<PersistentBottomSheetController<dynamic>?>
          streamControllers,
      StreamController<List<LatLng>> streamControllersRoutes) {
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
            "images/icon/ev_location.png",
            width: _marker,
            height: _marker,
          ),
          onPressed: () async {
            Position currLoc = await determinePosition();
            currPoints = LatLng(currLoc.latitude, currLoc.longitude);
            // print(currLoc);
            if (routes == null) {
              (List<LatLng>,double) res = await getRoute(currPoints, points);
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
                height: 220,
                child: Container(
                    padding: const EdgeInsets.all(8.0),
                    width: MediaQuery.of(context).size.width - 30,
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
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(distance.toString()+ " m"),
                              SizedBox(width: 80),
                              Container(
                                  height: 50,
                                  width: 50,
                                  child: Material(
                                      shape: CircleBorder(),
                                      color: Color.fromARGB(255, 95, 190,
                                          98), // Set the border radius),
                                      child: InkWell(
                                        customBorder: new CircleBorder(),
                                        onTap: () {},
                                        child: Center(
                                            child: const Icon(
                                          Iconsax.send_2,
                                          color: Colors.white,
                                          size: 32,
                                        )),
                                      )))
                            ],
                          ),
                        )
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

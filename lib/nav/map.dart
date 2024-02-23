import 'dart:convert';
import 'package:location/location.dart' as loc;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:iconsax/iconsax.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:ev/icons/current_loc.dart';
import 'package:latlong2/latlong.dart';


Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
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
  return await Geolocator.getCurrentPosition();
}

Future<bool> _locationRequest() async {
  loc.Location location = new loc.Location();
  bool ison = await location.serviceEnabled();
  if (!ison) {
    //if defvice is off
    bool isturnedon = await location.requestService();
    if (isturnedon) {
      print("GPS device is turned ON");
    } else {
      print("GPS Device is still OFF");
    }
    return isturnedon;
  }
  return ison;
}

class Maps extends StatefulWidget {
  @override
  _Maps createState() => _Maps();
}
class _Maps extends State<Maps> {
 
  final ev_location = TextEditingController();
  late MapController _mapController = MapController();
  LatLng mapPos = LatLng(0, 0);
  List<LatLng> routePoints = [LatLng(9.853852, 76.947620)];

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    ev_location.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return 
    Stack(
        children: [
          SizedBox(
            child: FlutterMap(
              options: MapOptions(
                initialCenter: routePoints[0],
                initialZoom: 18,
                maxZoom: 20,
              ),
              mapController: _mapController,
              children: [
                TileLayer(
                  urlTemplate:
                      'https://api.maptiler.com/maps/dataviz/{z}/{x}/{y}.png?key=54GmtaBGPUmEcqpweB6n',
                  userAgentPackageName: 'com.example.app',
                ),
                PolylineLayer(
                  polylineCulling: false,
                  polylines: [
                    Polyline(
                        points: routePoints,
                        color: Colors.green,
                        strokeWidth: 4)
                  ],
                ),
                MarkerLayer(markers: [ 
                  Marker(
                      point: mapPos,
                      height: 50,
                      rotate: true,
                      width: 50,
                      child: Container(
                        alignment: Alignment.center,
                        child: const CurrentLocIcon()
                      ))
                ])
              ],
            ),
          ),
          Positioned(
              bottom: 20,
              right: 10,
              child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.transparent,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset:
                            Offset(3, 4), // changes the position of the shadow
                      ),
                    ],
                  ),
                  child: Material(
                      shape: CircleBorder(),
                      color: Colors.white, // Set the border radius),
                      child: InkWell(
                        customBorder: new CircleBorder(),
                        // splashColor: Colors.red,
                        onTap: () async {
                          print('Circle Clicked!');
                          await _locationRequest();
                          Position pos = await _determinePosition();
                          mapPos = LatLng(pos.latitude, pos.longitude);
                          _mapController.move(mapPos, 18.0);
                          setState(() {
                            
                          });
                        },
                        child: Center(
                            child: const Icon(
                          Iconsax.gps,
                          color: Colors.green,
                          size: 28,
                        )),
                      )))),
          Positioned(
              width: MediaQuery.of(context).size.width,
              top: 50,
              child: Align(
                alignment: Alignment.center,
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: Container(
                        width: 330,
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              )
                            ],
                            border: Border.all(color: Colors.green)),
                        child: Row(
                          children: [
                            const Icon(
                              Iconsax.search_normal,
                              color: Colors.green,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: TextField(
                                textInputAction: TextInputAction.search,
                                onSubmitted: (value) async {
                                  var v1 = 9.852323109271987;
                                  var v2 = 76.94904472504429;
                                  var v3 = 9.853305886649755;
                                  var v4 = 76.94684982163658;

                                  var url = Uri.parse(
                                      "http://router.project-osrm.org/route/v1/driving/$v2,$v1;$v4,$v3?steps=true&annotations=true&geometries=geojson&overview=full");
                                  // var url = Uri.parse("https://routing.openstreetmap.de/routed-car/route/v1/driving/$v2,$v1;$v4,$v3?overview=false&geometries=geojson&steps=true&hints=NwaPgcdQFIMrAAAAAAAAAAABAACTAAAAXcigQgAAAACExfJDPBOKQysAAAAAAAAAAAEAAJMAAAAmOwAAvGaWBNaZlgC8ZpYE1pmWABYAnwBH1g1v%3BueiRiMHokYgFAAAAAQAAAAUAAAAEAAAA0JInQaBAmD8WiA1BIKflQAUAAAABAAAABQAAAAQAAAAmOwAAoF2WBAJolgDZXZYEtWeWAAEAXwNH1g1v");
                                  var response = await http.get(url);
                                  print(response.body);
                                  setState(() {
                                    routePoints = [];
                                    var ruter =
                                        jsonDecode(response.body)['routes'][0]
                                            ['geometry']['coordinates'];
                                    print(ruter);
                                    for (int i = 0; i < ruter.length; i++) {
                                      var rep = ruter[i].toString();
                                      rep = rep.replaceAll("[", "");
                                      rep = rep.replaceAll("]", "");
                                      var lat1 = rep.split(", ");
                                      // print(lat1);
                                      // var long1 = rep.split(',');
                                      routePoints.add(LatLng(
                                          double.parse(lat1[1]),
                                          double.parse(lat1[0])));
                                    }
                                    // print(response);
                                    // print(ruter);
                                    _mapController.move(routePoints[0], 18.0);
                                    print(routePoints);
                                  });

                                  // print(response.body);
                                },
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Search stations',
                                ),
                                style: TextStyle(color: Colors.black),
                                cursorColor: Colors.green,
                              ),
                            )
                          ],
                        ))),
              )),
        ],
      );
  }
}

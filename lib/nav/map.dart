import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:iconsax/iconsax.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:ev/icons/current_loc.dart';
import 'package:latlong2/latlong.dart';
import 'package:ev/components/marker.dart';
import 'package:ev/util/currentLoc.dart';



class Maps extends StatefulWidget {
  @override
  _Maps createState() => _Maps();
}

class _Maps extends State<Maps> with AutomaticKeepAliveClientMixin<Maps> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  late PersistentBottomSheetController? controller;
  final ev_location = TextEditingController();
  late MapController _mapController = MapController();
  LatLng mapPos = LatLng(0, 0);
  LatLng initialMap = LatLng(9.853852, 76.947620);
  List<LatLng> routePoints = [LatLng(9.853852, 76.947620)];
  late double _markerSize;
  final streamControllers = StreamController<PersistentBottomSheetController?>();
  final streamControllersRoutes = StreamController<List<LatLng>>();
  late StreamSubscription<PersistentBottomSheetController<dynamic>?> streamSubscription;
  late StreamSubscription<List<LatLng>> streamSubscriptionRoutes;
  late final CustomMarker marker1;
  late final CustomMarker marker2;
  late final CustomMarker marker3;
  late final CustomMarker marker4;
    // final CustomMarker marker2 =
    //     CustomMarker(LatLng(11.199882, 76.260287), context, _scaffoldKey,streamControllers,streamControllersRoutes);
    // final CustomMarker marker3 =
    //     CustomMarker(LatLng(9.853643, 76.947692), context, _scaffoldKey,streamControllers,streamControllersRoutes);
    // final CustomMarker marker4 =
    //     CustomMarker(LatLng(9.853567, 76.946688), context, _scaffoldKey,streamControllers,streamControllersRoutes);

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    ev_location.dispose();
    streamControllers.close();
    streamSubscription.cancel();
    streamControllersRoutes.close();
    streamSubscriptionRoutes.cancel();
    super.dispose();
  }

  void initState() {
    super.initState();
    marker1 =
        CustomMarker("kajas",LatLng(11.19899, 76.260804), _scaffoldKey,streamControllers,streamControllersRoutes);
    marker2 =
        CustomMarker("Kajas",LatLng(11.199882, 76.260287), _scaffoldKey,streamControllers,streamControllersRoutes);
    marker3 =CustomMarker("Desktop Solution Echarge",LatLng(9.853643, 76.947692), _scaffoldKey,streamControllers,streamControllersRoutes);
    marker4 =CustomMarker("Parambans Echarge",LatLng(9.853567, 76.946688), _scaffoldKey,streamControllers,streamControllersRoutes);
    streamSubscription = streamControllers.stream.listen(
      (event) => (controller = event)
    );
    streamSubscriptionRoutes = streamControllersRoutes.stream.listen(
      (event) => (this.setState((){
        routePoints = event;
      }))
    );
    _markerSize = 40.0 * (18 / 13.0); // Default marker size

  }
  void _updateMarkerSize(double? zoom) {
    // Update the marker size based on zoom
    setState(() {
      if (zoom! < 17) {
        _markerSize = 0;
      } else {
        _markerSize = 40.0 * (zoom! / 13.0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        key: _scaffoldKey,
        body: Stack(
          children: [
            SizedBox(
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: initialMap,
                  onTap: (p, s) {
                    _closeModalBottomSheet();
                    setState(() {
                      routePoints=[];
                    });
                  },
                  onPositionChanged: (position, hasGesture) {
                    if (hasGesture) {
                      // print(position.zoom);
                      _updateMarkerSize(position.zoom);
                    }
                  },
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
                          strokeWidth: 5)
                    ],
                  ),
                  MarkerLayer(markers: <Marker>[
                    Marker(
                        point: mapPos,
                        height: 50,
                        rotate: true,
                        width: 50,
                        child: Container(
                            alignment: Alignment.center,
                            child: const CurrentLocIcon())),
                    // Marker(
                    //     point: LatLng(11.199882, 76.260287),
                    //     height: _markerSize,
                    //     width: _markerSize,
                    //     rotate: true,
                    //     child: Container(
                    //       alignment: Alignment.center,
                    //       child: IconButton(
                    //         icon: Image.asset(
                    //           "images/icon/ev_location.png",
                    //           width: _markerSize,
                    //           height: _markerSize,
                    //         ),
                    //         onPressed: () {
                    //           print("touched me");
                    //         },
                    //       ),
                    //     )),
                    marker1.markerBuilder(_markerSize),
                    marker2.markerBuilder(_markerSize),
                    marker3.markerBuilder(_markerSize),
                    marker4.markerBuilder(_markerSize),
                  ])
                ],
              ),
            ),
            Positioned(
                bottom: 20,
                right: 10,
                child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.transparent,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: Offset(
                              3, 4), // changes the position of the shadow
                        ),
                      ],
                    ),
                    child: Material(
                        shape: CircleBorder(),
                        color: Color.fromARGB(
                            255, 95, 190, 98), // Set the border radius),
                        child: InkWell(
                          customBorder: new CircleBorder(),
                          onTap: () async {
                            print('Circle Clicked!');
                            await locationRequest();
                            Position pos = await determinePosition();
                            mapPos = LatLng(pos.latitude, pos.longitude);
                            initialMap = mapPos;
                            // print(mapPos);
                            _mapController.move(mapPos, 18.0);
                            setState(() {});
                          },
                          child: Center(
                              child: const Icon(
                            Iconsax.gps,
                            color: Colors.white,
                            size: 26,
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
                                    var v1 = 11.198752;
                                    var v2 = 76.260167;
                                    var v3 = 11.200322;
                                    var v4 = 76.262337;

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
        ));
  }

  @override
  bool get wantKeepAlive => true;

  void _closeModalBottomSheet() {
    if (controller != null) {
      controller!.close();
      controller = null;
    }
  }
}

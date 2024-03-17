import 'dart:io';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ShopData extends StatefulWidget {
  @override
  _ShopData createState() => _ShopData();
}

class _ShopData extends State<ShopData> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  late PersistentBottomSheetController? controllerr;
  LatLng initialMap = LatLng(9.853852, 76.947620);
  MapController _mapController = MapController();
  final textController = TextEditingController();
  LatLng? points;
  File? _image;
  Color clr = Colors.black;
  get data => null;

  @override
  void initState() {
    super.initState();
    print(points);
  }

  @override
  void dispose() {
    super.dispose();
  }

  PersistentBottomSheetController createScaffold() {
    return _scaffoldKey.currentState!.showBottomSheet(
        backgroundColor: Colors.transparent, elevation: 0, (context) {
      return StatefulBuilder(builder: (BuildContext context,
          StateSetter setStates /*You can rename this!*/) {
        return Container(
          padding: EdgeInsets.all(8.0),
          color: Colors.transparent,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - 100,
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
              child: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: FlutterMap(
                      options: MapOptions(
                        initialCenter: points == null ? initialMap : points!,
                        onTap: (p, s) {
                          setStates(() {
                            points = LatLng(s.latitude, s.longitude);
                          });
                        },
                        onPositionChanged: (position, hasGesture) {
                          if (hasGesture) {}
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
                        points != null
                            ? MarkerLayer(markers: <Marker>[
                                Marker(
                                  width: 32,
                                  height: 32,
                                  rotate: true,
                                  point: points!,
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Image.asset(
                                      "assets/images/icon/ev_location.png",
                                    ),
                                  ),
                                )
                              ])
                            : MarkerLayer(markers: <Marker>[])
                      ],
                    ),
                  ),
                  Positioned(
                      top: 5,
                      right: 5,
                      child: Container(
                          height: 50,
                          width: 50,
                          child: Material(
                              shape: CircleBorder(),
                              color: Colors.transparent,
                              child: InkWell(
                                customBorder: new CircleBorder(),
                                onTap: () {
                                  if (controllerr != null) {
                                    controllerr!.close();
                                    controllerr = null;
                                  }
                                },
                                child: Center(
                                    child: Transform.rotate(
                                        angle: 25.9,
                                        child: const Icon(
                                          Iconsax.add,
                                          color: Colors.black,
                                          size: 32,
                                        ))),
                              )))),
                  Positioned(
                      width: MediaQuery.of(context).size.width - 100,
                      top: 5,
                      child: Align(
                        alignment: Alignment.center,
                        child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 0),
                            child: Container(
                                width: 330,
                                height: 50,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
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
                                        onSubmitted: (value) {
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
                      ))
                ],
              )),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(children: [
                  const SizedBox(
                    height: 60,
                  ),
                  const Row(children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Complete Your Profile",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    const Icon(
                      Iconsax.edit,
                    ),
                  ]),
                  const SizedBox(
                    height: 20,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Profile completion is mandatory to access all features. Your information is kept secure and confidential.",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Material(
                    shape: CircleBorder(),
                    color: Colors.white, // Set the border radius),
                    child: InkWell(
                      customBorder: new CircleBorder(),
                      onTap: () async {
                        final image = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          setState(() {
                            _image = File(image.path);
                          });
                        }
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100)),
                              child: Container(
                                width: 120.0,
                                height: 120.0,
                                child: Center(
                                  child: _image == null
                                      ? const Icon(
                                          Iconsax.edit,
                                          color: Colors.black,
                                        )
                                      : Image.file(_image!,
                                          width: 120, height: 120),
                                ),
                              )),
                          Container(
                            width: 120.0,
                            height: 120.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color:
                                    Colors.green, // Set the color of the border
                                width: 2.0, // Set the width of the border
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // )
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Shop Name",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Center(
                      child: Container(
                    width: 330,
                    height: 40,
                    // padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border:
                            Border(bottom: BorderSide(color: Colors.green))),
                    child: TextField(
                      textInputAction: TextInputAction.search,
                      controller: textController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        // hintText: 'Shop Name',
                      ),
                      style: TextStyle(color: Colors.black),
                      cursorColor: Colors.green,
                    ),
                  )),
                  SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: GestureDetector(
                      onTapDown: (e) => {
                        setState(() {
                          clr = Colors.green;
                        })
                      },
                      onTapUp: (e) => {
                        setState(() {
                          clr = Colors.black;
                        })
                      },
                      onTap: () => {controllerr = createScaffold()},
                      child: Wrap(
                        alignment: WrapAlignment.spaceEvenly,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Icon(Iconsax.location, color: clr),
                          SizedBox(
                            width: 5,
                          ),
                          Text("Select your Location",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, color: clr)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        minimumSize: Size(300, 50),
                        textStyle: TextStyle(fontSize: 14, color: Colors.black),
                        side: BorderSide(
                            color: Color.fromARGB(255, 99, 225, 103)),
                      ),
                      child: Text("Request",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.green)),
                      onPressed: () {
                        if (points != null &&
                            textController.text != "" &&
                            _image != null) {
                              print(textController.text);
                          print("In");
                        } else {
                          Fluttertoast.showToast(
              msg: "You should fill all fields to continue",
              backgroundColor: Colors.grey,
              fontSize: 12,
              gravity: ToastGravity.BOTTOM,
              textColor: Colors.white
            );
                        }
                      }),
                ]))));
  }
}

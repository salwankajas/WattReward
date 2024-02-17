import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:iconsax/iconsax.dart';

class Home extends StatefulWidget {
  @override
  _Navstate createState() => _Navstate();
}

class _Navstate extends State<Home> {
  final ev_location = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    ev_location.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SizedBox(
            child: FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(9.853852, 76.947620),
                initialZoom: 18,
                maxZoom: 20,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://api.maptiler.com/maps/dataviz/{z}/{x}/{y}.png?key=54GmtaBGPUmEcqpweB6n',
                  userAgentPackageName: 'com.example.app',
                ),
              ],
            ),
          ),
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
                                onSubmitted: (value){
                                  print(value);
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
                            // Text(
                            //   "Search station",
                            //   style: TextStyle(color: Colors.grey),
                            // )
                          ],
                        ))),
              )),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.green,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        iconSize: 20.0,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        // showUnselectedLabels: true,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Iconsax.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Iconsax.wallet), label: "Wallet"),
          BottomNavigationBarItem(
              icon: Icon(Iconsax.note), label: "Transaction"),
          BottomNavigationBarItem(
              icon: Icon(Iconsax.profile_2user), label: "Account")
        ],
      ),
    );
  }
}

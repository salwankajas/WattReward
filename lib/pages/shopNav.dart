import 'dart:convert';
import 'package:location/location.dart' as loc;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:iconsax/iconsax.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:ev/icons/current_loc.dart';
import 'package:flutter/services.dart';
import 'package:ev/nav/map.dart';
import 'package:ev/nav/acc.dart';
import 'package:ev/nav/reward.dart';

var pressed = 0;
int preTime = DateTime.now().millisecondsSinceEpoch;

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

class ShopNav extends StatefulWidget {
  @override
  _ShopNav createState() => _ShopNav();
}
class _ShopNav extends State<ShopNav> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  void _onItemTapped(int index) {
  setState(() {
    _selectedIndex = index;
  });
  _pageController.jumpToPage(index);
}

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
    PopScope(
      canPop: false,
      child:
    Scaffold(
      backgroundColor: Colors.white,
      body:
      PageView(
        controller: _pageController,
        children: <Widget>[
          Reward(),
          Text("sdfsdf"),
          Text("sdfsdf"),
          Acc(),
        ],
        onPageChanged: (pages) {
          setState(() {
            _selectedIndex = pages;
          });
        },
      )
      // _pages.elementAt(_selectedIndex)
      // Maps()
      ,
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: const Color.fromARGB(255, 118, 118, 118),
        selectedItemColor: Colors.green,
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        iconSize: 20.0,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        // showUnselectedLabels: true,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Iconsax.money_send), label: "Reward"),
          BottomNavigationBarItem(icon: Icon(Iconsax.transaction_minus), label: "Offers"),
          BottomNavigationBarItem(
              icon: Icon(Iconsax.note), label: "Transaction"),
          BottomNavigationBarItem(
              icon: Icon(Iconsax.profile_2user), label: "Account",
              )
        ],
      ),
    ),
     onPopInvoked: (bool didPop) async {
    print("back");
    pressed++;
    int diff = DateTime.now().millisecondsSinceEpoch - preTime;
    preTime = DateTime.now().millisecondsSinceEpoch;
    print(diff);
    if(diff <= 2000){
      if(pressed >= 2 ){
        pressed =0;
        SystemNavigator.pop();
      }
    }else{
      pressed = 0;
    }
  },
    );
  }
}

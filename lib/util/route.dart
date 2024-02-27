import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<(List<LatLng>,double)> getRoute(LatLng from, LatLng to) async {
  late List<LatLng>? routePoints;
  var v1 = from.latitude;
  var v2 = from.longitude;
  var v3 = to.latitude;
  var v4 = to.longitude;

  var url = Uri.parse(
      "http://router.project-osrm.org/route/v1/driving/$v2,$v1;$v4,$v3?steps=true&annotations=true&geometries=geojson&overview=full");
  print(url);
  // var url = Uri.parse("https://routing.openstreetmap.de/routed-car/route/v1/driving/$v2,$v1;$v4,$v3?overview=false&geometries=geojson&steps=true&hints=NwaPgcdQFIMrAAAAAAAAAAABAACTAAAAXcigQgAAAACExfJDPBOKQysAAAAAAAAAAAEAAJMAAAAmOwAAvGaWBNaZlgC8ZpYE1pmWABYAnwBH1g1v%3BueiRiMHokYgFAAAAAQAAAAUAAAAEAAAA0JInQaBAmD8WiA1BIKflQAUAAAABAAAABQAAAAQAAAAmOwAAoF2WBAJolgDZXZYEtWeWAAEAXwNH1g1v");
  var response = await http.get(url);
  // print(response.body);
  routePoints = [];
  double distance = double.parse(jsonDecode(response.body)['routes'][0]['distance'].toString());
  // double distance = 0.0;
  print(jsonDecode(response.body)['routes'][0]['distance']);
  // print(double.parse(jsonDecode(response.body)['routes'][0]['distance']));
  var ruter = jsonDecode(response.body)['routes'][0]['geometry']['coordinates'];
  // print(ruter);
  for (int i = 0; i < ruter.length; i++) {
    var rep = ruter[i].toString();
    rep = rep.replaceAll("[", "");
    rep = rep.replaceAll("]", "");
    var lat1 = rep.split(", ");
    routePoints.add(LatLng(double.parse(lat1[1]), double.parse(lat1[0])));
  }
  return(routePoints,distance);
}

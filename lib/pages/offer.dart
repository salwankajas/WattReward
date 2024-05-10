import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'add_offer.dart'; // Import the add_offer.dart file
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ev/util/database.dart';
import 'package:ev/util/enum.dart';

final storage = new FlutterSecureStorage();

class OfferPage extends StatefulWidget {
  @override
  _OfferPageState createState() => _OfferPageState();
}

class _OfferPageState extends State<OfferPage>
    with AutomaticKeepAliveClientMixin<OfferPage> {
  List<Offer> offers = []; // List to store offers
  @override
  bool get wantKeepAlive => true;
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    super.dispose();
  }

  @override
  void initState() {
    storage.read(key: "id").then((value) async{
      DocumentSnapshot<Object?> data = await readDB(Entity.shop, value!);
      int length = data['offers'].length;
      List<MapEntry<String, dynamic>> offersList = data['offers'].entries.toList();
      offersList.sort((a, b) => b.key.compareTo(a.key));
      print(offersList.map((entry) => entry.value).toList());
      int count=0;
      // print(offersList[0].);
      offersList.forEach((data){
      count++;
      Offer updatedOffer = Offer(
                          image: data.value["url"], // Provide the image path
                          title: data.value["heading"],
                          description: data.value["description"],
                          timestamp:int.parse(data.key)

                        );
                        offers.add(updatedOffer);
    });
    if(count == length){
      setState(() {        
                        });
    }
    });
    super.initState();

    // print(name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.only(right: 20.0,left: 20.0,top: 25.0),
        child: ListView.builder(
          itemCount: offers.length,
          itemBuilder: (context, index) {
            return OfferItem(
              image: offers[index].image,
              title: offers[index].title,
              description: offers[index].description,
              shadowSpreadRadius: 1,
              shadowBlurRadius: 15,
              shadowOffset: Offset(2, 2),
              onDelete: () async{
                String? id = await storage.read(key: "id");
                setState(() {
                  removeoffer(id!, offers[index].timestamp);
                  offers.removeAt(index);
                });
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print(offers.length);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddOfferPage()),
          ).then((newOffer) {
            if (newOffer != null) {
              setState(() {
                offers.insert(0,newOffer);
              });
            }
          });
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Color.fromARGB(255, 99, 209, 103),
      ),
    );
  }
}

class OfferItem extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final double shadowSpreadRadius;
  final double shadowBlurRadius;
  final Offset shadowOffset;
  final Function onDelete; // Function to handle delete action

  OfferItem({
    required this.image,
    required this.title,
    required this.description,
    required this.shadowSpreadRadius,
    required this.shadowBlurRadius,
    required this.shadowOffset,
    required this.onDelete, // Receive the onDelete function
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.withOpacity(0.4),
        //     spreadRadius: shadowSpreadRadius,
        //     blurRadius: shadowBlurRadius,
        //     offset: shadowOffset,
        //   ),
        // ],
      ),
      child: Stack(
        children: [
          Card(
            shadowColor: Colors.black,
            elevation: 3.0,
            surfaceTintColor:Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
              side: BorderSide(color: Color(0xff01b763), width: 2.0),
            ),
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // Image.asset(
                  //   image,
                  //   width: double.infinity,
                  //   height: 200.0,
                  //   fit: BoxFit.cover,
                  // ),
                  CachedNetworkImage(
                    imageUrl:
                        image, // Replace with your image URL
                            progressIndicatorBuilder: (context, url, downloadProgress) => 
               CircularProgressIndicator(value: downloadProgress.progress),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                  // Image.network(
                  //   image, // Replace this URL with your image URL
                  //   loadingBuilder: (context, child, loadingProgress) {
                  //     if (loadingProgress == null) {
                  //       return child;
                  //     }
                  //     return CircularProgressIndicator(
                  //       value: loadingProgress.expectedTotalBytes != null
                  //           ? loadingProgress.cumulativeBytesLoaded /
                  //               loadingProgress.expectedTotalBytes!
                  //           : null,
                  //     );
                  //   },
                  //   errorBuilder: (context, error, stackTrace) {
                  //     return Text('Error loading image');
                  //   },
                  // ),
                  SizedBox(height: 10.0),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    description,
                    style: TextStyle(fontSize: 16.0),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 5,
            child: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                onDelete(); // Call the onDelete function when the delete icon is pressed
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Offer {
  String image;
  String title;
  String description;
  int timestamp;

  Offer({
    required this.image,
    required this.title,
    required this.description,
    required this.timestamp,
  });
}

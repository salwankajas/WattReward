import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'offer.dart'; // Import the offer.dart file
import 'package:path/path.dart';
import 'package:ev/util/imgurApi.dart';
import 'package:ev/util/database.dart';

final storage = new FlutterSecureStorage();

class AddOfferPage extends StatefulWidget {
  @override
  _AddOfferPageState createState() => _AddOfferPageState();
}

class _AddOfferPageState extends State<AddOfferPage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  File? _image;
  String? imageUrl;

  Future _uploadImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Add Offer',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
          backgroundColor: Color(0xffffffff),
          surfaceTintColor: Colors.white,
        ),
        body: ListView(children: [
          Container(
            padding: EdgeInsets.all(20.0),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Color(0xff01b763)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                    color: Color(0xFFeffaf3),
                  ),
                  child: TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: 'Enter Title',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Text(
                  'Add Picture',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 15.0),
                ElevatedButton.icon(
                  onPressed: () async {
                    imageUrl = null;
                    await _uploadImage();
                    try {
                      imageUrl =
                          await uploadImageToImgur(_image!, "d68107ed6c1cf3a");
                      print('Image uploaded successfully. URL: $imageUrl');
                    } catch (e) {
                      print('Error uploading image: $e');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFeffaf3),
                    textStyle: TextStyle(color: Colors.black),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: Color(0xff01b763)),
                    ),
                  ),
                  icon: Icon(
                    Icons.cloud_upload,
                    color: Color(0xff01b763),
                  ),
                  label: Text(
                    'Upload Picture',
                    style: TextStyle(
                        color: Color(0xff01b763), fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(height: 20.0),
                Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Color(0xff01b763)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                    color: Color(0xFFeffaf3),
                  ),
                  child: TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      hintText: 'Enter Description',
                      border: InputBorder.none,
                    ),
                    maxLines: 5,
                  ),
                ),
                SizedBox(height: 25.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        // Create a new Offer object with updated details
                        if(imageUrl != null){
                          int timestamp = DateTime.now().millisecondsSinceEpoch;
                        Offer updatedOffer = Offer(
                          image: imageUrl!, // Provide the image path
                          title: _titleController.text,
                          description: _descriptionController.text,
                          timestamp:timestamp

                        );
                        String? id = await storage.read(key: "id");
                        await addoffer(id!, _titleController.text, imageUrl!, _descriptionController.text,timestamp);
                        // Pass the updated offer back to the previous screen
                        Navigator.pop(context, updatedOffer);
                        }else{
                          Fluttertoast.showToast(
                        msg: "The upload isn't complete...",
                        backgroundColor: Colors.grey,
                        fontSize: 14,
                        gravity: ToastGravity.BOTTOM,
                        textColor: Colors.white);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff01b763),
                        textStyle: TextStyle(color: Colors.white),
                      ),
                      child: Text(
                        'Confirm',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(width: 25.0),
                    ElevatedButton(
                      onPressed: () {
                        _titleController.clear();
                        _descriptionController.clear();
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        surfaceTintColor: Colors.white,
                        textStyle: TextStyle(color: Colors.black),
                        side: BorderSide(color: Color(0xFF01b763)),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Color(0xff01b763)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ]));
  }
}

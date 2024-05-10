import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev/util/enum.dart';

Future<void> addUser(String id, Entity entity, String name, String email) {
  CollectionReference users =
      FirebaseFirestore.instance.collection(entity.value);
  return users
      .doc(id)
      .set({
        'name': name,
        'email': email,
        'verified': false,
        'edited': false,
        'wallet': false,
      })
      .then((value) => print("User added successfully!"))
      .catchError((error) => print("Failed to add user: $error"));
}
Future<void> addoffer(String id, String heading,String url,String description,int timestamp){
  CollectionReference users = FirebaseFirestore.instance.collection(Entity.shop.value);
  return users
      .doc(id)
      .set({
        'offers': {'${timestamp}':{
          'heading':heading,
          'url': url,
          'description': description,
          // Add more fields as needed
        }
      }},SetOptions(merge: true))
      .then((value) => print("User added successfully!"))
      .catchError((error) => print("Failed to add user: $error"));
}
Future<void> removeoffer(String id,int timestamp){
  CollectionReference users = FirebaseFirestore.instance.collection(Entity.shop.value);
  return users
      .doc(id)
      .update({
        'offers.$timestamp': FieldValue.delete(),
      })
      .then((_) => print('Offer removed successfully'))
      .catchError((error) => print('Failed to remove offer: $error'));
}

Future<void> addWallet(
    String id, Entity entity, String privateKey, String publicKey) {
  CollectionReference users =
      FirebaseFirestore.instance.collection(entity.value);
  return users
      .doc(id)
      .set({
        'privateKey': privateKey,
        'publicKey': publicKey,
        'wallet': true,
      }, SetOptions(merge: true))
      .then((value) => print("User added successfully!"))
      .catchError((error) => print("Failed to add user: $error"));
}
Future<void> addShopData(
    String id, String name, int slot,GeoPoint geo) {
  CollectionReference users =
      FirebaseFirestore.instance.collection("shop");
  return users
      .doc(id)
      .set({
        'name': name,
        'slot': slot,
        'location': geo,
        'edited': true,
      }, SetOptions(merge: true))
      .then((value) => print("User added successfully!"))
      .catchError((error) => print("Failed to add user: $error"));
}

Future<DocumentSnapshot<Object?>> readDB(Entity entity,String id) {
  CollectionReference users = FirebaseFirestore.instance.collection(entity.value);
  return users.doc(id).get();
}

Future<QuerySnapshot<Object?>> readDBStore() {
  CollectionReference users = FirebaseFirestore.instance.collection("shop");
  return users.get();
}
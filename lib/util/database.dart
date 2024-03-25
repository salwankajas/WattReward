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
        'varified': false,
        'edited': false,
        'wallet': false,
      })
      .then((value) => print("User added successfully!"))
      .catchError((error) => print("Failed to add user: $error"));
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

Future<DocumentSnapshot<Object?>> readDB(Entity entity,String id) {
  CollectionReference users = FirebaseFirestore.instance.collection(entity.value);
  return users.doc(id).get();
}

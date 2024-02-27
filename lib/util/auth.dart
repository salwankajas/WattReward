import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
final storage = new FlutterSecureStorage();
Future<dynamic> signInWithGoogle() async {
    try {
      await FirebaseAuth.instance.signOut();
      final GoogleSignInAccount? googleUser = await GoogleSignIn(scopes: <String>["email"]).signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on Exception catch (e) {
      // TODO
      print('exception->$e');
    }
}

Future<bool> signOutFromGoogle() async {
    try {
      await FirebaseAuth.instance.signOut();
      googleSignIn.disconnect();
      await storage.deleteAll();
      return true;
    } on Exception catch (_) {
      return false;
    }
}



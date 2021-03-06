import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final firestore = FirebaseFirestore.instance;

  Stream<User?> get user {
    return FirebaseAuth.instance.authStateChanges();
  }

  User? checkAuth() {
    var authUser;
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
        authUser = user;
      } else {
        print('User is signed in!');
      }
    });
    return authUser;
  }

  //update roles firestore
  void userPrivileges(User user) async {
    final videoPaths = firestore.collection("jaw_movements").doc(user.uid);
    if (!(await videoPaths.get()).exists) {
      videoPaths.set({'video_paths': {}});
      print('Doc set');
    }
  }

  //sign in with phone credential
  Future signInWithCredential(PhoneAuthCredential credential) async {
    User user;
    try {
      var result = await FirebaseAuth.instance.signInWithCredential(credential);
      user = result.user!;

      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign in with email
  Future signInWithEmailAndPassword(String email, String password) async {
    User user;
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user!;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //register with email and pass
  Future registerWithEmailAndPassword(String email, String password) async {
    User user;
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      user = userCredential.user!;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign in with google
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  //sign out
  Future signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      print("Signed Out");
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}

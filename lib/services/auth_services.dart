import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fin/models/profile_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fin/models/user_model.dart';

class AuthServices {
  final auth = FirebaseAuth.instance;

  Future<String> login(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      await Future.delayed(const Duration(milliseconds: 1000));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return "User not found. Sign-Up";
      } else if (e.code == 'wrong-password') {
        return "Email and Password does not match";
      }
    }
    return "Successful";
  }

  bool isEmailVerified() {
    User? user = auth.currentUser;
    if (user!.emailVerified) {
      return true;
    }
    return false;
  }

  Future<bool> isProfileAvailable() async {
    User? user = auth.currentUser;
    final profileDoc = await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .collection("profile")
        .doc("Basic Profile")
        .get();

    if (profileDoc.exists) {
      return true;
    }
    return false;
  }

  Future<String> signup(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'operation-not-allowed' || e.code == 'invalid-email') {
        return "Signing in with Email and Password is not enabled.";
      } else if (e.code == 'too-many-requests') {
        return "Too Many Request Sent. Try after Sometime";
      }
    }

    return "Account created successfully";
  }

  Future<void> addUserToDataBase(String email, String password,
      String firstName, String secondName) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    UserModel userModel = UserModel.getModel();

    User? user = auth.currentUser;
    if (user != null) {
      userModel.email = email;
      userModel.uid = user.uid;
      userModel.firstName = firstName;
      userModel.secondName = secondName;

      await firebaseFirestore
          .collection("users")
          .doc(user.uid)
          .set(userModel.toMap());
    }
  }

  Future<String> passwordReset(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return "User not found. Sign-Up";
      } else if (e.code == 'wrong-password') {
        return "Email and Password does not match";
      }
    }
    return "Successfull";
  }

  Future<void> addProfileToDataBase(
      String name, String age, String gender, String country) async {
    ProfileModel profileModel = ProfileModel.getModel();
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = auth.currentUser;

    if (user != null) {
      profileModel.name = name;
      profileModel.age = num.parse(age);
      profileModel.gender = gender;
      profileModel.country = country;

      await firebaseFirestore
          .collection("users")
          .doc(user.uid)
          .collection("profile")
          .doc("Basic Profile")
          .set(profileModel.toMap());
    }
  }
}

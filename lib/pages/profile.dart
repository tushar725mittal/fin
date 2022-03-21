import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:fin/models/profile_model.dart';
import 'package:fin/utils/routes.dart';
import 'package:fin/widgets/formButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({ Key? key }) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  String gender = "male";
  String country = "Select Country";
  final _auth = FirebaseAuth.instance;
  bool changeButton = false;
  ProfileModel profileModel = ProfileModel.getModel();
  var _gender = Gender.male;
  final _formkey = GlobalKey<FormState>();

  createProfile(GlobalKey<FormState> _formkey) async {
    if (_formkey.currentState!.validate()) {
      setState(() {
        if(country == "Select Country"){country = "India";}
        changeButton = true;
      });

      try {
        FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
        User? user = _auth.currentUser;
        
        if(user != null){
          profileModel.name = nameController.text;
          profileModel.age = num.parse(ageController.text);
          profileModel.gender = gender;
          profileModel.country = country;

          await firebaseFirestore
              .collection("users")
              .doc(user.uid)
              .collection("profile")
              .doc("Basic Profile")
              .set(profileModel.toMap());
        }
        
        await Future.delayed(const Duration(milliseconds: 500));

        await context.vxNav.push(Uri.parse(MyRoutes.homeRoute));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'invalid-email') {
          print("Your email address appears to be malformed.");
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: "Signing in with Email and Password is not enabled."
                  .text
                  .make()));
        } else if (e.code == 'operation-not-allowed') {
          print("Signing in with Email and Password is not enabled.");
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: "Signing in with Email and Password is not enabled."
                  .text
                  .make()));
        } else if (e.code == 'too-many-requests') {
          print("Signing in with Email and Password is not enabled.");
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: "Signing in with Email and Password is not enabled."
                  .text
                  .make()));
        }
      }
      setState(() {
        changeButton = false;
      });
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var gender_widget_size = MediaQuery.of(context).size.width - 64;
    return Scaffold(
      body: SingleChildScrollView(
          child: Form(
        key: _formkey,
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Image.asset(
                "assets/images/login_image.png",
                fit: BoxFit.fill,
              ),
            ),
            Container(
              color: Colors.white,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 32.0),
                child: Column(
                  children: [
                    TextFormField(
                        decoration: const InputDecoration(
                          hintText: "Enter your Name",
                          prefixIcon: Icon(Icons.account_circle),
                          labelText: "Full Name",
                        ),
                        controller: nameController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "First Name cannot be blank";
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          hintText: "Enter your Age(18-24)",
                          prefixIcon: Icon(Icons.man_outlined),
                          labelText: "Age",
                        ),
                        controller: ageController,
                        validator: (value) {
                          if (!value!.isNumber() || (num.parse(value) < 18 || num.parse(value) > 24)) {
                            return "Age should be between 18-24";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: gender_widget_size/12,
                            child: const Icon(Icons.male)),
                          SizedBox(
                            width: gender_widget_size/6,
                            child: const Text("Gender:")),
                          SizedBox(
                            width: gender_widget_size/4,
                            child: RadioListTile<Gender>(value: Gender.male, groupValue: _gender, onChanged: (Gender? value) {
                              setState(() {
                                _gender = value!;
                                gender = _gender.name;
                              });
                            }, title: const Text("M"),),
                          ),
                          SizedBox(
                            width: gender_widget_size/4,
                            child: RadioListTile<Gender>(value: Gender.female, groupValue: _gender, onChanged: (Gender? value) {
                              setState(() {
                                _gender = value!;
                                gender = _gender.name;
                              });
                            }, title: const Text("F")),
                          ),
                          SizedBox(
                            width: gender_widget_size/4,
                            child: RadioListTile<Gender>(value: Gender.others, groupValue: _gender, onChanged: (Gender? value) {
                              setState(() {
                                _gender = value!;
                                gender = _gender.name;
                              });
                            }, title: const Text("O")),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        child: Card(
                          color: Colors.amber[50],
                          child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(country, style: const TextStyle(fontSize: 20),),
                        )),
                        onTap: () => showCountryPicker(context: context, onSelect: (Country c) {setState(() {
                          country = c.name;
                        });}, 
                      showPhoneCode: false, showWorldWide: false, ),
                      ),                                         
                    const SizedBox(
                      height: 40.0,
                    ),
                    FormButton(changeButton: changeButton, onTapFunction: createProfile, formkey: _formkey, buttonName: "Create Profile",),
                  ],
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}

enum Gender{male, female, others}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:fin/widgets/formButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:fin/utils/routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var email = "";
  var password = "";
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool changeButton = false;

  final _formkey = GlobalKey<FormState>();

  signIn(GlobalKey<FormState> _formkey) async {
    if (_formkey.currentState!.validate()) {
      setState(() {
        email = emailController.text;
        password = passwordController.text;
        changeButton = true;
      });

      try {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        await Future.delayed(const Duration(milliseconds: 1000));
        final auth = FirebaseAuth.instance;
        User? user = auth.currentUser;
        if (user!.emailVerified) {
          // await context.vxNav.push(Uri.parse(MyRoutes.homeRoute), params: {"email": emailController.text});
          final profileDoc = await FirebaseFirestore.instance
              .collection("users")
              .doc(user.uid)
              .collection("profile")
              .doc("Basic Profile")
              .get();

          await context.vxNav.push(Uri.parse(
            profileDoc.exists ? MyRoutes.homeRoute : MyRoutes.profileRoute,
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: "Email not verified. Please verify email".text.make()));
        }
      } on FirebaseAuthException catch (e) {
        changeButton = false;
        if (e.code == 'user-not-found') {
          print("This email is not registered");

          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: "User not found. Sign-Up".text.make()));
          await context.vxNav.push(Uri.parse(MyRoutes.signupRoute),
              params: {"email": emailController.text});
        } else if (e.code == 'wrong-password') {
          print("Email and Password does not match");
          await context.vxNav.push(Uri.parse(MyRoutes.verifyRoute));
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: "Email and Password does not match".text.make()));
        }
      }
      FocusScopeNode currentFocus = FocusScope.of(context);

      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
      setState(() {
        changeButton = false;
      });
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                        hintText: "Enter your Email",
                        prefixIcon: Icon(CupertinoIcons.mail),
                        labelText: "Email",
                      ),
                      controller: emailController,
                      validator: (value) {
                        if (value!.isEmpty || !EmailValidator.validate(value)) {
                          return "Enter valid Email-ID";
                        }
                        if (value.isEmpty) {
                          return "Email-ID cannot be empty";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: "Enter password",
                        prefixIcon: Icon(Icons.password),
                        labelText: "Password",
                      ),
                      controller: passwordController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Password cannot be empty";
                        } else if (value.length < 6) {
                          return "Length of password should be atleast 6";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 40.0,
                    ),
                    FormButton(
                      changeButton: changeButton,
                      onTapFunction: signIn,
                      formkey: _formkey,
                      buttonName: "Login",
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () => context.vxNav
                              .push(Uri.parse(MyRoutes.resetRoute)),
                          child: const Text('Forgot Password!'),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an Account? "),
                        TextButton(
                          onPressed: () => context.vxNav.push(
                              Uri.parse(MyRoutes.signupRoute),
                              params: {"email": email}),
                          child: const Text('Signup'),
                        ),
                      ],
                    ),
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

import 'package:email_validator/email_validator.dart';
import 'package:fin/models/user_model.dart';
import 'package:fin/services/auth_services.dart';
import 'package:fin/utils/routes.dart';
import 'package:fin/widgets/formButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class SignUp extends StatefulWidget {
  final email;

  const SignUp({@required this.email, Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  var email = "";
  var password = "";
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final firstNameController = TextEditingController();
  final secondNameController = TextEditingController();
  bool changeButton = false;
  UserModel userModel = UserModel.getModel();
  final _formkey = GlobalKey<FormState>();

  signUp(GlobalKey<FormState> _formkey) async {
    if (_formkey.currentState!.validate()) {
      setState(() {
        email = emailController.text;
        password = passwordController.text;
        changeButton = true;
      });

      String result = await AuthServices().signup(email, password);
      if (result == "Account created successfully") {
        await AuthServices().addUserToDataBase(email, password,
            firstNameController.text, secondNameController.text);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: "Account created successfully".text.make()));
        await Future.delayed(const Duration(milliseconds: 500));

        await context.vxNav.push(Uri.parse(MyRoutes.verifyRoute));
      } else if (result ==
          "Signing in with Email and Password is not enabled.") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: "Signing in with Email and Password is not enabled."
                .text
                .make()));
      } else if (result == "Too Many Request Sent. Try after Sometime") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: "Too Many Request Sent. Try after Sometime".text.make()));
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
    firstNameController.dispose();
    confirmPasswordController.dispose();
    secondNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    emailController.text = widget.email;
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
                        hintText: "Enter your First Name",
                        prefixIcon: Icon(Icons.account_circle),
                        labelText: "First Name",
                      ),
                      controller: firstNameController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "First Name cannot be blank";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: "Enter your Last Name",
                        prefixIcon: Icon(Icons.account_circle),
                        labelText: "Last Name",
                      ),
                      controller: secondNameController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Last Name cannot be blank";
                        }
                        return null;
                      },
                    ),
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
                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: "Enter password",
                        prefixIcon: Icon(Icons.password),
                        labelText: "Confirm Password",
                      ),
                      controller: confirmPasswordController,
                      validator: (value) {
                        if (passwordController.text != value) {
                          return "Password does not match";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 40.0,
                    ),
                    FormButton(
                      changeButton: changeButton,
                      onTapFunction: signUp,
                      formkey: _formkey,
                      buttonName: "Sign Up",
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

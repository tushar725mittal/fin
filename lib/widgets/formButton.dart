import 'package:flutter/material.dart';

class FormButton extends StatelessWidget {
  const FormButton({
    Key? key,
    required this.changeButton,
    required this.onTapFunction,
    required this.formkey,
    required this.buttonName,
  }) : super(key: key);

  final bool changeButton;
  final Function onTapFunction ;
  final GlobalKey<FormState> formkey;
  final String buttonName;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xff403b58),
      borderRadius: changeButton
          ? BorderRadius.circular(50)
          : BorderRadius.circular(10),
      child: InkWell(
        onTap: () => onTapFunction(formkey),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 1000),
          width: changeButton ? 60 : 170,
          height: 60,
          alignment: Alignment.center,
          child: changeButton
              ? const Icon(
                  Icons.done,
                  color: Colors.white,
                )
              : Text(
                  buttonName,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
        ),
      ),
    );
  }
}

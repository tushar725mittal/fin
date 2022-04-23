import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fin/pages/questionnaire/radio_group.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Questionnaire extends StatelessWidget {
  const Questionnaire({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Questionnaire"),
      ),
      body: const QuestionnaireForm(),
    );
  }
}

class QuestionnaireForm extends StatefulWidget {
  const QuestionnaireForm({Key? key}) : super(key: key);

  @override
  State<QuestionnaireForm> createState() => _QuestionnaireFormState();
}

class _QuestionnaireFormState extends State<QuestionnaireForm> {
  final _key = GlobalKey<FormState>();
  final questions = {
    'How is life?': [
      'Yes',
      'Maybe',
      'No',
    ],
    'Are you sad?': [
      'Yes',
      'Maybe',
      'No',
    ],
    'Are you very sad?': [
      'Yes',
      'Maybe',
      'No',
    ],
  };

  Map<int, String?> selectedOptions = {};

  void _submit() async {
    var _ref = FirebaseFirestore.instance;
    var user = FirebaseAuth.instance.currentUser;

    Map<String, String?> response = {};

    for (int i = 0; i < questions.length; i++) {
      String question = questions.keys.elementAt(i);
      response[question] = selectedOptions[i];
    }

    if (user != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Submitting..."),
        ),
      );
      await _ref
          .collection('users')
          .doc(user.uid)
          .collection('questionnaireResponses')
          .add(response);

      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Submitted. Thank you!"),
          action: SnackBarAction(
              label: "Dismiss",
              onPressed: () =>
                  ScaffoldMessenger.of(context).hideCurrentSnackBar()),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("You must login before submitting the form!"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _key,
      child: Scrollbar(
        child: ListView.separated(
          itemCount: questions.length + 1,
          separatorBuilder: (context, separatorIndex) => const Divider(
            indent: 20,
            endIndent: 20,
          ),
          itemBuilder: (context, questionIndex) =>
              questionIndex != questions.length
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ListTile(
                          title: Text("Q${questionIndex + 1}. " +
                              questions.keys.elementAt(questionIndex)),
                        ),
                        RadioGroup(
                          options: questions.values.elementAt(questionIndex),
                          currentlySelected: selectedOptions[questionIndex],
                          onChanged: (value) {
                            setState(() {
                              selectedOptions[questionIndex] = value;
                            });
                          },
                        ),
                      ],
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: ElevatedButton(
                            onPressed: _submit,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text("Submit"),
                                SizedBox(width: 7),
                                Icon(
                                  Icons.arrow_forward,
                                  size: 20,
                                )
                              ],
                            )),
                      ),
                    ),
        ),
      ),
    );
  }
}

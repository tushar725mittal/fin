import 'package:fin/pages/questionnaire/options.dart';
import 'package:fin/pages/questionnaire/radio_group.dart';
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

  Map<int, Options?> selectedOptions = {};

  void submit() {
    print(selectedOptions);
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
                            onPressed: submit,
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

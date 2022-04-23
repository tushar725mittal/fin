import 'package:flutter/material.dart';

class RadioGroup extends StatelessWidget {
  final List<String> options;
  final String? currentlySelected;
  final Function(String?) onChanged;

  const RadioGroup({
    Key? key,
    required this.options,
    required this.currentlySelected,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: options
          .map(
            (option) => RadioListTile(
              title: Text(option),
              value: option,
              groupValue: currentlySelected,
              onChanged: (String? value) {
                onChanged(value!);
              },
            ),
          )
          .toList(),
    );
  }
}

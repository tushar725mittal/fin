import 'package:flutter/material.dart';
import 'options.dart';

class RadioGroup extends StatelessWidget {
  final Options? currentlySelected;
  final Function(Options?) onChanged;

  const RadioGroup(
      {Key? key, required this.currentlySelected, required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: Options.values
          .map(
            (option) => RadioListTile<Options>(
              title: Text(option.name),
              value: option,
              groupValue: currentlySelected,
              onChanged: (Options? value) {
                onChanged(value);
              },
            ),
          )
          .toList(),
    );
  }
}

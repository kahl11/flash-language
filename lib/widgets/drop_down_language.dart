import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flash_language/helpers/const.dart';
import 'package:flutter/material.dart';

class DropDownLanguage extends StatefulWidget {
  final ValueChanged<String>? onSelect;
  final String? value;
  const DropDownLanguage({Key? key, this.onSelect, required this.value})
      : super(key: key);

  @override
  _DropDownLanguageState createState() => _DropDownLanguageState();
}

class _DropDownLanguageState extends State<DropDownLanguage> {
  List<String> values = LANGUAGES.keys.toList();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: DropdownButton2(
      isExpanded: true,
      value: widget.value,
      underline: Container(),
      iconStyleData: const IconStyleData(iconSize: 0),
      style: TextStyle(fontSize: 16, color: Theme.of(context).primaryColor),
      onChanged: (String? value) {
        if (widget.onSelect != null) {
          widget.onSelect!(value!);
        }
      },
      items: values.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Center(
              child: Text(
            value,
            textAlign: TextAlign.center,
          )),
        );
      }).toList(),
    ));
  }
}

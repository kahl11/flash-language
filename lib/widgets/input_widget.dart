import 'package:flutter/material.dart';

class InputWidget extends StatefulWidget {
  final ValueChanged<String>? onSubmit;
  const InputWidget({Key? key, this.onSubmit}) : super(key: key);

  @override
  _InputWidgetState createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            const BoxShadow(
              color: Color.fromARGB(70, 0, 0, 0),
            ),
            BoxShadow(
              color: (Colors.grey[850])!,
              spreadRadius: -1.0,
              blurRadius: 10.0,
            ),
          ],
        ),
        child: TextField(
          onSubmitted: (s) {
            widget.onSubmit!(s);
          },
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            labelText: 'Translate',
            labelStyle: TextStyle(color: Theme.of(context).primaryColor),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            filled: true,
            fillColor: const Color.fromARGB(55, 29, 29, 29),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(50)),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
                borderRadius: BorderRadius.circular(50)),
          ),
        ));
  }
}

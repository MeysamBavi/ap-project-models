import 'package:flutter/material.dart';
import '../classes/server.dart';
import 'constants.dart';

Widget buildLoginPhoneNumberField(Server server, void Function(String?) onSaved, [String? initialValue]) {
  return TextFormField(
    decoration: InputDecoration(
      hintText: Strings.get('phone-number-hint'),
      icon: Icon(Icons.phone),
    ),
    keyboardType: TextInputType.number,
    initialValue: initialValue,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return Strings.get('phone-number-empty');
      }
      if (!Server.isPhoneNumberValid(value)) {
        return Strings.get('phone-number-invalid');
      }
    },
    onSaved: onSaved,
  );
}

class PasswordField extends StatefulWidget {

  final Server server;
  final void Function(String?) onSaved;
  final String? initialValue;

  PasswordField(this.server, this.onSaved, [this.initialValue]) : super();

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {

  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Flexible(
          child: TextFormField(
            decoration: InputDecoration(
              hintText: Strings.get('password-hint'),
              icon: Icon(Icons.lock),
              helperText: Strings.get('password-helper'),
            ),
            initialValue: widget.initialValue,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return Strings.get('password-empty');
              }
              if (!Server.isPasswordValid(value)) {
                return Strings.get('password-invalid');
              }
            },
            onSaved: widget.onSaved,
            obscureText: _obscure,
          ),
          flex: 7,
        ),
        Flexible(
          child: IconButton(icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off), onPressed: () {
            setState(() {
              _obscure = !_obscure;
            });
          },),
          flex: 1,
        ),
      ],
    );
  }
}
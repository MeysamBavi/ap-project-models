import 'package:flutter/material.dart';
import 'login_ui.dart';
import 'head.dart';
import '../classes/server.dart';
import 'constants.dart';
import 'button_model.dart';

class LoginPanel extends StatefulWidget {

  final bool isForUser;
  final Widget Function(BuildContext) nextPageBuilder;
  final Widget Function(BuildContext) previousPageBuilder;
  LoginPanel({required this.isForUser, required this.nextPageBuilder, required this.previousPageBuilder})  : super();

  @override
  _LoginPanelState createState() => _LoginPanelState();
}

class _LoginPanelState extends State<LoginPanel> {

  final _formKey = GlobalKey<FormState>();
  String? _phoneNumber;
  String? _password;
  bool _notFoundError = false;
  late Server server;
  
  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;
    server = Head.of(context).server;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/login_background.jpg', package: 'models'), fit: BoxFit.cover),
        ),
        alignment: Alignment.center,
        child: Container(
          width: size.width * 0.9,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Theme.of(context).cardColor,
          ),
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(Strings.get('login-header')!, style: Theme.of(context).textTheme.headline1,),
                const SizedBox(height: 10,),
                if (_notFoundError)
                  buildNotFoundError(),
                buildLoginPhoneNumberField(server, (value) => _phoneNumber = value),
                PasswordField(server, (value) => _password = value),
                const SizedBox(height: 10,),
                buildModelButton(Strings.get('login-button')!, Theme.of(context).primaryColor, loginPressed),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(Strings.get('sign-up-prompt')!),
                    TextButton(child: Text(Strings.get('sign-up-button')!), onPressed: signUpPressed,)
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildNotFoundError() {
    return Container(
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Theme.of(context).errorColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Theme.of(context).errorColor),
      ),
      child: Text(Strings.get('no-accounts-found')!, style: TextStyle(color: Theme.of(context).iconTheme.color),),
    );
  }

  void loginPressed() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    var found = await server.login(_phoneNumber!, _password!, widget.isForUser);
    if (!found) {
      setState(() {
        _notFoundError = true;
      });
      return;
    }
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: widget.nextPageBuilder));
  }

  void signUpPressed() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: widget.previousPageBuilder));
  }
}

import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'head.dart';
import '../classes/server.dart';
import '../classes/data_provider.dart';

class NetworkSettingsDialog extends StatefulWidget {
  const NetworkSettingsDialog({Key? key}) : super(key: key);

  @override
  _NetworkSettingsDialogState createState() => _NetworkSettingsDialogState();
}

class _NetworkSettingsDialogState extends State<NetworkSettingsDialog> {

  var formKey = GlobalKey<FormState>();
  late Server server;
  String? ip;
  int? port;
  int? ping;
  bool shouldShowPing = false;
  bool loading = false;

  @override
  Widget build(BuildContext context) {

    var head = Head.of(context);
    server = head.server;
    if (head.isOnline) {
      if (ip == null) {
        ip = server.ip;
      }
      if (port == null) {
        port = server.port;
      }
    }

    return AlertDialog(
      title: Text('Network Settings'),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: head.isOnline ? [
            TextFormField(
              decoration: InputDecoration(
                hintText: 'IP address',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'IP address is required.';
                if (!Server.isIPValid(value)) return 'invalid IP address';
              },
              initialValue: ip,
              onSaved: (value) => ip = value!,
            ),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Port',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Port is required.';
                var i = int.tryParse(value);
                if (i == null || i < 0) return 'invalid Port.';
              },
              initialValue: port?.toString(),
              onSaved: (value) => port = int.tryParse(value!)!,
            ),
            const SizedBox(height: 10,),
            if (shouldShowPing)
              buildPing()
          ] : [Text('App is in offline mode.')],
        ),
      ),
      actions: head.isOnline ? [
        if (loading)
          CircularProgressIndicator(value: null,)
        else
        TextButton(child: Text('Set'), onPressed: () async {
          if (!formKey.currentState!.validate()) return;
          formKey.currentState!.save();
          server.setSocket(ip!, port!);
          showLoadingUntilPingIsFinished();
        },
        ),
        if (shouldShowPing)
          TextButton(child: Text('Ping'), onPressed: () async {showLoadingUntilPingIsFinished();},),
        TextButton(child: Text('Offline Mode', style: TextStyle(color: Theme.of(context).accentColor)), onPressed: offlineModePressed),
      ] : [
      IconButton(icon: Icon(Icons.info, color: Colors.grey,), onPressed: infoPressed),
      TextButton(child: Text('Online Mode', style: TextStyle(color: Theme.of(context).accentColor)), onPressed: onlineModePressed),
    ],
    );
  }

  void showLoadingUntilPingIsFinished() {
    setState(() {
      loading = true;
      shouldShowPing = false;
    });
    refreshPing().then((value) => setState(() {
      loading = false;
      shouldShowPing = true;
    }));
  }

  Future<void> refreshPing() async {
    ping = await server.ping;
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Widget buildPing() {
    if (ping == null) {
      return Text('Connection timeout.', style: TextStyle(color: Theme.of(context).errorColor),);
    }
    return Wrap(
      direction: Axis.vertical,
      children: [
        Text('Connected.', style: TextStyle(color: CommonColors.themeColorGreen),),
        Text('ping: $ping ms')
      ],
    );
  }

  void offlineModePressed() {
    setState(() {
      Head.of(context).offlineMode = true;
    });
  }

  void onlineModePressed() {
    setState(() {
      Head.of(context).offlineMode = false;
    });
  }

  void infoPressed() {
    Navigator.of(context).pop();
    showDialog(context: context, builder: buildInfoDialog);
  }

  Widget buildInfoDialog(BuildContext context) {
    var head = Head.of(context);
    return AlertDialog(
      title: Text('Login Info'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('You can login with these information or sign up.'),
          const SizedBox(height: 13,),
          // Text('Phone number: ${head.isForUser ? UserProvider.userPhoneNumber : 'blank'}'),
          // Text('Password: ${head.isForUser ? UserProvider.userPassword : 'blank'}'),
          RichText(
              text: TextSpan(
                  style: Theme.of(context).textTheme.bodyText2,
                  children: [
                    TextSpan(text: 'Phone number: '),
                    TextSpan(text: head.isForUser ? UserProvider.userPhoneNumber : OwnerProvider.ownerPhoneNumber,
                        style: TextStyle(color: Theme.of(context).primaryColor))
                  ]
              )
          ),
          RichText(
              text: TextSpan(
                  style: Theme.of(context).textTheme.bodyText2,
                  children: [
                    TextSpan(text: 'Password: '),
                    TextSpan(text: head.isForUser ? UserProvider.userPassword : OwnerProvider.ownerPassword,
                        style: TextStyle(color: Theme.of(context).primaryColor))
                  ]
              )
          ),
        ],
      ),
      actions: [
        TextButton(child: Text('OK'), onPressed: () => Navigator.of(context).pop(),)
      ],
    );
  }
}

Widget buildNetworkSettingsDialog(BuildContext context) {
  return NetworkSettingsDialog();
}
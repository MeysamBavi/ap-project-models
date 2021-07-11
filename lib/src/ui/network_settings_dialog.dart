import 'package:flutter/material.dart';
import 'head.dart';
import '../classes/server.dart';

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

    server = Head.of(context).server;
    if (ip == null) {
      ip = server.ip;
    }
    if (port == null) {
      port = server.port;
    }

    return AlertDialog(
      title: Text('Network Settings'),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
          ],
        ),
      ),
      actions: [
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
          TextButton(child: Text('Ping'), onPressed: () async {
            showLoadingUntilPingIsFinished();
          },)
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
        Text('Connected.', style: TextStyle(color: Colors.green),),
        Text('ping: $ping ms')
      ],
    );
  }
}

Widget buildNetworkSettingsDialog(BuildContext context) {
  return NetworkSettingsDialog();
}
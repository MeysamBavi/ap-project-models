import 'package:flutter/material.dart';
import 'head.dart';

Widget buildNetworkSettingsDialog(BuildContext context) {
  var server = Head.of(context).server;
  var formKey = GlobalKey<FormState>();
  var ip = server.ip;
  var port = server.port;
  return AlertDialog(
    title: Text('Network Settings'),
    content: Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            decoration: InputDecoration(
              hintText: 'IP address',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'IP address is required.';
              var regex = RegExp(r'^(\d+\.)*(\d+)$');
              if (!regex.hasMatch(value)) return 'invalid IP address';
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
        ],
      ),
    ),
    actions: [
      TextButton(child: Text('Set'), onPressed: () {
        if (!formKey.currentState!.validate()) return;
        formKey.currentState!.save();
        server.setSocket(ip!, port!);
        Navigator.of(context).pop();
      },
      ),
    ],
  );
}
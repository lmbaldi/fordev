import 'package:flutter/material.dart';
import 'package:fordev/ui/helpers/helpers.dart';
import 'package:meta/meta.dart';

class ReloadScreen extends StatelessWidget {

  final String error;
  final Future<void> Function() reload;
  const ReloadScreen({@required this.error,@required this.reload});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.all(30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            error,
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          RaisedButton(
            child: Text(R.string.reload),
            onPressed: reload,
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:the_winery/core/viewmodels/views/export_model.dart';

class ExportDialog extends StatelessWidget {
  final ExportModel model;

  ExportDialog({this.model});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
          "Export did not succeed due to a server error! \n Please try again."),
      content: RaisedButton(
        color: Colors.blue,
        onPressed: () {
          model.startExport();
          Navigator.pop(context);
        },
        child: Text(
          "Return",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

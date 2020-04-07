import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_winery/core/viewmodels/views/export_model.dart';

import '../constants.dart';
import 'base_widget.dart';
import 'widgets/export_dialog.dart';

class ExportView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseWidget<ExportModel>(
      model: ExportModel(userService: Provider.of(context)),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text("Exporting your cellar"),
        ),
        body: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Flexible(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    "This is where you can export your wines into CSV files.\n"
                    "The file is automatically sent to your email-address. "
                    "The CSV file can be opened by any program such as Microsoft Excel or Google "
                    "sheets for further processing of the data",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              SizedBox(
                height: 45,
              ),
              model.export
                  ? Column(
                      children: <Widget>[
                        Text("Enter your filename"),
                        Card(
                          margin: EdgeInsets.symmetric(horizontal: 30),
                          child: TextField(
                            decoration:
                                InputDecoration(border: InputBorder.none),
                            controller: model.controller,
                          ),
                        ),
                        Builder(
                          builder: (context) => RaisedButton(
                            onPressed: () async {
                              bool success = await model.exportWines();
                              if (!success)
                                showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (_) => ExportDialog(model: model),
                                );
                              else {
                                Scaffold.of(context).showSnackBar(
                                  SnackBar(
                                    action: SnackBarAction(
                                      label: 'Open gmail',
                                      onPressed: () => model.openGmail(),
                                    ),
                                    content: Text(
                                        "Created file: ${model.controller.text.replaceAll(model.filenameRegExp, '')}.csv and sent to ${model.email}"),
                                  ),
                                );
                                model.startExport();
                              }
                            },
                            child: Text(
                              "Export!",
                              style: TextStyle(color: Colors.white),
                            ),
                            color: confirmColor,
                          ),
                        )
                      ],
                    )
                  : Column(
                      children: [
                        RaisedButton(
                          onPressed: () => model.startExport(),
                          child: Text(
                            "Export your databse",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: confirmColor,
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

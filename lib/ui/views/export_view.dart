import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wine_cellar/core/viewmodels/views/export_model.dart';

import '../constants.dart';
import 'base_widget.dart';
import 'widgets/export_dialog.dart';

class ExportView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseWidget<ExportModel>(
      model: ExportModel(db: Provider.of(context), api: Provider.of(context)),
      builder: (context, model, child) => Scaffold(
            appBar: AppBar(
              title: Text("Importing/Exporting CSV"),
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
                        "This is where you can export and import CSV files to your database.\n"
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
                                      bool success = await model.exportToCsv();
                                      if (!success)
                                        showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (_) =>
                                              ExportDialog(model: model),
                                        );
                                      else {
                                        Scaffold.of(context).showSnackBar(
                                          SnackBar(
                                            action: SnackBarAction(
                                                label: 'Undo',
                                                onPressed: () =>
                                                    print("hello")),
                                            content: Text(
                                                "Created file: ${model.controller.text}.csv"),
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
                            /*RaisedButton(
                              onPressed: () => model.postWine(),
                              child: Text("Send to Api"),
                            ),
                            RaisedButton(
                              onPressed: () => model.getCellar(),
                              child: Text("Import from api"),
                            )*/
                          ],
                        ),
                ],
              ),
            ),
          ),
    );
  }
}

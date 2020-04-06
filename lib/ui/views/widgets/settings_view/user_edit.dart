import 'package:flutter/material.dart';
import 'package:wine_cellar/core/viewmodels/views/settings_model.dart';

class UserEdit extends StatelessWidget {
  final SettingsModel model;

  const UserEdit({Key key, this.model}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: ListTile(
        onTap: () => {model.toggleUserEdit()},
        title: Text("Edit your user settings"),
        subtitle: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text("Here you can edit your email and other settings."),
              ],
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 450),
              height: model.isUserEdit ? 65 : 0,
              child: model.isUserEdit
                  ? Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: Text("Email: "),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.55,
                          child: TextField(
                            controller: model.controller,
                            decoration: InputDecoration(),
                          ),
                        ),
                        Spacer(),
                        model.busy
                            ? CircularProgressIndicator()
                            : Column(
                                children: <Widget>[
                                  IconButton(
                                      icon: Icon(
                                        Icons.check_circle,
                                        color: model.edited
                                            ? Colors.green
                                            : Colors.grey,
                                      ),
                                      onPressed: () => {model.editEmail()}),
                                  model.edited
                                      ? Text(
                                          "Confirm",
                                          style: TextStyle(fontSize: 9),
                                        )
                                      : Container()
                                ],
                              ),
                      ],
                    )
                  : Container(),
            ),
            Icon(model.isUserEdit
                ? Icons.keyboard_arrow_up
                : Icons.keyboard_arrow_down),
          ],
        ),
      ),
    );
  }
}

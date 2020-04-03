import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wine_cellar/core/models/profile.dart';
import 'package:wine_cellar/core/viewmodels/views/cellar_edit_model.dart';

import '../constants.dart';
import 'base_widget.dart';

class CellarEditView extends StatelessWidget {
  final Profile profile;

  const CellarEditView({Key key, this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseWidget<CellarEditModel>(
      model: CellarEditModel(profileService: Provider.of(context)),
      onModelReady: (model) => model.setProfile(profile),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(),
        body: WillPopScope(
          onWillPop: () async => model.changeProfile(),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: CircleAvatar(
                      backgroundColor: Color(model.profile.color),
                      radius: MediaQuery.of(context).size.height * 0.08,
                      child: Text(
                        model.profile.displayName == ""
                            ? ""
                            : model.profile.displayName
                                .substring(0, 1)
                                .toUpperCase(),
                        style: TextStyle(color: Colors.white, fontSize: 40),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  DropdownButton<Color>(
                    value: Color(model.profile.color),
                    hint: Text("Size of bottle(s)"),
                    onChanged: (newValue) => model.setColor(newValue.value),
                    items: colors
                        .map((value) => DropdownMenuItem<Color>(
                            value: Color(value),
                            child: Text(
                              model.getColorName(value),
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold),
                            )))
                        .toList(),
                  ),
                ],
              ),
              Text(
                "Name of Cellar",
                style: titleStyle,
              ),
              Card(
                elevation: 2,
                margin: EdgeInsets.symmetric(horizontal: 25),
                child: TextField(
                  controller: model.controller,
                  decoration: InputDecoration(border: InputBorder.none),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

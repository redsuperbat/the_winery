import 'package:flutter/material.dart';
import 'package:wine_cellar/core/models/profile.dart';
import 'package:wine_cellar/core/viewmodels/views/home_model.dart';

import '../../../constants.dart';
import 'welcome_dialog.dart';

class MyDrawer extends StatelessWidget {
  final HomeModel model;

  MyDrawer({this.model});

  @override
  Widget build(BuildContext context) {
    model.loadProfiles();
    return Drawer(
      child: Column(
        children: <Widget>[
          Card(
            color: accentColor,
            child: InkWell(
              splashColor: mainColor,
              onTap: () {
                model.increment();
                if (model.counter == 12) {
                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                            title: Text("You really like to click that huh?"),
                            content: RaisedButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text("Return to being a bored person"),
                            ),
                          ),
                      barrierDismissible: false);
                  model.counter = 0;
                }
              },
              child: StreamBuilder<List>(
                  stream: model.profiles,
                  builder: (context, snapshot) {
                    final int length =
                        snapshot.hasData ? snapshot.data.length : 0;
                    return UserAccountsDrawerHeader(
                      margin: EdgeInsets.all(0),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                      ),
                      otherAccountsPictures: <Widget>[
                        for (var i = 1; i <= 2; i++)
                          AlternativeCellar(
                            profile: snapshot.hasData && length > i
                                ? snapshot.data[i]
                                : null,
                            changeCellar: (profile) =>
                                model.changeCellar(profile),
                            addCellar: (name) => model.createCellar(name),
                          ),
                      ],
                      currentAccountPicture: AlternativeCellar(
                          profile: snapshot.hasData && length > 0
                              ? snapshot.data[0]
                              : null,
                          addCellar: (name) => model.createCellar(name),
                          style: TextStyle(
                              fontSize: 35, )),
                      accountName: Container(),
                      accountEmail: Container(
                        child: Text(
                          snapshot.hasData ? snapshot.data[0].displayName : "",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    );
                  }),
            ),
          ),
          ListTile(
            isThreeLine: true,
            title: Text("Export/Import"),
            subtitle: Text("Export your data so you can view it in Excel"),
            trailing: Icon(Icons.import_export),
            onTap: () => Navigator.pushNamed(context, 'export'),
          ),
          ListTile(
            title: Text("Statistics"),
            isThreeLine: true,
            subtitle: Text("View the statistics of your cellar"),
            trailing: Icon(Icons.graphic_eq),
            onTap: () => Navigator.pushNamed(context, 'statistics'),
          ),
          Spacer(),
          ListTile(
            subtitle: Text("Change the settings"),
            title: Text("Settings"),
            trailing: Icon(Icons.settings),
            onTap: () => Navigator.pushNamed(context, 'settings'),
          ),
          SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }
}

class AlternativeCellar extends StatelessWidget {
  final Profile profile;
  final Function changeCellar;
  final Function addCellar;
  final TextStyle style;

  AlternativeCellar(
      {this.profile, this.changeCellar, this.addCellar, this.style});

  @override
  Widget build(BuildContext context) {
    print(profile);
    return profile == null
        ? InkWell(
            child: CircleAvatar(
              backgroundColor: mainColor,
              child: Container(
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ),
            onTap: () => showDialog(
              context: context,
              builder: (_) => WelcomeDialog(
                addCellar: addCellar,
                title: Text(
                  "Add a new cellar",
                  style: titleStyle,
                ),
                content: Text(
                  "This new cellar will contain no wines,"
                  "\nto change back to your original cellar just press that cellar.",
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          )
        : InkWell(
            onTap: () =>
                changeCellar == null ? print("im null") : changeCellar(profile),
            child: CircleAvatar(
              foregroundColor: Colors.white,
              backgroundColor: Color(profile.color),
              child: Text(
                profile.displayName.substring(0, 1).toUpperCase(),
                style: style ?? TextStyle(),
              ),
            ),
          );
  }
}

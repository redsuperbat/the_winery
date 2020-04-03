import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wine_cellar/core/viewmodels/views/home_model.dart';

import '../constants.dart';
import 'base_widget.dart';
import 'widgets/home_view/drawer.dart';
import 'widgets/home_view/dropdown_filter.dart';
import 'widgets/home_view/searchbar.dart';
import 'widgets/home_view/welcome_dialog.dart';
import 'widgets/home_view/wine_list.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseWidget<HomeModel>(
      model: HomeModel(
        wineService: Provider.of(context),
        settings: Provider.of(context),
        profileService: Provider.of(context),
      ),
      onModelReady: (model) async {

        await model.iniAppData();
        if (!model.hasCreated)
          await showDialog(
              context: context,
              builder: (_) => WelcomeDialog(
                    title: Text(
                      "Welcome to Cellar Tracker",
                      style: titleStyle,
                    ),
                    content: Text(
                      "Please specify the name of your first winecellar",
                      textAlign: TextAlign.center,
                    ),
                    addCellar: (name) async {
                      await model.createCellar(name);
                      model.setHasCreated(true);
                    },
                  ),
              barrierDismissible: false);
        await model.iniDb();
      },
      builder: (context, model, child) => Scaffold(
        appBar: model.search
            ? SearchBar(
                homeModel: model,
              )
            : AppBar(
                title: Container(
                  margin: EdgeInsets.only(top: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Your Wines"),
                      StreamBuilder<String>(
                        stream: model.subType,
                        builder: (context, snapshot) => Text(
                          snapshot.hasData ? snapshot.data : "show all",
                          style: TextStyle(
                              fontSize: 15, fontStyle: FontStyle.italic),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () => model.beginSearch(),
                  ),
                  DropdownFilter(),
                ],
              ),
        drawer: MyDrawer(model: model),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red,
          onPressed: () => Navigator.pushNamed(context, 'add'),
          child: Icon(Icons.add),
        ),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            children: <Widget>[
              Text(
                model.search
                    ? "Search results"
                    : "The latest additions to the cellar",
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
              WineList(),
            ],
          ),
        ),
      ),
    );
  }
}

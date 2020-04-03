import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wine_cellar/core/viewmodels/views/home_model.dart';
import 'package:wine_cellar/core/viewmodels/views/search_model.dart';

import '../../base_widget.dart';

class SearchBar extends StatelessWidget implements PreferredSizeWidget {
  final HomeModel homeModel;

  SearchBar({this.homeModel});

  @override
  Widget build(BuildContext context) {
    return BaseWidget<SearchModel>(
      model: SearchModel(wineService: Provider.of(context)),
      builder: (context, model, child) => AppBar(
            leading: IconButton(
              icon: Icon(Icons.close),
              onPressed: () => homeModel.beginSearch(),
            ),
            title: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    onChanged: (query) => model.search(query),
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                        hintText: "Search", border: InputBorder.none),
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56);
}

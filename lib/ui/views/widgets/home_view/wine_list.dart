import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wine_cellar/core/viewmodels/widgets/wine_list_model.dart';

import '../../base_widget.dart';
import 'wine_card.dart';

class WineList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseWidget<WineListModel>(
      model: WineListModel(wineService: Provider.of(context)),
      builder: (context, model, child) => StreamBuilder(
        stream: model.wines,
        builder: (context, AsyncSnapshot<List> snapshot) => snapshot.hasData
            ? Expanded(
                child: RefreshIndicator(
                  onRefresh: () async => await model.onRefresh(),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) => WineCard(
                      wine: snapshot.data[index],
                      onRemove: (wine) {
                        snapshot.data.remove(wine);
                        model.removeWine(wine);
                      },
                    ),
                    //WineCard(wine: model.wines[index]),
                  ),
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}

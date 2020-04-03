import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wine_cellar/core/models/wine.dart';
import 'package:wine_cellar/core/viewmodels/widgets/wine_card_model.dart';

import 'package:wine_cellar/ui/views/widgets/home_view/wine_slider.dart';

import '../../../constants.dart';
import '../../base_widget.dart';

class WineCard extends StatelessWidget {
  final Wine wine;
  final Function onRemove;

  const WineCard({this.wine, this.onRemove});

  @override
  Widget build(BuildContext context) {
    print("WineCard being rebuilt");
    return BaseWidget<WineCardModel>(
      model: WineCardModel(wineService: Provider.of(context)),
      builder: (context, model, child) => Slidable(
        key: ValueKey(wine.id),
        actions: <Widget>[
          SlideAction(
            child: WineSlider(
              title: 'Remove all',
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
              color: Colors.red[300],
            ),
            onTap: () => onRemove(wine),
          ),
        ],
        secondaryActions: <Widget>[
          SlideAction(
            child: WineSlider(
              title: 'Add one',
              child: Icon(
                Icons.add_box,
                color: Colors.white,
              ),
              color: Colors.green[300],
            ),
            onTap: () => model.increment(wine),
          ),
          SlideAction(
            child: WineSlider(
              title: "Drink one",
              color: Colors.blue[300],
              child: Icon(IconData(0xe800, fontFamily: 'WineGlass'),
                  color: Colors.white),
            ),
            onTap: () => model.decrement(wine),
          )
        ],
        actionPane: SlidableScrollActionPane(),
        child: Card(
          elevation: 3,
          child: InkWell(
            onTap: () {
              //model.injectWine(wine);
              Navigator.pushNamed(context, 'wine', arguments: wine);
            },
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(8),
                  child: wine.type == null
                      ? Column(
                          children: [
                            Icon(
                              Icons.image,
                              color: Colors.grey,
                              size: 80,
                            ),
                            Text("No image\navailable", style: hintStyle,)
                          ],
                        )
                      : Image.asset(
                          wine.type == "Rose"
                              ? 'assets/wines/rose_wine.png'
                              : wine.type == "Red"
                                  ? 'assets/wines/red_wine.png'
                                  : wine.type == "Sparkling" ||
                                          wine.type == "Champagne"
                                      ? 'assets/wines/sparkling_wine.png'
                                      : 'assets/wines/white_wine.png',
                          height: 100,
                          fit: BoxFit.contain,
                        ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.40,
                      child: Text(
                        wine.name ?? "",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text('${wine.country ?? ""} ${wine.aoo ?? ""}'),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.40,
                      child: Text(
                        wine.grapes ?? "",
                        style: TextStyle(
                            fontSize: 13, fontStyle: FontStyle.italic),
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Column(
                  children: <Widget>[
                    Container(
                      child: Text(
                        wine.nv ? "NV" : wine.vintage.toString(),
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                    Container(
                      height: 15,
                      child: Text(wine.size ?? ""),
                    ),
                    Container(
                      margin: EdgeInsets.all(5),
                      child: Text(
                        '${wine.owned} st',
                        style: TextStyle(fontSize: 20, color: Colors.red),
                      ),
                    ),
                    Container(
                      child: Text(wine.time?.substring(0, 10)),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

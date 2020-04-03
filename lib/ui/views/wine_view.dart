import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wine_cellar/core/models/wine.dart';
import 'package:wine_cellar/core/viewmodels/views/wine_model.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../constants.dart';
import 'base_widget.dart';
import 'widgets/wine_view/wine_image.dart';

class WineView extends StatelessWidget {
  final Wine wine;

  const WineView({this.wine});

  @override
  Widget build(BuildContext context) {
    return BaseWidget<WineModel>(
      model: WineModel(
          wineService: Provider.of(context), settings: Provider.of(context)),
      onModelReady: (model) => model.initialize(wine),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(wine.name ?? ""),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => Navigator.pushNamed(context, 'wine-edit'),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      InkWell(
                        onTap: () => model.getImage(wine),
                        child: Container(
                          padding: EdgeInsets.all(25),
                          child: WineImage(
                            path: wine.image,
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: MediaQuery.of(context).size.height * 0.245,
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Rating",
                            style: titleStyle,
                          ),
                          Text(
                            "Set the rating by dragging the stars",
                            style: hintStyle,
                          ),
                          FlutterRatingBar(
                            initialRating: wine.rating,
                            allowHalfRating: true,
                            onRatingUpdate: (rating) =>
                                model.setRating(rating, wine),
                          ),
                          Text('${wine.rating}/5.0')
                        ],
                      ),
                    ],
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width*0.43,
                    child: Card(
                      margin: EdgeInsets.only(top: 25),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: <Widget>[
                            if (wine.country != null && wine.aoo != null)
                              WineInfo(
                                  title: 'Country & Appelation',
                                  text:
                                      '${wine.country ?? ""} ${wine.aoo ?? ""}'),
                            if (!wine.nv)
                              WineInfo(
                                  title: "Vintage",
                                  text: wine.vintage.toString()),
                            if (wine.grapes != null)
                              WineInfo(
                                text: wine.grapes,
                                title: "Grapes",
                              ),
                            if (wine.price != null)
                              WineInfo(
                                text:
                                    '${wine.price.toString().replaceAll(".0", "")} ${model.currency}',
                                title: "Price",
                              ),
                            if (wine.type != null)
                              WineInfo(
                                text: wine.type,
                                title: "Type",
                              )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                "Comments",
                style: titleStyle,
              ),
              Card(
                margin: EdgeInsets.only(right: 25, left: 25, bottom: 10),
                elevation: 3,
                child: TextField(
                  controller: model.cmtController,
                  onChanged: (value) => model.setComments(value, wine),
                  decoration: InputDecoration.collapsed(
                    hintText: "Write your notes about the wine here",
                  ),
                  maxLines: 10,
                ),
              ),
              Text(
                'Placed in cellar: ${wine.time.substring(0, 16)}',
                textAlign: TextAlign.center,
                style: TextStyle(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WineInfo extends StatelessWidget {
  final String text;
  final String title;

  const WineInfo({Key key, this.text, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            title,
            style: subTitleStyle,
          ),
          Text(
            text ?? "",
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}

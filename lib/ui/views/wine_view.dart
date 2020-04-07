import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_winery/core/models/wine.dart';
import 'package:the_winery/core/viewmodels/views/wine_model.dart';
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
                        onTap: () => {},
                        child: Container(
                          padding: EdgeInsets.only(
                              left: 18, right: 18, bottom: 18, top: 12.5),
                          child: WineImage(
                            url: wine.imageUrl,
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
                    width: MediaQuery.of(context).size.width * 0.43,
                    child: Container(
                      margin: EdgeInsets.only(top: 12.5),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: <Widget>[
                            if (wine.country != null && wine.district != null)
                              WineInfo(
                                  title: 'Origin',
                                  text:
                                      '${wine.country ?? ""} ${wine.district ?? ""}'),
                            if (wine.vintage != null)
                              WineInfo(title: "Vintage", text: wine.vintage),
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
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: TextField(
                    controller: model.cmtController,
                    onChanged: (value) => model.setComments(value, wine),
                    decoration: InputDecoration.collapsed(
                      hintText: "Write your notes about the wine here",
                    ),
                    maxLines: 10,
                  ),
                ),
              ),
              Text(
                'Placed in cellar: ${wine.date}',
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
            style: subTitleStyle2,
          ),
          Text(
            text ?? "",
            style: TextStyle(fontSize: 15),
          ),
        ],
      ),
    );
  }
}

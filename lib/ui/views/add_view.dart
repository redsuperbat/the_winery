import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wine_cellar/core/viewmodels/views/add_model.dart';
import '../constants.dart';

import 'base_widget.dart';
import 'widgets/add_view/bottle_amount.dart';
import 'widgets/add_view/country_picker.dart';
import 'widgets/add_view/picker.dart';
import 'widgets/add_view/vintage_picker.dart';
import 'widgets/add_view/wine_form.dart';

class Add extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseWidget<AddModel>(
      model: AddModel(
        wineService: Provider.of(context),
      ),
      builder: (context, model, child) => Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                tileMode: TileMode.clamp,
                radius: 1.6,
                stops: [0.6, 0.8],
                colors: [
                  mainColor,
                  Colors.black,
                ],
              ),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                iconTheme: IconThemeData(color: Colors.white),
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.red,
                child: Icon(
                  Icons.add_a_photo,
                  color: Colors.white,
                ),
                onPressed: () async => await model.getImage(),
              ),
              body: SingleChildScrollView(
                child: Card(
                  elevation: 5,
                  margin: EdgeInsets.all(25),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "Add more wine to your cellar",
                        style: TextStyle(fontSize: 30, color: mainColor),
                        textAlign: TextAlign.center,
                      ),
                      model.image == null
                          ? Container()
                          : Image.file(
                              model.image,
                              fit: BoxFit.contain,
                              height: 100,
                            ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: AddWineForm(),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Picker(),
                      SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: <Widget>[
                          Spacer(),
                          CountryPicker(),
                          Spacer(),
                          BottleAmount(),
                          Spacer(),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        child: VintagePicker(),
                      ),
                      RaisedButton(
                        color: confirmColor,
                        onPressed: () async {
                          await model.addWineToDb();
                          Navigator.pop(context);
                        },
                        child: Text("Add to Cellar", style: TextStyle(color: Colors.white),),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wine_cellar/core/viewmodels/widgets/add_view/country_picker_model.dart';

import '../../base_widget.dart';
import 'country_dialog.dart';

class CountryPicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseWidget<CountryPickerModel>(
      model: CountryPickerModel(
          json: Provider.of(context), wineService: Provider.of(context)),
      onModelReady: (model) => model.loadAssets(),
      builder: (context, model, child) => model.country == null
          ? RaisedButton(
              child: Text("Wine origin country"),
              onPressed: () => showDialog(
                    context: context,
                    builder: (_) => CountryDialog(model: model),
                  ),
            )
          : Container(
              width: MediaQuery.of(context).size.width * 0.45,
              height: 60,
              child: InkWell(
                onTap: () => showDialog(
                      context: context,
                      builder: (_) => CountryDialog(model: model),
                    ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(45.0),
                      ),
                      child: Image.asset(
                        model.country.flag,
                        height: 60,
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.05,
                    ),
                    Flexible(child: Text(model.country.name)),
                  ],
                ),
              ),
            ),
    );
  }
}

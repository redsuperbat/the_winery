import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wine_cellar/core/viewmodels/widgets/add_view/add_wine_form_model.dart';

import '../../base_widget.dart';

class AddWineForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseWidget<AddWineFormModel>(
      model: AddWineFormModel(
          wineService: Provider.of(context), settings: Provider.of(context)),
      builder: (context, model, child) => Container(
            width: MediaQuery.of(context).size.width / 1.2,
            child: Stack(
              children: [
                Column(
                  children: <Widget>[
                    TextField(
                      focusNode: model.focusNode,
                      onTap: () => model.showWineSearch(),
                      controller: model.nameController,
                      decoration: InputDecoration(
                          hintText: 'Brand Name & Wine Producer'),
                    ),
                    TextField(
                      controller: model.grapeController,
                      decoration: InputDecoration(hintText: 'Grapes'),
                    ),
                    TextField(
                      controller: model.aooController,
                      decoration: InputDecoration(
                        suffixIcon: Tooltip(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          message:
                              'Where the wine originates from. \nEg. Bourgogne, Bourdeaux or Napa-Valley',
                          child: Icon(
                            Icons.info,
                          ),
                        ),
                        hintText: 'Appellation of origin',
                      ),
                    ),
                    TextField(
                      keyboardType: TextInputType.number,
                      controller: model.priceController,
                      inputFormatters: <TextInputFormatter>[
                        // WhitelistingTextInputFormatter('[0-9.]'), Implement me
                      ],
                      decoration: InputDecoration(
                        suffixIcon: Container(
                          height: 30,
                          width: MediaQuery.of(context).size.width * 0.1,
                          child: Center(child: Text(model.currency)),
                        ),
                        hintText: 'Purchase price',
                      ),
                    ),
                  ],
                ),
                StreamBuilder(
                    stream: model.wines,
                    builder: (context, AsyncSnapshot<List> snapshot) => snapshot
                                .hasData &&
                            snapshot.data.length != 0 &&
                            model.text != "" &&
                            model.showSearch &&
                            model.focusNode.hasFocus
                        ? Container(
                            color: Colors.transparent,
                            margin: EdgeInsets.only(top: 48, right: 5),
                            child: LimitedBox(
                              maxHeight: snapshot.data.length.toDouble() * 45,
                              maxWidth: double.infinity,
                              child: Card(
                                margin: EdgeInsets.zero,
                                elevation: 4,
                                child: ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, index) => Container(
                                    padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                            border: Border(
                                                bottom: BorderSide(
                                                    color: Colors.black54))),
                                        height: 45,
                                        child: InkWell(
                                          child: Row(
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  snapshot.data[index].name ?? "",
                                                  style: TextStyle(fontSize: 17),
                                                ),
                                              ),
                                            ],
                                          ),
                                          onTap: () =>
                                              model.setWine(snapshot.data[index]),
                                        ),
                                      ),
                                ),
                              ),
                            ),
                          )
                        : Container()),
              ],
            ),
          ),
    );
  }
}

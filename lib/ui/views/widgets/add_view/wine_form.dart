import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:the_winery/core/models/wine.dart';
import 'package:the_winery/core/viewmodels/widgets/add_view/add_wine_form_model.dart';
import 'package:the_winery/ui/constants.dart';

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
                  autofocus: false,
                  onTap: () => model.showWineSearch(),
                  controller: model.nameController,
                  decoration: InputDecoration(hintText: 'Name & Producer'),
                ),
                TextField(
                  autofocus: false,
                  controller: model.grapeController,
                  decoration: InputDecoration(hintText: 'Grapes'),
                ),
                TextField(
                  autofocus: false,
                  controller: model.districtController,
                  decoration: InputDecoration(
                    suffixIcon: Tooltip(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      message:
                          'Where the wine originates from. \nEg. Bourgogne, Bourdeaux or Napa-Valley',
                      child: Icon(
                        Icons.info,
                      ),
                    ),
                    hintText: 'District',
                  ),
                ),
                TextField(
                  autofocus: false,
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
                stream: model.stream,
                builder: (context, AsyncSnapshot<List<Wine>> snapshot) =>
                    snapshot.hasData &&
                            snapshot.data.length != 0 &&
                            model.text != "" &&
                            model.showSearch &&
                            model.focusNode.hasFocus
                        ? Container(
                            color: Colors.transparent,
                            margin: EdgeInsets.only(
                              top: 48,
                            ),
                            child: LimitedBox(
                              maxHeight: snapshot.data.length.toDouble() * 45,
                              maxWidth: double.infinity,
                              child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index) => Card(
                                  margin: EdgeInsets.all(0),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
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
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.61,
                                            child: Text(
                                              snapshot.data[index].name ?? "",
                                              style: TextStyle(fontSize: 17),
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                                color: accentColor,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(15))),
                                            child: Text(
                                              "Quickadd!",
                                              style: TextStyle(fontSize: 9),
                                            ),
                                          )
                                        ],
                                      ),
                                      onTap: () => model.setWine(
                                          snapshot.data[index].toJson()),
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

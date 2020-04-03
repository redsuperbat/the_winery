import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wine_cellar/core/viewmodels/widgets/add_view/bottle_amount_model.dart';

import '../../base_widget.dart';

class BottleAmount extends StatefulWidget {
  @override
  _BottleAmountState createState() => _BottleAmountState();
}

class _BottleAmountState extends State<BottleAmount> {
  @override
  Widget build(BuildContext context) {
    return BaseWidget<BottleAmountModel>(
      model: BottleAmountModel(wineService: Provider.of(context)),
      builder: (context, model, child) => Column(
            children: <Widget>[
              Text("Amount of bottles"),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Card(
                    elevation: 3,
                    child: InkWell(
                      child: Icon(
                        Icons.remove,
                        size: 40,
                      ),
                      onTap: () => model.decrement(),
                    ),
                  ),
                  Container(
                    width: 30,
                    child: TextField(
                      inputFormatters: <TextInputFormatter>[
                        BlacklistingTextInputFormatter('-',
                            replacementString: '')
                      ],
                      maxLength: 3,
                      controller: model.controller,
                      keyboardType: TextInputType.numberWithOptions(),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Card(
                    elevation: 3,
                    child: InkWell(
                      child: Icon(
                        Icons.add,
                        size: 40,
                      ),
                      onTap: () => model.increment(),
                    ),
                  ),
                ],
              ),
            ],
          ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_winery/core/viewmodels/widgets/dropdown_filter_model.dart';
import 'package:the_winery/ui/constants.dart';

import '../../base_widget.dart';

class DropdownFilter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseWidget<DropdownFilterModel>(
      model: DropdownFilterModel(wineService: Provider.of(context)),
      builder: (context, model, child) => Container(
        margin: EdgeInsets.only(right: 8),
        child: InkWell(
          child: Icon(Icons.filter_list),
          onTap: () async {
            model.setType(
              await showMenu(
                    context: context,
                    position: RelativeRect.fromLTRB(100.0, 40.0, 30.0, 100.0),
                    items: model.category
                        .map(
                          (s) => PopupMenuItem(
                            child: Text(s),
                            value: s,
                          ),
                        )
                        .toList(),
                  ) ??
                  "show all",
            );
            print(model.type);
            model.type == "show all"
                ? await model.getAllWine()
                : model.setSubType(
                    await showMenu(
                      context: context,
                      position: RelativeRect.fromLTRB(100.0, 40.0, 30.0, 100.0),
                      items: model.type == "type"
                          ? wineCategories
                              .map((t) => PopupMenuItem(
                                    child: Text(t),
                                    value: t,
                                  ))
                              .toList()
                          : wineSizes
                              .map((s) => PopupMenuItem(
                                    child: Text(s),
                                    value: s,
                                  ))
                              .toList(),
                    ),
                  );
          },
        ),
      ),
    );
  }
}

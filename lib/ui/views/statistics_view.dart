import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_winery/core/viewmodels/views/statistics_model.dart';

import 'base_widget.dart';
import 'widgets/statistics_view/pie_chart_page_view.dart';
import 'widgets/statistics_view/top_card.dart';

class StatisticsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseWidget<StatisticsModel>(
      onModelReady: (model) => model.initPieData(),
      model: StatisticsModel(
        wineService: Provider.of(context),
        settings: Provider.of(context),
      ),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Statistics",
            textAlign: TextAlign.center,
          ),
        ),
        body: model.busy
            ? Container()
            : SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TopCard(model: model),
                    PieChartPageView(model: model),
                    // Container(
                    //   height: MediaQuery.of(context).size.height * 0.3,
                    //   child: Card(
                    //     child: Center(
                    //       child: Text("Ads here"),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
      ),
    );
  }
}

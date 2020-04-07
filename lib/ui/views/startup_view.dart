import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_winery/core/services/user_service.dart';
import 'package:the_winery/core/viewmodels/views/startup_model.dart';
import 'package:the_winery/ui/views/base_widget.dart';
import 'package:the_winery/ui/views/home_view.dart';

import 'register_view.dart';

class StartupView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseWidget<StartupModel>(
      model: StartupModel(userService: Provider.of<UserService>(context)),
      onModelReady: (model) => model.init(),
      builder: (context, model, child) => StreamBuilder(
        stream: model.stream,
        builder: (context, snapshot) => snapshot.hasData
            ? snapshot.data == "register" ? RegisterView() : HomeView()
            : Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
      ),
    );
  }
}

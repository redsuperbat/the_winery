/*
this is where you place all of your routes
*/

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'views/add_view.dart';
import 'views/cellar_edit_view.dart';
import 'views/export_view.dart';
import 'views/home_view.dart';
import 'views/image_view.dart';
import 'views/settings_view.dart';
import 'views/statistics_view.dart';
import 'views/wine_edit_view.dart';
import 'views/wine_view.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => HomeView());
      case 'add':
        return MaterialPageRoute(builder: (_) => Add());
      case 'wine':
        var wine = settings.arguments;
        return MaterialPageRoute(builder: (_) => WineView(wine: wine));
      case 'export':
        return MaterialPageRoute(builder: (_) => ExportView());
      case 'settings':
        return MaterialPageRoute(builder: (_) => SettingsView());
      case 'statistics':
        return MaterialPageRoute(builder: (_) => StatisticsView());
      case 'image':
        String path = settings.arguments;
        return MaterialPageRoute(builder: (_) => ImageView(path));
      case 'wine-edit':
        return MaterialPageRoute(builder: (_) => WineEditView());
      case 'cellar-edit':
        var profile = settings.arguments;
        return MaterialPageRoute(
            builder: (_) => CellarEditView(
                  profile: profile,
                ));
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text('No route defined for ${settings.name}'),
                  ),
                ));
    }
  }
}

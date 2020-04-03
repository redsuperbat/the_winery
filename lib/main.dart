import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'provider_setup.dart';
import 'ui/constants.dart';
import 'ui/router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          fontFamily: 'GlacialIndifference',
          iconTheme: IconThemeData(color: Colors.red),
          appBarTheme: AppBarTheme(
              textTheme: TextTheme(
                  title: TextStyle(color: Colors.black87, fontSize: 24)),
              color: accentColor,
              elevation: 3,
              iconTheme: IconThemeData(color: Color(0xFFc72442))),
        ),
        onGenerateRoute: Router.generateRoute,
        initialRoute: '/',
      ),
    );
  }
}

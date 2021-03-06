import 'package:provider/provider.dart';
import 'package:nested/nested.dart';

// import 'core/services/api.dart';
// import 'core/services/database_service.dart';
import 'core/services/json_service.dart';
// import 'core/services/profile_service.dart';
import 'core/services/settings_service.dart';
import 'core/services/user_service.dart';
// import 'core/services/wine_db_service.dart';
import 'core/services/wine_service.dart';

List<SingleChildWidget> providers = [
  ...independentServices,
  ...dependentServices,
  ...uiConsumableProviders
];

List<SingleChildWidget> independentServices = [
  // Provider.value(value: WineDb()),
  Provider.value(value: JsonService()),
  Provider.value(value: Settings()),
  // Provider.value(value: DatabaseService());
  Provider.value(value: UserService())
];

List<SingleChildWidget> dependentServices = [
  ProxyProvider<UserService, WineService>(
      //The initial builder can instantiate some value for you if you want
      //initialBuilder: (wineService) => wineService.instantiateSomeValue(),
      update: (context, userService, wineService) =>
          WineService(userService: userService))
  // ProxyProvider<DatabaseService, ProfileService>(
  //   update: (context, db, profileService) => ProfileService(db: db),
  // ),
];

List<SingleChildWidget> uiConsumableProviders = [
/*  example of a StreamProvider
StreamProvider<User>(
    builder: (context) => Provider.of<AuthenticationService>(context, listen: false).user,
  )*/
];

import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

import 'package:wine_cellar/core/models/country.dart';
import 'package:wine_cellar/ui/constants.dart';

class JsonService {
  final List<Country> _countries = [];
  final List<Country> _suggestedCountries = [];
  List _response;

  List<Country> get countries => _countries;

  List<Country> get suggestedCountries => _suggestedCountries;

  Future<void> loadAssets() async {
    if (_response == null)
      _response = json
          .decode(await rootBundle.loadString('assets/text/country_data.json'));
    if (_countries.length == 0) {
      print("im loading the country assets");
      _response.forEach((c) {
        _countries.add(Country.fromJson(c));
        if (countryNames.contains(c['name'])) {
          _suggestedCountries.add(Country.fromJson(c));
        }
      });
      _countries.sort((f, s) => (f.name.compareTo(s.name)));
      _suggestedCountries.sort((f, s) => (f.name.compareTo(s.name)));
      }
      }
}

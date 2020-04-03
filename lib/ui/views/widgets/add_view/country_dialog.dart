import 'package:flutter/material.dart';
import 'package:wine_cellar/core/models/country.dart';
import 'package:wine_cellar/core/viewmodels/widgets/add_view/country_picker_model.dart';

class CountryDialog extends StatelessWidget {
  final CountryPickerModel model;

  CountryDialog({this.model});

  @override
  Widget build(BuildContext context) {
    return model.busy
        ? Container()
        : SimpleDialog(
            backgroundColor: Colors.transparent,
            children: <Widget>[
              Card(
                child: Column(
                  children: [
                    CountryTitle(
                      initialData: true,
                      onTap: (show) => model.toggleSuggestions(show),
                      show: model.suggestionStream,
                      title: "Suggested Countries",
                    ),
                    StreamBuilder<bool>(
                        initialData: true,
                        stream: model.suggestionStream,
                        builder: (context, snapshot) => snapshot.data
                            ? Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                                child: ListView.builder(
                                  physics: ScrollPhysics(),
                                  itemCount: model.suggestedCountries.length,
                                  itemBuilder: (context, index) => CountryTile(
                                    country: model.suggestedCountries[index],
                                    onTap: (country) =>
                                        model.setCountry(country),
                                  ),
                                ),
                              )
                            : Container()),
                    CountryTitle(
                      initialData: false,
                      title: "Other countries",
                      onTap: (show) => model.toggleOther(show),
                      show: model.otherStream,
                    ),
                    StreamBuilder<bool>(
                        initialData: false,
                        stream: model.otherStream,
                        builder: (context, snapshot) => snapshot.data
                            ? Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                                child: ListView.builder(
                                  physics: ScrollPhysics(),
                                  itemCount: model.countries.length,
                                  itemBuilder: (context, index) => CountryTile(
                                    country: model.countries[index],
                                    onTap: (country) =>
                                        model.setCountry(country),
                                  ),
                                ),
                              )
                            : Container()),
                  ],
                ),
              ),
            ],
          );
  }
}

class CountryTitle extends StatelessWidget {
  final String title;
  final Function onTap;
  final Stream show;
  final bool initialData;

  const CountryTitle(
      {Key key, this.onTap, this.show, this.title, this.initialData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      initialData: initialData,
      stream: show,
      builder: (context, AsyncSnapshot<bool> snapshot) => Card(
        child: ListTile(
          onTap: () => onTap(!snapshot.data),
          dense: true,
          contentPadding: EdgeInsets.zero,
          title: Row(
            children: <Widget>[
              Container(),
              Spacer(),
              Text(
                title,
                style: TextStyle(fontSize: 20),
              ),
              Spacer(),
              Icon(snapshot.data ? Icons.arrow_drop_down : Icons.arrow_drop_up)
            ],
          ),
        ),
      ),
    );
  }
}

class CountryTile extends StatelessWidget {
  final Function onTap;
  final Country country;

  const CountryTile({Key key, this.country, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onTap(country);
        Navigator.pop(context);
      },
      title: Row(
        children: <Widget>[
          Image.asset(
            country.flag,
            width: 40,
            fit: BoxFit.contain,
          ),
          SizedBox(
            width: 10,
          ),
          Flexible(
            child: Text(
              country.name,
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}

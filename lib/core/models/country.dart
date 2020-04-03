class Country {
  String flag;
  String name;

  Country({this.flag, this.name});

  Country.fromJson(Map<String, dynamic> json) {
    flag = json['flag'];
    name = json['name'];
  }
}

class Profile {
  int id;
  String cellarName;
  bool isDefault;
  String index;
  int color = 0xFFFFFFFF;
  String displayName;

  Profile({this.cellarName,
    this.displayName,
    this.id,
    this.isDefault = false,
    this.color,
    this.index = "one"});

  Map<String, dynamic> toJson() =>
      <String, dynamic>{
        'id': id,
        'cellarName': cellarName,
        'displayName': displayName,
        'isDefault': isDefault ? 1 : 0,
        'databaseKey': index,
        'color': color
      };

  Profile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    displayName = json['displayName'];
    cellarName = json['cellarName'];
    isDefault = json['isDefault'] == 1 ? true : false;
    index = json['databaseKey'];
    color = json['color'];
  }
}

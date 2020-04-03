class Wine {
  String name;
  int vintage;
  String type;
  String size;
  String aoo;
  String country;
  bool nv;
  int id;
  int owned;
  String grapes;
  String image;
  double rating;
  String comment;
  double price;
  String time;

  Wine(
      {this.name,
      this.type,
      this.aoo,
      this.country,
      this.vintage,
      this.id,
      this.grapes,
      this.owned = 1,
      this.size,
      this.image,
      this.nv = false,
      this.time,
      this.comment,
      this.price = 0.0,
      this.rating = 0.0});

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'type': type,
        'vintage': vintage,
        'aoo': aoo,
        'country': country,
        'nv': nv,
        'grapes': grapes,
        'owned': owned,
        'size': size,
        'time': time,
        'rating': rating,
        'comment': comment,
        'price': price,
        'image': image,
      };

  Wine.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    type = json['type'];
    vintage = json['vintage'];
    id = json['id'];
    grapes = json['grapes'];
    owned = json['owned'];
    size = json['size'];
    image = json['image'];
    time = json['time'];
    nv = json['nv'] == 0 ? false : true;
    rating = json['rating']?.toDouble();
    comment = json['comment'];
    aoo = json['aoo'];
    country = json['country'];
    price = json['price']?.toDouble();
  }
}

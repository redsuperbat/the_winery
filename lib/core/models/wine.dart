class Wine {
  String name;
  String vintage;
  String type;
  String size;
  String district;
  String country;
  String id;
  int quantity;
  String grapes;
  String imageUrl;
  double rating;
  String comment;
  double price;
  String date;
  bool archived;

  Wine(
      {this.name,
      this.type,
      this.district,
      this.country,
      this.vintage,
      this.id,
      this.grapes,
      this.quantity = 1,
      this.size,
      this.imageUrl,
      this.date,
      this.comment,
      this.archived,
      this.price,
      this.rating});

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'type': type,
        'vintage': vintage,
        'district': district,
        'country': country,
        'grapes': grapes,
        'quantity': quantity,
        'size': size,
        'date': date,
        'rating': rating,
        'archived': archived,
        'comment': comment,
        'price': price,
        'imageUrl': imageUrl,
        '_id': id,
      };

  Wine.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    type = json['type'];
    vintage = json['vintage'];
    id = json['_id'];
    grapes = json['grapes'];
    quantity = json['quantity'];
    size = json['size'];
    imageUrl = json['imageUrl'];
    archived = json['archived'];
    date = json['date'];
    rating = json['rating']?.toDouble();
    comment = json['comment'];
    district = json['district'];
    country = json['country'];
    price = json['price']?.toDouble();
  }
}

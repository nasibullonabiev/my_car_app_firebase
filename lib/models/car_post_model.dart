class PostCarModel {
  late String postKey;
  late String carBrand;
  late String carModel;
  late String price;
  late String date;
  late String description;

  String? image;

  PostCarModel(
      {required this.postKey,
      required this.carBrand,
      required this.carModel,
      required this.price,
      required this.date,
      required this.description,
      this.image});

  PostCarModel.fromJson(Map<String, dynamic> json) {
    postKey = json["postKey"];
    carBrand = json['carBrand'];
    carModel = json['carModel'];
    price = json['price'];
    date = json['date'];
    description = json['description'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() => {
        'postKey': postKey,
        'carBrand': carBrand,
        'carModel': carModel,
        'price': price,
        'date': date,
        'description': description,
        'image': image
      };
}

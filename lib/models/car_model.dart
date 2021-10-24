class CarModel {
  String id;
  String make;
  String model;
  String type;
  String logo;
  String category;

  CarModel(
      {this.id, this.make="loading...", this.model="loading...", this.type="loading...", this.logo="loading...", this.category="loading..."});

  factory CarModel.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return CarModel();
    }

    return CarModel(
        id: json['_id'] ?? null,
        make: json['car_make'] ?? null,
        model: json['car_model'] ?? null,
        type: json['car_type'] ?? null,
        logo: json['car_image'] ?? null,
        category: json['car_category'] ?? null);
  }
}

//{
//"car_image": "https://stimg.cardekho.com/images/carexteriorimages/630x420/Tata/Tata-Aria/047.jpg",
//"_id": "5e89eef50b887116a44b9f91",
//"car_make": "Tata",
//"car_model": "Aria",
//"car_type": "Diesel",
//"car_category": "SUV"
//},

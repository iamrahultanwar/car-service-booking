class ServiceModel {
  String id;
  int index;
  String name;
  String logoUrl;
  String offer;
  String description;

  ServiceModel(
      {this.index = 1,
      this.id,
      this.name,
      this.logoUrl,
      this.offer,
      this.description});

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['_id'],
      name: json['name'],
      logoUrl: json["logo"],
      offer: "50% off",
      description: json['description'],
    );
  }
}

//service_id": {
//"offer": "50 %",
//"_id": "5e8b70d7429bcc03eb0b337c",
//"name": "Car Service",
//"description": "Autoflipz's Car Service packages of bare essentials with additional services."
//},

class SubServiceQuestion {
  String question;
  String answer;

  SubServiceQuestion({this.question, this.answer});

  factory SubServiceQuestion.fromJson(Map<String, dynamic> json) {
    return SubServiceQuestion(
        question: json["question"], answer: json["answer"]);
  }
}

class SubServiceComponents {
  String name;
  String details;

  SubServiceComponents({this.name, this.details});

  factory SubServiceComponents.fromJson(Map<String, dynamic> json) {
    return SubServiceComponents(name: json["name"], details: json["details"]);
  }
}

class SubServiceModel {
  String id;
  String name;
  String logoUrl;
  String offerPrice;
  String price;
  String brief;
  String description;
  String detailed;
  String when;
  String what;
  String carCategory;
  String carType;
  List<String> images;
  List<dynamic> questions;
  List<SubServiceComponents> components;

  SubServiceModel(
      {this.id,
      this.name,
      this.logoUrl,
      this.offerPrice,
      this.price,
      this.brief,
      this.description,
      this.detailed,
      this.when,
      this.what,
      this.carCategory,
      this.carType,
      this.images,
      this.questions,
      this.components});

  factory SubServiceModel.fromJson(Map<String, dynamic> json) {
    List _images = json["images"];
    List _questions = json["questions"];
    List _components = json["components"];
    return SubServiceModel(
        id: json['sub_service_id'] ?? json["_id"],
        name: json['name'],
        logoUrl: json['logo'],
        offerPrice: json['offer_price'],
        price: json['price'],
        brief: json['brief'],
        description: json['description'],
        detailed: json['detailed'],
        when: json['when'],
        what: json['what'],
        carCategory: json['car_category'],
        carType: json['car_type'],
        questions: _questions.length > 0
            ? _questions.map((question) {
                return SubServiceQuestion.fromJson(question);
              }).toList()
            : _questions,
        components: _components.map((component) {
          return SubServiceComponents.fromJson(component);
        }).toList(),
        images: _images.map<String>((image) {
          return image;
        }).toList());
  }
}

class ServiceTab {
  String name;
  List<SubServiceModel> subServiceList;

  ServiceTab({this.name, this.subServiceList});
}

//{
//"offer_price": "30 % off",
//"_id": "5e8b856538c74f25bbc89062",
//"service_id": "5e8b70d7429bcc03eb0b337c",
//"name": "Basic",
//"logo": null,
//"price": "1999",
//"brief": "All the basic essentials to keep your car fit and running.",
//"description": "Autoflipz's Car Service packages of bare essentials with additional services.",
//"detailed": "Engine Oil Replace,Oil Filter Replace,Air Filter Replace,Brake and Clutch Fluid Top Up,Windshield Water Fluid Top Up,Coolant Top Up,Standard Service Labour.",
//"what": "Engine Oil Replaced,Oil Filter Replaced,Air Filer Cleaned,Wiper Fluid Replaced,Battery Top Up,Coolant Top Up,Spark Plugs Cleaned,Car Wash,Interior Detail Cleaning.",
//"when": "Recommended every 5,000 Kms or 3 months, 90 Points Check List",
//"car_category": "Hatchback",
//"car_type": "Petrol",
//"__v": 0
//},

//"service_category": "Car Service",
//"car_category": "Hatchback (Petrol)",
//"sub_service": "Basic",
//"sub_service_icon": null,
//"sub_service_description": "Autoflipz's Car Service packages of bare essentials with additional services.",
//"sub_service_when": "Recommended every 5,000 Kms or 3 months, 90 Points Check List",
//"sub_service_what": "Engine Oil Replaced,Oil Filter Replaced,Air Filer Cleaned,Wiper Fluid Replaced,Battery Top Up,Coolant Top Up,Spark Plugs Cleaned,Car Wash,Interior Detail Cleaning.",
//"sub_service_detailed": "Engine Oil Replace,Oil Filter Replace,Air Filter Replace,Brake and Clutch Fluid Top Up,Windshield Water Fluid Top Up,Coolant Top Up,Standard Service Labour.",
//"sub_service_brief": "All the basic essentials to keep your car fit and running.",
//"sub_service_price": "1999"

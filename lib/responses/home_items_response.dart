class ItemsResponse {
  List<Categories>? categories;

  ItemsResponse({this.categories});

  ItemsResponse.fromJson(Map<String, dynamic> json) {
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(new Categories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.categories != null) {
      data['categories'] = this.categories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Categories {
  int? id;
  String? name;
  List<Dishes>? dishes;

  Categories({this.id, this.name, this.dishes});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['dishes'] != null) {
      dishes = <Dishes>[];
      json['dishes'].forEach((v) {
        dishes!.add(new Dishes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.dishes != null) {
      data['dishes'] = this.dishes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Dishes {
  int? id;
  String? name;
  String? price;
  String? currency;
  int? calories;
  String? description;
  List<Addons>? addons;
  String? imageUrl;
  bool? customizationsAvailable;
  late int itemCount;
  late num total;

  Dishes(
      {this.id,
      this.name,
      this.price,
      this.currency,
      this.calories,
      this.description,
      this.addons,
      this.imageUrl,
      this.customizationsAvailable,
      required this.itemCount,
      required this.total});

  Dishes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    currency = json['currency'];
    calories = json['calories'];
    description = json['description'];
    if (json['addons'] != null) {
      addons = <Addons>[];
      json['addons'].forEach((v) {
        addons!.add(new Addons.fromJson(v));
      });
    }
    imageUrl = json['image_url'];
    customizationsAvailable = json['customizations_available'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['price'] = this.price;
    data['currency'] = this.currency;
    data['calories'] = this.calories;
    data['description'] = this.description;
    if (this.addons != null) {
      data['addons'] = this.addons!.map((v) => v.toJson()).toList();
    }
    data['image_url'] = this.imageUrl;
    data['customizations_available'] = this.customizationsAvailable;
    return data;
  }
}

class Addons {
  int? id;
  String? name;
  String? price;

  Addons({this.id, this.name, this.price});

  Addons.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['price'] = this.price;
    return data;
  }
}

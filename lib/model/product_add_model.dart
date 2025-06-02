class ProductAddModel {
  String? employeeId;
  String? vendorId;
  String? model;
  String? price;
  String? quantity;
  String? minimum;
  String? subtract;
  String? stockStatusId;
  String? shipping;
  String? image;
  String? pid;
  List<ProductDescription>? productDescription;
  List<ProductImage>? productImage;
  List<ProductOption>? productOption;

  ProductAddModel({
    this.employeeId,
    this.vendorId,
    this.model,
    this.price,
    this.quantity,
    this.minimum,
    this.subtract,
    this.stockStatusId,
    this.shipping,
    this.image,
    this.productDescription,
    this.productImage,
    this.productOption,
  });

  factory ProductAddModel.fromJson(Map<String, dynamic> json) =>
      ProductAddModel(
        employeeId: json["employee_id"],
        vendorId: json["vendor_id"],
        model: json["model"],
        price: json["price"]?.toDouble(),
        quantity: json["quantity"],
        minimum: json["minimum"],
        subtract: json["subtract"],
        stockStatusId: json["stock_status_id"],
        shipping: json["shipping"],
        image: json["image"],
        productDescription: json["product_description"] == null
            ? []
            : List<ProductDescription>.from(json["product_description"]!
                .map((x) => ProductDescription.fromJson(x))),
        productImage: json["product_image"] == null
            ? []
            : List<ProductImage>.from(
                json["product_image"]!.map((x) => ProductImage.fromJson(x))),
        productOption: json["product_option"] == null
            ? []
            : List<ProductOption>.from(
                json["product_option"]!.map((x) => ProductOption.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "employee_id": employeeId,
        "vendor_id": vendorId,
        "language_id": 1,
        "model": model,
        "price": price,
        "quantity": quantity,
        "minimum": minimum,
        "subtract": subtract,
        "stock_status_id": stockStatusId,
        "shipping": shipping,
        "image": image,
        "product_description": productDescription == null
            ? []
            : List<dynamic>.from(productDescription!.map((x) => x.toJson())),
        "product_image": productImage == null
            ? []
            : List<dynamic>.from(productImage!.map((x) => x.toJson())),
        "product_option": productOption == null
            ? []
            : List<dynamic>.from(productOption!.map((x) => x.toJson())),
      };
  Map<String, dynamic> toUpdateJson() => {
        "employee_id": employeeId,
        "vendor_id": vendorId,
        "product_id": pid,
        "language_id": 1,
        "model": model,
        "price": price,
        "quantity": quantity,
        "minimum": minimum,
        "subtract": subtract,
        "stock_status_id": stockStatusId,
        "shipping": shipping,
        "image": image,
        "product_description": productDescription == null
            ? []
            : List<dynamic>.from(productDescription!.map((x) => x.toJson())),
        "product_image": productImage == null
            ? []
            : List<dynamic>.from(productImage!.map((x) => x.toJson())),
        "product_option": productOption == null
            ? []
            : List<dynamic>.from(productOption!.map((x) => x.toJson())),
      };
}

class ProductDescription {
  String? name;
  String? metaTitle;

  ProductDescription({
    this.name,
    this.metaTitle,
  });

  factory ProductDescription.fromJson(Map<String, dynamic> json) =>
      ProductDescription(
        name: json["name"],
        metaTitle: json["meta_title"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "meta_title": metaTitle,
        "language_id": 1,
      };
}

class ProductImage {
  String? image;
  int? sortOrder;

  ProductImage({
    this.image,
    this.sortOrder,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) => ProductImage(
        image: json["image"],
        sortOrder: json["sort_order"],
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "sort_order": sortOrder,
      };
}

class ProductOption {
  String? optionId;
  String? required;
  List<ProductOptionValueAddModel>? productOptionValue;
  String? value;

  ProductOption({
    this.optionId,
    this.required,
    this.productOptionValue,
    this.value,
  });

  factory ProductOption.fromJson(Map<String, dynamic> json) => ProductOption(
        optionId: json["option_id"],
        required: json["required"],
        productOptionValue: json["product_option_value"] == null
            ? []
            : List<ProductOptionValueAddModel>.from(
                json["product_option_value"]!
                    .map((x) => ProductOptionValueAddModel.fromJson(x))),
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "option_id": optionId,
        "required": required,
        "product_option_value": productOptionValue == null
            ? []
            : List<dynamic>.from(productOptionValue!.map((x) => x.toJson())),
        "value": value,
      };
}

class ProductOptionValueAddModel {
  String? optionValueId;
  String? quantity;
  String? subtract;
  String? price;
  String? pricePrefix;
  String? points;
  String? pointsPrefix;
  String? weight;
  String? weightPrefix;

  ProductOptionValueAddModel({
    this.optionValueId,
    this.quantity,
    this.subtract,
    this.price,
    this.pricePrefix,
    this.points,
    this.pointsPrefix,
    this.weight,
    this.weightPrefix,
  });

  factory ProductOptionValueAddModel.fromJson(Map<String, dynamic> json) =>
      ProductOptionValueAddModel(
        optionValueId: json["option_value_id"],
        quantity: json["quantity"],
        subtract: json["subtract"],
        price: json["price"]?.toDouble(),
        pricePrefix: json["price_prefix"],
        points: json["points"],
        pointsPrefix: json["points_prefix"],
        weight: json["weight"]?.toDouble(),
        weightPrefix: json["weight_prefix"],
      );

  Map<String, dynamic> toJson() => {
        "option_value_id": optionValueId,
        "quantity": quantity,
        "subtract": subtract,
        "price": price,
        "price_prefix": pricePrefix,
        "points": points,
        "points_prefix": pointsPrefix,
        "weight": weight,
        "weight_prefix": weightPrefix,
      };
}

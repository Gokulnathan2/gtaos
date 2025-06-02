class DynamicSelector {
  DynamicSelector({
    this.productId,
    this.qcustomerId,
    this.name,
    this.model,
    this.option,
    this.cost,
    this.price,
  });

  String? productId;
  dynamic qcustomerId;
  String? name;
  String? model;
  List<Option>? option;
  dynamic cost;
  String? price;

  factory DynamicSelector.fromJson(Map<String, dynamic> json) =>
      DynamicSelector(
        productId: json["product_id"],
        qcustomerId: json["qcustomer_id"],
        name: json["name"],
        model: json["model"],
        option: json["option"] == null
            ? []
            : List<Option>.from(json["option"]!.map((x) => Option.fromJson(x))),
        cost: json["cost"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "qcustomer_id": qcustomerId,
        "name": name,
        "model": model,
        "option": option == null
            ? []
            : List<dynamic>.from(option!.map((x) => x.toJson())),
        "cost": cost,
        "price": price,
      };
}

class Option {
  Option({
    this.productOptionId,
    this.productOptionValue,
    this.optionId,
    this.name,
    this.type,
    this.value,
    this.required,
  });

  String? productOptionId;
  List<ProductOptionValue>? productOptionValue;
  String? optionId;
  String? name;
  String? type;
  String? value;
  String? required;

  factory Option.fromJson(Map<String, dynamic> json) => Option(
        productOptionId: json["product_option_id"],
        productOptionValue: json["product_option_value"] == null
            ? []
            : List<ProductOptionValue>.from(json["product_option_value"]!
                .map((x) => ProductOptionValue.fromJson(x))),
        optionId: json["option_id"],
        name: json["name"],
        type: json["type"],
        value: json["value"],
        required: json["required"],
      );

  Map<String, dynamic> toJson() => {
        "product_option_id": productOptionId,
        "product_option_value": productOptionValue == null
            ? []
            : List<dynamic>.from(productOptionValue!.map((x) => x.toJson())),
        "option_id": optionId,
        "name": name,
        "type": type,
        "value": value,
        "required": required,
      };
}

class ProductOptionValue {
  ProductOptionValue({
    this.productOptionValueId,
    this.optionValueId,
    this.name,
    this.price,
    this.pricePrefix,
  });

  String? productOptionValueId;
  String? optionValueId;
  String? name;
  String? price;
  String? pricePrefix;

  factory ProductOptionValue.fromJson(Map<String, dynamic> json) =>
      ProductOptionValue(
        productOptionValueId: json["product_option_value_id"],
        optionValueId: json["option_value_id"],
        name: json["name"],
        price: json["price"].toString(),
        pricePrefix: json["price_prefix"],
      );

  Map<String, dynamic> toJson() => {
        "product_option_value_id": productOptionValueId,
        "option_value_id": optionValueId,
        "name": name,
        "price": price,
        "price_prefix": pricePrefix,
      };
}

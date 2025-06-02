class ProductForUpdate {
  int? success;
  List<dynamic>? error;
  Data? data;

  ProductForUpdate({
    this.success,
    this.error,
    this.data,
  });

  factory ProductForUpdate.fromJson(Map<String, dynamic> json) =>
      ProductForUpdate(
        success: json["success"],
        error: json["error"] == null
            ? []
            : List<dynamic>.from(json["error"]!.map((x) => x)),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "error": error == null ? [] : List<dynamic>.from(error!.map((x) => x)),
        "data": data?.toJson(),
      };
}

class Data {
  String? productId;
  String? model;
  String? sku;
  String? upc;
  String? ean;
  String? jan;
  String? isbn;
  String? mpn;
  String? location;
  String? quantity;
  String? stockStatusId;
  String? image;
  String? manufacturerId;
  String? shipping;
  String? price;
  String? points;
  String? taxClassId;
  DateTime? dateAvailable;
  String? weight;
  String? weightClassId;
  String? length;
  String? width;
  String? height;
  String? lengthClassId;
  String? subtract;
  String? minimum;
  String? sortOrder;
  String? status;
  String? viewed;
  DateTime? dateAdded;
  String? dateModified;
  String? languageId;
  String? name;
  String? description;
  String? tag;
  String? metaTitle;
  String? metaDescription;
  String? metaKeyword;
  String? vendorId;
  String? cproductId;

  Data({
    this.productId,
    this.model,
    this.sku,
    this.upc,
    this.ean,
    this.jan,
    this.isbn,
    this.mpn,
    this.location,
    this.quantity,
    this.stockStatusId,
    this.image,
    this.manufacturerId,
    this.shipping,
    this.price,
    this.points,
    this.taxClassId,
    this.dateAvailable,
    this.weight,
    this.weightClassId,
    this.length,
    this.width,
    this.height,
    this.lengthClassId,
    this.subtract,
    this.minimum,
    this.sortOrder,
    this.status,
    this.viewed,
    this.dateAdded,
    this.dateModified,
    this.languageId,
    this.name,
    this.description,
    this.tag,
    this.metaTitle,
    this.metaDescription,
    this.metaKeyword,
    this.vendorId,
    this.cproductId,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        productId: json["product_id"],
        model: json["model"],
        sku: json["sku"],
        upc: json["upc"],
        ean: json["ean"],
        jan: json["jan"],
        isbn: json["isbn"],
        mpn: json["mpn"],
        location: json["location"],
        quantity: json["quantity"],
        stockStatusId: json["stock_status_id"],
        image: json["image"],
        manufacturerId: json["manufacturer_id"],
        shipping: json["shipping"],
        price: json["price"],
        points: json["points"],
        taxClassId: json["tax_class_id"],
        dateAvailable: json["date_available"] == null
            ? null
            : DateTime.parse(json["date_available"]),
        weight: json["weight"],
        weightClassId: json["weight_class_id"],
        length: json["length"],
        width: json["width"],
        height: json["height"],
        lengthClassId: json["length_class_id"],
        subtract: json["subtract"],
        minimum: json["minimum"],
        sortOrder: json["sort_order"],
        status: json["status"],
        viewed: json["viewed"],
        dateAdded: json["date_added"] == null
            ? null
            : DateTime.parse(json["date_added"]),
        dateModified: json["date_modified"],
        languageId: json["language_id"],
        name: json["name"],
        description: json["description"],
        tag: json["tag"],
        metaTitle: json["meta_title"],
        metaDescription: json["meta_description"],
        metaKeyword: json["meta_keyword"],
        vendorId: json["vendor_id"],
        cproductId: json["cproduct_id"],
      );

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "model": model,
        "sku": sku,
        "upc": upc,
        "ean": ean,
        "jan": jan,
        "isbn": isbn,
        "mpn": mpn,
        "location": location,
        "quantity": quantity,
        "stock_status_id": stockStatusId,
        "image": image,
        "manufacturer_id": manufacturerId,
        "shipping": shipping,
        "price": price,
        "points": points,
        "tax_class_id": taxClassId,
        "date_available":
            "${dateAvailable!.year.toString().padLeft(4, '0')}-${dateAvailable!.month.toString().padLeft(2, '0')}-${dateAvailable!.day.toString().padLeft(2, '0')}",
        "weight": weight,
        "weight_class_id": weightClassId,
        "length": length,
        "width": width,
        "height": height,
        "length_class_id": lengthClassId,
        "subtract": subtract,
        "minimum": minimum,
        "sort_order": sortOrder,
        "status": status,
        "viewed": viewed,
        "date_added": dateAdded?.toIso8601String(),
        "date_modified": dateModified,
        "language_id": languageId,
        "name": name,
        "description": description,
        "tag": tag,
        "meta_title": metaTitle,
        "meta_description": metaDescription,
        "meta_keyword": metaKeyword,
        "vendor_id": vendorId,
        "cproduct_id": cproductId,
      };
}

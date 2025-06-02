class UpdatePacModel {
  UpdatePacModel(
      {this.notes,
      this.taskId,
      this.linkId,
      this.vendorId,
      this.attachname,
      this.attachpath,
      this.taskStatusId,
      this.taskstatus,
      this.firstName,
      this.lat,
      this.lan,
      this.ip,
      this.vtaskId,
      this.productList,
      this.shippingCost,
      this.employeeId});

  String? notes;
  String? taskId;
  String? vtaskId;
  String? linkId;
  String? vendorId;
  String? employeeId;
  String? attachname;
  String? attachpath;
  String? taskStatusId;
  String? taskstatus;
  String? firstName;
  String? lat;
  String? lan;
  String? ip;
  String? shippingCost;

  List<ProductList>? productList;
  String get totalPrice {
    num toAddPrice = 0;
    num sc = 0;

    if (shippingCost != null && shippingCost!.isNotEmpty) {
      sc = num.parse(shippingCost!);
    }
    if (productList != null && productList!.isNotEmpty) {
      toAddPrice = productList!
          .map((e) => num.parse(e.totalPrice))
          .reduce((value, element) => value + element);
    }
    return (toAddPrice + sc).toString();
  }

  factory UpdatePacModel.fromJson(Map<String, dynamic> json) => UpdatePacModel(
        notes: json["notes"],
        taskId: json["task_id"],
        shippingCost: json["shipping"],
        vtaskId: json["v_task_id"],
        linkId: json["link_id"],
        vendorId: json["vendor_id"],
        employeeId: json["employee_id"],
        attachname: json["attachname"],
        attachpath: json["attachpath"],
        taskStatusId: json["task_status_id"],
        taskstatus: json["taskstatus"],
        firstName: json["firstName"],
        lat: json["lat"],
        lan: json["lan"],
        ip: json["ip"],
        productList: json["product_list"] == null
            ? []
            : (List<ProductList>.from(
                json["product_list"]!.map((x) => ProductList.fromJson(x)))),
      );

  Map<String, dynamic> toJson() => {
        "notes": notes,
        "task_id": taskId,
        "total": totalPrice,
        "shipping": shippingCost,
        "v_task_id": vtaskId,
        "link_id": linkId,
        "vendor_id": vendorId,
        "employee_id": employeeId,
        "attachname": attachname,
        "attachpath": attachpath,
        "task_status_id": taskStatusId,
        "taskstatus": taskstatus,
        "firstName": firstName,
        "lat": lat,
        "lon": lan,
        "ip": ip,
        "product_list": productList == null
            ? []
            : (List<dynamic>.from(productList!.map((x) => x.toJson()))),
      };
}

class ProductList {
  ProductList({
    this.productId,
    this.vendorId,
    this.employeeId,
    this.taskId,
    this.instyes,
    this.vTaskId,
    this.firstName,
    this.paccsName,
    this.message,
    this.taskstatus,
    this.taskstatusId,
    this.option,
    this.price,
    this.shippingCost,
    this.quantity,
  });

  String? productId;
  String? vendorId;
  String? employeeId;
  String? taskId;
  String? instyes;
  String? vTaskId;
  String? firstName;
  String? paccsName;
  String? message;
  int? quantity;
  String? price;
  String? shippingCost;
  String? taskstatus;
  String? taskstatusId;
  List<FieldOption>? option;

  String get totalPrice {
    num toAddPrice = 0;
    num times = 0;
    if (price != null && price!.isNotEmpty) {
      toAddPrice = num.parse(price!);
    }
    if (quantity != null) {
      times = quantity!;
    }
    return ((toAddPrice * times)).toString();
  }

  factory ProductList.fromJson(Map<String, dynamic> json) => ProductList(
        productId: json["product_id"],
        shippingCost: json["shippingCost"] ?? "0",
        price: json["price"] ?? "0",
        vendorId: json["vendor_id"],
        employeeId: json["employee_id"],
        taskId: json["task_id"],
        instyes: json["instyes"],
        vTaskId: json["v_task_id"],
        firstName: json["firstName"],
        paccsName: json["paccs_name"],
        message: json["message"],
        taskstatus: json["taskstatus"],
        taskstatusId: json["taskstatus_id"],
        option: json["option"] == null
            ? []
            : List<FieldOption>.from(
                json["option"]!.map((x) => FieldOption.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "quantity": quantity,
        "vendor_id": vendorId,
        "employee_id": employeeId,
        "task_id": taskId,
        "instyes": instyes,
        "v_task_id": vTaskId,
        "firstName": firstName,
        "paccs_name": paccsName,
        "message": message,
        "price": price,
        "taskstatus": taskstatus,
        "taskstatus_id": taskstatusId,
        "option": option == null
            ? []
            : (List<dynamic>.from(option!.map((x) => x.toJson()))),
      };
}

class FieldOption {
  FieldOption({
    this.productOptionId,
    this.productOptionValueId,
    this.optionId,
    this.name,
    this.type,
    this.value,
  });

  String? productOptionId;
  String? productOptionValueId;
  String? optionId;
  String? name;
  String? type;
  String? value;

  factory FieldOption.fromJson(Map<String, dynamic> json) => FieldOption(
        productOptionId: json["product_option_id"],
        productOptionValueId: json["product_option_value_id"],
        optionId: json["option_id"],
        name: json["name"],
        type: json["type"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "product_option_id": productOptionId,
        "product_option_value_id": productOptionValueId,
        "option_id": optionId,
        "name": name,
        "type": type,
        "value": value,
      };
}

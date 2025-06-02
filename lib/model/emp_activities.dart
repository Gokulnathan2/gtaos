class EmployeeActivities {
  EmployeeActivities({
    this.success,
    this.error,
    this.data,
  });

  int? success;
  List<dynamic>? error;
  ActivityData? data;

  factory EmployeeActivities.fromJson(Map<String, dynamic> json) =>
      EmployeeActivities(
        success: json["success"],
        error: json["error"] == null
            ? []
            : List<dynamic>.from(json["error"]!.map((x) => x)),
        data: json["data"] == null ? null : ActivityData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "error": error == null ? [] : List<dynamic>.from(error!.map((x) => x)),
        "data": data?.toJson(),
      };
}

class ActivityData {
  ActivityData({
    this.activities,
  });

  List<Workdata>? activities;

  factory ActivityData.fromJson(Map<String, dynamic> json) => ActivityData(
        activities: json["activities"] == null
            ? []
            : List<Workdata>.from(
                json["activities"]!.map((x) => Workdata.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "activities": activities == null
            ? []
            : List<dynamic>.from(activities!.map((x) => x.toJson())),
      };
}

class Workdata {
  Workdata({
    this.serialno,
    this.taskname,
    this.taskId,
    this.products,
    this.employeeId,
  });

  int? serialno;
  String? taskname;
  String? taskId;
  List<Product>? products;
  String? employeeId;

  factory Workdata.fromJson(Map<String, dynamic> json) => Workdata(
        serialno: json["serialno"],
        taskname: json["taskname"],
        taskId: json["task_id"],
        products: json["products"] == null
            ? []
            : List<Product>.from(
                json["products"]!.map((x) => Product.fromJson(x))),
        employeeId: json["employee_id"],
      );

  Map<String, dynamic> toJson() => {
        "serialno": serialno,
        "taskname": taskname,
        "task_id": taskId,
        "products": products == null
            ? []
            : List<dynamic>.from(products!.map((x) => x.toJson())),
        "employee_id": employeeId,
      };
}

class Product {
  Product({
    this.model,
    this.productname,
    this.productoptionvalue,
    this.productId,
    this.completed,
    this.attachname,
    this.attachpath,
    this.note,
    this.dateAdded,
  });

  String? model;
  String? productname;
  List<Productoptionvalue>? productoptionvalue;
  String? productId;
  String? completed;
  String? attachname;
  String? attachpath;
  String? note;
  String? dateAdded;
bool get isCompleted => (completed??"")=='1';
  factory Product.fromJson(Map<String, dynamic> json) => Product(
        model: json["model"],
        productname: json["productname"],
        productoptionvalue: json["productoptionvalue"] == null
            ? []
            : List<Productoptionvalue>.from(json["productoptionvalue"]!
                .map((x) => Productoptionvalue.fromJson(x))),
        productId: json["product_id"],
        completed: json["completed"],
        attachname: json["attachname"],
        attachpath: json["attachpath"],
        note: json["note"],
        dateAdded: json["date_added"],
      );

  Map<String, dynamic> toJson() => {
        "model": model,
        "productname": productname,
        "productoptionvalue": productoptionvalue == null
            ? []
            : List<dynamic>.from(productoptionvalue!.map((x) => x.toJson())),
        "product_id": productId,
        "completed": completed,
        "attachname": attachname,
        "attachpath": attachpath,
        "note": note,
        "date_added": dateAdded,
      };
}

class Productoptionvalue {
  Productoptionvalue({
    this.value,
    this.name,
  });

  String? value;
  String? name;

  factory Productoptionvalue.fromJson(Map<String, dynamic> json) =>
      Productoptionvalue(
        value: json["value"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "value": value,
        "name": name,
      };
}

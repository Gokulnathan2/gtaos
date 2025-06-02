class EmployeList {
  EmployeList({
    required this.success,
    required this.error,
    required this.data,
  });

  int success;
  List<dynamic> error;
  List<Datum> data;

  factory EmployeList.fromJson(Map<String, dynamic> json) => EmployeList(
        success: json["success"],
        error: List<dynamic>.from(json["error"].map((x) => x)),
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "error": List<dynamic>.from(error.map((x) => x)),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    required this.employeeId,
    required this.name,
  });

  String employeeId;
  String name;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        employeeId: json["employee_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "employee_id": employeeId,
        "name": name,
      };
}

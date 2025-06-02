class StatusList {
  StatusList({
    required this.success,
    required this.error,
    required this.data,
  });

  int success;
  List<dynamic> error;
  List<Datum> data;

  factory StatusList.fromJson(Map<String, dynamic> json) => StatusList(
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
    required this.statusId,
    required this.vendorId,
    required this.name,
    required this.completed,
    required this.dateAdded,
  });

  String statusId;
  String vendorId;
  String name;
  String completed;
  DateTime dateAdded;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        statusId: json["status_id"],
        vendorId: json["vendor_id"],
        name: json["name"],
        completed: json["completed"],
        dateAdded: DateTime.parse(json["date_added"]),
      );

  Map<String, dynamic> toJson() => {
        "status_id": statusId,
        "vendor_id": vendorId,
        "name": name,
        "completed": completed,
        "date_added":
            "${dateAdded.year.toString().padLeft(4, '0')}-${dateAdded.month.toString().padLeft(2, '0')}-${dateAdded.day.toString().padLeft(2, '0')}",
      };
}

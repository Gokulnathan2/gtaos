class AttendanceStatus {
  AttendanceStatus({
    this.success,
    this.error,
    this.data,
  });

  int? success;
  List<dynamic>? error;
  List<AttendanceMiniObject>? data;

  factory AttendanceStatus.fromJson(Map<String, dynamic> json) =>
      AttendanceStatus(
        success: json["success"],
        error: json["error"] == null
            ? []
            : List<dynamic>.from(json["error"]!.map((x) => x)),
        data: json["data"] == null
            ? []
            : List<AttendanceMiniObject>.from(
                json["data"]!.map((x) => AttendanceMiniObject.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "error": error == null ? [] : List<dynamic>.from(error!.map((x) => x)),
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class AttendanceMiniObject {
  AttendanceMiniObject({
    this.statusId,
    this.vendorId,
    this.name,
    this.completed,
    this.dateAdded,
  });

  String? statusId;
  String? vendorId;
  String? name;
  String? completed;
  DateTime? dateAdded;

  factory AttendanceMiniObject.fromJson(Map<String, dynamic> json) =>
      AttendanceMiniObject(
        statusId: json["status_id"],
        vendorId: json["vendor_id"],
        name: json["name"],
        completed: json["completed"],
        dateAdded: json["date_added"] == null
            ? null
            : DateTime.parse(json["date_added"]),
      );

  Map<String, dynamic> toJson() => {
        "status_id": statusId,
        "vendor_id": vendorId,
        "name": name,
        "completed": completed,
        "date_added":
            "${dateAdded!.year.toString().padLeft(4, '0')}-${dateAdded!.month.toString().padLeft(2, '0')}-${dateAdded!.day.toString().padLeft(2, '0')}",
      };
}

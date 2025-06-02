class AttendanceData {
  AttendanceData({
    this.success,
    this.error,
    this.data,
  });

  int? success;
  List<dynamic>? error;
  List<Datum>? data;

  factory AttendanceData.fromJson(Map<String, dynamic> json) => AttendanceData(
        success: json["success"],
        error: json["error"] == null
            ? []
            : List<dynamic>.from(json["error"]!.map((x) => x)),
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "error": error == null ? [] : List<dynamic>.from(error!.map((x) => x)),
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.attendanceId,
    this.details,
    this.inorout,
    this.employeeno,
    this.employeeId,
    this.employeeName,
    this.vTaskIds,
    this.taskName,
    this.currentTaskId,
    this.currentVtaskId,
    this.message,
    this.location,
    this.createdBy,
    this.vendorId,
    this.vendorName,
    this.dateAdded,
  });

  String? attendanceId;
  String? details;
  String? inorout;
  dynamic employeeno;
  String? employeeId;
  String? employeeName;
  String? vTaskIds;
  dynamic taskName;
  String? currentTaskId;
  String? currentVtaskId;
  String? message;
  String? location;
  String? createdBy;
  String? vendorId;
  String? vendorName;
  DateTime? dateAdded;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        attendanceId: json["attendance_id"],
        details: json["details"],
        inorout: json["inorout"],
        employeeno: json["employeeno"],
        employeeId: json["employee_id"],
        employeeName: json["employee_name"],
        vTaskIds: json["v_task_ids"],
        taskName: json["task_name"],
        currentTaskId: json["current_task_id"],
        currentVtaskId: json["current_vtask_id"],
        message: json["message"],
        location: json["location"],
        createdBy: json["created_by"],
        vendorId: json["vendor_id"],
        vendorName: json["vendor_name"],
        dateAdded: json["date_added"] == null
            ? null
            : DateTime.parse(json["date_added"]),
      );

  Map<String, dynamic> toJson() => {
        "attendance_id": attendanceId,
        "details": details,
        "inorout": inorout,
        "employeeno": employeeno,
        "employee_id": employeeId,
        "employee_name": employeeName,
        "v_task_ids": vTaskIds,
        "task_name": taskName,
        "current_task_id": currentTaskId,
        "current_vtask_id": currentVtaskId,
        "message": message,
        "location": location,
        "created_by": createdBy,
        "vendor_id": vendorId,
        "vendor_name": vendorName,
        "date_added": dateAdded?.toIso8601String(),
      };
}

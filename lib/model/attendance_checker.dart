class AttendanceChecker {
  AttendanceChecker({
    required this.success,
    required this.error,
    required this.data,
  });

  bool success;
  List<dynamic> error;
  AttendancechekerData data;

  factory AttendanceChecker.fromJson(Map<String, dynamic> json) =>
      AttendanceChecker(
        success: json["success"] == 1,
        error: List<dynamic>.from(json["error"].map((x) => x)),
        data: AttendancechekerData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "error": List<dynamic>.from(error.map((x) => x)),
        "data": data.toJson(),
      };
}

class AttendancechekerData {
  AttendancechekerData({
    required this.employeeId,
    required this.attendance,
    required this.supervisor,
  });

  String employeeId;
  bool attendance;
  bool supervisor;

  factory AttendancechekerData.fromJson(Map<String, dynamic> json) => AttendancechekerData(
        employeeId: json["employee_id"] ?? "",
        attendance: json["employee_id"] != null && json["attendance"] == 1,
        supervisor: json["employee_id"] != null && json["supervisor"] == 1,
      );

  Map<String, dynamic> toJson() => {
        "employee_id": employeeId,
        "attendance": attendance,
        "supervisor": supervisor,
      };
}

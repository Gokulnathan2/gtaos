class PacHistory {
  PacHistory({
    required this.success,
    required this.error,
    required this.data,
  });

  int success;
  List<dynamic> error;
  List<Datum> data;

  factory PacHistory.fromJson(Map<String, dynamic> json) => PacHistory(
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
    required this.etaskHistoryId,
    required this.taskId,
    required this.vTaskId,
    required this.employeeId,
    required this.userName,
    required this.vendorId,
    required this.notify,
    required this.taskstatus,
    required this.taskStatusId,
    required this.message,
    required this.dateAdded,
  });

  String etaskHistoryId;
  String taskId;
  String vTaskId;
  String employeeId;
  String userName;
  String vendorId;
  String notify;
  String taskstatus;
  String taskStatusId;
  String message;
  DateTime dateAdded;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        etaskHistoryId: json["etask_history_id"],
        taskId: json["task_id"],
        vTaskId: json["v_task_id"],
        employeeId: json["employee_id"],
        userName: json["user_name"],
        vendorId: json["vendor_id"],
        notify: json["notify"],
        taskstatus: json["taskstatus"],
        taskStatusId: json["task_status_id"],
        message: json["message"],
        dateAdded: DateTime.parse(json["date_added"]),
      );

  Map<String, dynamic> toJson() => {
        "etask_history_id": etaskHistoryId,
        "task_id": taskId,
        "v_task_id": vTaskId,
        "employee_id": employeeId,
        "user_name": userName,
        "vendor_id": vendorId,
        "notify": notify,
        "taskstatus": taskstatus,
        "task_status_id": taskStatusId,
        "message": message,
        "date_added": dateAdded.toIso8601String(),
      };
}

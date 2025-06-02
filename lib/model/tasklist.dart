class EmpTaskList {
  EmpTaskList({
    this.success,
    this.error,
    this.data,
  });

  int? success;
  List<dynamic>? error;
  List<TaskListDatum>? data;

  factory EmpTaskList.fromJson(Map<String, dynamic> json) => EmpTaskList(
        success: json["success"],
        error: json["error"] == null
            ? []
            : List<dynamic>.from(json["error"]!.map((x) => x)),
        data: json["data"] == null
            ? []
            : List<TaskListDatum>.from(
                json["data"]!.map((x) => TaskListDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "error": error == null ? [] : List<dynamic>.from(error!.map((x) => x)),
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class TaskListDatum {
  TaskListDatum({
    this.taskstatus,
    this.orderStatusId,
    this.subject,
    this.taskId,
    this.vTaskId,
  });

  String? taskstatus;
  String? orderStatusId;
  String? subject;
  String? taskId;
  String? vTaskId;

  factory TaskListDatum.fromJson(Map<String, dynamic> json) => TaskListDatum(
        taskstatus: json["taskstatus"],
        orderStatusId: json["order_status_id"],
        subject: json["subject"],
        taskId: json["task_id"],
        vTaskId: json["v_task_id"],
      );

  Map<String, dynamic> toJson() => {
        "taskstatus": taskstatus,
        "order_status_id": orderStatusId,
        "subject": subject,
        "task_id": taskId,
        "v_task_id": vTaskId,
      };
}

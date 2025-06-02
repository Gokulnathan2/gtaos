class PacList {
  PacList({
    required this.success,
    required this.error,
    required this.data,
  });

  int success;
  List<dynamic> error;
  List<Datum> data;

  factory PacList.fromJson(Map<String, dynamic> json) => PacList(
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
    required this.vendorId,
    required this.startOn,
    required this.dateAdded,
    required this.subject,
    required this.taskId,
    required this.refno,
    required this.taskstatus,
    required this.sdsCode,
  });

  String vendorId;
  DateTime startOn;
  DateTime dateAdded;
  String subject;
  String taskId;
  String refno;
  String taskstatus;
  String sdsCode;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        vendorId: json["vendor_id"],
        startOn: DateTime.parse(json["start_on"] ?? "2222-02-02"),
        dateAdded: DateTime.parse(json["date_added"] ?? "2222-02-02"),
        subject: json["subject"] ?? "null",
        taskId: json["task_id"] ?? "null",
        refno: json["refno"] ?? "null",
        taskstatus: json["taskstatus"] ?? "null",
        sdsCode: json["sds_code"] ?? "null",
      );

  Map<String, dynamic> toJson() => {
        "vendor_id": vendorId,
        "start_on": startOn.toIso8601String(),
        "date_added":
            "${dateAdded.year.toString().padLeft(4, '0')}-${dateAdded.month.toString().padLeft(2, '0')}-${dateAdded.day.toString().padLeft(2, '0')}",
        "subject": subject,
        "task_id": taskId,
        "refno": refno,
        "taskstatus": taskstatus,
        "sds_code": sdsCode,
      };
}

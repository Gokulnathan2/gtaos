// ignore_for_file: non_constant_identifier_names

class Addpac {
  String ref_no;
  String project_name;
  String project_id;
  String task_name;
  String task_date;
  String task_status;
  String task_status_id;
  String message;
  String? taskid, link_id, v_task_id;

  Addpac(
      {required this.ref_no,
      required this.project_name,
      required this.project_id,
      required this.task_name,
      required this.task_date,
      required this.task_status,
      required this.task_status_id,
      required this.message,
      this.taskid,
      this.link_id,
      this.v_task_id});

  Addpac copyWith({
    String? ref_no,
    String? project_name,
    String? project_id,
    String? task_name,
    String? task_date,
    String? task_status,
    String? task_status_id,
    String? message,
  }) {
    return Addpac(
      ref_no: ref_no ?? this.ref_no,
      project_name: project_name ?? this.project_name,
      project_id: project_id ?? this.project_id,
      task_name: task_name ?? this.task_name,
      task_date: task_date ?? this.task_date,
      task_status: task_status ?? this.task_status,
      task_status_id: task_status_id ?? this.task_status_id,
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "ref_no": ref_no,
      "project_name": project_name,
      "project_id": project_id,
      "task_name": task_name,
      "task_date": task_date,
      "task_status": task_status,
      "task_status_id": task_status_id,
      "message": message,
    };
  }

  Map<String, dynamic> toUpdateMap() {
    return <String, dynamic>{
      "task_id": taskid,
      "project_name": project_name,
      "project_id": project_id,
      "task_name": task_name,
      "task_date": task_date,
      "task_status": task_status,
      "task_status_id": task_status_id,
      "message": message,
    };
  }

  factory Addpac.fromMap(Map<String, dynamic> map) {
    print(map);
    return Addpac(
      ref_no: map["ref_no"] ?? "",
      project_name: map["project_name"] ?? "",
      project_id: map["project_id"],
      task_name: map["task_name"],
      task_date: map["task_date"],
      task_status: map["task_status"],
      task_status_id: map["task_status_id"],
      message: map["message"] ?? "",
      link_id: map["link_id"],
      v_task_id: map["v_task_id"],
    );
  }

  @override
  String toString() {
    return "Addpac(ref_no: $ref_no, project_name: $project_name, project_id: $project_id, task_name: $task_name, task_date: $task_date, task_status: $task_status, task_status_id: $task_status_id, message: $message)'";
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Addpac &&
        other.ref_no == ref_no &&
        other.project_name == project_name &&
        other.project_id == project_id &&
        other.task_name == task_name &&
        other.task_date == task_date &&
        other.task_status == task_status &&
        other.task_status_id == task_status_id &&
        other.message == message;
  }

  @override
  int get hashCode {
    return ref_no.hashCode ^
        project_name.hashCode ^
        project_id.hashCode ^
        task_name.hashCode ^
        task_date.hashCode ^
        task_status.hashCode ^
        task_status_id.hashCode ^
        message.hashCode;
  }
}

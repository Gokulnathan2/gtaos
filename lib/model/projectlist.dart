class ProjectList {
  ProjectList({
    required this.success,
    required this.error,
    required this.data,
  });

  int success;
  List<dynamic> error;
  List<Datum> data;

  factory ProjectList.fromJson(Map<String, dynamic> json) => ProjectList(
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
    required this.projectId,
    required this.vendorId,
    required this.projectname,
    required this.projecttype,
    required this.startDate,
    required this.proposedDate,
    required this.estimate,
    required this.psId,
    required this.refer,
    required this.dateAdded,
  });

  String projectId;
  String vendorId;
  String projectname;
  String projecttype;
  String startDate;
  String proposedDate;
  String estimate;
  String psId;
  String refer;
  DateTime dateAdded;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        projectId: json["project_id"],
        vendorId: json["vendor_id"],
        projectname: json["projectname"],
        projecttype: json["projecttype"],
        startDate: json["start_date"],
        proposedDate: json["proposed_date"],
        estimate: json["estimate"],
        psId: json["ps_id"],
        refer: json["refer"],
        dateAdded: DateTime.parse(json["date_added"]),
      );

  Map<String, dynamic> toJson() => {
        "project_id": projectId,
        "vendor_id": vendorId,
        "projectname": projectname,
        "projecttype": projecttype,
        "start_date": startDate,
        "proposed_date": proposedDate,
        "estimate": estimate,
        "ps_id": psId,
        "refer": refer,
        "date_added":
            "${dateAdded.year.toString().padLeft(4, '0')}-${dateAdded.month.toString().padLeft(2, '0')}-${dateAdded.day.toString().padLeft(2, '0')}",
      };
}

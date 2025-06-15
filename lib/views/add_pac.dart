import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gtaos/utils/colors.dart';
import 'package:gtaos/widgets/loading_overlay.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:gtaos/helper/network.dart';
import 'package:gtaos/model/add.dart';
import 'package:gtaos/model/projectlist.dart';
import 'package:gtaos/model/statuslist.dart';
import 'package:gtaos/model/projectlist.dart' as pl;
import 'package:gtaos/model/statuslist.dart' as sl;

// ignore: must_be_immutable
class ManagePad extends StatefulWidget {
  final Addpac? addpac;
  final String? taskId;
  final String? ref;

  const ManagePad({
    Key? key,
    this.addpac,
    this.taskId,
    this.ref,
  }) : super(key: key);

  @override
  State<ManagePad> createState() => _ManagePadState();
}

class _ManagePadState extends State<ManagePad> {
  var refCon = TextEditingController();
  var tackCon = TextEditingController();
  var messageCon = TextEditingController();
  var dateCon = TextEditingController();
  var seed = 1000000000;
 @override
void initState() {
  super.initState();

  final now = DateTime.now();
  final formattedNow = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
  messageCon.text = formattedNow; // Prepopulate message with current date

  addpac = Addpac(
    ref_no: widget.ref ?? "",
    project_name: "",
    project_id: "",
    task_name: "",
    task_date: "",
    task_status: "",
    task_status_id: "",
    message: messageCon.text, // assign same value to model initially
  );

  if (widget.ref == null) {
    addpac.ref_no = refCon.text;
    refCon.text = "EM" + (Random().nextInt(seed) + seed).toString();
  } else {
    refCon.text = widget.ref!;
  }

  WidgetsBinding.instance.addPostFrameCallback((_) {
    getdata();
  });
}


  late Addpac addpac;
  StatusList? statusList;
  ProjectList? projectList;
  getdata() async {
    LoadingOverlay.show(context);
    await Future.wait((Iterable.castFrom([
      if (isEdit)
        networkCaller.getPac(widget.taskId)..then((sl) => addpac = sl),
      networkCaller.getStatusList().then((sl) => statusList = sl),
      networkCaller.getProjectList().then((pl) => projectList = pl)
    ])));
    if (isEdit) {
      project = projectList!.data.firstWhereOrNull(
          (element) => element.projectId == addpac.project_id);
      status = statusList!.data.firstWhereOrNull(
          (element) => element.statusId == addpac.task_status_id);
      addpac.task_status = status?.name ?? "";
      addpac.project_name = project?.projectname ?? "";
      tackCon.text = addpac.task_name;
      dateCon.text = addpac.task_date;
      dateTime = DateTime.parse(addpac.task_date);
    }
    LoadingOverlay.dismiss();

    if (mounted) setState(() {});
  }

  bool get isEdit => widget.taskId != null;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Edit Task" : 'Add Task'),
      ),
      body: ListView(
        children: [
          if (!isEdit)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                readOnly: isEdit,
                controller: refCon,
                decoration:_getInputDecoration("Refrence No *") ,
              ),
            ),
          if (projectList != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField(
                value: project,
                decoration:  _getInputDecoration('Project'),
                items: [
                  ...projectList!.data
                      .map<DropdownMenuItem<pl.Datum>>((e) => DropdownMenuItem(
                            child: Text(e.projectname),
                            value: e,
                          ))
                      .toList()
                ],
                onChanged: (pl.Datum? value) {
                  project = value;
                  setState(() {});
                },
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: tackCon,
              decoration: _getInputDecoration("Task *"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: messageCon,
              maxLines: 3,
              decoration: _getInputDecoration("Message *"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              readOnly: true,
              controller: dateCon,
              onTap: () async {
                var dt = await showDatePicker(
                    context: context,
                    initialDate: dateTime ?? DateTime.now(),
                    firstDate: DateTime.now().subtract(Duration(days: 1000)),
                    lastDate: DateTime.now().add(Duration(days: 1000)));
                if (dt != null) {
                  dateTime = dt;
                  dateCon.text = DateFormat("yyyy-MM-dd HH:mm:ss").format(dt);
                  setState(() {});
                }
              },
              decoration:_getInputDecoration("Date of Task"),
            ),
          ),
          if (statusList != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField(
                value: status,
                decoration: _getInputDecoration("Task Status"),
                items: [
                  ...statusList!.data
                      .map<DropdownMenuItem<sl.Datum>>((e) => DropdownMenuItem(
                            child: Text(e.name),
                            value: e,
                          ))
                      .toList()
                ],
                onChanged: (sl.Datum? value) {
                  status = value;
                  setState(() {});
                },
              ),
            ),
            Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
  child: SizedBox(
    width: double.infinity,
    child: ElevatedButton.icon(
      icon: Icon(isEdit ? Icons.edit : Icons.add, color: Colors.white),
      label: Text(
        isEdit ? "UPDATE TASK" : "ADD TASK",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          letterSpacing: 1.2,
          color: Colors.white,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Appcolors.primary2, // Teal tone
        padding: EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 6,
      ),
      onPressed: () async {
        if (project != null && status != null) {
          addpac.project_id = project!.projectId;
          addpac.project_name = project!.projectname;
          addpac.task_name = tackCon.text.trim();
          addpac.task_date = dateCon.text.trim();
          addpac.task_status = status!.name;
          addpac.task_status_id = status!.statusId;
          addpac.ref_no = refCon.text.trim();
          addpac.message = messageCon.text.trim();
          if (isEdit) {
            addpac.taskid = widget.taskId;
          }
          try {
            LoadingOverlay.show(context);
            if (isEdit)
              await networkCaller.updatePacs(addpac);
            else
              await networkCaller.addPacs(addpac);
          } catch (e) {
            print(e);
          }
          setState(() {});
          LoadingOverlay.dismiss();
          Navigator.pop(context);
        }
      },
    ),
  ),
),

          // FractionallySizedBox(
          //   widthFactor: .5,
          //   child: ElevatedButton(
          //       style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          //       onPressed: () async {
          //         if (project != null && status != null) {
          //           addpac.project_id = project!.projectId;
          //           addpac.project_name = project!.projectname;
          //           addpac.task_name = tackCon.text.trim();
          //           addpac.task_date = dateCon.text.trim();
          //           addpac.task_status = status!.name;
          //           addpac.task_status_id = status!.statusId;
          //           addpac.ref_no = refCon.text.trim();
          //           addpac.message = messageCon.text.trim();
          //           if (isEdit) {
          //             addpac.taskid = widget.taskId;
          //           }
          //           try {
          //             LoadingOverlay.show(context);
          //             if (isEdit)
          //               await networkCaller.updatePacs(addpac);
          //             else
          //               await networkCaller.addPacs(addpac);
          //           } catch (e) {
          //             print(e);
          //           }
          //           setState(() {});
          //           LoadingOverlay.dismiss();

          //           Navigator.pop(context);
          //         }
          //       },
          //       child: Text(isEdit ? "Update" : "Add")),
          // )
        ],
      ),
    );
  }

  DateTime? dateTime;
  sl.Datum? status;
  pl.Datum? project;
}


 InputDecoration _getInputDecoration(String labelText, {String? hintText}) {
    return InputDecoration(
      isDense: true,
      hintText: hintText,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 20,vertical: 12.0),
      hintStyle: TextStyle(
        fontFamily: 'Raleway',
        fontSize: 14,
        color: Colors.grey.shade600,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide:
            BorderSide(color: Appcolors.primary2), // Highlight on focus
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      errorStyle: const TextStyle(
        fontFamily: 'Raleway',
        fontSize: 11,
        color: Colors.red,
      ),
      labelText: labelText,
      labelStyle: TextStyle(color: Colors.grey.shade700),
    );
  }

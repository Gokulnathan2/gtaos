import 'dart:async';
import 'dart:developer';

import 'package:easy_web_view/easy_web_view.dart';
import 'package:flutter/material.dart';
import 'package:gtaos/widgets/loading_overlay.dart';
import 'package:intl/intl.dart';
import 'package:gtaos/helper/network.dart';
import 'package:gtaos/model/attendance.dart';
import 'package:gtaos/model/attendancestatus.dart' as ad;
import 'package:gtaos/views/history.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:gtaos/model/employelist.dart' as em;

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  AttendanceData? attendanceData;
  Map<String, List<Datum>> attendanceDatas = {};
  bool hasAttendedLoggedOut = false;
  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final String timeZoneId = 'Asia/Kolkata';
    var loc = tz.getLocation(timeZoneId);
    dateTime = tz.TZDateTime.from(DateTime.now(), loc);
    log(dateTime.toString());
    getAsync();
    startTImer();
  }

  startTImer() {
    if (timer == null) {
      timer = Timer.periodic(Duration(seconds: 5), (timer) {
        getAsync(true);
      });
    } else {
      if (!(timer!.isActive)) {
        timer = Timer.periodic(Duration(seconds: 5), (timer) {
          getAsync(true);
        });
      }
    }
  }

  Timer? timer;
  late DateTime dateTime;
  logoutted() async {
    hasAttendedLoggedOut = await networkCaller.getSigninStatus();
    setState(() {});
  }

  getAsync([noREset = false]) async {
    try {
      if (!networkCaller.isAdminMode) await logoutted();

    // ✅ Always clear previous data to avoid duplication
    attendanceDatas.clear();
    attendanceData = null;

   

      setState(() {});
      if (!noREset) attendanceDatas = {};
      attendanceData = await networkCaller.getUserAttendance(
          DateFormat("yyyy-MM-dd").format(dateTime),
          selectedEmployee?.employeeId);
      for (var element in attendanceData!.data!) {
        if (attendanceDatas[element.employeeName!] == null)
          attendanceDatas[element.employeeName!] = [element];
        else
          attendanceDatas[element.employeeName!]!.add(element);
      }
    } catch (e) {
      print(e);
    }
    if (mounted) setState(() {});
  }

  getbody() {
    if (attendanceData == null)
      return Center(
          child: CircularProgressIndicator(backgroundColor: Colors.orange));
    else {
      if (attendanceData!.data!.isEmpty)
        return RefreshIndicator(
          onRefresh: () {
            return getAsync();
          },
          child: Column(
            children: [
              ListTile(
                onTap: () async {
                  var dt = await showDatePicker(
                      context: context,
                      initialDate: dateTime,
                      firstDate: DateTime.now().subtract(Duration(days: 1000)),
                      lastDate: DateTime.now().add(Duration(days: 1000)));
                  if (dt != null) {
                    dateTime = dt;
                    LoadingOverlay.show(context);
                    await getAsync();
                    timer?.cancel();
                    LoadingOverlay.dismiss();

                    setState(() {});
                  }
                },
                trailing: const Icon(Icons.calendar_month),
                title: Text("Filter"),
                subtitle: Text(DateFormat("yyyy-MM-dd").format(dateTime)),
              ),
              if (selectedEmployee != null)
                ListTile(
                  onTap: () async {
                    selectedEmployee = null;
                    LoadingOverlay.show(context);
                    await getAsync();
                    startTImer();
                    LoadingOverlay.dismiss();
                    setState(() {});
                  },
                  trailing: const Icon(Icons.clear),
                  title: Text("Filtered Employee"),
                  subtitle: Text(selectedEmployee!.name),
                ),
              Spacer(),
              Center(child: Text("No Attendance")),
              Spacer(),
            ],
          ),
        );
      else
        return Column(
          children: [
            Card(
              child: Column(
                children: <Widget>[
                  ListTile(
                    onTap: () async {
                      var dt = await showDatePicker(
                          context: context,
                          initialDate: dateTime,
                          firstDate:
                              DateTime.now().subtract(Duration(days: 1000)),
                          lastDate: DateTime.now().add(Duration(days: 1000)));
                      if (dt != null) {
                        dateTime = dt;
                        LoadingOverlay.show(context);
                        await getAsync();
                        timer?.cancel();

                        LoadingOverlay.dismiss();

                        setState(() {});
                      }
                    },
                    trailing: const Icon(Icons.calendar_month),
                    title: Text("Filter"),
                    subtitle: Text(DateFormat("yyyy-MM-dd").format(dateTime)),
                  ),
                  if (selectedEmployee != null)
                    ListTile(
                      onTap: () async {
                        selectedEmployee = null;
                        LoadingOverlay.show(context);
                        await getAsync();
                        startTImer();

                        LoadingOverlay.dismiss();
                        setState(() {});
                      },
                      trailing: const Icon(Icons.clear),
                      title: Text("Filtered Employee"),
                      subtitle: Text(selectedEmployee!.name),
                    ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: attendanceDatas.length,
                  itemBuilder: (c, i) => Column(
                        children: <Widget>[
                          ExpansionTile(
                            // subtitle: Text(DateFormat("yyyy/MM/dd HH:mm:ss")
                            //     .format(attendanceDatas!.data![i].dateAdded!)),
                            title: Text(attendanceDatas.keys.toList()[i]),
                            children: [
                              for (var dd in attendanceDatas[
                                  attendanceDatas.keys.toList()[i]]!) ...[
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text(dd.details ?? ""),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: EasyWebView(
                                    key: ValueKey(dd.message),

                                    src: dd.message?.trim() ?? "",
                                    isMarkdown: false, // Use markdown syntax
                                    convertToWidgets:
                                        true, // Try to convert to flutter widgets
                                    height: getHeightByLength(
                                        (attendanceData!.data![i].message ?? "")
                                            .length),
                                  ),
                                ),
                                // Text(
                                //     dd.message?.trim().length.toString() ?? ""),
                                Divider(),
                              ]
                            ],
                          ),
                          // ListTile(
                          //   dense: true,
                          //   title: Text(
                          //       attendanceData!.data![i].employeeName ?? ""),
                          // subtitle: Text(DateFormat("yyyy/MM/dd HH:mm:ss")
                          //     .format(attendanceData!.data![i].dateAdded!)),
                          // ),
                          Divider(),
                        ],
                      )),
            ),
          ],
        );
    }
  }

  List<em.Datum>? all;
  bool searchmode = false;
  em.Datum? selectedEmployee;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: !hasAttendedLoggedOut
            ? null
            : FloatingActionButton.extended(
                onPressed: logoutLogic, label: Text("End Attendance")),
        appBar: AppBar(
          title: searchmode
              ? TextField(
                  onChanged: (v) {
                    all = networkCaller.employeList!.data
                        .where((element) => element.name
                            .toLowerCase()
                            .startsWith(v.toLowerCase()))
                        .toList();
                    setState(() {});
                  },
                  cursorColor: Colors.white,
                  style: TextStyle(color: Colors.white),
                  autofocus: true,
                )
              : Text('Attendance'),
          actions: [
            if (networkCaller.isAdminMode || networkCaller.isSupervisor)
              IconButton(
                  onPressed: () async {
                    all = (await networkCaller.employeeList()).data;

                    setState(() {
                      searchmode = true;
                    });
                  },
                  icon: const Icon(Icons.search))
          ],
        ),
        body: searchmode
            ? ListView.builder(
                itemCount: all?.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    selected: selectedEmployee == all![index],
                    onTap: () async {
                      selectedEmployee = all![index];
                      searchmode = false;
                      timer?.cancel();
                      setState(() {});
                      LoadingOverlay.show(context);
                      await getAsync();
                      LoadingOverlay.dismiss();
                    },
                    leading: const Icon(Icons.person),
                    title: Text(all![index].name),
                  );
                },
              )
            : getbody());
  }

  logoutLogic() {
    showDialog(
        context: context,
        builder: (c) => SimpleDialog(
              title: Text("Are you sure?"),
              children: [
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text("This will log you out")),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("cancel")),
                    SizedBox(width: 10),
                    TextButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          LoadingOverlay.show(context);
                          await networkCaller.logoutAttendance(logoutDatum);
                          await logoutted();
                          LoadingOverlay.dismiss();
                        },
                        child: Text("ok")),
                  ],
                )
              ],
            ));
  }

  ad.AttendanceMiniObject? datum;
  ad.AttendanceMiniObject logoutDatum =
      ad.AttendanceMiniObject(statusId: "1", name: "Logout");
  ad.AttendanceStatus? attendanceStatus;
}

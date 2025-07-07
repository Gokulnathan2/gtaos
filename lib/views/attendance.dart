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
      // timer = Timer.periodic(Duration(seconds: 5), (timer) {
        getAsync(true);
      // });
    } else {
      if (!(timer!.isActive)) {
        // timer = Timer.periodic(Duration(seconds: 5), (timer) {
          getAsync(true);
        // });
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

  Widget _buildDateFilter() {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.all(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () async {
          final dt = await showDatePicker(
            context: context,
            initialDate: dateTime,
            firstDate: DateTime.now().subtract(const Duration(days: 1000)),
            lastDate: DateTime.now().add(const Duration(days: 1000)),
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.light(
                    primary: Theme.of(context).colorScheme.primary,
                    onPrimary: Theme.of(context).colorScheme.onPrimary,
                    surface: Theme.of(context).colorScheme.surface,
                    onSurface: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                child: child!,
              );
            },
          );
          if (dt != null) {
            setState(() => dateTime = dt);
            // LoadingOverlay.show(context);
            await getAsync();
            timer?.cancel();
            // LoadingOverlay.dismiss();
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.calendar_today, 
                color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Date',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat("MMMM d, yyyy").format(dateTime),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right,
                color: Theme.of(context).colorScheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmployeeFilter() {
    if (selectedEmployee == null) return const SizedBox.shrink();
    
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () async {
          selectedEmployee = null;
          // LoadingOverlay.show(context);
          await getAsync();
          startTImer();
          // LoadingOverlay.dismiss();
          setState(() {});
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Icon(Icons.person,
                  color: Theme.of(context).colorScheme.onPrimaryContainer),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Filtered Employee',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(selectedEmployee!.name,
                      style: Theme.of(context).textTheme.bodyLarge),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () async {
                  selectedEmployee = null;
                  // LoadingOverlay.show(context);
                  await getAsync();
                  startTImer();
                  // LoadingOverlay.dismiss();
                  setState(() {});
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAttendanceList() {
    if (attendanceData == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (attendanceData!.data!.isEmpty) {
      return RefreshIndicator(
        onRefresh: () => getAsync(),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildDateFilter()),
            SliverToBoxAdapter(child: _buildEmployeeFilter()),
            const SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.event_busy, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('No Attendance Records',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => getAsync(),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildDateFilter()),
          SliverToBoxAdapter(child: _buildEmployeeFilter()),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final employeeName = attendanceDatas.keys.toList()[index];
                final attendances = attendanceDatas[employeeName]!;
                
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      dividerTheme: const DividerThemeData(
                        space: 1,
                        thickness: 1,
                      ),
                    ),
                    child: ExpansionTile(
                      title: Text(
                        employeeName,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      children: attendances.map((attendance) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (attendance.details?.isNotEmpty ?? false)
                              Padding(
                                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                                child: Text(
                                  attendance.details!,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: EasyWebView(
                                key: ValueKey(attendance.message),
                                src: attendance.message?.trim() ?? "",
                                isMarkdown: false,
                                convertToWidgets: true,
                                height: getHeightByLength(
                                  (attendance.message ?? "").length,
                                ),
                              ),
                            ),
                            const Divider(),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
              childCount: attendanceDatas.length,
            ),
          ),
        ],
      ),
    );
  }

  List<em.Datum>? all;
  bool searchmode = false;
  em.Datum? selectedEmployee;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: searchmode
            ? SearchBar(
                hintText: 'Search employee...',
                leading: const Icon(Icons.search),
                trailing: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        searchmode = false;
                        all = null;
                      });
                    },
                  ),
                ],
                onChanged: (v) {
                  setState(() {
                    all = networkCaller.employeList!.data
                        .where((element) => element.name
                            .toLowerCase()
                            .startsWith(v.toLowerCase()))
                        .toList();
                  });
                },
              )
            : const Text('Attendance'),
        actions: [
          if (networkCaller.isAdminMode || networkCaller.isSupervisor)
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () async {
                all = (await networkCaller.employeeList()).data;
                setState(() => searchmode = true);
              },
            ),
        ],
      ),
      body: searchmode
          ? ListView.builder(
              itemCount: all?.length ?? 0,
              itemBuilder: (context, index) {
                final employee = all![index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    child: Icon(Icons.person,
                      color: Theme.of(context).colorScheme.onPrimaryContainer),
                  ),
                  title: Text(employee.name),
                  selected: selectedEmployee == employee,
                  selectedTileColor: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.1),
                  onTap: () async {
                    selectedEmployee = employee;
                    searchmode = false;
                    timer?.cancel();
                    setState(() {});
                    // LoadingOverlay.show(context);
                    await getAsync();
                    // LoadingOverlay.dismiss();
                  },
                );
              },
            )
          : _buildAttendanceList(),
      floatingActionButton: !hasAttendedLoggedOut
          ? null
          : FloatingActionButton.extended(
              onPressed: logoutLogic,
              icon: const Icon(Icons.logout),
              label: const Text("End Attendance"),
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
    );
  }

  void logoutLogic() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("End Attendance?"),
        content: const Text(
          "This will log you out of the attendance system. Are you sure you want to continue?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          FilledButton.tonal(
            onPressed: () async {
              Navigator.pop(context);
              // LoadingOverlay.show(context);
              await networkCaller.logoutAttendance(logoutDatum);
              await logoutted();
              // LoadingOverlay.dismiss();
            },
            child: const Text("End Attendance"),
          ),
        ],
      ),
    );
  }

  ad.AttendanceMiniObject? datum;
  ad.AttendanceMiniObject logoutDatum =
      ad.AttendanceMiniObject(statusId: "1", name: "Logout");
  ad.AttendanceStatus? attendanceStatus;
}

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:gtaos/helper/network.dart';
import 'package:gtaos/utils/colors.dart';
import 'package:gtaos/views/actualhome.dart';
import 'package:gtaos/views/add_pac.dart';
import 'package:gtaos/views/attendance.dart';
import 'package:gtaos/views/map.dart';
import 'package:gtaos/views/pac.dart';
import 'package:gtaos/views/checkin_update_pac.dart';
import 'package:gtaos/widgets/loading_overlay.dart';
import 'package:gtaos/model/tasklist.dart';
import 'package:gtaos/model/paclist.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  int index = 0;

  @override
  bool get wantKeepAlive => true;

  Widget getBody() {
    if (index == 0) {
      return ActualHome();
    } else if (index == 1) {
      if (networkCaller.isAdminMode ||
          (networkCaller.attendanceChecker?.data.supervisor ?? false)) {
        return PacView();
      } else {
        return PlacePolylineBody();
      }
    } else if (index == 2){

return AttendanceScreen();
    }else{
      return PlacePolylineBody();
    }
  }

  @override
  void initState() {
    super.initState();
    if (!networkCaller.isAdminMode) networkCaller.sendLivelocation();
  }

  @override
  void dispose() {
    log("****home dispose***");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      extendBody: true,
      body: getBody(),

      // ✅ FAB: Centered & circular with only "+" icon
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        onPressed: () async {
          try {
            LoadingOverlay.show(context);
            // Get task list
            
            final taskList = await networkCaller.getTaskList();
            log(  'tasl${taskList.data    }');
            if (taskList.data == null || taskList.data!.isEmpty) {

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('No tasks available'),
                  backgroundColor: Colors.orange,
                ),
              );
              return;
            }
            
            // Find ongoing task
            TaskListDatum? ongoingTask;
            //  log(  'tasl${ongoingTask!.orderStatusId}');
            try {
              ongoingTask = taskList.data!.firstWhere(
                (task) => task.taskstatus?.toLowerCase() == 'Progress',
                orElse: () => throw StateError('No ongoing task found'),
              );
            } catch (e) {
              ongoingTask = null;
            }
            
            if (ongoingTask != null) {
              // Convert TaskListDatum to Datum
              final datum = Datum(
                vendorId: networkCaller.getUser()?.vendorId ?? '',
                startOn: DateTime.now(),  // Use current time since we don't have this info
                dateAdded: DateTime.now(),  // Use current time since we don't have this info
                subject: ongoingTask.subject ?? '',
                taskId: ongoingTask.taskId ?? '',
                refno: '',  // We don't have this info
                taskstatus: ongoingTask.taskstatus ?? '',
                sdsCode: '',  // We don't have this info
              );
              
              // Navigate to task update screen
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (c) => CheckinUpadatePacScreen(data: datum),
                ),
              );
              setState(() {});
            } else {
              // Show message if no ongoing task
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('No ongoing task found'),
                  backgroundColor: Colors.orange,
                ),
              );
            }
          } catch (e) {
            log('Error: $e');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${e.toString()}'),
                backgroundColor: Colors.red,
              ),
            );
          } finally {
            LoadingOverlay.dismiss();
          }
        },
        backgroundColor: Appcolors.primary2,
        elevation: 4,
        child: const Icon(Icons.run_circle_outlined, color: Colors.white, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // ✅ BottomAppBar with proper notch shape
      bottomNavigationBar: BottomAppBar(
        shape: const AutomaticNotchedShape(
          RoundedRectangleBorder(),
          StadiumBorder(),
        ),
        notchMargin: 8.0,
        elevation: 8,
        color: Colors.white,
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          currentIndex: index,
          onTap: (value) {
            setState(() {
              index = value;
            });
          },
          selectedItemColor: Appcolors.blackDark,
          unselectedItemColor: Colors.grey.shade500,
          showUnselectedLabels: true,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          type: BottomNavigationBarType.fixed,

          // ✅ Adjust icons count based on permissions
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 16,),
              label: "Home",
            ),
            if (networkCaller.isAdminMode ||
                (networkCaller.attendanceChecker?.data.supervisor ?? false))
              const BottomNavigationBarItem(
                icon: Icon(Icons.circle_outlined, size: 16,),
                label: "Task",
              ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.select_all, size: 16,),
              label: "Attendance",
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.map, size: 16,),
              label: "Map View",
            ),
          ],
        ),
      ),
    );
  }
}
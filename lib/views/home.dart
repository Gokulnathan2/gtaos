// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:gtaos/helper/network.dart';
// import 'package:gtaos/utils/colors.dart';
// import 'package:gtaos/views/actualhome.dart';
// import 'package:gtaos/views/map.dart';
// import 'package:gtaos/views/pac.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen>
//     with AutomaticKeepAliveClientMixin {
//   int index = 0;

//   @override
//   bool get wantKeepAlive => true;

//   getBody() {
//     if (index == 0) {
//       return ActualHome();
//     } else if (index == 1) {
//       if (networkCaller.isAdminMode ||
//           (networkCaller.attendanceChecker?.data.supervisor ?? false))
//         return PacView();
//       else
//         return PlacePolylineBody();
//     } else {
//       return PlacePolylineBody();
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     if (!networkCaller.isAdminMode) networkCaller.sendLivelocation();
//   }

//   @override
//   void dispose() {
//     log("****home dispose***");
//     super.dispose();
//   }
// Widget home() {
//   return Column(
//     children: <Widget>[
//       Expanded(child: getBody()),
//       Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: const BorderRadius.only(
//               topLeft: Radius.circular(20), topRight: Radius.circular(20)),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               spreadRadius: 5,
//               blurRadius: 10,
//               offset: const Offset(0, -1),
//             )
//           ],
//         ),
//         child: BottomNavigationBar(
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           currentIndex: index,
//           onTap: (value) async {
//             if (value != 0) {}
//             setState(() {
//               index = value;
//             });
//             print(index);
//           },
//           selectedItemColor: Appcolors. blackDark,
//           unselectedItemColor: Colors.grey.shade500,
//           showUnselectedLabels: true,
//           selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
//           items: [
//             BottomNavigationBarItem(
//               icon: Icon(Icons.home),
//               label: "Home",
//             ),
//             if (networkCaller.isAdminMode ||
//                 (networkCaller.attendanceChecker?.data.supervisor ?? false))
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.circle_outlined),
//                 label: "Task",
//               ),

//                 BottomNavigationBarItem(
//               icon: Icon(Icons.select_all),
//               label: "Attendence",
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.map),
//               label: "Map View",
//             ),
//           ],
//         ),
//       ),
//     ],
//   );}
//   // home() {
//   //   return Column(children: <Widget>[
//   //     Expanded(child: getBody()),
//   //     BottomNavigationBar(
//   //         currentIndex: index,
//   //         onTap: (value) async {
//   //           if (value != 0) {}
//   //           setState(() {
//   //             index = value;
//   //           });
//   //           print(index);
//   //         },
//   //         items: [
//   //           BottomNavigationBarItem(
//   //               icon: const Icon(Icons.home), label: "Home"),
//   //           if (networkCaller.isAdminMode ||
//   //               (networkCaller.attendanceChecker?.data.supervisor ?? false))
//   //             BottomNavigationBarItem(
//   //                 icon: const Icon(Icons.circle_outlined), label: "Task"),
//   //           BottomNavigationBarItem(
//   //               icon: const Icon(Icons.map), label: "Map View")
//   //         ]),
//   //   ]);
//   // }

//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     return home();
//   }
// }

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:gtaos/helper/network.dart';
import 'package:gtaos/utils/colors.dart';
import 'package:gtaos/views/actualhome.dart';
import 'package:gtaos/views/add_pac.dart';
import 'package:gtaos/views/map.dart';
import 'package:gtaos/views/pac.dart';

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
    } else {
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
      
  onPressed: () async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (c) => ManagePad()),
    );
    setState(() {});
  },
  backgroundColor: Appcolors.primary2,
  elevation: 4,
  child: const Icon(Icons.add, color: Colors.white, size: 28),
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
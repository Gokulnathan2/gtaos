// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:gtaos/helper/network.dart';
// import 'package:gtaos/model/paclist.dart';
// import 'package:gtaos/views/pac.dart';

// class PacUpdater extends StatefulWidget {
//   const PacUpdater({super.key});

//   @override
//   State<PacUpdater> createState() => _PacUpdaterState();
// }

// class _PacUpdaterState extends State<PacUpdater> {
//   @override
//   void initState() {
//     super.initState();

//     getAsync();
//   }

//   getbody() {
//     if (pacList == null)
//       return Center(
//           child: CircularProgressIndicator(backgroundColor: Colors.orange));
//     else {
//       if (pacList!.data.isEmpty)
//         return Center(child: Text("No Task"));
//       else
//         return ListView.builder(
//             physics: BouncingScrollPhysics(),
//             itemCount: pacList!.data.length,
//             itemBuilder: (c, i) => PacListCard(datum: pacList!.data[i]));
//     }
//   }

//   PacList? pacList;
//   getAsync() async {
//     try {
//       pacList = await networkCaller.getPacList();
//     } catch (e) {
//       log(e.toString());
//     }
//     if (mounted) setState(() {});
//   }
// Widget _buildFilterButtons() {
//     List<Map<String, dynamic>> filters = [
//       {"label": "All", "type": null},
//       {"label":"Pending", "type": null},
//       {"label": "Progress", "type": null},
//       {"label": "Completed", "type": null},
//     ];

//     return LayoutBuilder(
//       builder: (context, constraints) {
//         double buttonWidth = (constraints.maxWidth - 4) /
//             filters.length; // Subtract padding to fit properly

//         return Container(
//           height:  40, // Enough height for full visibility
//           decoration: BoxDecoration(
//             color: Colors.grey, // Background for unselected buttons
//             borderRadius:
//                 BorderRadius.circular(0.8),
//           ),
//           padding: EdgeInsets.all(
//               2), // Add padding so the selection is fully visible
//           child: Stack(
//             children: [
//               // Background selection animation
//               AnimatedPositioned(
//                 duration: Duration(milliseconds: 250),
//                 curve: Curves.easeInOut,
//                 // left: _getLeftPosition(selectedFilter, filters, buttonWidth),
//                 child: Container(
//                   width: buttonWidth,
//                   // height: ResponsiveHelper.scaleHeight(context, 36),
//                   decoration: BoxDecoration(
//                     // color: AppColors.primary,
//                     // borderRadius: BorderRadius.circular(
//                     //     ResponsiveHelper.scaleRadius(context, 8)),
//                   ),
//                 ),
//               ),
//               Row(
//                 children: List.generate(filters.length, (index) {
//                   // final bool isSelected =
//                   //     selectedFilter == filters[index]["type"];

//                   return GestureDetector(
//                     onTap: () async {
//                       // final dpId = await SecureStorageService.getDpTempId();
//                       setState(() {
                       
//                       });
//                     },
//                     behavior: HitTestBehavior.opaque,
//                     child: Container(
//                       width: buttonWidth, // Ensures proper width
//                       alignment: Alignment.center,
//                       child: Text(
//                         filters[index]["label"],
//                         style: TextStyle(
//                           fontSize: 12,
//                           fontWeight: FontWeight.w600,
//                           // color: isSelected ? Colors.white : Color(0xFF888888),
//                         ),
//                       ),
//                     ),
//                   );
//                 }),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text('Task'),
//         ),
//         body: Column(
//           children: [
            
//             _buildFilterButtons(),
//        Expanded(child:     getbody())],
//         ));
//   }
// }
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gtaos/helper/network.dart';
import 'package:gtaos/model/paclist.dart';
import 'package:gtaos/utils/colors.dart';
import 'package:gtaos/views/pac.dart';

class PacUpdater extends StatefulWidget {
  const PacUpdater({super.key});

  @override
  State<PacUpdater> createState() => _PacUpdaterState();
}

class _PacUpdaterState extends State<PacUpdater> {
  String? selectedFilter; // Track the selected filter

  @override
  void initState() {
    super.initState();
    // Initialize selectedFilter to "All" or null to represent "All"
    selectedFilter = null;
    getAsync();
  }

  PacList? pacList;
  Future<void> getAsync() async {
    try {
      pacList = await networkCaller.getPacList();
    } catch (e) {
      log('Error fetching PAC list: $e');
      // Consider showing a SnackBar or an error message to the user
    }
    if (mounted) setState(() {});
  }

  // --- Filtering Logic (New or Updated) ---
  List<Datum> getFilteredPacList() {
    if (pacList == null) {
      return [];
    }

    if (selectedFilter == null || selectedFilter == "All") {
      return pacList!.data;
    }

    // Assuming your Datum has a 'status' or 'taskStatus' field
    // You'll need to adjust 'datum.status.toLowerCase()' to your actual field name
    return pacList!.data.where((datum) {
      // Example: If your Datum class has a 'status' field that holds the task status
      // You might need to adjust this condition based on your actual data structure
      return datum.taskstatus?.toLowerCase() == selectedFilter;
    }).toList();
  }

  // --- UI Building Methods ---
  Widget getbody() {
    final filteredList = getFilteredPacList();

    if (pacList == null) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Appcolors.primary2),
        ),
      );
    } else if (filteredList.isEmpty) { // Use filteredList here
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.task_alt, size: 60, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              "No Tasks Available for this filter",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Raleway',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    } else {
      return ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: filteredList.length,
        itemBuilder: (c, i) => PacListCard(datum: filteredList[i]),
      );
    }
  }

  Widget _buildFilterButtons() {
    List<Map<String, dynamic>> filters = [
      {"label": "All", "type": null}, // Use null to represent "All"
      {"label": "Pending", "type": "pending"},
      {"label": "Progress", "type": "progress"},
      {"label": "Completed", "type": "completed"},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Calculate button width to ensure even distribution
          double buttonWidth = constraints.maxWidth / filters.length;

          // Find the index of the currently selected filter
          final int selectedIndex =
              filters.indexWhere((f) => f["type"] == selectedFilter);

          return Container(
            height: 48, // Slightly increased height for better touch target
            decoration: BoxDecoration(
              color: Colors.grey[100], // Lighter background for filter container
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08), // Softer shadow
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  left: selectedIndex * buttonWidth,
                  child: Container(
                    width: buttonWidth,
                    height: 48, // Match container height
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Appcolors.primary2, Appcolors.primary2.withOpacity(0.8)], // Slight gradient for depth
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Appcolors.primary2.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: List.generate(filters.length, (index) {
                    final bool isSelected = selectedFilter == filters[index]["type"];
                    return Expanded( // Use Expanded to ensure even distribution
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedFilter = filters[index]["type"];
                          });
                        },
                        behavior: HitTestBehavior.opaque, // Ensures the whole area is tappable
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            filters[index]["label"],
                            style: TextStyle(
                              fontFamily: 'Raleway',
                              fontSize: 15, // Slightly larger font
                              fontWeight: FontWeight.w600,
                              color: isSelected ? Colors.white : Colors.grey[800],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark, // Changed to dark for light app bar
    ));

    return Scaffold(
      backgroundColor: Colors.white, // Clean white background for the screen
      appBar: AppBar(
        backgroundColor: Colors.white, // Clean white app bar
        elevation: 0, // No shadow for a modern flat look
        title: Text(
          'Tasks',
          style: TextStyle(
            fontFamily: 'Raleway',
            fontWeight: FontWeight.w700,
            fontSize: 24,
            color: Colors.black, // Darker text for better contrast
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        // No iconTheme needed as there's no back button by default.
        // If you add a leading icon, set its color explicitly.
        // iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          _buildFilterButtons(),
          Expanded(child: getbody()),
        ],
      ),
    );
  }
}
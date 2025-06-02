import 'package:easy_web_view/easy_web_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gtaos/helper/network.dart';
import 'package:gtaos/model/emp_dashboard.dart';
import 'package:gtaos/utils/colors.dart';
import 'package:gtaos/views/history.dart';
import 'package:gtaos/views/pac_updater.dart';
import 'package:gtaos/widget/drawer.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_web_view/easy_web_view.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_web_view/easy_web_view.dart';

// class ActualHome extends StatefulWidget {
//   const ActualHome({super.key});

//   @override
//   State<ActualHome> createState() => _ActualHomeState();
// }

// class _ActualHomeState extends State<ActualHome>
//     with AutomaticKeepAliveClientMixin {
//   @override
//   void initState() {
//     super.initState();
//     getAsync();
//   }

//   var totalPac = "0";

//   getAsync({force = false}) async {
//     try {
//       // EasyLoading.show(status: "Fetching pacs...");
//       if (!networkCaller.isAdminMode)
//         totalPac = await networkCaller.getTotalPacs(force: force);
//       employeeDashboard =
//           await networkCaller.getEmpPacListDashboard(force: force);
//     } catch (e) {}
//     // EasyLoading.dismiss();

//     if (mounted) setState(() {});
//   }

//   EmployeeDashboard? employeeDashboard;
//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     return Scaffold(
//         // appBar: PreferredSize(
//         //   preferredSize: Size.fromHeight(100), // Increased app bar height
//         //   child: ClipRRect(
//         //     borderRadius: BorderRadius.only(
//         //         bottomLeft: Radius.circular(20),
//         //         bottomRight: Radius.circular(20)),
//         //     child: AppBar(
//         //       backgroundColor: Colors.black, // Solid color background
//         //       elevation: 10,
//         //       scrolledUnderElevation: 15,
//         //       shadowColor: Colors.black.withOpacity(0.3),
//         //       title: Column(
//         //         crossAxisAlignment: CrossAxisAlignment.start,
//         //         children: [
//         //           Image.asset(
//         //             'asset/brand_icon.png',
//         //             width: 150,
//         //             height: 150,
//         //           ),
//         //           // Text(
//         //           //   'Dashboard',
//         //           //   style: TextStyle(
//         //           //     color: Colors.white,
//         //           //     fontFamily: 'DM Sans',
//         //           //     fontWeight: FontWeight.w700,
//         //           //     fontSize: 24,
//         //           //     letterSpacing: 0.5,
//         //           //   ),
//         //           // ),
//         //           // Text(
//         //           //   'Your Tasks Overview',
//         //           //   style: TextStyle(
//         //           //     color: Colors.white70,
//         //           //     fontFamily: 'DM Sans',
//         //           //     fontWeight: FontWeight.w400,
//         //           //     fontSize: 14,
//         //           //   ),
//         //           // ),
//         //         ],
//         //       ),
//         //       iconTheme: IconThemeData(color: Colors.white, size: 28),
//         //       flexibleSpace: Container(
//         //         decoration: BoxDecoration(
//         //           gradient: LinearGradient(
//         //             begin: Alignment.topLeft,
//         //             end: Alignment.bottomRight,
//         //             colors: [
//         //               Appcolors.primary2.withOpacity(0.9),
//         //               // Colors.black.withOpacity(0.9),
//         //               Color(0xffcf8103),
//         //             ],
//         //           ),
//         //         ),
//         //       ),
//         //       shape: RoundedRectangleBorder(
//         //         borderRadius: BorderRadius.vertical(
//         //           bottom: Radius.circular(20),
//         //         ),
//         //       ),
//         //       systemOverlayStyle: SystemUiOverlayStyle.light,
//         //     ),
//         //   ),
//         // ),
//         // appBar: AppBar(
//         //   // backgroundColor: Appcolors.primary2,
//         //   title: const Text(
//         //     'Dashboard',
//         //     style: TextStyle(color: Colors.black),
//         //   ),
//         //   iconTheme:
//         //       IconThemeData(color: Colors.black), // Change the icon color here
//         // ),
//         appBar: AppBar(
//   flexibleSpace: Container(
//     decoration: BoxDecoration(
//       gradient: LinearGradient(
//         colors: [
//           // Appcolors.primary2, // Use your defined primary color
//           // Color(0xFF1A237E), // Deep indigo for a modern touch
//         ],
//         begin: Alignment.topLeft,
//         end: Alignment.bottomRight,
//       ),
//     ),
//   ),
//   elevation: 4, // Subtle shadow for depth
//   shadowColor: Colors.black.withOpacity(0.3), // Soft shadow
//   title:  Image.asset(
//                     'asset/brand_icon.png',
//                     width: 100,
//                     height: 100,
//                   ),
//   centerTitle: true, // Center the title for a balanced look
//   iconTheme: IconThemeData(color: Colors.black), // White icons for contrast
//   actions: [
//     IconButton(
//       icon: Icon(Icons.face, size: 28, color: Colors.black,),
//       tooltip: 'Profile',
//       onPressed: () {
//         getAsync(force: true); // Trigger refresh
//       },
//     ),
//     SizedBox(width: 8), // Spacing for clean layout
//   ],
// ),
//         drawer: GTAOSDrawer(),
//         body: RefreshIndicator(
//           onRefresh: () {
//             return getAsync(force: true);
//           },
//           child: Padding(
//               padding: EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(height: 20),
//                   Text(
//                     "👋 Hello Siva!",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontFamily: 'DM Sans',
//                       fontWeight: FontWeight.w600,
//                       fontSize: 18,
//                       color: Color(0xFF333333),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   if (!networkCaller.isAdminMode)
//                     Center(
//                       child: SizedBox(
//                         height: 120,
//                         // width: 200,
//                         child: GestureDetector(
//                             onTap: () {
//                               Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (c) => PacUpdater()));
//                             },
//                             child: Card(
//                               shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(16)),
//                               elevation: 5,
//                               color: Colors.black,
//                               child: InkWell(
//                                 onTap: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (c) => PacUpdater()),
//                                   );
//                                 },
//                                 child: Container(
//                                   height: 140,
//                                   width: double.infinity,
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 20, vertical: 16),
//                                   child: Row(
//                                     children: [
//                                       // Icon(Icons.task_alt, size: 48, color: Colors.white),
//                                       // const SizedBox(width: 20),
//                                       Expanded(
//                                         child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.center,
//                                           children: [
//                                             Text(
//                                               "Remaining Task's",
//                                               textAlign: TextAlign.center,
//                                               style: TextStyle(
//                                                 fontFamily: 'DM Sans',
//                                                 fontWeight: FontWeight.w600,
//                                                 fontSize: 18,
//                                                 color: Colors.white,
//                                               ),
//                                             ),
//                                             const SizedBox(height: 4),
//                                             const Text(
//                                               "View more...",
//                                               style: TextStyle(
//                                                   color: Colors.white70),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                       // Circular progress with task count
//                                       Stack(
//                                         alignment: Alignment.center,
//                                         children: [
//                                           SizedBox(
//                                             width: 50,
//                                             height: 50,
//                                             child: CircularProgressIndicator(
//                                               value: (int.tryParse(totalPac) ??
//                                                       0) /
//                                                   10, // Adjust max value as needed
//                                               strokeWidth: 8,
//                                               backgroundColor: Colors.white24,
//                                               valueColor:
//                                                   AlwaysStoppedAnimation<Color>(
//                                                       Appcolors.primary2),
//                                             ),
//                                           ),
//                                           CircleAvatar(
//                                             radius: 23,
//                                             backgroundColor: Colors.white,
//                                             child: Text(
//                                               "$totalPac",
//                                               style: const TextStyle(
//                                                 color: Colors.black,
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             )),
//                       ),
//                     ),
//                   const SizedBox(height: 20),
//                   Text(
//                     "Task Details",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontFamily: 'DM Sans',
//                       fontWeight: FontWeight.w600,
//                       fontSize: 18,
//                       color: Color(0xFF333333),
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Expanded(
//                     child: CustomScrollView(
//                       slivers: [
//                         SliverList(
//                           delegate: SliverChildBuilderDelegate(
//                             (context, index) {
//                               final dummyTasks = [
//                                 {
//                                   "title": "Submit Timesheet",
//                                   "date": "2025-05-20",
//                                   "status": "Pending"
//                                 },
//                                 {
//                                   "title": "Client Feedback Review",
//                                   "date": "2025-05-19",
//                                   "status": "Completed"
//                                 },
//                                 {
//                                   "title": "Design Team Sync",
//                                   "date": "2025-05-21",
//                                   "status": "In Progress"
//                                 },
//                                 {
//                                   "title": "Update Documentation",
//                                   "date": "2025-05-22",
//                                   "status": "Pending"
//                                 },
//                                 {
//                                   "title": "Code Review",
//                                   "date": "2025-05-18",
//                                   "status": "Completed"
//                                 },
//                                 {
//                                   "title": "Sprint Planning",
//                                   "date": "2025-05-23",
//                                   "status": "Scheduled"
//                                 },
//                                 {
//                                   "title": "QA Testing",
//                                   "date": "2025-05-24",
//                                   "status": "Pending"
//                                 },
//                                 {
//                                   "title": "Release Deployment",
//                                   "date": "2025-05-25",
//                                   "status": "In Progress"
//                                 },
//                                 {
//                                   "title": "Bug Fixes",
//                                   "date": "2025-05-17",
//                                   "status": "Completed"
//                                 },
//                                 {
//                                   "title": "Team Retrospective",
//                                   "date": "2025-05-26",
//                                   "status": "Scheduled"
//                                 },
//                               ];

//                               final task = dummyTasks[index];

//                               Color statusColor;
//                               switch (task['status']) {
//                                 case "Completed":
//                                   statusColor = Colors.green;
//                                   break;
//                                 case "Pending":
//                                   statusColor = Colors.orange;
//                                   break;
//                                 case "In Progress":
//                                   statusColor = Colors.blue;
//                                   break;
//                                 case "Scheduled":
//                                   statusColor = Colors.purple;
//                                   break;
//                                 default:
//                                   statusColor = Colors.grey;
//                               }

//                               return Card(
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(16)),
//                                 elevation: 0,
//                                 margin: const EdgeInsets.symmetric(
//                                     vertical: 8, horizontal: 4),
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(16),
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         task['title']!,
//                                         style: const TextStyle(
//                                           fontSize: 18,
//                                           fontWeight: FontWeight.bold,
//                                           fontFamily: 'DM Sans',
//                                         ),
//                                       ),
//                                       const SizedBox(height: 8),
//                                       Row(
//                                         children: [
//                                           Icon(Icons.calendar_today,
//                                               size: 16,
//                                               color: Colors.grey[600]),
//                                           const SizedBox(width: 6),
//                                           Text(
//                                             task['date']!,
//                                             style: TextStyle(
//                                                 color: Colors.grey[800]),
//                                           ),
//                                         ],
//                                       ),
//                                       const SizedBox(height: 6),
//                                       Row(
//                                         children: [
//                                           Icon(Icons.check_circle_outline,
//                                               size: 16,
//                                               color: Colors.grey[600]),
//                                           const SizedBox(width: 6),
//                                           Text(
//                                             task['status']!,
//                                             style:
//                                                 TextStyle(color: statusColor),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               );
//                             },
//                             childCount: 10,
//                           ),
//                         ),
//                       ],
//                     ),
//                   )

//                   // Expanded(
//                   //   child: CustomScrollView(
//                   //     physics: BouncingScrollPhysics(),
//                   //     slivers: [
//                   //       SliverToBoxAdapter(child: SizedBox(height: 50)),

//                   //       // SliverToBoxAdapter(
//                   //       //   child:
//                   //       // ),
//                   //       if (employeeDashboard == null)
//                   //         SliverToBoxAdapter(
//                   //           child: Padding(
//                   //             padding: const EdgeInsets.all(8.0),
//                   //             child: FractionallySizedBox(
//                   //               widthFactor: .1,
//                   //               child: CircularProgressIndicator(
//                   //                 backgroundColor: Colors.amber,
//                   //               ),
//                   //             ),
//                   //           ),
//                   //         ),
//                   //       if (employeeDashboard != null &&
//                   //           employeeDashboard!.data!.workdatas != null)
//                   //         SliverList(
//                   //             delegate: SliverChildBuilderDelegate(
//                   //           (c, i) {
//                   //             var data = employeeDashboard!.data!.workdatas![i];

//                   //             return PerWorkCard(data: data);
//                   //           },
//                   //           childCount:
//                   //               employeeDashboard!.data!.workdatas!.length,
//                   //         ))
//                   //     ],
//                   //   ),
//                   // )
//                 ],
//               )),
//         ));
//   }

//   @override
//   bool get wantKeepAlive => true;
// }

class PerWorkCard extends StatelessWidget {
  const PerWorkCard({
    super.key,
    required this.data,
  });

  final Workdata data;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Column(
        children: [
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            child: Row(
              children: [
                Text(data.taskname ?? "-",
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        height: 1.4)),
              ],
            ),
          ),
          Divider(
            endIndent: 15,
            indent: 15,
          ),
          if (data.products != null && data.products!.isNotEmpty)
            ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: data.products!.length,
                itemBuilder: (BuildContext context, int subIndex) {
                  var item = data.products![subIndex];

                  return Column(
                    children: [
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 2),
                            child: Row(
                              children: [
                                if (item.productoptionvalue?.isNotEmpty ??
                                    false)
                                  Text.rich(
                                    TextSpan(
                                        text: item.productname ?? "-",
                                        children: [
                                          TextSpan(
                                            text: "\n" +
                                                (item.productoptionvalue?[0]
                                                        .value ??
                                                    "-"),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(fontSize: 10),
                                          )
                                        ]),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium!
                                        .copyWith(
                                            fontSize: 14,
                                            color: Colors.black,
                                            height: 1.4),
                                    maxLines: 4,
                                  ),
                              ],
                            ),
                          ),
                          Spacer(),
                          Container(
                            padding: EdgeInsets.all(3),
                            color: item.isCompleted ? Colors.green : Colors.red,
                            child: Text(
                              (item.isCompleted ? "Completed" : "Pending"),
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: EasyWebView(
                          src: "<b>Note:</b> " + (item.note ?? ""),
                          isMarkdown: false, // Use markdown syntax
                          convertToWidgets:
                              true, // Try to convert to flutter widgets
                          height: getHeightByLength(item.note?.length) + 10,
                        ),
                      ),
                      // Divider(),
                      // Text((item.note ?? "").length.toString())
                    ],
                  );
                })
        ],
      ),
    );
  }
}

Widget _buildGridStatusCard(
  BuildContext context, {
  required String title,
  required String count,
  required double progress,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Raleway',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            "View more...",
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 42,
                    height: 42,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 6,
                      backgroundColor: Colors.white24,
                      valueColor: AlwaysStoppedAnimation<Color>(Appcolors.primary2),
                    ),
                  ),
                  CircleAvatar(
                    radius: 17,
                    backgroundColor: Colors.white,
                    child: Text(
                      count,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 18),
            ],
          ),
        ],
      ),
    ),
  );
}


class ActualHome extends StatefulWidget {
  const ActualHome({super.key});

  @override
  State<ActualHome> createState() => _ActualHomeState();
}

class _ActualHomeState extends State<ActualHome> with AutomaticKeepAliveClientMixin {
  final CarouselSliderController _carouselController = CarouselSliderController();
  int _currentCarouselIndex = 0;
  var totalPac = "12"; // Example value, replace with your actual data

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                // Colors.black.withOpacity(0.9),
                // const Color(0xffcf8103),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.3),
        title: Image.asset(
          'asset/brand_icon.png',
          width: 100,
          height: 100,
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, size: 28, color: Colors.white),
            onPressed: () {
              // Refresh logic here
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: const GTAOSDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          // Refresh logic here
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                "👋 Hello Siva!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 20),
              
              // Task Status Carousel (keeping your original card design)
              GridView.count(
  crossAxisCount: 2,
  shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),
  crossAxisSpacing: 16,
  mainAxisSpacing: 16,
  childAspectRatio: 0.9,
  scrollDirection : Axis.vertical,
  padding: const EdgeInsets.all(16),
  children: [
    _buildGridStatusCard(
      context,
      title: "Remaining Task's",
      count: totalPac,
      progress: (int.tryParse(totalPac) ?? 0) / 10,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (c) => const PacUpdater()),
        );
      },
    ),
    _buildGridStatusCard(
      context,
      title: "Ongoing Task's",
      count: "5",
      progress: 0.5,
      onTap: () {
        // Navigate to ongoing tasks
      },
    ),
    _buildGridStatusCard(
      context,
      title: "Pending Review",
      count: "3",
      progress: 0.3,
      onTap: () {
        // Navigate to pending review
      },
    ),
    _buildGridStatusCard(
      context,
      title: "All",
      count: "3",
      progress: 0.3,
      onTap: () {
        // Navigate to pending review
      },
    ),
  ],
),

              // CarouselSlider(
              //   carouselController: _carouselController,
              //   options: CarouselOptions(
              //     height: 140,
              //     aspectRatio: 16/9,
              //     viewportFraction: 0.9,
              //     initialPage: 0,
              //     enableInfiniteScroll: true,
              //     autoPlay: true,
              //     autoPlayInterval: const Duration(seconds: 5),
              //     autoPlayAnimationDuration: const Duration(milliseconds: 800),
              //     enlargeCenterPage: true,
              //     onPageChanged: (index, reason) {
              //       setState(() {
              //         _currentCarouselIndex = index;
              //       });
              //     },
              //   ),
              //   items: [
              //     _buildOriginalStatusCard(
              //       context,
              //       title: "Remaining Task's",
              //       count: totalPac,
              //       progress: (int.tryParse(totalPac) ?? 0) / 10,
              //       onTap: () {
              //         Navigator.push(
              //           context,
              //           MaterialPageRoute(builder: (c) => const PacUpdater()),
              //         );
              //       },
              //     ),
              //     _buildOriginalStatusCard(
              //       context,
              //       title: "Ongoing Task's", 
              //       count: "5",
              //       progress: 0.5,
              //       onTap: () {
              //         // Navigate to ongoing tasks
              //       },
              //     ),
              //     _buildOriginalStatusCard(
              //       context,
              //       title: "Pending Review",
              //       count: "3",
              //       progress: 0.3,
              //       onTap: () {
              //         // Navigate to pending review
              //       },
              //     ),
              //   ],
              // ),
              // const SizedBox(height: 12),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [0, 1, 2].map((index) {
              //     return Container(
              //       width: 8.0,
              //       height: 8.0,
              //       margin: const EdgeInsets.symmetric(horizontal: 4.0),
              //       decoration: BoxDecoration(
              //         shape: BoxShape.circle,
              //         color: _currentCarouselIndex == index
              //             ? const Color(0xffcf8103)
              //             : Colors.grey.shade300,
              //       ),
              //     );
              //   }).toList(),
              // ),
              
              const SizedBox(height: 30),
              const Text(
                "Activities Report",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
  child: CustomScrollView(
    slivers: [
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final dummyTasks = [
              {
                "title": "Submit Timesheet",
                "date": "2025-05-20",
                "status": "Pending",
                "note": "Remember to include overtime details."
              },
              {
                "title": "Client Feedback Review",
                "date": "2025-05-19",
                "status": "Completed",
                "note": "Reviewed and documented feedback from last meeting."
              },
              {
                "title": "Design Team Sync",
                "date": "2025-05-21",
                "status": "In Progress",
                "note": "Discuss Figma prototype updates."
              },
              {
                "title": "Update Documentation",
                "date": "2025-05-22",
                "status": "Pending",
                "note": "Update API and onboarding guide."
              },
              {
                "title": "Code Review",
                "date": "2025-05-18",
                "status": "Completed",
                "note": "Reviewed PR #302 and approved."
              },
              {
                "title": "Sprint Planning",
                "date": "2025-05-23",
                "status": "Scheduled",
                "note": "Finalize story points and backlog."
              },
              {
                "title": "QA Testing",
                "date": "2025-05-24",
                "status": "Pending",
                "note": "Functional testing for user login flow."
              },
              {
                "title": "Release Deployment",
                "date": "2025-05-25",
                "status": "In Progress",
                "note": "Monitoring rollout and system logs."
              },
              {
                "title": "Bug Fixes",
                "date": "2025-05-17",
                "status": "Completed",
                "note": "Fixed crashes reported in v1.2.3."
              },
              {
                "title": "Team Retrospective",
                "date": "2025-05-26",
                "status": "Scheduled",
                "note": "Prepare discussion points from last sprint."
              },
            ];

            final task = dummyTasks[index];

            Color statusColor;
            switch (task['status']) {
              case "Completed":
                statusColor = Colors.green;
                break;
              case "Pending":
                statusColor = Colors.orange;
                break;
              case "In Progress":
                statusColor = Colors.blue;
                break;
              case "Scheduled":
                statusColor = Colors.purple;
                break;
              default:
                statusColor = Colors.grey;
            }

            return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 0,
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: ExpansionTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                title: Text(
                  task['title']!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Raleway',
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.calendar_today,
                            size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 6),
                        Text(
                          task['date']!,
                          style: TextStyle(color: Colors.grey[800]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.check_circle_outline,
                            size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 6),
                        Text(
                          task['status']!,
                          style: TextStyle(color: statusColor),
                        ),
                      ],
                    ),
                  ],
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        task['note']!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          fontFamily: 'Raleway',
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
          childCount: 10,
        ),
      ),
    ],
  ),
),

              // Task List (keeping your original card design but making expandable)
              
              
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOriginalStatusCard(
    BuildContext context, {
    required String title,
    required String count,
    required double progress,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)),
        elevation: 5,
        color: Colors.black,
        child: Container(
          height: 140,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Colors.white),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "View more...",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 8,
                      backgroundColor: Colors.white24,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Appcolors.primary2),
                    ),
                  ),
                  CircleAvatar(
                    radius: 23,
                    backgroundColor: Colors.white,
                    child: Text(
                      count,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
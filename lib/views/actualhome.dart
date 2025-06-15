import 'package:easy_web_view/easy_web_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gtaos/helper/network.dart';
import 'package:gtaos/model/emp_dashboard.dart';
import 'package:gtaos/utils/colors.dart';
import 'package:gtaos/views/history.dart';
import 'package:gtaos/views/pac_updater.dart';
import 'package:gtaos/widget/drawer.dart';
import 'package:carousel_slider/carousel_slider.dart';

class PerWorkCard extends StatelessWidget {
  const PerWorkCard({
    super.key,
    required this.data,
  });

  final Workdata data;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Colors.grey.shade50,
            ],
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Appcolors.primary1.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.work_outline, color: Appcolors.primary1, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      data.taskname ?? "-",
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Appcolors.primary1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (data.products != null && data.products!.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: data.products!.length,
                itemBuilder: (BuildContext context, int subIndex) {
                  var item = data.products![subIndex];
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (item.productoptionvalue?.isNotEmpty ?? false)
                                    Text(
                                      item.productname ?? "-",
                                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey.shade800,
                                      ),
                                    ),
                                  if (item.productoptionvalue?.isNotEmpty ?? false)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Text(
                                        item.productoptionvalue?[0].value ?? "-",
                                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: item.isCompleted ? Appcolors.primary2 : Colors.orange,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    item.isCompleted ? Icons.check_circle : Icons.schedule,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    item.isCompleted ? "Completed" : "Pending",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (item.note?.isNotEmpty ?? false)
                          Container(
                            margin: const EdgeInsets.only(top: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: EasyWebView(
                              src: "<b>Note:</b> " + (item.note ?? ""),
                              isMarkdown: false,
                              convertToWidgets: true,
                              height: getHeightByLength(item.note?.length) + 10,
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

Widget _buildModernStatusCard(
  BuildContext context, {
  required String title,
  required String count,
  required double progress,
  required VoidCallback onTap,
  required IconData icon,
  required Color color,
}) {
  return Material(
    borderRadius: BorderRadius.circular(20),
    elevation: 2,
    shadowColor: color.withOpacity(0.3),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0,),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              color.withOpacity(0.05),
            ],
          ),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const Spacer(),
                Text(
                  count,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                    minHeight: 4,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  "${(progress * 100).toInt()}%",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
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

class ActualHome extends StatefulWidget {
  const ActualHome({super.key});

  @override
  State<ActualHome> createState() => _ActualHomeState();
}

class _ActualHomeState extends State<ActualHome> with AutomaticKeepAliveClientMixin {
  final CarouselSliderController _carouselController = CarouselSliderController();
  int _currentCarouselIndex = 0;
  var totalPac = "0";
  EmployeeDashboard? employeeDashboard;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getAsync();
  }

  getAsync({force = false}) async {
    if (isLoading) return;
    
    try {
      setState(() => isLoading = true);
      
      if (!networkCaller.isAdminMode) {
        totalPac = await networkCaller.getTotalPacs(force: force);
      }
      employeeDashboard = await networkCaller.getEmpPacListDashboard(force: force);
    } catch (e) {
      print(e);
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Appcolors.primary1,
                Appcolors.primary2,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu_rounded, color: Colors.white, size: 28),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
               
              //  Image.asset(
              //       'asset/brand_icon.png',
              //       width: 80,
              //       height: 80,
              //     ),
                
                // const SizedBox(width: 12),
                // const Text(
                //   'Welcome',
                //   style: TextStyle(
                //     color: Colors.white,
                //     fontSize: 20,
                //     fontWeight: FontWeight.bold,
                //     letterSpacing: 1.2,
                //   ),
                // ),
              ],
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.refresh_rounded, color: Colors.white, size: 20),
                ),
                onPressed: () {
                  HapticFeedback.lightImpact();
                  getAsync(force: true);
                },
              ),
              const SizedBox(width: 16),
            ],
          ),
        ),
      ),
      drawer: const GTAOSDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          HapticFeedback.lightImpact();
          await getAsync(force: true);
        },
        color: Appcolors.primary1,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Appcolors.primary1.withOpacity(0.1),
                      Appcolors.primary2.withOpacity(0.05),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Appcolors.primary1.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            Icons.waving_hand,
                            color: Appcolors.primary1,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Good ${_getTimeOfDay()}!",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Text(
                                "Welcome back, Siva",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Appcolors.primary1.withOpacity(0.2)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today, color: Appcolors.primary1, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            _getCurrentDate(),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Appcolors.primary2.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              "Active",
                              style: TextStyle(
                                color: Appcolors.primary2,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Task Status Grid
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.dashboard_outlined, color: Appcolors.primary1, size: 24),
                        const SizedBox(width: 8),
                        const Text(
                          "Task Overview",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.1,
                      children: [
                        _buildModernStatusCard(
                          context,
                          title: "Remaining Tasks",
                          count: totalPac,
                          progress: (int.tryParse(totalPac) ?? 0) / 20,
                          icon: Icons.pending_actions,
                          color: Appcolors.primary1,
                          onTap: () {
                            HapticFeedback.selectionClick();
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (c) => const PacUpdater()),
                            );
                          },
                        ),
                        _buildModernStatusCard(
                          context,
                          title: "Ongoing Tasks",
                          count: "5",
                          progress: 0.4,
                          icon: Icons.play_circle_outline,
                          color: Appcolors.primary2,
                          onTap: () {
                            HapticFeedback.selectionClick();
                            // Navigate to ongoing tasks
                          },
                        ),
                        _buildModernStatusCard(
                          context,
                          title: "Pending Review",
                          count: "3",
                          progress: 0.6,
                          icon: Icons.rate_review_outlined,
                          color: Appcolors.primary3,
                          onTap: () {
                            HapticFeedback.selectionClick();
                            // Navigate to pending review
                          },
                        ),
                        _buildModernStatusCard(
                          context,
                          title: "Completed",
                          count: "18",
                          progress: 0.9,
                          icon: Icons.check_circle_outline,
                          color: const Color(0xFF4CAF50),
                          onTap: () {
                            HapticFeedback.selectionClick();
                            // Navigate to completed tasks
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Activities Report
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.analytics_outlined, color: Appcolors.primary1, size: 24),
                        const SizedBox(width: 8),
                        const Text(
                          "Recent Activities",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const Spacer(),
                        TextButton.icon(
                          onPressed: () {
                            // Navigate to full activities
                          },
                          icon: Icon(Icons.arrow_forward, size: 16, color: Appcolors.primary1),
                          label: Text(
                            "View All",
                            style: TextStyle(color: Appcolors.primary1, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),

              // Activity List
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: isLoading 
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : employeeDashboard?.data?.workdatas == null || employeeDashboard!.data!.workdatas!.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.task_alt_outlined,
                                size: 48,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "No activities found",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: employeeDashboard!.data!.workdatas!.length,
                        separatorBuilder: (context, index) => Divider(
                          height: 1,
                          color: Colors.grey.shade200,
                          indent: 16,
                          endIndent: 16,
                        ),
                        itemBuilder: (context, index) {
                          final workData = employeeDashboard!.data!.workdatas![index];
                          final completedCount = workData.products?.where((p) => p.isCompleted).length ?? 0;
                          final totalCount = workData.products?.length ?? 0;
                          final progress = totalCount > 0 ? completedCount / totalCount : 0.0;

                          Color statusColor;
                          IconData statusIcon;
                          String statusText;

                          if (progress == 1.0) {
                            statusColor = const Color(0xFF4CAF50);
                            statusIcon = Icons.check_circle;
                            statusText = "Completed";
                          } else if (progress > 0) {
                            statusColor = Appcolors.primary2;
                            statusIcon = Icons.play_circle;
                            statusText = "In Progress";
                          } else {
                            statusColor = Colors.orange;
                            statusIcon = Icons.schedule;
                            statusText = "Pending";
                          }

                          return ExpansionTile(
                            tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(statusIcon, color: statusColor, size: 20),
                            ),
                            title: Text(
                              workData.taskname ?? "Untitled Task",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(Icons.assignment_outlined, size: 14, color: Colors.grey.shade600),
                                    const SizedBox(width: 4),
                                    Text(
                                      "$completedCount/$totalCount items",
                                      style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                                    ),
                                    const SizedBox(width: 16),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: statusColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        "${(progress * 100).toInt()}%",
                                        style: TextStyle(
                                          color: statusColor,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                statusText,
                                style: TextStyle(
                                  color: statusColor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            children: [
                              if (workData.products != null && workData.products!.isNotEmpty)
                                ...workData.products!.map((product) => Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: product.isCompleted 
                                        ? const Color(0xFF4CAF50).withOpacity(0.2)
                                        : Colors.grey.shade200,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              product.productname ?? "Untitled Product",
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: product.isCompleted 
                                                ? const Color(0xFF4CAF50).withOpacity(0.1)
                                                : Colors.orange.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              product.isCompleted ? "Completed" : "Pending",
                                              style: TextStyle(
                                                color: product.isCompleted 
                                                  ? const Color(0xFF4CAF50)
                                                  : Colors.orange,
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (product.productoptionvalue?.isNotEmpty ?? false) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          product.productoptionvalue![0].value ?? "",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                      if (product.note?.isNotEmpty ?? false) ...[
                                        const SizedBox(height: 8),
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: EasyWebView(
                                            src: "<b>Note:</b> ${product.note}",
                                            isMarkdown: false,
                                            convertToWidgets: true,
                                            height: getHeightByLength(product.note?.length ?? 0) + 10,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                )).toList(),
                            ],
                          );
                        },
                      ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  String _getTimeOfDay() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Morning";
    if (hour < 17) return "Afternoon";
    return "Evening";
  }

  String _getCurrentDate() {
    final now = DateTime.now();
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return "${now.day} ${months[now.month - 1]}, ${now.year}";
  }

  @override
  bool get wantKeepAlive => true;
}
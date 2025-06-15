import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gtaos/utils/colors.dart';
import 'package:intl/intl.dart';
import 'package:gtaos/helper/network.dart';
import 'package:gtaos/model/paclist.dart';
import 'package:gtaos/views/add_pac.dart';
import 'package:gtaos/views/checkin_update_pac.dart';
import 'package:gtaos/views/history.dart';
import 'package:gtaos/widget/drawer.dart';

class PacView extends StatefulWidget {
  const PacView({super.key, this.noDrawer = false});
  final bool noDrawer;
  @override
  State<PacView> createState() => _PacViewState();
}

class _PacViewState extends State<PacView> {
  @override
  void initState() {
    super.initState();
    log("init state");
    getAsync();
  }

  PacList? pacList;
  getAsync({force = false}) async {
    try {
      pacList = await networkCaller.getPacList(force: force);
    } catch (e) {
      log(e.toString());
    }
    if (mounted) setState(() {});
  }
  getbody() {
    if (pacList == null) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Appcolors.primary2),
        ),
      );
    } else {
      if (pacList!.data.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.task_alt, size: 60, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                "No Tasks Available",
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
        return RefreshIndicator(
          onRefresh: () => getAsync(force: true),
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: pacList!.data.length,
            itemBuilder: (c, i) => PacListCard(
              datum: pacList!.data[i],
              onEdit: () {
                getAsync(force: true);
              },
              onDelete: (val) {
                pacList!.data.remove(pacList!.data[i]);
                if (mounted) setState(() {});
              },
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () async {
      //     await Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (c) => ManagePad()),
      //     );
      //     getAsync(force: true);
      //   },
      //   backgroundColor: Appcolors.primary2,
      //   elevation: 4,
      //   icon: const Icon(Icons.add, color:  Colors.white,),
      //   label: const Text(
      //     "Add Task",
      //     style: TextStyle(
      //       fontFamily: 'Raleway',
      //       fontWeight: FontWeight.w600,
      //       color: Colors.white,
      //     ),
      //   ),
      // ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Task List',
          style: TextStyle(
            fontFamily:'Raleway',
            fontWeight: FontWeight.w700,
            fontSize: 24,
            color: Colors.black87,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
      ),
      body: getbody(),
    );
  }
}

class PacListCard extends StatelessWidget {
  const PacListCard({
    super.key,
    required this.datum,
    this.onEdit,
    this.onDelete,
  });

  final Datum datum;
  final VoidCallback? onEdit;
  final Function(Datum)? onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        if (onEdit != null || kDebugMode) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (c) => HistoryScreen(taskId: datum.taskId),
            ),
          );
        }
      },
      child: Card(
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [Colors.white, Colors.grey.shade50],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            datum.subject,
                            style: theme.textTheme.titleMedium!.copyWith(
                              fontFamily: 'Raleway',
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${DateFormat('yyyy-MM-dd').format(datum.dateAdded)} (${datum.sdsCode})",
                            style: theme.textTheme.bodySmall!.copyWith(
                              fontFamily: 'Raleway',
                              fontSize: 12,
                              color: Colors.grey[600],
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Row(
                      children: [
                        if (onEdit != null) ...[
                          IconButton(
                            icon: const Icon(Icons.edit, color: Color.fromARGB(255, 53, 52, 52)),
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (c) => ManagePad(
                                    taskId: datum.taskId,
                                    ref: datum.refno,
                                  ),
                                ),
                              );
                              onEdit?.call();
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Color.fromARGB(255, 53, 52, 52)),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (c) => AlertDialog(
                                  title: const Text("Are you sure?"),
                                  content: const Text("This cannot be undone."),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        Navigator.pop(context);
                                        var res = await networkCaller.deletePac(datum.taskId);
                                        if (res) onDelete?.call(datum);
                                      },
                                      child: const Text("Delete"),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ] else
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Appcolors.primary2,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (c) => CheckinUpadatePacScreen(data: datum),
                                ),
                              );
                            },
                            child: const Text(
                              "UPDATE",
                              style: TextStyle(
                                fontFamily: 'Raleway',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(thickness: 1, height: 1, color: Colors.black12),
                const SizedBox(height: 12),
                _buildInfoRow("Ref. No", datum.refno, theme),
                _buildInfoRow(
                  "Started On",
                  DateFormat("yyyy-MM-dd hh:mm:ss").format(datum.startOn),
                  theme,
                ),
                _buildInfoRow("Status", datum.taskstatus, theme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(
              "$label:",
              style: theme.textTheme.bodySmall!.copyWith(
                fontFamily: 'Raleway',
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium!.copyWith(
                fontFamily: 'Raleway',
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


import 'package:easy_web_view/easy_web_view.dart';
import 'package:flutter/material.dart';
import 'package:gtaos/helper/network.dart';
import 'package:gtaos/model/pacHistory.dart';
import 'package:gtaos/views/pac.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key, required this.taskId});
  final String taskId;

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    getAsync();
  }

  PacHistory? pacHistory;
  getAsync() async {
    try {
      pacHistory = await networkCaller.pacHistoryGet(widget.taskId);
    } catch (e) {}
    if (mounted) setState(() {});
  }

  getbody() {
    if (pacHistory == null)
      return Center(
          child: CircularProgressIndicator(backgroundColor: Colors.orange));
    else {
      if (pacHistory!.data.isEmpty) return Center(child: Text("No history"));
      return RefreshIndicator(
        onRefresh: () {
          return getAsync();
        },
        child: ListView.builder(
            itemCount: pacHistory!.data.length,
            itemBuilder: (c, i) => Card(
                  elevation: 5,
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      row("Name", pacHistory!.data[i].userName),
                      row("Status", pacHistory!.data[i].taskstatus),
                      Divider(
                        endIndent: 15,
                        indent: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: EasyWebView(
                          src: pacHistory!.data[i].message,
                          isMarkdown: false, // Use markdown syntax
                          convertToWidgets:
                              true, // Try to convert to flutter widgets
                          height: getHeightByLength(
                              pacHistory!.data[i].message.length),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:
                            Text(pacHistory!.data[i].message.length.toString()),
                      ),
                    ],
                  ),
                )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('History'),
        ),
        body: getbody());
  }
}

getHeightByLength(length) {
  // log(length.toString());

  if (length == 0) return 1.00;
  if (length < 50) {
    return 30.0;
  }
  if (length > 500) {
    return (length - 1).toDouble() + 40.0 + 15.0;
  }

  return (length - 1).toDouble() + 15.0;
}
Padding row(String prefix, String suffix) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
    child: Row(
      children: [
        Text(prefix),
        Spacer(),
        Text(
          suffix,
          maxLines: 5,
        ),
      ],
    ),
  );
}
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gtaos/widgets/loading_overlay.dart';
import 'package:intl/intl.dart';

import 'package:gtaos/helper/network.dart';
import 'package:gtaos/model/dynamicSeletor.dart';
import 'package:gtaos/model/emp_dashboard.dart';
import 'package:gtaos/model/employelist.dart';
import 'package:gtaos/model/tasklist.dart';
import 'package:gtaos/views/actualhome.dart';

class WorkReport extends StatefulWidget {
  const WorkReport({super.key});

  @override
  State<WorkReport> createState() => _WorkReportState();
}

class _WorkReportState extends State<WorkReport> {
  EmployeeDashboard? employeeDashboard;
  @override
  void initState() {
    super.initState();

    dateTime = DateTime.now();
    getAsync();
  }

  late DateTime dateTime;
  EmpTaskList? empTaskList;
  TaskListDatum? seletedTD;
  Datum? employe;
  DynamicSelector? selectorDs;
  Option? selectorOption;
  ProductOptionValue? productOptionValue;
  getAsync([from, to]) async {
    try {
      await filter();

      networkCaller.getTaskList().then((v) {
        empTaskList = v;
        if (mounted) setState(() {});
      });
      networkCaller.getDynamicFormData().then((v) {
        if (mounted) setState(() {});
      });
      if (networkCaller.isAdminMode) {
        networkCaller.employeeList().then((v) {
          if (mounted) setState(() {});
        });
      }
    } catch (e) {}
  }

  filter([show = false]) async {
    if (show) {
      LoadingOverlay.show(context);
    }
    try {
      employeeDashboard = await networkCaller.getPacListReport(
          fromDateCon.text,
          toDateCon.text,
          seletedTD,
          selectorDs,
          selectorOption,
          productOptionValue,
          employe?.employeeId);
    } catch (e) {
      log(e.toString());
    }
    if (show) {
      LoadingOverlay.dismiss();
    }
    if (mounted) setState(() {});
  }

  var fromDateCon = TextEditingController();
  var toDateCon = TextEditingController();

  getbody() {
    if (employeeDashboard == null)
      return Center(
          child: CircularProgressIndicator(backgroundColor: Colors.orange));
    else {
      if (employeeDashboard!.data!.workdatas!.isEmpty)
        return Center(child: Text("No reports"));
      else
        return RefreshIndicator(
          onRefresh: () {
            return filter();
          },
          child: CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Card(
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: [
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              readOnly: true,
                              controller: fromDateCon,
                              onTap: () async {
                                var dt = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now()
                                        .subtract(Duration(days: 1000)),
                                    lastDate: DateTime.now()
                                        .add(Duration(days: 1000)));
                                if (dt != null) {
                                  fromDateCon.text =
                                      DateFormat("yyyy-MM-dd").format(dt);

                                  setState(() {});
                                }
                              },
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  label: Text("From")),
                            ),
                          )),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                readOnly: true,
                                controller: toDateCon,
                                onTap: () async {
                                  var dt = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now()
                                          .subtract(Duration(days: 1000)),
                                      lastDate: DateTime.now()
                                          .add(Duration(days: 1000)));
                                  if (dt != null) {
                                    toDateCon.text =
                                        DateFormat("yyyy-MM-dd").format(dt);

                                    setState(() {});
                                  }
                                },
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    label: Text("To")),
                              ),
                            ),
                          )
                        ],
                      ),
                      if (!networkCaller.isAdminMode && empTaskList != null)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownButtonFormField(
                            value: seletedTD,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                label: Text("Task")),
                            items: [
                              ...empTaskList!.data!
                                  .map<DropdownMenuItem>(
                                      (e) => DropdownMenuItem(
                                            child: Text(e.subject ?? "-"),
                                            value: e,
                                          ))
                                  .toList()
                            ],
                            onChanged: (value) {
                              seletedTD = value;
                              // dynamicSelector = value;
                              setState(() {});
                            },
                          ),
                        ),
                      if (networkCaller.isAdminMode &&
                          networkCaller.employeList != null)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownButtonFormField(
                            value: seletedTD,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                label: Text("Employee")),
                            items: [
                              ...networkCaller.employeList!.data
                                  .map<DropdownMenuItem>(
                                      (e) => DropdownMenuItem(
                                            child: Text(e.name),
                                            value: e,
                                          ))
                                  .toList()
                            ],
                            onChanged: (value) {
                              employe = value;
                            },
                          ),
                        ),
                      if (networkCaller.dynamicSelector != null) ...[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownButtonFormField(
                            value: selectorDs,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                label: Text("Product")),
                            items: [
                              ...networkCaller.dynamicSelector!
                                  .map<DropdownMenuItem<DynamicSelector>>(
                                      (e) => DropdownMenuItem(
                                            child: Text(e.name ?? "-"),
                                            value: e,
                                          ))
                                  .toList()
                            ],
                            onChanged: (value) {
                              selectorDs = value;

                              setState(() {});
                            },
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DropdownButtonFormField(
                                  isExpanded: true,
                                  value: selectorOption,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      label: Text("Option")),
                                  items: [
                                    ...networkCaller.dynamicSelector!
                                        .map((e) => e.option)
                                        .expand((element) => element!)
                                        .toList()
                                        .map<DropdownMenuItem<Option>>((e) =>
                                            DropdownMenuItem(
                                              child: Text(
                                                e.name ?? "-",
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              value: e,
                                            ))
                                        .toList()
                                  ],
                                  onChanged: (value) {
                                    selectorOption = value;

                                    setState(() {});
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DropdownButtonFormField(
                                  isExpanded: true,
                                  value: productOptionValue,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      label: Text("Value")),
                                  items: [
                                    ...networkCaller.dynamicSelector!
                                        .map((e) => e.option)
                                        .expand((element) => element!)
                                        .where((element) =>
                                            element.type == "select")
                                        .map((e) => e.productOptionValue)
                                        .expand((element) => element!)
                                        .toList()
                                        .map<
                                            DropdownMenuItem<
                                                ProductOptionValue>>((e) =>
                                            DropdownMenuItem(
                                              child: Text(
                                                e.name ?? "-",
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              value: e,
                                            ))
                                        .toList()
                                  ],
                                  onChanged: (value) {
                                    productOptionValue = value;

                                    setState(() {});
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red),
                              onPressed: () {
                                selectorDs = null;
                                selectorOption = null;
                                productOptionValue = null;
                                seletedTD = null;
                                setState(() {});
                                filter(true);
                              },
                              icon: const Icon(Icons.reset_tv),
                              label: Text("Reset")),
                          ElevatedButton.icon(
                              onPressed: () {
                                filter(true);
                              },
                              icon: const Icon(Icons.filter_drama),
                              label: Text("Filter")),
                        ],
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
              if (employeeDashboard != null &&
                  employeeDashboard!.data!.workdatas != null)
                SliverList(
                    delegate: SliverChildBuilderDelegate(
                  (c, i) {
                    var data = employeeDashboard!.data!.workdatas![i];

                    return PerWorkCard(data: data);
                  },
                  childCount: employeeDashboard!.data!.workdatas!.length,
                ))
            ],
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Work report'),
        ),
        body: getbody());
  }
}

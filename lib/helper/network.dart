import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:gtaos/model/add.dart';
import 'package:gtaos/model/admin.dart';
import 'package:gtaos/model/attendance.dart';
import 'package:gtaos/model/attendance_checker.dart';
import 'package:gtaos/model/attendancestatus.dart';
import 'package:gtaos/model/dynamicSeletor.dart';
import 'package:gtaos/model/emp_dashboard.dart';
import 'package:gtaos/model/employelist.dart';
import 'package:gtaos/model/latlong.dart';
import 'package:gtaos/model/pacHistory.dart';
import 'package:gtaos/model/paclist.dart';
import 'package:gtaos/model/product_add_model.dart';
import 'package:gtaos/model/product_for_update.dart';
import 'package:gtaos/model/projectlist.dart';
import 'package:gtaos/model/statuslist.dart';
import 'package:gtaos/model/tasklist.dart';
import 'package:gtaos/model/updatepac.dart';
import 'package:gtaos/model/user.dart';

class NetworkCaller {
  static String _currentDomain = "";
  static final Map<String, String> _urlCache = {};

  static String _getUrl(String key) {
    if (_currentDomain != AppConfig.domain) {
      _urlCache.clear();
      _currentDomain = AppConfig.domain;
    }
    
    return _urlCache.putIfAbsent(key, () {
      switch (key) {
        case 'addPac': return "$withSuffix/addPac";
        case 'adminChangePassword': return "$withSuffixAdmin/adminChangePassword";
        // Add all other cases...
        default: throw Exception("Unknown URL key: $key");
      }
    });
  }

  static String get addPac => _getUrl('addPac');
  static String get adminChangePassword => _getUrl('adminChangePassword');
  // static const addPac = "$withSuffix/addPac";
  // static const adminChangePassword = "$withSuffixAdmin/adminChangePassword";
  // static const adminDashbord = "$withSuffixAdmin/pacListDashboard";
  // static const adminLoginUrl = "$withSuffixAdmin/adminLogin";
  // static const attendance = "$domain/attendance";
  // static const attendanceStatusUrl = "$withSuffix/attendanceStatus";
  // static const attendanceUrl = "$withSuffix/attendanceLogout";
  // static const checkInStatusUrl = "$withSuffix/getCheckinStatus";
  // static const checkInUrl = "$withSuffix/checkIn";
  // static const deletePacurl = "$withSuffix/pacDelete";
  // // static const domain = "https://app.gleantech.com";
  // static String get domain => AppConfig.domain;
  
  // static String get withSuffix => "$domain/index.php?route=extension/app/account";
  // static String get withSuffixAdmin => "$domain/index.php?route=extension/app/admin";
  // static const editPac = "$withSuffix/editPac";
  // static const empChangePassword = "$withSuffix/empChangePassword";
  // static const empDashbord = "$withSuffix/pacListDashboard";
  // static const empForgotPasswordUrl = "$withSuffix/empForgotPassword";
  // static const employeeLoginUrl = "$withSuffix/employeeLogin";
  // static const employeeTaskListUrl = "$withSuffix/employeeTaskList";
  // static const forgotPasswordAdminUrl = "$withSuffixAdmin/adminForgotPassword";
  // static const getAttendence = "$withSuffixAdmin/getAttendence";
  // static const getPacUrl = "$withSuffix/getPac";
  // static const getSigninStatusUrl = "$withSuffix/getAttendanceStatus";
  // static const homeUrl = "$domain/index.php?route=employee/dashboard";
  // static const logOutUrl = "$domain/employeelogout";
  // static const mainUrl = "$domain/employee";
  // static const pacHistory = "$withSuffix/pacHistory";
  // static const pacListReportUrl = "$withSuffixAdmin/pacListReport";
  // static const paclist = "$withSuffix/paclist";
  // static const productList = "$withSuffix/productList";
  // static const deleteProductUrl = "$withSuffix/productDelete";
  // static const getProductUrl = "$withSuffix/getProduct";
  // static const projectList = "$withSuffix/projectList";
  // static const statuslist = "$withSuffix/statusList";
  // static const updatePacUrl = "$withSuffix/updatePac";
  // static const addProduct = "$withSuffix/addProduct";
  // static const editProductUrl = "$withSuffix/editProduct";
  // static const withSuffix = "$domain/index.php?route=extension/app/account";
  // static const withSuffixAdmin = "$domain/index.php?route=extension/app/admin";
// Domain configuration
  static String get domain => AppConfig.domain;
  static String get withSuffix => "$domain/index.php?route=extension/app/account";
  static String get withSuffixAdmin => "$domain/index.php?route=extension/app/admin";

  // Change all const to static final
  // static final addPac = "$withSuffix/addPac";
  // static final adminChangePassword = "$withSuffixAdmin/adminChangePassword";
  static final adminDashbord = "$withSuffixAdmin/pacListDashboard";
  static final adminLoginUrl = "$withSuffixAdmin/adminLogin";
  static final attendance = "$domain/attendance";
  static final attendanceStatusUrl = "$withSuffix/attendanceStatus";
  static final attendanceUrl = "$withSuffix/attendanceLogout";
  static final checkInStatusUrl = "$withSuffix/getCheckinStatus";
  static final checkInUrl = "$withSuffix/checkIn";
  static final deletePacurl = "$withSuffix/pacDelete";
  static final editPac = "$withSuffix/editPac";
  static final empChangePassword = "$withSuffix/empChangePassword";
  static final empDashbord = "$withSuffix/pacListDashboard";
  static final empForgotPasswordUrl = "$withSuffix/empForgotPassword";
  static final employeeLoginUrl = "$withSuffix/employeeLogin";
  static final employeeTaskListUrl = "$withSuffix/employeeTaskList";
  static final forgotPasswordAdminUrl = "$withSuffixAdmin/adminForgotPassword";
  static final getAttendence = "$withSuffixAdmin/getAttendence";
  static final getPacUrl = "$withSuffix/getPac";
  static final getSigninStatusUrl = "$withSuffix/getAttendanceStatus";
  static final homeUrl = "$domain/index.php?route=employee/dashboard";
  static final logOutUrl = "$domain/employeelogout";
  static final mainUrl = "$domain/employee";
  static final pacHistory = "$withSuffix/pacHistory";
  static final pacListReportUrl = "$withSuffixAdmin/pacListReport";
  static final paclist = "$withSuffix/paclist";
  static final productList = "$withSuffix/productList";
  static final deleteProductUrl = "$withSuffix/productDelete";
  static final getProductUrl = "$withSuffix/getProduct";
  static final projectList = "$withSuffix/projectList";
  static final statuslist = "$withSuffix/statusList";
  static final updatePacUrl = "$withSuffix/updatePac";
  static final addProduct = "$withSuffix/addProduct";
  static final editProductUrl = "$withSuffix/editProduct";

  AttendanceChecker? attendanceChecker;
  final box = GetStorage();
  List<DynamicSelector>? dynamicSelector;
  EmployeList? employeList;
  EmployeeDashboard? employeeDashboard;
  String? ip;
  Position? lastPosition;
  StreamSubscription<Position>? lp;
  PacList? pacList;
  var totalPac = "0";
  reset() {
    attendanceChecker = null;
    employeeDashboard = null;
    lastPosition = null;
  }

  String get totalPacUrl =>
      // isAdminMode ? "$withSuffixAdmin/totalPacs" :
      "$withSuffix/totalPacs";

  getDataByVendorId(url) async {
    var res = await http.post(Uri.parse(url), body: {
      "vendor_id": getUser()?.vendorId,
      if (!isAdminMode) "employee_id": getUser()?.employeeId
    });
    var js = jsonDecode(res.body);
    log(js.toString());
    return js;
  }

  getSigninStatus() async {
    var res = await http.post(Uri.parse(getSigninStatusUrl), body: {
      "vendor_id": getUser()?.vendorId,
      "employee_id": getUser()?.employeeId
    });
    var js = jsonDecode(res.body);
    log("getAttendanceStatus " + js.toString());
    return js["data"].toString() == "1";
  }

  updateThePac(UpdatePacModel updatePacModel) async {
    var body = jsonEncode(updatePacModel.toJson());
    var res = await http.post(Uri.parse(updatePacUrl), body: body);
    log("updateThePac : " + res.body);
    return jsonDecode(res.body)["success"].toString() == "1";
  }

  addproduct(ProductAddModel productAddModel) async {
    var body = jsonEncode(productAddModel.toJson());
    var res = await http.post(Uri.parse(addProduct), body: body);
    log("addproduct : " + res.body);
    return jsonDecode(res.body)["success"].toString() == "1";
  }

  editproduct(ProductAddModel productAddModel) async {
    var body = jsonEncode(productAddModel.toUpdateJson());
    log(body);
    var res = await http.post(Uri.parse(editProductUrl), body: body);
    log("editproduct : " + res.body);
    return jsonDecode(res.body)["success"].toString() == "1";
  }

  checkInStatus() async {
    var res = await http.post(Uri.parse(checkInStatusUrl),
        body: getEmployeeAndVendorId());
    log("checkInStatus : " + res.body);
    return jsonDecode(res.body)["success"].toString() == "1";
  }

  getUserAttendance(date, se) async {
    var body = {"vendor_id": getUser()?.vendorId, "filter_date": date};
    if (se != null) {
      body["employee_id"] = se;
    } else {
      if (isEmployee) body["employee_id"] = getUser()?.employeeId;
    }

    log("getUserAttendance body : " + body.toString());
    log(getAttendence);

    var res = await http.post(Uri.parse(getAttendence), body: body);
    log("getUserAttendance : " + res.body);
    return AttendanceData.fromJson(jsonDecode(res.body));
  }

  getPacListReport(
      [String? from,
      String? to,
      TaskListDatum? taskListDatum,
      DynamicSelector? dynamicSelector,
      Option? option,
      ProductOptionValue? productOptionValue,
      empid]) async {
    var body = {
      "vendor_id": getUser()?.vendorId,
      if (!isAdminMode) "filter_employee_id": getUser()?.employeeId,
    };
    if (empid != null) {
      body["filter_employee_id"] = empid;
    }
    if (from != null && from.isNotEmpty) {
      body["filter_date_from"] = from;
    }
    if (to != null && to.isNotEmpty) {
      body["filter_date_to"] = to;
    }
    if (taskListDatum != null) {
      body["task_id"] = taskListDatum.taskId.toString();
    }
    if (dynamicSelector != null) {
      body["product_id"] = dynamicSelector.productId.toString();
    }
    if (option != null) {
      body["option_id"] = option.optionId.toString();
    }
    if (productOptionValue != null) {
      body["option_value_id"] =
          productOptionValue.productOptionValueId.toString();
    }
    log(pacListReportUrl);
    log("getPacListReport body : " + body.toString());
    var res = await http.post(Uri.parse(pacListReportUrl), body: body);
    log("getPacListReport res : " + res.body);

    return EmployeeDashboard.fromJson(jsonDecode(res.body));
  }

  getTotalPacs({force = false}) async {
    if (totalPac != "0" && !force) return totalPac;

    var res = await http.post(Uri.parse(totalPacUrl), body: {
      "vendor_id": getUser()?.vendorId,
      "employee_id": getUser()?.employeeId
    });
    log("getTotalPacs: " + res.body);
    return totalPac = jsonDecode(res.body)["data"];
  }

  getAttendanceStatus() async {
    var res = await http.post(Uri.parse(attendanceStatusUrl), body: {
      "vendor_id": getUser()?.vendorId,
      "employee_id": getUser()?.employeeId
    });
    log("getTotalPacs: " + res.body);
    return AttendanceStatus.fromJson(jsonDecode(res.body));
  }

  getTaskList() async {
    var res = await http.post(Uri.parse(employeeTaskListUrl), body: {
      "vendor_id": getUser()?.vendorId,
      if (!isAdminMode) "employee_id": getUser()?.employeeId
    });
    log("getTaskList: " + res.body);
    return EmpTaskList.fromJson(jsonDecode(res.body));
  }

  getEmpPacListDashboard({force = false}) async {
    if (employeeDashboard != null && !force) return employeeDashboard;
    log(empDashbord);
    var res = await http
        .post(Uri.parse(isAdminMode ? adminDashbord : empDashbord), body: {
      "vendor_id": getUser()?.vendorId,
      if (!isAdminMode) "employee_id": getUser()?.employeeId
    });
    log("getEmpPacListDashboard body: " +
        {
          "vendor_id": getUser()?.vendorId,
          if (!isAdminMode) "employee_id": getUser()?.employeeId
        }.toString());

    log("getEmpPacListDashboard res: " + res.body);
    return employeeDashboard = EmployeeDashboard.fromJson(jsonDecode(res.body));
  }

  getPacList({force = false}) async {
    if (pacList != null && !force) return pacList;
    log("getttingPacList");
    return pacList = PacList.fromJson(await getDataByVendorId(paclist));
  }

  changPass(oldPass, newPass) async {
    var res = await http.post(
        Uri.parse(!isAdminMode ? empChangePassword : adminChangePassword),
        body: {
          "vendor_id": getUser()?.vendorId,
          if (!isAdminMode) "employee_id": getUser()?.employeeId,
          "oldpassword": oldPass,
          "password": newPass
        });
    log("changPass body: " +
        {
          "vendor_id": getUser()?.vendorId,
          if (!isAdminMode) "employee_id": getUser()?.employeeId,
          "oldpassword": oldPass,
          "password": newPass,
          "confirm": newPass,
        }.toString());
    log("changPass res : " + res.body);
    return jsonDecode(res.body)["success"].toString() == "1";
  }

  getDynamicFormData([force = false]) async {
    if (dynamicSelector != null && !force) return dynamicSelector;
    var res = await http.post(Uri.parse(productList),
        body: {"vendor_id": getUser()?.vendorId, "language_id": "1"});
    log(res.body);
    return dynamicSelector = jsonDecode(res.body)["data"]
        .map<DynamicSelector>((e) => DynamicSelector.fromJson(e))
        .toList();
  }

  deleteProduct(pid) async {
    var res = await http.post(Uri.parse(deleteProductUrl), body: {
      "product_id": pid,
    });
    log("deleteProduct $pid ${res.body}");
    return jsonDecode(res.body)["success"].toString() == "1";
  }

  getProduct(pid) async {
    var res = await http.post(Uri.parse(getProductUrl), body: {
      "product_id": pid,
      'vendor_id': getUser()?.vendorId,
    });
    log("getProduct $pid ${res.body}");
    return ProductForUpdate.fromJson(jsonDecode(res.body));
  }

  getPac(taskId) async {
    log("getttingPac $taskId");
    var res = await http.post(Uri.parse(getPacUrl), body: {
      "vendor_id": getUser()?.vendorId,
      if (!isAdminMode) "employee_id": getUser()?.employeeId,
      "task_id": taskId,
    });
    log(res.body);
    return Addpac.fromMap(jsonDecode(res.body)["data"]);
  }

  deletePac(taskid) async {
    log(taskid);
    var res = await http.post(Uri.parse(deletePacurl), body: {
      "vendor_id": getUser()?.vendorId,
      "task_id": taskid,
    });
    log(res.body);
    var js = jsonDecode(res.body);
    return js["success"] == 1;
  }

  pacHistoryGet(taskid) async {
    log(taskid);
    var res = await http.post(Uri.parse(pacHistory), body: {
      "vendor_id": getUser()?.vendorId,
      "task_id": taskid,
    });
    log(res.body);
    var js = jsonDecode(res.body);
    return PacHistory.fromJson(js);
  }

  addPacs(Addpac addpac) async {
    var body = {
      "vendor_id": getUser()?.vendorId,
      if (!isAdminMode) "employee_id": getUser()?.employeeId,
      ...addpac.toMap()
    };
    var res = await http.post(Uri.parse(addPac), body: body);
    log("addPacs :" + res.body);

    log(res.body);
  }

  updatePacs(Addpac addpac) async {
    var body = {
      "vendor_id": getUser()?.vendorId,
      if (!isAdminMode) "employee_id": getUser()?.employeeId,
      ...addpac.toUpdateMap()
    };
    log(body.toString());
    var res = await http.post(Uri.parse(editPac), body: body);
    log("updatePacs");

    log(res.body);
  }

  getProjectList() async {
    log("getttingProjectList");
    return ProjectList.fromJson(await getDataByVendorId(projectList));
  }

  getStatusList() async {
    log("getStatusList");
    return StatusList.fromJson(await getDataByVendorId(statuslist));
  }

  bool get isAdminMode => box.read("isAdminMode") ?? false;
  bool get isSupervisor =>
      !isAdminMode &&
      attendanceChecker != null &&
      attendanceChecker!.data.supervisor;
  bool get isEmployee =>
      !isAdminMode &&
      attendanceChecker != null &&
      !attendanceChecker!.data.supervisor;

  bool get canSwitchAccount =>
      box.read("user") != null && box.read("adminuser") != null;

  set isAdminMode(v) => box.write("isAdminMode", v);

  saveUser(user, isAdmin) async {
    if (isAdmin)
      await box.write("adminuser", user.toJson());
    else
      await box.write("user", user.toJson());
  }

  getUser() {
    if (isAdminMode) return AdminModel.fromJson(box.read("adminuser"));

    log(box.read("user").toString(), name: "cuser");
    if (box.read("user") == null) return box.read("user");
    return GTAOSEmployeeModel.fromJson(box.read("user"));
  }

  removeUser() async {
    if (isAdminMode) {
      await box.remove("adminuser");
      await box.remove("adminuser_headers");
      isAdminMode = false;
    } else {
      await box.remove("user");
      await box.remove("user_headers");

      lp?.cancel();
    }
    reset();
  }

  login(email, pass, isAdminLogin) async {
    var res = await http.post(
        Uri.parse(isAdminLogin ? adminLoginUrl : employeeLoginUrl),
        body: {"email": email, "password": pass});
    log("login " + res.body);
    print("login " + res.body);
    log("login " + res.headers.toString());

    var js = jsonDecode(res.body);
    var user;
    if (js["success"] == 1) {
      lp?.cancel();
      if (!isAdminLogin) {
        await box.write("user_headers", res.headers);
        user = GTAOSEmployeeModel.fromJson(js["data"]);
        await saveUser(user, isAdminLogin);
      } else {
        await box.write("adminuser_headers", res.headers);
        user = AdminModel.fromJson(js["data"]);
        await saveUser(AdminModel.fromJson(js["data"]), isAdminLogin);
      }
      isAdminMode = isAdminLogin;
    }
    return user;
  }

  employeeList() async {
    if (employeList != null) return employeList;
    var res = await http.post(
      Uri.parse("$withSuffix/employeeList"),
      body: getEmployeeAndVendorId(),
    );
    log("employeeList");
    log(res.body);
    var js = jsonDecode(res.body);
    return employeList = EmployeList.fromJson(js);
  }

  getLocationByEid(id, date) async {
    try {
      log(
        "getLocationByEid_$id" +
            {"filter_employee_id": id, "filter_date": date}.toString(),
      );
      var body = {"vendor_id": getUser()?.vendorId};
      if (id != null) {
        body["filter_employee_id"] = id;
      }
      if (date != null) {
        body["filter_date"] = date;
      }
      log("getLocationByEid body: " + body.toString());
      var url = "$withSuffixAdmin/empLocations";
      // if (isAdminMode || isSupervisor) {
      //   url = "$withSuffixAdmin/empLocations";
      // }
      var res = await http.post(Uri.parse(url), body: body);
      log(url);
      log("getLocationByEid res: " + res.body);
      var js = jsonDecode(res.body);
      if (js["success"] == 1)
        return js["data"]
            .where((a) => a["lat"].toString().isNotEmpty)
            .map<LatLongger>((e) => LatLongger.fromMap(e))
            .toList();
      else
        return [];
    } catch (e) {
      print(e.toString());
    }
  }

  sendPasswordResetEmail(email, isAdmin) async {
    var res = await http.post(
        Uri.parse(isAdmin
            ? NetworkCaller.forgotPasswordAdminUrl
            : NetworkCaller.empForgotPasswordUrl),
        body: {"email": email});
    var js = jsonDecode(res.body);
    return js["data"]["email_sent"];
  }

  checkAttendance() async {
    if (isAdminMode)
      return AttendanceChecker(
          data: AttendancechekerData(
              attendance: true, supervisor: true, employeeId: ''),
          success: true,
          error: []);
    log("$withSuffix/checkEmpAttendance");
    log("checkEmpAttendance body :" + getEmployeeAndVendorId().toString());

    var res = await http.post(Uri.parse("$withSuffix/checkEmpAttendance"),
        body: getEmployeeAndVendorId());
    log(res.body.toString());
    var js = jsonDecode(res.body);
    return attendanceChecker = AttendanceChecker.fromJson(js);
  }

  Future<String> getPublicIp() async {
    if (ip != null) return ip!;
    final response = await http.get(Uri.parse('https://api.ipify.org'));
    if (response.statusCode == 200) {
      return ip = response.body;
    } else {
      throw Exception('Failed to get public IP');
    }
  }

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR" + error.toString());
    });
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
  }

  logoutAttendance(AttendanceMiniObject datum) async {
    var res = await http.post(Uri.parse(NetworkCaller.attendanceUrl), body: {
      "attendancestatus": datum.name,
      "att_status_id": datum.statusId,
      ...getEmployeeAndVendorId()
    });
    log("logoutAttendance body: " +
        {
          "attendancestatus": datum.name,
          "att_status_id": datum.statusId,
          ...getEmployeeAndVendorId()
        }.toString());
    log("logoutAttendance : " + res.body);
  }

  getEmployeeAndVendorId() {
    var currentUser = getUser();

    return {
      if (!networkCaller.isAdminMode) "employee_id": currentUser!.employeeId,
      "vendor_id": currentUser.vendorId
    };
  }

  uploadPhoto(path, status, task) async {
    var request =
        http.MultipartRequest('POST', Uri.parse('$withSuffix/photoUpload'));
    if (kIsWeb) {
      request.files.add(
        http.MultipartFile.fromBytes('file', path,
            filename:
                getUser()?.employeeId + DateTime.now().toString() + ".png",
            contentType: MediaType("image", "png")),
      );
    } else {
      request.files.add(await http.MultipartFile.fromPath('file', path));
    }
    var currentLocaiton;
    try {
      currentLocaiton = await getUserCurrentLocation();
    } catch (e) {
      print(e);
      currentLocaiton = await getUserCurrentLocation();
    }
    var currentUser = getUser();
    request.fields.addAll({
      "ip": await getPublicIp(),
      "lat": currentLocaiton.latitude.toString(),
      "lon": currentLocaiton.longitude.toString(),
      "employee_id": currentUser!.employeeId,
      "vendor_id": currentUser.vendorId,
      "attendancestatus": status.name,
      "att_status_id": status.statusId,
      "task_id": task.taskId,
      "v_task_id": task.vTaskId,
      "taskstatus": task.taskstatus,
      "taskstatus_id": task.orderStatusId,
    });
    print(request.fields);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return jsonDecode(await response.stream.bytesToString());
    } else {
      return jsonDecode((response.reasonPhrase).toString());
    }
  }

  uploadAttachment(path) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('$withSuffix/attachmentUpload'));
    request.files.add(await http.MultipartFile.fromPath('file', path));

    var currentUser = getUser();
    request.fields.addAll({
      "employee_id": currentUser!.employeeId,
      "vendor_id": currentUser.vendorId,
    });
    print(request.fields);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var bod = await response.stream.bytesToString();
      log("uploadAttachment : " + bod);
      return jsonDecode(bod);
    } else {
      return jsonDecode((response.reasonPhrase).toString());
    }
  }

  uploadLiveLocation(Position currentLocaiton) async {
    lastPosition = currentLocaiton;
    log(currentLocaiton.toString(), name: "uploadLiveLocationCalled");
    var currentUser = getUser();
    if (currentUser == null) return;
    log("$withSuffix/insertLiveLocation");
    var res =
        await http.post(Uri.parse("$withSuffix/insertLiveLocation"), body: {
      "ip": await getPublicIp(),
      "lot": currentLocaiton.latitude.toString(),
      "lon": currentLocaiton.longitude.toString(),
      if (!isAdminMode) "employee_id": currentUser.employeeId,
      "vendor_id": currentUser.vendorId
    });
    log({
      "ip": await getPublicIp(),
      "lot": currentLocaiton.latitude.toString(),
      "lon": currentLocaiton.longitude.toString(),
      if (!isAdminMode) "employee_id": currentUser.employeeId,
      "vendor_id": currentUser.vendorId
    }.toString());
    var js = jsonDecode(res.body);
    log(js.toString());
  }

  checkin(inorout, taskid, vtaskid) async {
    var currentUser = getUser();
    if (currentUser == null) return;
    await Geolocator.checkPermission().then((value) async {
      if (value == LocationPermission.denied ||
          value == LocationPermission.deniedForever ||
          value == LocationPermission.unableToDetermine) {
        await Geolocator.requestPermission();
      }
      var cp = await Geolocator.getCurrentPosition();
      log("checkin body: " +
          {
            "id": inorout.toString(),
            "lat": cp.latitude.toString(),
            "long": cp.longitude.toString(),
            "employee_id": currentUser.employeeId.toString(),
            "vendor_id": currentUser.vendorId.toString(),
            "inorout": inorout.toString(),
            "attachname": "",
            "attachpath": "",
            "comments": ""
          }.toString());
      log(NetworkCaller.checkInUrl);
      var res = await http.post(Uri.parse(NetworkCaller.checkInUrl), body: {
        "id": inorout.toString(),
        "lat": cp.latitude.toString(),
        "long": cp.longitude.toString(),
        "inorout": inorout.toString(),
        "employee_id": currentUser.employeeId.toString(),
        "vendor_id": currentUser.vendorId.toString(),
        "attachname": "",
        "attachpath": "",
        "comments": ""
      });

      log("checkin res: " + res.body);
    });
  }

  uploadLiveLocationTest(lat, lng) async {
    var currentUser = getUser();
    if (currentUser == null) return;
    var res =
        await http.post(Uri.parse("$withSuffix/insertLiveLocation"), body: {
      "ip": await getPublicIp(),
      "lot": lat.toString(),
      "lon": lng.toString(),
      "employee_id": currentUser.employeeId,
      "vendor_id": currentUser.vendorId
    });
    log({
      "ip": await getPublicIp(),
      "lot": lat.toString(),
      "lon": lng.toString(),
      "employee_id": currentUser.employeeId,
      "vendor_id": currentUser.vendorId
    }.toString());
  }

  sendLivelocation() async {
    Geolocator.checkPermission().then((value) async {
      if (value == LocationPermission.denied ||
          value == LocationPermission.deniedForever ||
          value == LocationPermission.unableToDetermine) {
        await Geolocator.requestPermission();
      }
      if (lp == null) {
        log("Sending live location initiated");
        lp = Geolocator.getPositionStream(
                locationSettings: LocationSettings(distanceFilter: 2))
            .listen((event) {
          if (lastPosition != event) uploadLiveLocation(event);
        });
      }
    });
  }
  

  Future<LatLongger?> getLiveLocation(eid) async {
    var currentUser = getUser();
    var res = await http.post(Uri.parse("$withSuffix/getLiveLocation"),
        body: {"employee_id": eid, "vendor_id": currentUser!.vendorId});
    var js = jsonDecode(res.body);
    log("getLiveLocation $eid: " + js.toString());
    if (js["data"] != null) return LatLongger.fromMap(js["data"]);
    return null;
  }
}
class AppConfig {
  static String _domain = "https://app.gleantech.com"; // default domain
  
  static String get domain => _domain;
  
  static set domain(String value) {
    _domain = value;
    // You might want to persist this to GetStorage or other storage
    GetStorage().write('app_domain', value);
  }
    static final _storage = GetStorage();
  
  // static String get domain => _storage.read('app_domain') ?? "https://app.gleantech.com";
  
  static Future<void> setDomain(String newDomain) async {
    if (!newDomain.startsWith('http')) {
      newDomain = 'https://$newDomain';
    }
    await _storage.write('app_domain', newDomain);
    networkCaller.reset(); // Reset network caller state
  }
  
  static Future<void> clearDomain() async {
    await _storage.remove('app_domain');
  }
  static Future<void> loadDomain() async {
    // Load from storage if available
    _domain = GetStorage().read('app_domain') ?? "https://app.gleantech.com";
  }
}

final networkCaller = NetworkCaller();



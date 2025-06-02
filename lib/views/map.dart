import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animarker/flutter_map_marker_animation.dart';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_flutter_web/google_maps_flutter_web.dart';

import 'package:intl/intl.dart';
import 'package:gtaos/helper/network.dart';
import 'package:gtaos/model/employelist.dart';
import 'package:gtaos/model/latlong.dart';
import 'package:gtaos/widget/drawer.dart';
import 'package:gtaos/widgets/loading_overlay.dart';

class PlacePolylineBody extends StatefulWidget {
  const PlacePolylineBody({super.key});

  @override
  State<StatefulWidget> createState() => PlacePolylineBodyState();
}

class PlacePolylineBodyState extends State<PlacePolylineBody> {
  PlacePolylineBodyState();
  @override
  void initState() {
    super.initState();

    date = DateTime.now();
    setupMarkerIcon();
    getLocation();
    networkCaller.employeeList();
  }

  bool kisweb = false;

  BitmapDescriptor? icon;
  setupMarkerIcon() async {
    if (kIsWeb) {
      icon = await BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(), "asset/m1.png");
    } else if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android) {
      icon = await BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(),
          defaultTargetPlatform == TargetPlatform.iOS
              ? "asset/m1.png"
              : "asset/marker.png");
    } else if (defaultTargetPlatform == TargetPlatform.linux ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.windows) {
      // Some desktop specific code there
    }

    if (mounted) setState(() {});
  }

  getLocation() async {
    mrks = {};
    animatedMarker = {};
    latlngs = await networkCaller.getLocationByEid(
        networkCaller.isEmployee
            ? networkCaller.getUser()?.employeeId
            : selectedEmployee?.employeeId,
        DateFormat('yyyy-MM-dd').format(date!));
    var allLocations = <LatLng>[];
    for (var i = 0; i < latlngs!.length; i++) {
      var l = latlngs![i];
      mrks[l.toString()] = Marker(
          infoWindow: InfoWindow(title: l.name + " " + l.location),
          markerId: MarkerId(l.toString()),
          position: l.latlng);
      allLocations.add(l.latlng);
      if (mounted) setState(() {});
    }
    try {
      var currentLocation = await getUserCurrentLocation();
      allLocations
          .add(LatLng(currentLocation.latitude, currentLocation.longitude));
    } catch (e) {}
    var pid = PolylineId("poly");
    polylines[pid] =
        Polyline(endCap: Cap.roundCap, polylineId: pid, points: allLocations);
    if (mrks.isNotEmpty) {
      controller?.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: allLocations.last, zoom: 18)));
    }
    if (mounted) setState(() {});
  }

  getLocationOfAEmployee() async {
    mrks = {};
    animatedMarker = {};
    polylines = {};

    latlngs = await networkCaller.getLocationByEid(selectedEmployee?.employeeId,
        date != null ? DateFormat('yyyy-MM-dd').format(date!) : null);
    var allLocations = <LatLng>[];
    for (var i = 0; i < latlngs!.length; i++) {
      var l = latlngs![i];
      mrks[l.toString()] = Marker(
          infoWindow: InfoWindow(title: l.name + " " + l.location),
          markerId: MarkerId(l.toString()),
          position: l.latlng);
      allLocations.add(l.latlng);
      if (mounted) setState(() {});
    }
    var pid = PolylineId("poly");
    polylines[pid] =
        Polyline(endCap: Cap.roundCap, polylineId: pid, points: allLocations);
    if (mrks.isNotEmpty) {
      controller?.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: allLocations.last, zoom: 18)));
    }
    if (mounted) setState(() {});
  }

  getdata() {
    if (selectedEmployee?.employeeId != null)
      networkCaller.getLiveLocation(selectedEmployee?.employeeId).then((value) {
        if (value != null) {
          animatedMarker["a"] = Marker(
              markerId: MarkerId("markerId"),
              icon: icon!,
              infoWindow: InfoWindow(
                  title: selectedEmployee?.name ?? "" + ", Current Location"),
              position: value.latlng);
          setState(() {});

          controller?.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(target: LatLng(value.lat, value.lng), zoom: 18)));
        }
      });
    else {
      animatedMarker = {};

      timer?.cancel();
      setState(() {});
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    controller?.dispose();
    super.dispose();
  }

  getLiveLocation() {
    timer?.cancel();
    animatedMarker = {};
    setState(() {});
    getdata();
    timer = Timer.periodic(Duration(seconds: 3), (timer) {
      getdata();
    });
  }

  List<LatLongger>? latlngs;

  GoogleMapController? controller;
  Map<PolylineId, Polyline> polylines = <PolylineId, Polyline>{};
  Map<String, Marker> mrks = <String, Marker>{};
  Map<String, Marker> animatedMarker = <String, Marker>{};

  // ignore: use_setters_to_change_properties
  void _onMapCreated(GoogleMapController controller) {
    this.controller = controller;
    if (!completerCon.isCompleted) completerCon.complete(controller);
  }

  // created method for getting user current location
  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR" + error.toString());
    });

    return await Geolocator.getCurrentPosition();
  }

  Datum? selectedEmployee;
  List<Datum>? all;
  DateTime? date;
  bool searchmode = false;
  var con = TextEditingController();
  final completerCon = Completer<GoogleMapController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: GTAOSDrawer(),
        appBar: AppBar(
          leading: searchmode
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      searchmode = false;
                    });
                  },
                  icon: const Icon(Icons.arrow_back))
              : null,
          title: searchmode
              ? TextField(
                  onChanged: (v) {
                    all = networkCaller.employeList!.data
                        .where((element) => element.name
                            .toLowerCase()
                            .startsWith(v.toLowerCase()))
                        .toList();
                    setState(() {});
                  },
                  cursorColor: Colors.white,
                  style: TextStyle(color: Colors.white),
                  autofocus: true,
                )
              : const Text('Map View'),
          actions: searchmode
              ? []
              : [
                  IconButton(
                      onPressed: () {
                        showDatePicker(
                          context: context,
                          initialDate: date!,
                          firstDate: DateTime.now()
                              .subtract(const Duration(days: 600)),
                          lastDate:
                              DateTime.now().add(const Duration(days: 600)),
                        ).then((DateTime? value) async {
                          if (value != null) {
                            LoadingOverlay.show(context);
                            date = value;
                            try {
                              await getLocationOfAEmployee();
                            } catch (e) {
                              print(e);
                            }
                            LoadingOverlay.dismiss();

                            setState(() {});
                          }
                        });
                      },
                      icon: const Icon(Icons.date_range_sharp)),
                  if (networkCaller.isAdminMode ||
                      (networkCaller.attendanceChecker?.data.supervisor ??
                          false))
                    IconButton(
                        onPressed: () async {
                          all = (await networkCaller.employeeList()).data;

                          setState(() {
                            searchmode = true;
                          });
                        },
                        icon: const Icon(Icons.search))
                ],
        ),
        body: Stack(
          children: <Widget>[
            Column(
              children: [
                if (selectedEmployee != null)
                  ListTile(
                    trailing: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () async {
                        selectedEmployee = null;
                        date = DateTime.now();
                        LoadingOverlay.show(context);
                        try {
                          animatedMarker = {};
                          timer?.cancel();
                          await getLocation();
                        } catch (e) {
                          print(e);
                        }
                        LoadingOverlay.dismiss();

                        timer?.cancel();
                        setState(() {});
                      },
                    ),
                    leading: const Icon(Icons.person),
                    title: Text(selectedEmployee?.name ?? "-"),
                    subtitle: Text(DateFormat('yyyy-MM-dd').format(date!)),
                  ),
                Expanded(
                  child: Animarker(
                    useRotation: false,
                    shouldAnimateCamera: true,
                    zoom: 18,
                    markers: animatedMarker.values.toSet(),
                    mapId: completerCon.future.then<int>((value) {
                      log("mapId ${value.mapId}");
                      return value.mapId;
                    }),
                    child: GoogleMap(
                      // myLocationEnabled: true,
                      indoorViewEnabled: true,
                      buildingsEnabled: true,
                      markers: mrks.values.toSet(),
                      initialCameraPosition: const CameraPosition(
                        target: LatLng(0, 0),
                        zoom: 17.0,
                      ),
                      polylines: Set<Polyline>.of(polylines.values),
                      onMapCreated: _onMapCreated,
                    ),
                  ),
                ),
              ],
            ),
            if (searchmode)
              Container(
                color: Colors.white,
                child: ListView.builder(
                  itemCount: all?.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      selected: selectedEmployee == all![index],
                      onTap: () async {
                        animatedMarker = {};
                        if (selectedEmployee == all![index]) {
                          LoadingOverlay.show(context);
                          searchmode = false;
                          selectedEmployee = null;
                          try {
                            await getLocation();
                          } catch (e) {}
                          LoadingOverlay.dismiss();

                          timer?.cancel();
                        } else {
                          LoadingOverlay.show(context);
                          selectedEmployee = all![index];
                          searchmode = false;
                          try {
                            await getLocationOfAEmployee();
                            await getLiveLocation();
                          } catch (e) {}
                          LoadingOverlay.dismiss();
                        }
                        setState(() {});
                      },
                      leading: const Icon(Icons.person),
                      title: Text(all![index].name),
                    );
                  },
                ),
              )
          ],
        ));
  }

  Timer? timer;
}

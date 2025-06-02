import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class LatLongger {
  double lat;
  double lng;
  String location, name;
  LatLongger({
    required this.lat,
    required this.lng,
    required this.location,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "lat": lat,
      "lng": lng,
      "location": location,
    };
  }

  LatLng get latlng => LatLng(this.lat, this.lng);

  factory LatLongger.fromMap(Map<String, dynamic> map) {
    return LatLongger(
      lat: double.parse(map["lat"].toString()),
      lng: double.parse(map["lon"].toString()),
      location: map["location"] ?? "-",
      name: map["name"] ?? "-",
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() => "LatLongger(lat: $lat, lng: $lng, location: $location)'";

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LatLongger &&
        other.lat == lat &&
        other.lng == lng &&
        other.location == location;
  }

  @override
  int get hashCode => lat.hashCode ^ lng.hashCode ^ location.hashCode;

  factory LatLongger.fromJson(String source) =>
      LatLongger.fromMap(json.decode(source));
}

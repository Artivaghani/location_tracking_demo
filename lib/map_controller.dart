import 'dart:async';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:location_tracking_demo/Constance.dart';

class MapController extends GetxController {
  Completer<GoogleMapController> mapcontroller = Completer();

  CameraPosition kGooglePlex = const CameraPosition(
    target: LatLng(21.2049, 72.8411),
    zoom: 15,
  );

  Location location = Location();
  LocationData? locationData;

  bool isloading = true;

  PolylinePoints polylinePoints = PolylinePoints();

  PolylineResult? result;

  List<LatLng> polilinecordinator = [];

  @override
  void onInit() {
    getcurrentlocation();
    location.onLocationChanged.listen((LocationData currentLocation) async {
      locationData = currentLocation;
      update();
    });

    super.onInit();
  }

  getcurrentlocation() async {
    location.getLocation().then((value) {
      isloading = false;

      kGooglePlex = CameraPosition(
        target: LatLng(value.latitude!, value.longitude!),
        zoom: 20,
      );
      update();
    });

    result = await polylinePoints.getRouteBetweenCoordinates(
        Constance.mapapikey,
        const PointLatLng(21.2049, 72.8411),
        const PointLatLng(21.2186, 72.8873));
    print(result!.points);
    for (var element in result!.points) {
      polilinecordinator.add(LatLng(element.latitude, element.longitude));
    }

    update();
  }
}


import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_tracking_demo/map_controller.dart';

void main() {
  if (Platform.isAndroid) {
    AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final MapController c = Get.put(MapController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location track demo'),
      ),
      body: GetBuilder<MapController>(
        builder: (controller) => controller.isloading
            ? const CircularProgressIndicator()
            : GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: c.kGooglePlex,
                onMapCreated: (GoogleMapController controller) {
                  c.mapcontroller.complete(controller);
                },
                markers: {
                  Marker(
                      markerId: const MarkerId('current'),
                      icon: BitmapDescriptor.defaultMarkerWithHue(90),
                      position: LatLng(controller.locationData!.latitude!,
                          controller.locationData!.longitude!)),
                  const Marker(
                      markerId: MarkerId('pickup'),
                      icon: BitmapDescriptor.defaultMarker,
                      position: LatLng(21.2049, 72.8411)),
                  const Marker(
                      markerId: MarkerId('drop'),
                      icon: BitmapDescriptor.defaultMarker,
                      position: LatLng(21.2186, 72.8873))
                },
                polylines: {
                  Polyline(
                      polylineId: const PolylineId('rout'),
                      points: controller.polilinecordinator,
                      color: Colors.blue,
                      width: 6)
                },
              ),
      ),
    );
  }
}

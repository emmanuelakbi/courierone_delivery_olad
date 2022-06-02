import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;

// ignore: must_be_immutable
class MyMapWidget extends StatefulWidget {
  final MyMapData _myMapData;

  MyMapWidget(Key key, this._myMapData) : super(key: key);

  @override
  MyMapState createState() => MyMapState(_myMapData);
}

class MyMapState extends State<MyMapWidget> {
  MyMapData mapData;
  GoogleMapController _googleMapController;

  MyMapState(this.mapData);

  @override
  Widget build(BuildContext context) {
    print("BuildingMapWith: $mapData");
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: mapData.latLngCenter,
        zoom: 6.0,
      ),
      mapType: MapType.normal,
      markers: mapData.markers,
      polylines: mapData.polyLines,
      zoomControlsEnabled: mapData.zoomEnabled,
      onMapCreated: (GoogleMapController controller) {
        _googleMapController = controller;
        rootBundle
            .loadString('assets/map_style.json')
            .then((string) => _googleMapController.setMapStyle(string));
      },
    );
  }

  void buildWith(MyMapData myMapData) {
    setState(() {
      mapData = myMapData;
    });
  }

  void updateMarkerLocation(String markerId, LatLng markerLocation) {
    Marker newMarker;
    mapData.markers.forEach((element) {
      if (element.markerId.value == markerId) {
        newMarker =
            MyMapHelper.genMarker(markerLocation, markerId, element.icon);
      }
    });
    if (newMarker != null) {
      print("newMarker: ${newMarker.markerId.value}");
      _googleMapController
          .animateCamera(CameraUpdate.newLatLng(markerLocation))
          .then((value) {
        setState(() {
          mapData.markers
              .removeWhere((element) => element.markerId.value == markerId);
          mapData.markers.add(newMarker);
        });
      });
    }
  }
}

class MyMapData {
  final LatLng latLngCenter;
  final Set<Marker> markers;
  final Set<Polyline> polyLines;
  final bool zoomEnabled;

  MyMapData(this.latLngCenter, this.markers, this.polyLines, this.zoomEnabled);

  @override
  String toString() {
    return 'MyMapData{center: $latLngCenter, markers: ${markers.length}, polyLines: ${polyLines.length}';
  }
}

class MyMapHelper {
  static Marker genMarker(
      LatLng latLng, String id, BitmapDescriptor descriptor) {
    return Marker(markerId: MarkerId(id), icon: descriptor, position: latLng);
  }

  static LatLngBounds getMarkerBounds(List<Marker> markers) {
    var lngs = markers.map<double>((m) => m.position.longitude).toList();
    var lats = markers.map<double>((m) => m.position.latitude).toList();

    double topMost = lngs.reduce(max);
    double leftMost = lats.reduce(min);
    double rightMost = lats.reduce(max);
    double bottomMost = lngs.reduce(min);

    LatLngBounds bounds = LatLngBounds(
      northeast: LatLng(rightMost, topMost),
      southwest: LatLng(leftMost, bottomMost),
    );

    return bounds;
  }
}

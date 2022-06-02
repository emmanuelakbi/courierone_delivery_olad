import 'package:courieronedelivery/config/app_config.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

class MapRepository {
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: AppConfig.mapsApiKey);

  Stream<Position> getCurrentLocation() {
    return Geolocator.getPositionStream(
      intervalDuration: Duration(seconds: 15),
      distanceFilter: 50,
    );
  }

  Future<Placemark> getAddressFromLatLng(LatLng latLng) async {
    List<Placemark> p = await GeocodingPlatform.instance
        .placemarkFromCoordinates(latLng.latitude, latLng.longitude);
    Placemark place = p[0];
    return place;
  }

  Future<List<LatLng>> getPolyline(
      LatLng pickupLatLng, LatLng dropLatLng) async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      AppConfig.mapsApiKey,
      PointLatLng(pickupLatLng.latitude, pickupLatLng.longitude),
      PointLatLng(dropLatLng.latitude, dropLatLng.longitude),
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    return polylineCoordinates;
  }

  Future<List<LatLng>> getPolylineCoordinates(
      LatLng source, LatLng destination) async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      AppConfig.mapsApiKey,
      PointLatLng(source.latitude, source.longitude),
      PointLatLng(destination.latitude, destination.longitude),
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    return polylineCoordinates;
  }

  Future<PlaceDetails> getPlaceDetails(String placeId) async {
    PlacesDetailsResponse response = await _places.getDetailsByPlaceId(placeId);
    return response.result;
  }

  LatLng getLatLng(PlaceDetails placeDetails) {
    LatLng latLng = LatLng(
        placeDetails.geometry.location.lat, placeDetails.geometry.location.lng);
    return latLng;
  }
}

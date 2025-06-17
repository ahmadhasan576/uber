import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

class TripRouteMapPage extends StatefulWidget {
  final LatLng fromLocation;
  final LatLng toLocation;

  TripRouteMapPage({required this.fromLocation, required this.toLocation});

  @override
  _TripRouteMapPageState createState() => _TripRouteMapPageState();
}

class _TripRouteMapPageState extends State<TripRouteMapPage> {
  List<LatLng> routePoints = [];
  final MapController mapController = MapController();

  final String apiKey =
      '5b3ce3597851110001cf6248ae7a6b1e52694f0abf85e2f36dec49fe';

  @override
  void initState() {
    super.initState();
    _getRouteFromORS(widget.fromLocation, widget.toLocation);
  }

  Future<void> _getRouteFromORS(LatLng from, LatLng to) async {
    final url =
        'https://api.openrouteservice.org/v2/directions/driving-car?api_key=$apiKey'
        '&start=${from.longitude},${from.latitude}&end=${to.longitude},${to.latitude}';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> coordinates =
            data["features"][0]["geometry"]["coordinates"];

        setState(() {
          routePoints =
              coordinates
                  .map<LatLng>((coord) => LatLng(coord[1], coord[0]))
                  .toList();
        });
      } else {
        print("Route API error: ${response.body}");
      }
    } catch (e) {
      print("Error fetching route: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("خريطة الرحلة"),
        backgroundColor: Colors.indigo,
      ),
      body: FlutterMap(
        mapController: mapController,
        options: MapOptions(center: widget.fromLocation, zoom: 13.0),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          if (routePoints.isNotEmpty)
            PolylineLayer(
              polylines: [
                Polyline(
                  points: routePoints,
                  strokeWidth: 4.0,
                  color: Colors.indigo,
                ),
              ],
            ),
          MarkerLayer(
            markers: [
              Marker(
                point: widget.fromLocation,
                builder:
                    (ctx) =>
                        Icon(Icons.location_on, color: Colors.green, size: 35),
              ),
              Marker(
                point: widget.toLocation,
                builder: (ctx) => Icon(Icons.flag, color: Colors.red, size: 35),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

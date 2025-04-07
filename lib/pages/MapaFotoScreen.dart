import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapaFotoScreen extends StatelessWidget {
  final double latitud;
  final double longitud;

  const MapaFotoScreen({
    Key? key,
    required this.latitud,
    required this.longitud,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LatLng ubicacion = LatLng(latitud, longitud);

    return Scaffold(
      appBar: AppBar(title: const Text('Ubicación de la Foto')),
      body: FlutterMap(
        options: MapOptions(center: ubicacion, zoom: 15.0),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(
            markers: [
              Marker(
                width: 40,
                height: 40,
                point: ubicacion,
                child: const Icon(
                  Icons.location_pin,
                  size: 40,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

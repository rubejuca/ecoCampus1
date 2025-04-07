import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class CameraPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Hardware();
  }
}

class _Hardware extends State<CameraPage> {
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  Position? _currentPosition;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Acceso a Cámara y GPS"),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildCameraGalleryButton("Cámara", ImageSource.camera),
                  SizedBox(width: 20),
                  _buildCameraGalleryButton("Galería", ImageSource.gallery),
                ],
              ),
              SizedBox(height: 20),

              if (_imageFile != null)
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                    image: DecorationImage(
                      image: FileImage(_imageFile!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              SizedBox(height: 20),

              if (_currentPosition != null)
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: FlutterMap(
                      options: MapOptions(
                        center: LatLng(
                          _currentPosition!.latitude,
                          _currentPosition!.longitude,
                        ),
                        zoom: 15,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                          subdomains: ['a', 'b', 'c'],
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              width: 40,
                              height: 40,
                              point: LatLng(
                                _currentPosition!.latitude,
                                _currentPosition!.longitude,
                              ),
                              child: Icon(
                                Icons.location_pin,
                                color: Colors.red,
                                size: 40,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCameraGalleryButton(String text, ImageSource source) {
    return ElevatedButton(
      onPressed: () => getImage(source),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.teal,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
      ),
      child: Row(
        children: [
          Icon(
            source == ImageSource.camera
                ? Icons.camera_alt
                : Icons.photo_library,
            color: Colors.white,
          ),
          SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Future<void> getImage(ImageSource source) async {
    XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      File localImage = File(image.path);

      bool locationIsActive = await Geolocator.isLocationServiceEnabled();

      if (locationIsActive) {
        LocationPermission permissions = await Geolocator.checkPermission();

        if (permissions == LocationPermission.denied ||
            permissions == LocationPermission.deniedForever) {
          permissions = await Geolocator.requestPermission();
        }

        if (permissions == LocationPermission.always ||
            permissions == LocationPermission.whileInUse) {
          try {
            await Future.delayed(Duration(seconds: 2));

            Position position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high,
            );

            debugPrint(
              "Ubicación obtenida: ${position.latitude}, ${position.longitude}",
            );

            setState(() {
              _imageFile = localImage;
              _currentPosition = position;
            });
          } catch (e) {
            debugPrint("Error al obtener ubicación: $e");

            Position? lastKnown = await Geolocator.getLastKnownPosition();

            if (lastKnown != null) {
              debugPrint(
                "Usando última ubicación conocida: ${lastKnown.latitude}, ${lastKnown.longitude}",
              );

              setState(() {
                _imageFile = localImage;
                _currentPosition = lastKnown;
              });
            } else {
              setState(() {
                _imageFile = localImage;
                _currentPosition = null;
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("No se pudo obtener la ubicación.")),
              );
            }
          }
        }
      }
    }
  }
}

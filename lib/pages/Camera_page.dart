import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';

class Camera_page extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Hardware();
  }
}

class _Hardware extends State<Camera_page> {
  final ImagePicker _picker = ImagePicker();

  DecorationImage defaultImage = DecorationImage(
    fit: BoxFit.cover,
    image: NetworkImage(
      "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
    ),
  );

  TextEditingController latitude = TextEditingController();
  TextEditingController longitude = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Acceso a Cámara y GPS"),
        backgroundColor: Colors.teal, // Cambié el color de la AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Añadí un padding general
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Botones para cámara y galería con un estilo moderno
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildCameraGalleryButton("Cámara", ImageSource.camera),
                SizedBox(width: 20),
                _buildCameraGalleryButton("Galería", ImageSource.gallery),
              ],
            ),
            SizedBox(height: 20),

            // Contenedor de imagen con borde redondeado y sombra
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
                    offset: Offset(0, 4), // Cambié la posición de la sombra
                  ),
                ],
                image: defaultImage,
              ),
            ),
            SizedBox(height: 20),

            // Campos de texto para mostrar latitud y longitud
            _buildTextField(latitude, "Latitud"),
            SizedBox(height: 10),
            _buildTextField(longitude, "Longitud"),
          ],
        ),
      ),
    );
  }

  // Función para crear los botones de la cámara y galería con diseño personalizado
  Widget _buildCameraGalleryButton(String text, ImageSource source) {
    return ElevatedButton(
      onPressed: () {
        getImage(source);
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.teal, // Color del texto del botón
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Bordes redondeados
        ),
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

  // Función para crear los campos de texto para latitud y longitud
  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      readOnly: true,
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          fontSize: 16,
          color: const Color.fromARGB(255, 98, 147, 142),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.teal, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.teal, width: 2),
        ),
      ),
    );
  }

  // Función para obtener la imagen y la ubicación
  void getImage(ImageSource source) async {
    XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      File localImage = File(image.path);

      bool locationIsActive = await Geolocator.isLocationServiceEnabled();

      if (locationIsActive) {
        LocationPermission permissions = await Geolocator.checkPermission();

        if (permissions == LocationPermission.unableToDetermine ||
            permissions == LocationPermission.denied ||
            permissions == LocationPermission.deniedForever) {
          permissions = await Geolocator.requestPermission();
        }
        if (permissions == LocationPermission.always ||
            permissions == LocationPermission.whileInUse) {
          Position position = await Geolocator.getCurrentPosition();

          latitude.text = position.latitude.toString();
          longitude.text = position.longitude.toString();
        }
      }

      setState(() {
        this.defaultImage = DecorationImage(image: FileImage(localImage));
      });
    }
  }
}

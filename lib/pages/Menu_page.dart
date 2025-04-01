import 'package:flutter/material.dart';
import 'package:ejemplo1/pages/Camera_page.dart'; // Importación correcta para Camera_page.dart

class Menu_Page extends StatelessWidget {
  const Menu_Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menú Principal'),
        backgroundColor: Colors.grey[300],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildMenuButton(context, 'Emergencias', Icons.warning, Colors.red),
            const SizedBox(height: 20),
            _buildMenuButton(
              context,
              'Daños Infraestructura',
              Icons.construction,
              Colors.orange,
            ),
            const SizedBox(height: 20),
            _buildMenuButton(
              context,
              'Reportes Generales',
              Icons.assignment,
              Colors.blue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
  ) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 15),
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Camera_page(),
          ), // Aquí sigue usando Camera_page
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

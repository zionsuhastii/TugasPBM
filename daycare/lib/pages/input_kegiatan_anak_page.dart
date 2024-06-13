import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:daycare/models/activity.dart';
import 'package:daycare/providers/app_providers.dart';
import 'package:daycare/pages/kegiatan_anak_page.dart';

class InputKegiatanPage extends StatefulWidget {
  const InputKegiatanPage({super.key});

  @override
  _InputKegiatanPageState createState() => _InputKegiatanPageState();
}

class _InputKegiatanPageState extends State<InputKegiatanPage> {
  final TextEditingController _kegiatanController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();

  void _submitKegiatan() {
    final String kegiatan = _kegiatanController.text;
    final String deskripsi = _deskripsiController.text;

    if (kegiatan.isNotEmpty && deskripsi.isNotEmpty) {
      Provider.of<AppProvider>(context, listen: false)
          .addActivity(Activity(name: kegiatan, description: deskripsi));
      _kegiatanController.clear();
      _deskripsiController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Input Kegiatan'),
        backgroundColor: Colors.indigo,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo, Colors.blue],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const Text(
                'Input Kegiatan',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _kegiatanController,
                        decoration: const InputDecoration(
                          labelText: 'Nama Kegiatan',
                          labelStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _deskripsiController,
                        decoration: const InputDecoration(
                          labelText: 'Deskripsi',
                          labelStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitKegiatan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                ),
                child: const Text('Submit'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const KegiatanAnakPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                ),
                child: const Text('Lihat Kegiatan Anak'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

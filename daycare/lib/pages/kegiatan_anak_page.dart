import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:daycare/providers/app_providers.dart';

class KegiatanAnakPage extends StatelessWidget {
  const KegiatanAnakPage({super.key});

  @override
  Widget build(BuildContext context) {
    final activities = Provider.of<AppProvider>(context).activities;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kegiatan Anak'),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 115, 114, 206),
              Color.fromARGB(255, 18, 29, 177)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView.builder(
          itemCount: activities.length,
          itemBuilder: (context, index) {
            final activity = activities[index];
            return Card(
              elevation: 5,
              margin: const EdgeInsets.all(16),
              child: ListTile(
                title: Text(
                  activity.name,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  activity.description,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const SevaMitraApp());
}

class SevaMitraApp extends StatelessWidget {
  const SevaMitraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SevaMitra 2.0',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const WorkerListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Worker {
  final String name;
  final String category;
  final String phone;
  final String location;

  Worker({
    required this.name,
    required this.category,
    required this.phone,
    required this.location,
  });
}

class WorkerListScreen extends StatefulWidget {
  const WorkerListScreen({super.key});

  @override
  State<WorkerListScreen> createState() => _WorkerListScreenState();
}

class _WorkerListScreenState extends State<WorkerListScreen> {
  final List<Worker> _workers = [
    Worker(name: 'Ramesh Kumar', category: 'Electrician', phone: '+919876543210', location: 'Delhi'),
    Worker(name: 'Suresh Sharma', category: 'Plumber', phone: '+919123456789', location: 'Noida'),
    Worker(name: 'Amit Verma', category: 'Carpenter', phone: '+919988776655', location: 'Gurgaon'),
  ];

  void _addWorkerDialog() {
    final nameController = TextEditingController();
    final categoryController = TextEditingController();
    final phoneController = TextEditingController();
    final locationController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Local Worker'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
                TextField(controller: categoryController, decoration: const InputDecoration(labelText: 'Category (e.g. Electrician)')),
                TextField(controller: phoneController, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Phone Number')),
                TextField(controller: locationController, decoration: const InputDecoration(labelText: 'Location')),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty && phoneController.text.isNotEmpty) {
                  setState(() {
                    _workers.add(Worker(
                      name: nameController.text,
                      category: categoryController.text.isNotEmpty ? categoryController.text.text ?? 'General' : 'General',
                      phone: phoneController.text,
                      location: locationController.text.isNotEmpty ? locationController.text : 'Local',
                    ));
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  Future<void> _openWhatsApp(String phoneNumber) async {
    final Uri launchUri = Uri.parse('https://wa.me/$phoneNumber');
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SevaMitra 2.0 - Direct Services'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: _workers.length,
        itemBuilder: (context, index) {
          final worker = _workers[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blueAccent,
                child: Text(worker.name[0], style: const TextStyle(color: Colors.white)),
              ),
              title: Text(worker.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${worker.category} • ${worker.location}\nPhone: ${worker.phone}'),
              isThreeLine: true,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.call, color: Colors.green),
                    onPressed: () => _makePhoneCall(worker.phone),
                  ),
                  IconButton(
                    icon: const Icon(Icons.message, color: Colors.teal),
                    onPressed: () => _openWhatsApp(worker.phone),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addWorkerDialog,
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

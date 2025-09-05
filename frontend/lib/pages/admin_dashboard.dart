import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/worker.dart';
import 'login_page.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  List<Worker> workers = [];
  List<Worker> filteredWorkers = [];
  bool isLoading = true;
  String searchQuery = "";

  // Form controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _skillController = TextEditingController();
  final TextEditingController _villageController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _languagesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchWorkers();
  }

  Future<void> fetchWorkers() async {
    try {
      final data = await ApiService.getWorkers();
      setState(() {
        workers = data.map((w) => Worker.fromJson(w)).toList();
        filteredWorkers = workers;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to load workers: $e")));
    }
  }

  void _filterWorkers(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      filteredWorkers = workers.where((w) {
        return w.name.toLowerCase().contains(searchQuery) ||
            w.skill.toLowerCase().contains(searchQuery) ||
            w.village.toLowerCase().contains(searchQuery);
      }).toList();
    });
  }

  Future<void> addWorker() async {
    final worker = {
      "name": _nameController.text.trim(),
      "skill": _skillController.text.trim(),
      "village": _villageController.text.trim(),
      "phone": _phoneController.text.trim(),
      "languages": _languagesController.text.trim(),
    };

    final success = await ApiService.addWorker(worker);

    if (success) {
      Navigator.pop(context);
      fetchWorkers();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Worker added successfully")),
      );
    }
  }

  Future<void> editWorker(Worker worker) async {
    _nameController.text = worker.name;
    _skillController.text = worker.skill;
    _villageController.text = worker.village;
    _phoneController.text = worker.phone;
    _languagesController.text = worker.languages ?? "";

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Worker"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Name"),
              ),
              TextField(
                controller: _skillController,
                decoration: const InputDecoration(labelText: "Skill"),
              ),
              TextField(
                controller: _villageController,
                decoration: const InputDecoration(labelText: "Village"),
              ),
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: "Phone"),
              ),
              TextField(
                controller: _languagesController,
                decoration: const InputDecoration(labelText: "Languages"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              final updatedWorker = {
                "name": _nameController.text.trim(),
                "skill": _skillController.text.trim(),
                "village": _villageController.text.trim(),
                "phone": _phoneController.text.trim(),
                "languages": _languagesController.text.trim(),
              };
              final success = await ApiService.updateWorker(
                worker.id,
                updatedWorker,
              );
              if (success) {
                Navigator.pop(context);
                fetchWorkers();
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text("Worker updated")));
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  Future<void> deleteWorker(int id) async {
    final success = await ApiService.deleteWorker(id);
    if (success) {
      fetchWorkers();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Worker deleted")));
    }
  }

  void _showAddWorkerDialog() {
    _nameController.clear();
    _skillController.clear();
    _villageController.clear();
    _phoneController.clear();
    _languagesController.clear();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Worker"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Name"),
              ),
              TextField(
                controller: _skillController,
                decoration: const InputDecoration(labelText: "Skill"),
              ),
              TextField(
                controller: _villageController,
                decoration: const InputDecoration(labelText: "Village"),
              ),
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: "Phone"),
              ),
              TextField(
                controller: _languagesController,
                decoration: const InputDecoration(labelText: "Languages"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(onPressed: addWorker, child: const Text("Add")),
        ],
      ),
    );
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddWorkerDialog,
          ),
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: "Search by name/skill/village",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _filterWorkers,
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: filteredWorkers.length,
                    itemBuilder: (context, index) {
                      final w = filteredWorkers[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        child: ListTile(
                          title: Text("${w.name} - ${w.skill}"),
                          subtitle: Text(
                            "${w.village} | ${w.phone} | ${w.languages ?? ''}",
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                                onPressed: () => editWorker(w),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => deleteWorker(w.id),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

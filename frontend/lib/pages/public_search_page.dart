import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/worker.dart';

class PublicSearchPage extends StatefulWidget {
  const PublicSearchPage({super.key});

  @override
  State<PublicSearchPage> createState() => _PublicSearchPageState();
}

class _PublicSearchPageState extends State<PublicSearchPage> {
  List<Worker> workers = [];
  List<Worker> filteredWorkers = [];
  bool isLoading = false;

  final TextEditingController _skillController = TextEditingController();
  final TextEditingController _villageController = TextEditingController();

  Future<void> _searchWorkers() async {
    setState(() => isLoading = true);

    try {
      final data = await ApiService.getWorkers();
      workers = data.map((w) => Worker.fromJson(w)).toList();

      setState(() {
        filteredWorkers = workers.where((w) {
          final skillMatch =
              _skillController.text.isEmpty ||
              w.skill.toLowerCase().contains(
                _skillController.text.toLowerCase(),
              );
          final villageMatch =
              _villageController.text.isEmpty ||
              w.village.toLowerCase().contains(
                _villageController.text.toLowerCase(),
              );
          return skillMatch && villageMatch;
        }).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error fetching workers: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SkillMap - Find Workers")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _skillController,
                    decoration: const InputDecoration(
                      labelText: "Search by Skill",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _villageController,
                    decoration: const InputDecoration(
                      labelText: "Search by Village",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _searchWorkers,
                  child: const Text("Search"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
                    child: filteredWorkers.isEmpty
                        ? const Center(child: Text("No workers found"))
                        : ListView.builder(
                            itemCount: filteredWorkers.length,
                            itemBuilder: (context, index) {
                              final w = filteredWorkers[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                child: ListTile(
                                  title: Text("${w.name} - ${w.skill}"),
                                  subtitle: Text("${w.village} | ${w.phone}"),
                                  trailing: IconButton(
                                    icon: const Icon(
                                      Icons.phone,
                                      color: Colors.green,
                                    ),
                                    onPressed: () {
                                      // For web: just copy number
                                      // For mobile: could use url_launcher
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text("Phone: ${w.phone}"),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
          ],
        ),
      ),
    );
  }
}

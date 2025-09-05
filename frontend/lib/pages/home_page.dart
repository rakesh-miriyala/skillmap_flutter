import 'package:flutter/material.dart';
import '../models/worker.dart';
import '../services/api_service.dart';
import '../l10n/app_localizations.dart';
import 'login_page.dart';
import 'register_worker_page.dart';
import 'worker_details_page.dart';

class HomePage extends StatefulWidget {
  final VoidCallback onToggleLanguage;
  const HomePage({super.key, required this.onToggleLanguage});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Worker> workers = [];
  List<Worker> filteredWorkers = [];
  bool isLoading = true;

  final TextEditingController searchController = TextEditingController();
  String? selectedSkill;
  String? selectedVillage;

  List<String> skills = [];
  List<String> villages = [];

  @override
  void initState() {
    super.initState();
    fetchWorkers();
  }

  Future<void> fetchWorkers() async {
    try {
      final data = await ApiService.getWorkers();
      final workerList = data.map((w) => Worker.fromJson(w)).toList();

      setState(() {
        workers = workerList;
        filteredWorkers = workerList;
        skills = workerList.map((w) => w.skill).toSet().toList()..sort();
        villages = workerList.map((w) => w.village).toSet().toList()..sort();
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  void _filterWorkers() {
    final query = searchController.text.toLowerCase();

    setState(() {
      filteredWorkers = workers.where((w) {
        final matchesQuery =
            w.name.toLowerCase().contains(query) ||
            w.skill.toLowerCase().contains(query) ||
            w.village.toLowerCase().contains(query);

        final matchesSkill = selectedSkill == null || w.skill == selectedSkill;
        final matchesVillage =
            selectedVillage == null || w.village == selectedVillage;

        return matchesQuery && matchesSkill && matchesVillage;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          t.appTitle,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: widget.onToggleLanguage,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RegisterWorkerPage(),
                        ),
                      ).then((_) => fetchWorkers());
                    },
                    child: Text(t.registerWorker),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                      );
                    },
                    child: Text(t.adminLogin),
                  ),
                ),
              ],
            ),
          ),

          // ✅ Search bar
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: t.searchWorkers,
                hintText: t.searchPlaceholder,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            searchController.clear();
                            _filterWorkers();
                          });
                        },
                      )
                    : null,
                border: const OutlineInputBorder(),
              ),
              onChanged: (_) => _filterWorkers(),
            ),
          ),

          // ✅ Filters
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String?>(
                    decoration: InputDecoration(labelText: t.skill),
                    value: selectedSkill,
                    items: [null, ...skills].map((skill) {
                      if (skill == null) {
                        return DropdownMenuItem<String?>(
                          value: null,
                          child: Text("-- ${t.skill} --"),
                        );
                      }
                      return DropdownMenuItem<String?>(
                        value: skill,
                        child: Text(skill),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => selectedSkill = value);
                      _filterWorkers();
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<String?>(
                    decoration: InputDecoration(labelText: t.village),
                    value: selectedVillage,
                    items: [null, ...villages].map((village) {
                      if (village == null) {
                        return DropdownMenuItem<String?>(
                          value: null,
                          child: Text("-- ${t.village} --"),
                        );
                      }
                      return DropdownMenuItem<String?>(
                        value: village,
                        child: Text(village),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => selectedVillage = value);
                      _filterWorkers();
                    },
                  ),
                ),
              ],
            ),
          ),

          // ✅ Clear Filters button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                icon: const Icon(Icons.clear, color: Colors.red),
                label: Text(
                  "Clear Filters",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                onPressed: () {
                  setState(() {
                    searchController.clear();
                    selectedSkill = null;
                    selectedVillage = null;
                    filteredWorkers = workers;
                  });
                },
              ),
            ),
          ),

          const Divider(),

          // ✅ Workers list
          Expanded(
            child: isLoading
                ? Center(child: Text(t.loading))
                : filteredWorkers.isEmpty
                ? Center(child: Text(t.noWorkersFound))
                : ListView.builder(
                    itemCount: filteredWorkers.length,
                    itemBuilder: (context, index) {
                      final w = filteredWorkers[index];
                      return Card(
                        child: ListTile(
                          title: Text(
                            "${w.name} - ${w.skill}",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          subtitle: Text(
                            "${w.village} | ${t.phone}: ${w.phone}",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.phone, color: Colors.green),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("${t.call}: ${w.phone}"),
                                ),
                              );
                            },
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => WorkerDetailsPage(worker: w),
                              ),
                            );
                          },
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

import 'package:flutter/material.dart';
import '../models/worker.dart';
import '../l10n/app_localizations.dart';
import '../pages/worker_details_page.dart';

class WorkerCard extends StatelessWidget {
  final Worker worker;
  const WorkerCard({super.key, required this.worker});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Card(
      child: ListTile(
        title: Text("${worker.name} - ${worker.skill}"),
        subtitle: Text("${worker.village} | ${t.phone}: ${worker.phone}"),
        trailing: IconButton(
          icon: const Icon(Icons.phone, color: Colors.green),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("${t.call}: ${worker.phone}")),
            );
          },
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => WorkerDetailsPage(worker: worker),
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../models/worker.dart';
import '../l10n/app_localizations.dart';

class WorkerDetailsPage extends StatelessWidget {
  final Worker worker;
  const WorkerDetailsPage({super.key, required this.worker});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          t.workerDetails,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "${worker.name} - ${worker.skill}",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "${t.name}: ${worker.name}",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              "${t.skill}: ${worker.skill}",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              "${t.village}: ${worker.village}",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              "${t.phone}: ${worker.phone}",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}

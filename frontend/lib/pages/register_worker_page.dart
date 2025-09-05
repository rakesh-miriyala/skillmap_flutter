import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../l10n/app_localizations.dart';

class RegisterWorkerPage extends StatefulWidget {
  const RegisterWorkerPage({super.key});

  @override
  State<RegisterWorkerPage> createState() => _RegisterWorkerPageState();
}

class _RegisterWorkerPageState extends State<RegisterWorkerPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _skillController = TextEditingController();
  final _villageController = TextEditingController();
  final _phoneController = TextEditingController();

  bool isLoading = false;

  Future<void> _registerWorker() async {
    if (!_formKey.currentState!.validate()) return;

    final t = AppLocalizations.of(context)!;
    setState(() => isLoading = true);

    try {
      await ApiService.addWorker({
        "name": _nameController.text,
        "skill": _skillController.text,
        "village": _villageController.text,
        "phone": _phoneController.text,
      });

      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.registerSuccess)));
      Navigator.pop(context);
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("${t.registerError}: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          t.registerWorker,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: t.name),
                validator: (value) =>
                    value!.isEmpty ? "${t.requiredField}" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _skillController,
                decoration: InputDecoration(labelText: t.skill),
                validator: (value) =>
                    value!.isEmpty ? "${t.requiredField}" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _villageController,
                decoration: InputDecoration(labelText: t.village),
                validator: (value) =>
                    value!.isEmpty ? "${t.requiredField}" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: t.phone),
                validator: (value) =>
                    value!.isEmpty ? "${t.requiredField}" : null,
              ),
              const SizedBox(height: 20),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _registerWorker,
                      child: Text(t.submit),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

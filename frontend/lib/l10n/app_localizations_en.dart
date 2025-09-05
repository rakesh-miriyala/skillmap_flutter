// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'SkillMap';

  @override
  String get registerWorker => 'Register as Worker';

  @override
  String get adminLogin => 'Admin Login';

  @override
  String get searchWorkers => 'Search workers';

  @override
  String get loading => 'Loading...';

  @override
  String get noWorkersFound => 'No workers found';

  @override
  String get name => 'Name';

  @override
  String get skill => 'Skill';

  @override
  String get village => 'Village';

  @override
  String get phone => 'Phone';

  @override
  String get languages => 'Languages';

  @override
  String get submit => 'Submit';

  @override
  String get registerSuccess => 'Worker registered successfully';

  @override
  String get registerError => 'Error registering worker';

  @override
  String get searchPlaceholder => 'Search by name, skill or village';

  @override
  String get call => 'Call';

  @override
  String get requiredField => 'This field is required';

  @override
  String get workerDetails => 'Worker Details';
}

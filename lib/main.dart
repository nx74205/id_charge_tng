import 'package:flutter/material.dart';
import 'package:id_charge_tng/widgets/charge_session_form.dart';
import 'package:intl/intl_standalone.dart' if (dart.library.html) 'package:intl/intl_browser.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await findSystemLocale();
  runApp(
    MaterialApp(
      home: ChargeSessionForm()
    )
  );
}

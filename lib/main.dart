import 'package:flutter/material.dart';
import 'package:id_charge_tng/widgets/charge_session_form.dart';
import 'package:id_charge_tng/widgets/charge_session_list.dart';
//import 'package:intl/intl_standalone.dart' if (dart.library.html) 'package:intl/intl_browser.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('de_DE', null);
  runApp(
    MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => const ChargeSessionList(),
          '/chargeform': (context) => const ChargeSessionForm(),
        },
    )
  );
}

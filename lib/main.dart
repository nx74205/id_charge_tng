import 'package:material_ui/material_ui.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:id_charge/services/mqtt/MQTTAppState.dart';
import 'package:id_charge/widgets/charge_session_form.dart';
import 'package:id_charge/widgets/charge_session_list.dart';
import 'package:id_charge/widgets/setup_form.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('de_DE', null);
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''), // English, no country code
        const Locale('de', ''),
      ],
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => ChangeNotifierProvider<MQTTAppState>(
          create: (context) => MQTTAppState(),
          child: ChargeSessionList(),
        ),
        '/chargeform': (BuildContext context) => const ChargeSessionForm(),
        '/setupform': (BuildContext context)  => const SetupForm(),
      },
    ),
  );
}
/*
  Build APK with "flutter build apk --split-per-abi"
 */
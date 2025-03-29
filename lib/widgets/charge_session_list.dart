import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:id_charge_tng/model/charge_session.dart';
import 'package:id_charge_tng/services/DatabaseService.dart';
import 'package:id_charge_tng/widgets/charge_session_card.dart';
import 'package:provider/provider.dart';

import '../model/charge_session_dto.dart';
import '../services/mqtt/MQTTAppState.dart';
import '../services/mqtt/MQTT_Manager.dart';
import '../services/secure_storage.dart';

class ChargeSessionList extends StatefulWidget {
  const ChargeSessionList({super.key});

  @override
  State<ChargeSessionList> createState() => _ChargeSessionListState();
}

class _ChargeSessionListState extends State<ChargeSessionList> {

  final DatabaseService _databaseService = DatabaseService.instance;
  final SecureStorage _secureStorage = SecureStorage();

  late MQTTAppState currentAppState;
  late MQTTManager manager;

  late List<ChargeSessionDto> dbSessions;
  final sessions = <int, ChargeSession>{};

  ChargeSessionDto newChargeDto = ChargeSessionDto(
      vehicleVin: '',
      chargingStatus: 'ACTIVE',
      startOfChargeDate: DateTime.now(),
      mileage: 0,
      tripLength: 0,
      quantityChargedKwh: 0,
      chargedKwPaid: 0,
      costOfCharge: 0,
      bcConsumption: 0,
      socStart: 0,
      socEnd: 0,
      locked: false,
      serverObjectVersion: 0,
      clientObjectVersion: 0
  );

  @override
  void initState() {
    super.initState();
    fetchSecureStorageData();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _configureAndConnect());
  }
  Future<void> fetchSecureStorageData() async {
    newChargeDto.vehicleVin = await _secureStorage.getVin() ?? '';
    //setState(() {});
  }
  @override
  Widget build(BuildContext context) {

    final MQTTAppState appState = Provider.of<MQTTAppState>(context);
    currentAppState = appState;

    if (currentAppState.getReceivedDtoSessions != null) {
      currentAppState.getReceivedDtoSessions?.forEach((mileage, chargeSessionDto) {
        int? clientObjectVersion = chargeSessionDto.clientObjectVersion;
        int? serverObjectVersion = chargeSessionDto.serverObjectVersion;

        if(sessions[mileage] != null) {
          if (chargeSessionDto.chargingStatus == "COMPLETED") {
            sessions.remove(mileage);
            _delChargeSession(mileage);
            manager.deleteServerMessage(mileage);
          } else {
            if(sessions[mileage]!.clientObjectVersion <= clientObjectVersion!) {
              // via mqtt received session is newer then the session in our database
              _delChargeSession(mileage);
              sessions[mileage] = ChargeSession.dto(chargeSessionDto);
            } else {
              // our version is newer lets check the server...
              if (sessions[mileage]!.serverObjectVersion < serverObjectVersion!) {
                chargeSessionDto.chargedKwPaid = sessions[mileage]?.chargeSessionDto.chargedKwPaid;
                chargeSessionDto.costOfCharge = sessions[mileage]?.chargeSessionDto.costOfCharge;
                chargeSessionDto.bcConsumption = sessions[mileage]?.chargeSessionDto.bcConsumption;
                chargeSessionDto.chargeProvider = sessions[mileage]?.chargeSessionDto.chargeProvider;
                chargeSessionDto.chargeType = sessions[mileage]?.chargeSessionDto.chargeType;
                sessions[mileage] = ChargeSession.dto(chargeSessionDto);
              } else {
                manager.publish(mileage, jsonEncode(sessions[mileage]?.chargeSessionDto.toJson()));
              }
            }
          }
        } else {
          if (chargeSessionDto.chargingStatus != "COMPLETED") {
            sessions[mileage] = ChargeSession.dto(chargeSessionDto);
          }
        }
      });
      currentAppState.clearReceivedSessions();
    }

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        foregroundColor: Colors.white,
        title: Text('Ladesitzungen'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () async {
              final result = await Navigator.pushNamed(context, '/setupform');
              if (result != null) {
                bool isSaved = result as bool;
                if (isSaved) {
                  currentAppState.setAppConnectionState(MQTTAppConnectionState.disconnected);
                  _configureAndConnect();

                }
              }
            }
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: sessions.length,
        itemBuilder: (BuildContext context, int index) {
          int key = sessions.keys.elementAt(index);
          return ChargeSessionCard(mqttManager: manager, chargeSession: sessions[key]!);
        }
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[400],
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
        onPressed: () async {

          final arguments = {'result' : newChargeDto};
          await Navigator.pushNamed(context, '/chargeform', arguments: arguments);
          ChargeSessionDto? result = arguments['result'] as ChargeSessionDto;

          if (result.hasChanged) {
            result.timestamp = DateTime.now();
            result.locked = true;
            _databaseService.addChargeSession(result.mileage!, result.serverObjectVersion!, result.clientObjectVersion!, jsonEncode(result.toJson()));
            manager.publish(result.mileage!, jsonEncode(result.toJson()));
            setState(() {
              sessions[result.mileage!] = ChargeSession.dto(result);
            });
          }
        }),
    );
  }

  _getAllDbSessions() async {
    dbSessions = await _databaseService.getChargeSessions();

    for (var session in dbSessions) {

      sessions[session.mileage!] = ChargeSession.dto(session);
    }
  }

  _delChargeSession(int mileage) async {
    await _databaseService.delChargeSession(mileage);

  }

  Future<void> _configureAndConnect() async {

    _getAllDbSessions();
    manager = MQTTManager(state: currentAppState);

    await manager.initializeMQTTClient();
    if (currentAppState.getAppConnectionState != MQTTAppConnectionState.notConfigured) {
      manager.connect();
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Server nicht konfiguriert'),
            content: const Text('Server ist noch nicht konfiguriert, '
                'Daten können nicht an das Backend übertragen werden'),
            actions: <Widget> [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          )
      );
    }
  }
}

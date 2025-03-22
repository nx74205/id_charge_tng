
import 'package:flutter/material.dart';
import 'package:id_charge_tng/model/charge_session_dto.dart';

enum MQTTAppConnectionState {connected, disconnected, connecting, notConfigured}

class MQTTAppState with ChangeNotifier{
  MQTTAppConnectionState _appConnectionState = MQTTAppConnectionState.disconnected;

  final _receivedSessions = <int, ChargeSessionDto>{};

  void setReceivedChargeSessions(ChargeSessionDto chargeSessionDto) {
    _receivedSessions[chargeSessionDto.mileage!] = chargeSessionDto;
    notifyListeners();
  }

  void setAppConnectionState(MQTTAppConnectionState state) {
    _appConnectionState = state;
    notifyListeners();
  }

  void clearReceivedSessions() {
    _receivedSessions.clear();
  }

  Map<int, ChargeSessionDto>? get getReceivedDtoSessions => _receivedSessions;

  MQTTAppConnectionState get getAppConnectionState => _appConnectionState;

}
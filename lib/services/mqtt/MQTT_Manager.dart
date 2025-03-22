import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:id_charge_tng/model/mqtt_credentials.dart';
import 'dart:convert';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:id_charge_tng/services/mqtt/MQTTAppState.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import '../../model/charge_session_dto.dart';
import '../secure_storage.dart';

class MQTTManager {

  late MQTTAppState _currentState;
  late MqttClient _client;
  late bool _useStorage;

  final SecureStorage _secureStorage = SecureStorage();

  late String _identifier;
  late String _vin;
  late String _host;
  late int _port;
  late String _connectType;
  late String _subscribeTopic;
  late String _publishTopic;
  late String _userName;
  late String _password;
  late String _storageStatus;

  late MqttCredentials _credentials;

  MQTTManager({required MQTTAppState state}) {
    _currentState = state;
    _useStorage = true;
  }

  MQTTManager.credentials({required MQTTAppState state, required MqttCredentials credentials}) {
    _currentState = state;
    _credentials = credentials;
    _useStorage = false;
  }



  Future<void> initializeMQTTClient() async {

    if (!_useStorage) {
      _vin = _credentials.vin;
      _identifier = _credentials.identifier;
      _host = _credentials.host;
      _port = int.parse(_credentials.port);
      _connectType = _credentials.connectType;
      _userName = _credentials.userName;
      _password = _credentials.password;

    } else {
      _storageStatus = (await _secureStorage.getStorageStatus());

      if (_storageStatus == "EMPTY") {
        _currentState.setAppConnectionState(
            MQTTAppConnectionState.notConfigured);
        return;

      } else {
        _vin = (await _secureStorage.getVin())!;
        _identifier = (await _secureStorage.getIdentifier())!;
        _host = (await _secureStorage.getHost())!;

        String portAsString = (await _secureStorage.getPort())!;
        _port = (await int.parse(portAsString));

        _connectType = (await _secureStorage.getConnectType())!;
        _userName = (await _secureStorage.getUsername())!;
        _password = (await _secureStorage.getPassword())!;
      }
    }

    _subscribeTopic = "cardata/$_vin/server/#";
    _publishTopic = "cardata/$_vin/client";

    if (_connectType.toUpperCase().startsWith("WS")) {
      _host = "$_connectType://$_host";
    }

    print("host is $_host");

    if (kIsWeb) {
      MqttServerClient serverClient = MqttServerClient(_host, _identifier);
      serverClient.useWebSocket = true;

      _client = serverClient;
    } else {
      MqttServerClient serverClient = MqttServerClient(_host, _identifier);
      serverClient.useWebSocket = true;

      _client = serverClient;
    }

    _client.port = _port;
    _client.keepAlivePeriod = 20;
    _client.logging(on: false);
    _client.onDisconnected = onDisconnected;
    _client.onConnected = onConnected;
    _client.onSubscribed = onSubscribed;

    final MqttConnectMessage connMess = MqttConnectMessage()
        .withClientIdentifier(_identifier)
        .startClean() // Non persistent session for testing
        .withWillQos(MqttQos.atLeastOnce);
    print('EXAMPLE::Mosquitto client connecting....');
    _client.connectionMessage = connMess;

  }

  Future<void> connect() async {
    try {
      print('EXAMPLE::Mosquitto start client connecting....');
      _currentState.setAppConnectionState(MQTTAppConnectionState.connecting);
      await _client.connect(_userName, _password);
      _currentState.setAppConnectionState(MQTTAppConnectionState.connected);
    } on Exception catch (e) {
      _currentState.setAppConnectionState(MQTTAppConnectionState.disconnected);
      print('EXAMPLE::client exception - $e');
      disconnect();
    }
  }

  void disconnect() {
    print('Disconnected');
    _client.disconnect();
    _currentState.setAppConnectionState(MQTTAppConnectionState.disconnected);
  }

  void publish(int mileage, String message) {
    if (_currentState.getAppConnectionState == MQTTAppConnectionState.connected) {
      final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
      builder.addString(message);
      _client.publishMessage("$_publishTopic/$mileage", MqttQos.exactlyOnce, builder.payload!, retain: true);
    }
  }

  void deleteServerMessage(int mileage) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString("");
    String topic = _subscribeTopic.replaceFirst("#", mileage.toString());
    _client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!, retain: true);

  }

  /// The subscribed callback
  void onSubscribed(String topic) {
    print('EXAMPLE::Subscription confirmed for topic $topic');
  }

  /// The unsolicited disconnect callback
  void onDisconnected() {
    print('EXAMPLE::OnDisconnected client callback - Client disconnection');
    if (_client.connectionStatus!.returnCode ==
        MqttConnectReturnCode.noneSpecified) {
      print('EXAMPLE::OnDisconnected callback is solicited, this is correct');
    }
    _currentState.setAppConnectionState(MQTTAppConnectionState.disconnected);
  }

  /// The successful connect callback
  void onConnected() {
    _currentState.setAppConnectionState(MQTTAppConnectionState.connected);
    print('EXAMPLE::Mosquitto client connected....');
    _client.subscribe(_subscribeTopic, MqttQos.atLeastOnce);
    _client.updates!.listen(_listen);

    print('EXAMPLE::OnConnected client callback - Client connection was sucessful');
  }

  void _listen(List<MqttReceivedMessage<MqttMessage?>>? c) {
    final MqttPublishMessage recMess = c![0].payload as MqttPublishMessage;

    if (recMess.payload.message.isNotEmpty) {
      final String data = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

      ChargeSessionDto dto = ChargeSessionDto.fromJson(json.decode(data));
      _currentState.setReceivedChargeSessions(dto);
    }
  }
}
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {

  final storage = const FlutterSecureStorage();

  final String _identifier = "IDENTIFIER";
  final String _connectType = "CONNECT_TYPE";
  final String _host       = "HOST";
  final String _port       = "PORT";
  final String _vin        = "VIN";
  final String _userName   = "USERNAME";
  final String _password   = "PASSWORD";
  final String _storageStatus = "STORAGE_STATUS";

  Future setIdentifier(String identifier) async {
    await storage.write(key: _identifier, value: identifier);
  }

  Future<String?> getIdentifier() async {
    return await storage.read(key: _identifier);
  }

  Future setHost(String host) async {
    await storage.write(key: _host, value: host);
  }
  Future<String?> getHost() async {
    return await storage.read(key: _host);
  }

  Future setConnectType(String connectType) async {
    await storage.write(key: _connectType, value: connectType);
  }
  Future<String?> getConnectType() async {
    return await storage.read(key: _connectType);
  }

  Future setPort(String port) async {
    await storage.write(key: _port, value: port);
  }
  Future<String?> getPort() async {
    return await storage.read(key: _port);
  }

  Future setVin(String vin) async {
    await storage.write(key: _vin, value: vin);
  }
  Future<String?> getVin() async {
    return await storage.read(key: _vin);
  }

  Future setUserName(String userName) async {
    await storage.write(key: _userName, value: userName);
  }
  Future<String?> getUsername() async {
    return await storage.read(key: _userName);
  }

  Future setPassword(String password) async {
    await storage.write(key: _password, value: password);
  }
  Future<String?> getPassword() async {
    return await storage.read(key: _password);
  }

  Future setStorageStatus(String storageStatus) async {
    await storage.write(key: _storageStatus, value: storageStatus);
  }
  Future<String> getStorageStatus() async {
    String? status = await storage.read(key: _storageStatus);
    return (status == null || status.isEmpty) ? "EMPTY" : status;
  }
}
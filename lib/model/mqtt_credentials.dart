class MqttCredentials {

  String identifier;
  String connectType;
  String host;
  String port;
  String vin;
  String userName;
  String password;


  MqttCredentials({
    required this.identifier,
    required this.connectType,
    required this.host,
    required this.port,
    required this.vin,
    required this.userName,
    required this.password
  });
}
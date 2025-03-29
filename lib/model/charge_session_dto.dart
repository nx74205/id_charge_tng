class ChargeSessionDto {

  String? vehicleVin;
  String? chargingStatus;
  DateTime? timestamp = DateTime.now();
  DateTime? startOfChargeDate;
  DateTime? endOfChargeDate;
  String? chargeProvider;
  String? chargeType;
  int? mileage;
  int? tripLength;
  double? quantityChargedKwh;
  double? chargedKwPaid;
  double? costOfCharge;
  double? bcConsumption;
  int? totalChargingDuration;
  DateTime? lastChargingSessionStart;
  DateTime? lastChargingSessionEnd;
  double? averageChargingPower;
  int? numberOfSessions;
  int? socStart;
  int? socEnd;
  double? latitude;
  double? longitude;
  int? serverObjectVersion;
  int? clientObjectVersion;
  bool? locked;
  bool hasChanged = false;

  ChargeSessionDto({
    this.vehicleVin,
    this.chargingStatus,
    this.timestamp,
    this.startOfChargeDate,
    this.endOfChargeDate,
    this.chargeProvider,
    this.chargeType,
    this.mileage,
    this.tripLength,
    this.quantityChargedKwh,
    this.chargedKwPaid,
    this.costOfCharge,
    this.bcConsumption,
    this.totalChargingDuration,
    this.lastChargingSessionStart,
    this.lastChargingSessionEnd,
    this.averageChargingPower,
    this.numberOfSessions,
    this.socStart,
    this.socEnd,
    this.latitude,
    this.longitude,
    this.serverObjectVersion,
    this.clientObjectVersion,
    this.locked
  });

  ChargeSessionDto.fromJson(Map<String, dynamic> json) {

    vehicleVin = json['vehicleVin'] ?? '';
    chargingStatus = json['chargingStatus'] ?? '';
    timestamp = DateTime.tryParse(json['timestamp'] ?? '');
    startOfChargeDate = DateTime.tryParse(json['startOfCharge'] ?? '');
    endOfChargeDate = DateTime.tryParse(json['endOfCharge'] ?? '');
    chargeProvider = json['chargeProvider'] ?? '';
    chargeType = json['chargeType'] ?? '';
    mileage = json['mileage'];
    tripLength = json['distance'];
    quantityChargedKwh = json['quantityChargedKwh'] ?? 0;
    costOfCharge = json['price'] ?? 0;
    bcConsumption = json['bcConsumption'] ?? 0;
    totalChargingDuration = json['totalChargingDuration'] ?? 0;
    lastChargingSessionStart = DateTime.tryParse(json['lastChargingSessionStart'] ?? '');
    lastChargingSessionEnd = DateTime.tryParse(json['lastChargingSessionEnd'] ?? '');
    averageChargingPower = json['averageChargingPower'] ?? 0;
    numberOfSessions = json['numberOfSessions'] ?? 0;
    socStart = json['socStart'];
    socEnd = json['socEnd'];
    chargedKwPaid = json['chargedKwPaid'] ?? 0;
    serverObjectVersion = json['serverObjectVersion'] ?? 0;
    clientObjectVersion = json['clientObjectVersion'] ?? 0;
    locked = json['locked'] ?? true;
  }

  Map<String, dynamic> toJson() => {
    'vehicleVin': vehicleVin,
    'chargingStatus': chargingStatus,
    'timestamp': timestamp?.toIso8601String(),
    'startOfCharge': startOfChargeDate?.toIso8601String(),
    'endOfCharge': endOfChargeDate?.toIso8601String(),
    'chargeProvider': chargeProvider,
    'chargeType': chargeType,
    'mileage': mileage,
    'distance': tripLength,
    'quantityChargedKwh': quantityChargedKwh,
    'price': costOfCharge,
    'bcConsumption': bcConsumption,
    'totalChargingDuration': totalChargingDuration,
    'lastChargingSessionStart': lastChargingSessionStart?.toIso8601String(),
    'lastChargingSessionEnd' : lastChargingSessionEnd?.toIso8601String(),
    'averageChargingPower': averageChargingPower,
    'numberOfSessions': numberOfSessions,
    'socStart': socStart,
    'socEnd': socEnd,
    'chargedKwPaid': chargedKwPaid,
    'serverObjectVersion': serverObjectVersion,
    'clientObjectVersion' : clientObjectVersion,
    'locked' : locked
  };
}







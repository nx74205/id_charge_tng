import 'package:id_charge_tng/model/charge_session_dto.dart';
import 'package:intl/intl.dart';

class ChargeSession {

  /*
    This is for output only. A converter will translate the numeric information from the dto-object
    into Strings to display the data.

   */

  String? vehicleVin;
  String? chargingStatus;
  late String startOfChargeDate;
  String? endOfChargeDate;
  late String chargeProvider;
  late String chargeType;
  late String mileage;
  late String tripLength;
  late String kwhCharged;
  late String costOfCharge;
  late String chargedKwPaid;
  late String kwhChargedInternal;
  late String bcConsumption;
  late String socStart;
  late String socEnd;
  late int serverObjectVersion;
  late int clientObjectVersion;
  late bool locked;
  bool editable = true;

  late ChargeSessionDto chargeSessionDto;

  ChargeSession ({
    required this.vehicleVin,
    required this.chargingStatus,
    required this.startOfChargeDate,
    required this.endOfChargeDate,
    required this.chargeProvider,
    required this.chargeType,
    required this.mileage,
    required this.tripLength,
    required this.kwhCharged,
    required this.costOfCharge,
    required this.chargedKwPaid,
    required this.kwhChargedInternal,
    required this.bcConsumption,
    required this.socEnd,
    required this.serverObjectVersion,
    required this.clientObjectVersion,
    required this.locked
  }) {
    _createDto();
  }

  ChargeSession.dto(this.chargeSessionDto) {

    var numFormat = NumberFormat("#,###.##", 'de-DE');

    this.chargeSessionDto = chargeSessionDto;

    this.vehicleVin = chargeSessionDto.vehicleVin;
    this.chargingStatus = chargeSessionDto.chargingStatus;
    this.startOfChargeDate = DateFormat('dd-MM-yyyy HH:mm').format(chargeSessionDto.startOfChargeDate!);
    this.chargeProvider = chargeSessionDto.chargeProvider!;
    this.chargeType = chargeSessionDto.chargeType!;
    this.mileage = numFormat.format(chargeSessionDto.mileage);
    this.tripLength = (chargeSessionDto.tripLength != null ? chargeSessionDto.tripLength.toString() : '');
    this.kwhCharged = numFormat.format(chargeSessionDto.kwhCharged);
    this.chargedKwPaid = '${numFormat.format(chargeSessionDto.chargedKwPaid)} €';
    this.costOfCharge = '${numFormat.format(chargeSessionDto.costOfCharge)} €';
    this.bcConsumption = '${numFormat.format(chargeSessionDto.bcConsumption)} kWh';
    this.socStart = '${chargeSessionDto.socEnd} %';
    this.socEnd = '${chargeSessionDto.socEnd} %';
    this.serverObjectVersion = chargeSessionDto.serverObjectVersion!;
    this.clientObjectVersion = chargeSessionDto.clientObjectVersion!;
    this.locked = chargeSessionDto.locked!;
    this.editable = chargeSessionDto.chargingStatus == "COMPLETED" ? false : true;
  }

  ChargeSessionDto _createDto() {

    ChargeSessionDto dto = ChargeSessionDto(
      vehicleVin: vehicleVin,
      chargingStatus: chargingStatus,
      startOfChargeDate: DateTime.parse(startOfChargeDate),
      endOfChargeDate: DateTime.tryParse(endOfChargeDate!),
      chargeProvider: chargeProvider,
      chargeType: chargeType,
      mileage: int.parse(mileage),
      tripLength: int.tryParse(tripLength),
      kwhCharged: double.parse(kwhCharged),
      chargedKwPaid: double.parse(chargedKwPaid),
      costOfCharge: double.parse(costOfCharge),
      bcConsumption: double.parse(bcConsumption),
      socStart: int.parse(socStart),
      socEnd: int.parse(socEnd),
      latitude: null,
      longitude: null,
      serverObjectVersion: serverObjectVersion,
      clientObjectVersion: clientObjectVersion,
      locked: locked
    );

    return dto;
  }
}
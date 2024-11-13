import 'package:id_charge_tng/model/charge_session_dto.dart';
import 'package:intl/intl.dart';

class ChargeSession {

  /*
    This is for output only. A converter will translate the numeric information from the dto-object
    into Strings to display the data.

   */

  late String chargeDate;
  late String chargeProvider;
  late String chargeType;
  late String mileage;
  late String tripLength;
  late String kwhCharged;
  late String costOfCharge;
  late String kwhPaid;
  late String kwhChargedInternal;
  late String bcConsumption;
  late String socStart;
  late String socEnd;

  late ChargeSessionDto chargeSessionDto;

  ChargeSession ({
    required this.chargeDate,
    required this.chargeProvider,
    required this.chargeType,
    required this.mileage,
    required this.tripLength,
    required this.kwhCharged,
    required this.costOfCharge,
    required this.kwhPaid,
    required this.kwhChargedInternal,
    required this.bcConsumption,
    required this.socEnd});

  ChargeSession.dto(this.chargeSessionDto) {

    var numFormat = NumberFormat("#,###.##", 'de-DE');

    this.chargeSessionDto = chargeSessionDto;

    this.chargeDate = DateFormat('dd-MM-yyyy HH:mm').format(chargeSessionDto.startOfChargeDate!);
    this.chargeProvider = chargeSessionDto.chargeProvider!;
    this.chargeType = chargeSessionDto.chargeType!;
    this.mileage = numFormat.format(chargeSessionDto.mileage);
    this.tripLength = chargeSessionDto.tripLength.toString();
    this.kwhCharged = numFormat.format(chargeSessionDto.kwhCharged);
    this.kwhPaid = '${numFormat.format(chargeSessionDto.kwhPaid)} €';
    this.costOfCharge = '${numFormat.format(chargeSessionDto.costOfCharge)} €';
    this.bcConsumption = '${numFormat.format(chargeSessionDto.bcConsumption)} kWh';
    this.socStart = '${chargeSessionDto.socEnd} %';
    this.socEnd = '${chargeSessionDto.socEnd} %';
  }
}
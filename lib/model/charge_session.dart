import 'package:id_charge_tng/model/charge_session_dto.dart';

class ChargeSession {

  /*
    This is for output only. A converter will translate the numeric information from the dto-object
    into Strings to display the data.

   */

  String chargeDate;
  String chargeProvider;
  String chargeType;
  String mileage;
  String tripLength;
  String kwhCharged;
  String kwhPaid;
  String kwhChargedInternal;
  String bcConsumption;
  String targetSoc;

  ChargeSession ({
    required this.chargeDate,
    required this.chargeProvider,
    required this.chargeType,
    required this.mileage,
    required this.tripLength,
    required this.kwhCharged,
    required this.kwhPaid,
    required this.kwhChargedInternal,
    required this.bcConsumption,
    required this.targetSoc});

}
import 'package:id_charge_tng/model/charge_session.dart';

class ChargeSessionDto {

  DateTime? startOfChargeDate;
  DateTime? endOfChargeDate;
  String? chargeProvider;
  String? chargeType;
  int? mileage;
  int? tripLength;
  double? kwhCharged;
  double? kwhPaid;
  double? costOfCharge;
  double? bcConsumption;
  int? socStart;
  int? socEnd;
  int? targetSoc;
  double? latitude;
  double? longitude;

  ChargeSession? chargeSession;

  ChargeSessionDto({
      this.startOfChargeDate,
      this.endOfChargeDate,
      this.chargeProvider,
      this.chargeType,
      this.mileage,
      this.tripLength,
      this.kwhCharged,
      this.kwhPaid,
      this.costOfCharge,
      this.bcConsumption,
      this.socStart,
      this.socEnd,
      this.targetSoc,
      this.latitude,
      this.longitude});
  
}
import '../model/charge_session_dto.dart';

class DtoTestdataFactory {

  static ChargeSessionDto chargeSessionDto1 = ChargeSessionDto(
      startOfChargeDate: DateTime.now(),
      endOfChargeDate: DateTime.now().add(Duration(minutes: 90)),
      chargeProvider: 'Ionity',
      chargeType: 'CCS 150kw',
      mileage: 12345,
      tripLength: 123,
      quantityChargedKwh: 17.5,
      chargedKwPaid: 19.2,
      costOfCharge: 9.88,
      bcConsumption: 16.5,
      socStart: 35,
      socEnd: 90,
      latitude: 1.2345678,
      longitude: 45.123456
  );

  static ChargeSessionDto chargeSessionDto2 = ChargeSessionDto(
      startOfChargeDate: DateTime.now(),
      endOfChargeDate: DateTime.now().add(Duration(minutes: 90)),
      chargeProvider: 'Ionity',
      chargeType: 'CCS 150kw',
      mileage: 66666,
      tripLength: 333,
      quantityChargedKwh: 17.5,
      chargedKwPaid: 19.2,
      costOfCharge: 9.88,
      bcConsumption: 16.5,
      socStart: 35,
      socEnd: 80,
      latitude: 1.2345678,
      longitude: 45.123456
  );

  static ChargeSessionDto chargeSessionDto3 = ChargeSessionDto(
      startOfChargeDate: DateTime.now(),
      endOfChargeDate: DateTime.now().add(Duration(minutes: 90)),
      chargeProvider: 'Ionity',
      chargeType: 'CCS 150kw',
      mileage: 77777,
      tripLength: 333,
      quantityChargedKwh: 17.5,
      chargedKwPaid: 19.2,
      costOfCharge: 9.88,
      bcConsumption: 16.5,
      socStart: 35,
      socEnd: 80,
      latitude: 1.2345678,
      longitude: 45.123456
  );

}
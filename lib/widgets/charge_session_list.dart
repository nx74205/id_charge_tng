import 'package:flutter/material.dart';
import 'package:id_charge_tng/model/charge_session.dart';
import 'package:id_charge_tng/services/dto_testdata_factory.dart';
import 'package:id_charge_tng/widgets/charge_session_card.dart';

import '../model/charge_session_dto.dart';

class ChargeSessionList extends StatefulWidget {
  const ChargeSessionList({super.key});

  @override
  State<ChargeSessionList> createState() => _ChargeSessionListState();
}

class _ChargeSessionListState extends State<ChargeSessionList> {

  ChargeSessionDto newChargeDto = ChargeSessionDto(
      startOfChargeDate: DateTime.now(),
      endOfChargeDate: DateTime.now().add(Duration(minutes: 90)),
      chargeProvider: 'Ionity',
      chargeType: 'CCS 150kw',
      mileage: 99999,
      tripLength: 123,
      kwhCharged: 17.5,
      kwhPaid: 19.2,
      costOfCharge: 9.88,
      bcConsumption: 16.5,
      socStart: 35,
      socEnd: 90,
      latitude: 1.2345678,
      longitude: 45.123456
  );

  List<ChargeSession> sessions = [
    ChargeSession.dto(DtoTestdataFactory.chargeSessionDto1),
    ChargeSession.dto(DtoTestdataFactory.chargeSessionDto2),
    ChargeSession.dto(DtoTestdataFactory.chargeSessionDto3),
  ];


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        foregroundColor: Colors.white,
        title: Text('Ladesitzungen'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: sessions.length,
        itemBuilder: (BuildContext context, int index) {
          return ChargeSessionCard(chargeSession: sessions[index]);
        }
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue[400],
          foregroundColor: Colors.white,
          child: Icon(Icons.add),
          onPressed: () async {
            final result = await Navigator.pushNamed(context, '/chargeform', arguments: newChargeDto);

            if (result != null) {
              ChargeSessionDto newSession = result as ChargeSessionDto;
              setState(() {
                sessions.add(ChargeSession.dto(newSession));
              });
            }
        }),
    );
  }
}

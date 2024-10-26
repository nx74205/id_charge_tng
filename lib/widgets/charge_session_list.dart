import 'package:flutter/material.dart';
import 'package:id_charge_tng/model/charge_session.dart';
import 'package:id_charge_tng/widgets/charge_session_card.dart';

class ChargeSessionList extends StatefulWidget {
  const ChargeSessionList({super.key});

  @override
  State<ChargeSessionList> createState() => _ChargeSessionListState();
}

class _ChargeSessionListState extends State<ChargeSessionList> {
  
  List<ChargeSession> sessions = [
    ChargeSession(chargeDate: '14.10.2024 17:00',
      chargeProvider: 'Wallbox',
      chargeType: 'AC',
      mileage: '14.456',
      tripLength: '221',
      kwhCharged: '34,5',
      kwhPaid: '15,25 €',
      kwhChargedInternal: '31',
      bcConsumption: '18,0',
      targetSoc: '80 %'),
    ChargeSession(chargeDate: '20.10.2024 12:00',
      chargeProvider: 'EnBw',
      chargeType: 'HPC 150',
      mileage: '15.456',
      tripLength: '95',
      kwhCharged: '24,5',
      kwhPaid: '10,25 €',
      kwhChargedInternal: '21',
      bcConsumption: '18,0',
      targetSoc: '100 %'),
    ChargeSession(chargeDate: '21.10.2024 12:00',
      chargeProvider: 'EWE_Go',
      chargeType: 'HPC 150',
      mileage: '15.456',
      tripLength: '95',
      kwhCharged: '24,5',
      kwhPaid: '10,25 €',
      kwhChargedInternal: '21',
      bcConsumption: '18,0',
      targetSoc: '100 %'),
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
          onPressed: () {

        }),
    );
  }
}

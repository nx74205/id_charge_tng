import 'package:flutter/material.dart';
import 'package:id_charge_tng/model/charge_session_dto.dart';
import 'package:intl/intl.dart';
import 'package:date_field/date_field.dart';

class ChargeSessionForm extends StatefulWidget {
  const ChargeSessionForm({super.key});

  @override
  State<ChargeSessionForm> createState() => _ChargeSessionFormState();
}

class _ChargeSessionFormState extends State<ChargeSessionForm> {

  final _formGlobalKey = GlobalKey<FormState>();
  final format = DateFormat('yyyy-MM-dd HH:mm');

  ChargeSessionDto chargeSession = ChargeSessionDto(
    startOfChargeDate: DateTime.now(),
    endOfChargeDate: DateTime.now().add(Duration(minutes: 90)),
    chargeProvider: 'EnBw',
    chargeType: 'DC',
    mileage: 13456,
    tripLength: 232,
    kwhCharged: 17.5,
    kwhPaid: 19.2,
    costOfCharge: 9.88,
    bcConsumption: 16.5,
    socStart: 35,
    socEnd: 80,
    targetSoc: 80,
    latitude: 1.2345678,
    longitude: 45.123456
  );

  @override
  Widget build(BuildContext context) {

    Future<DateTime?> onTapFunction({required BuildContext context}) async {
      DateTime? pickedDate = await showDatePicker(

        context: context,
        lastDate: DateTime.now(),
        firstDate: DateTime(2015),
        initialDate: chargeSession.startOfChargeDate,
      );
      if (pickedDate == null)
        return null;
      else
          return pickedDate;

    }

    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          backgroundColor: Colors.blue[400],
          foregroundColor: Colors.white,
          title: Text('Ladesitzungen'),
          centerTitle: true,
        ),
      body: Card(
        color: Colors.white,
        margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        elevation: 5,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15)
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
          child: Form(
            key: _formGlobalKey,
            child: Column(
              children: [
                SizedBox(height: 15),
                DateTimeFormField(
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    label: Text('Start Ladesession'),
                    prefixIcon: Icon(
                            color: Colors.blue,
                            Icons.calendar_today_rounded
                          )
                  ),
                  initialValue: chargeSession.startOfChargeDate,
                  dateFormat: format,
                  onChanged: (DateTime? value) {
                    print(value);
                    chargeSession.startOfChargeDate = value;
                  },
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: TextFormField(
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                          label: Text('Kilometerstand'),
                        ),
                        textAlign: TextAlign.end,
                        initialValue: chargeSession.mileage.toString(),
                        keyboardType: TextInputType.number,
                        onChanged: (String value) {
                          chargeSession.mileage = int.parse(value);
                        },
                      ),
                    ),
                    const SizedBox(width: 30),
                    Expanded(
                      flex: 4,
                      child: TextFormField(
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                          label: Text('Strecke'),
                        ),
                        textAlign: TextAlign.end,
                        initialValue: chargeSession.tripLength.toString(),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: TextFormField(
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                          label: Text('Menge kWh'),
                        ),
                        textAlign: TextAlign.end,
                        initialValue: chargeSession.kwhPaid.toString(),
                        keyboardType: TextInputType.number,
                        onChanged: (String value) {
                          chargeSession.kwhPaid = double.parse(value);
                        },
                      )
                    ),
                    const SizedBox(width: 30),
                    Expanded(
                        flex: 4,
                        child: TextFormField(
                          decoration: const InputDecoration(
                            prefixIcon: Icon(
                              Icons.euro_symbol,
                              size: 20,
                              //color: Colors.blue,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(),
                            label: Text('Gesamtpreis'),
                          ),
                          textAlign: TextAlign.end,
                          initialValue: chargeSession.costOfCharge.toString(),
                          keyboardType: TextInputType.number,
                          onChanged: (String value) {
                            chargeSession.costOfCharge = double.parse(value);
                          },
                        )
                    ),

                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

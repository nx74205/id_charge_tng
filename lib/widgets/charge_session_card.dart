import 'package:flutter/material.dart';
import 'package:id_charge_tng/model/charge_display_value.dart';
import 'package:id_charge_tng/model/charge_session.dart';

class ChargeSessionCard extends StatefulWidget {

  final ChargeSession chargeSession;

  ChargeSessionCard({super.key, required this.chargeSession});

  @override
  State<ChargeSessionCard> createState() => _ChargeSessionCardState();
}

class _ChargeSessionCardState extends State<ChargeSessionCard> {

  var chargeData = new Map();

  @override
  Widget build(BuildContext context) {

    ChargeSession chargeSession = widget.chargeSession;

    List<ChargeDisplayValue> chargeDisplayValues = [
      ChargeDisplayValue(displayText: 'Km-Stand', displayValue: chargeSession.mileage),
      ChargeDisplayValue(displayText: 'Trip', displayValue: chargeSession.tripLength),
      ChargeDisplayValue(displayText: 'kWh', displayValue: chargeSession.kwhCharged),
      ChargeDisplayValue(displayText: 'Kosten', displayValue: chargeSession.kwhPaid),
      ChargeDisplayValue(displayText: 'kWh/100 Km', displayValue: chargeSession.bcConsumption),
      ChargeDisplayValue(displayText: 'SOC', displayValue: chargeSession.targetSoc)
    ];

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15)
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          height: 90,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: 10),
                    Row(
                      children: [
                        Icon(Icons.calendar_month_outlined),
                        SizedBox(width: 3),
                        Text(
                          chargeSession.chargeDate,
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),

                      ]
                    ),
                    SizedBox(width: 10),
                    Row(
                      children: [
                        Icon(Icons.battery_charging_full),
                        SizedBox(width: 3),
                        Text(
                          chargeSession.chargeType,
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    )
                    //const SizedBox(height: 8),
                  ],
                ),
              ),
              Divider(
                color: Colors.black,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: chargeDisplayValues.map((display) => Column(
                  children: [
                    Text(display.displayValue),
                    Text(
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold
                      ),
                      display.displayText
                    )
                  ]
                )).toList(),
              ),
            ],
          )
        )
      )
    );
  }
}

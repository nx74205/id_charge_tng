import 'package:flutter/material.dart';
import 'package:id_charge_tng/model/charge_display_value.dart';
import 'package:id_charge_tng/model/charge_session.dart';

import '../model/charge_session_dto.dart';

class ChargeSessionCard extends StatefulWidget {

  ChargeSession chargeSession;

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
      ChargeDisplayValue(displayText: 'Kosten', displayValue: chargeSession.costOfCharge),
      ChargeDisplayValue(displayText: 'BC /100 Km', displayValue: chargeSession.bcConsumption),
      ChargeDisplayValue(displayText: 'SOC', displayValue: chargeSession.socEnd)
    ];

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15)
      ),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () async {
          final result = await Navigator.pushNamed(context, '/chargeform', arguments: chargeSession.chargeSessionDto);

          if (result != null) {
            ChargeSessionDto newSession = result as ChargeSessionDto;
            setState(() {
              widget.chargeSession = ChargeSession.dto(newSession);
            });
          }
        },
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
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      //SizedBox(width: 10),
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
                      //SizedBox(width: 10),
                      Container(),
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
        ),
      )
    );
  }
}

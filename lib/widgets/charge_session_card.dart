import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:id_charge_tng/model/charge_display_value.dart';
import 'package:id_charge_tng/model/charge_session.dart';
import 'package:id_charge_tng/services/mqtt/MQTT_Manager.dart';

import '../model/charge_session_dto.dart';
import '../services/DatabaseService.dart';

class ChargeSessionCard extends StatefulWidget {

  ChargeSession chargeSession;
  MQTTManager mqttManager;

  ChargeSessionCard({super.key, required this.chargeSession, required this.mqttManager});

  @override
  State<ChargeSessionCard> createState() => _ChargeSessionCardState();
}

class _ChargeSessionCardState extends State<ChargeSessionCard> {

  //var chargeData = Map();
  final DatabaseService _databaseService = DatabaseService.instance;

  final TextStyle _editable = TextStyle(color: Colors.black, fontSize: 18);
  final TextStyle _readOnly = TextStyle(color: Colors.grey, fontSize: 18);
  @override
  Widget build(BuildContext context) {

    ChargeSession chargeSession = widget.chargeSession;
    MQTTManager mqttManager = widget.mqttManager;

    List<ChargeDisplayValue> chargeDisplayValues = [
      ChargeDisplayValue(displayText: 'Km-Stand', displayValue: chargeSession.mileage),
      ChargeDisplayValue(displayText: 'Trip', displayValue: chargeSession.tripLength),
      ChargeDisplayValue(displayText: 'kWh', displayValue: chargeSession.chargedKwPaid),
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
        splashColor: Colors.grey.withAlpha(30),
        onTap: () async {
          if (widget.chargeSession.editable) {
            final arguments = {'result' : chargeSession.chargeSessionDto};
            await Navigator.pushNamed(context, '/chargeform', arguments: arguments);
            ChargeSessionDto? result = arguments['result'] as ChargeSessionDto;
            if (result.hasChanged) {
              result.timestamp = DateTime.now();
              _databaseService.addChargeSession(result.mileage!, result.serverObjectVersion!, result.clientObjectVersion!, jsonEncode(result.toJson()));
              mqttManager.publish(result.mileage!, jsonEncode(result.toJson()));
              setState(() {
                widget.chargeSession = ChargeSession.dto(result);
                widget.chargeSession.editable = result.chargingStatus != "COMPLETED";
                mqttManager.deleteServerMessage(result.mileage!);
              });
            } else {
              print('Back without saving');
            }
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
                            chargeSession.startOfChargeDate,
                            style: chargeSession.editable ? _editable : _readOnly
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
                            style: chargeSession.editable ? _editable : _readOnly
                          ),
                        ],
                      )
                      //const SizedBox(height: 8),
                    ],
                  ),
                ),
                Divider(
                  color: chargeSession.editable ? Colors.black : Colors.grey
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: chargeDisplayValues.map((display) => Column(
                    children: [
                      Text(
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: chargeSession.editable ? Colors.black : Colors.grey
                        ),
                          display.displayValue
                      ),
                      Text(
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: chargeSession.editable ? Colors.black : Colors.grey
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

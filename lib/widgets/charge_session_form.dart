import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final dateFormat = DateFormat('dd-MM-yyyy HH:mm');
  final numFormat = NumberFormat("#,###.##", 'de-DE');

  final _controller = TextEditingController();

  List<String> _chargeProviders = [
    'Zuhause',
    'EnBw',
    'Ionity',
    'EWE Go',
    'Sonstige'
  ];

  List<String> _chargeTypes = [
    'AC',
    'CCS',
    'CCS 150kw',
    'CCS HPC'
  ];

  String _chargeType = '';
  String _chargeProvider = '';

  ChargeSessionDto? data;

  @override
  Widget build(BuildContext context) {

    data = ModalRoute.of(context)?.settings.arguments as ChargeSessionDto;

    _chargeType = (_chargeTypes.contains(data?.chargeType) ? data?.chargeType : _chargeTypes[0])!;
    _chargeProvider = (_chargeProviders.contains(data?.chargeProvider) ? data?.chargeProvider : _chargeProvider[0])!;

    _controller.text = data!.mileage.toString();
    _controller.selection = TextSelection(
      baseOffset: 0,
      extentOffset: data!.mileage.toString().length,
    );

   return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          backgroundColor: Colors.blue[400],
          foregroundColor: Colors.white,
          title: Text('Ladevorgang erfassen'),
          centerTitle: true,
          leading: BackButton(
            onPressed: () => showDialog<ChargeSessionDto>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Ladevorgang abbrechen'),
                content: const Text('Ladevorgang ohne speichern beenden'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, data);
                    }, //=> Navigator.pop(context, 'Cancel'),
                    child: const Text('Weiter'),
                  ),
                  TextButton(
                    onPressed: () {
                      int count = 0;
                      Navigator.popUntil(context, (route) {
                        return count++ == 2;
                      });
                      //=> Navigator.pop(context, 'OK'),
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.done),
              onPressed: () {
                if (_formGlobalKey.currentState!.validate()) {
                  _formGlobalKey.currentState!.save();
                  Navigator.pop(context, data);
                }
              }),
          ]
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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20),
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
                    initialValue: data?.startOfChargeDate,
                    dateFormat: dateFormat,
                    onChanged: (DateTime? value) {
                      data?.startOfChargeDate = value;
                    },
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        flex: 6,
                        child: TextFormField(
                          controller: _controller,
                          autofocus: true,
                          decoration: const InputDecoration(
                            suffixText: "Km",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(),
                            label: Text('Kilometerstand'),
                          ),
                          textAlign: TextAlign.end,
                          //initialValue: data?.mileage.toString(),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                            LengthLimitingTextInputFormatter(7)
                          ],
                          onTap: () => _controller.selection =
                              TextSelection(baseOffset: 0, extentOffset: _controller.value.text.length),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Kilometerstand fehlt';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            data?.mileage = int.parse(value!);
                          },
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        flex: 4,
                        child: TextFormField(
                          decoration: const InputDecoration(
                            suffixText: "Km",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(),
                            label: Text('Distanz'),
                          ),
                          inputFormatters:  <TextInputFormatter> [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                            LengthLimitingTextInputFormatter(4)
                          ],
                          textAlign: TextAlign.end,
                          initialValue: data?.tripLength.toString(),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Distanz fehlt';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            data?.tripLength = int.parse(value!);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField(
                          value: _chargeType,
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(),
                              label: Text('Ladetyp'),
                            ),
                          items: _chargeTypes.map((p) {
                            return DropdownMenuItem(
                                value: p,
                                child: Text(p),
                            );
                          }).toList(),
                          onChanged: (value){
                            setState(() {
                              _chargeType = value!;
                              data?.chargeType = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: DropdownButtonFormField(
                          value: _chargeProvider,
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(),
                            label: Text('Provider'),
                          ),
                          items: _chargeProviders.map((p) {
                            return DropdownMenuItem(
                              value: p,
                              child: Text(p),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _chargeProvider = value!;
                            });
                          },
                        ),
                      ),
              
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        flex: 7,
                        child: TextFormField(
                          decoration: const InputDecoration(
                            suffixText: "kWh",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(),
                            label: Text('BC Verbr.'),
                          ),
                          textAlign: TextAlign.end,
                          initialValue: numFormat.format(data?.bcConsumption),
                          keyboardType: TextInputType.number,
                          inputFormatters:  <TextInputFormatter> [
                            FilteringTextInputFormatter.allow(RegExp(r'\d*,?\d*')),
                            LengthLimitingTextInputFormatter(5)
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Eingabe erforderlich';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            data?.bcConsumption = double.parse(value!.replaceAll(',', '.'));
                          },
                        )
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(),
                      ),
                      Expanded(
                          flex: 4,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              suffixText: "%",
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(),
                              label: Text('Von SOC'),
                            ),
                            textAlign: TextAlign.end,
                            initialValue: data?.socStart.toString(),
                            keyboardType: TextInputType.number,
                            inputFormatters:  <TextInputFormatter> [
                              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                              LengthLimitingTextInputFormatter(2)
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Eingabe erforderlich';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              data?.socStart = int.parse(value!);
                            },
                          )
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(),
                      ),
                      Expanded(
                          flex: 4,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              suffixText: "%",
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(),
                              label: Text('Bis SOC'),
                            ),
                            textAlign: TextAlign.end,
                            initialValue: data?.socEnd.toString(),
                            keyboardType: TextInputType.number,
                            inputFormatters:  <TextInputFormatter> [
                              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                              LengthLimitingTextInputFormatter(3)
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Eingabe erforderlich';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              data?.socEnd = int.parse(value!);
                            },
                          )
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        flex: 7,
                        child: TextFormField(
                          decoration: const InputDecoration(
                            suffixText: "kWh",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(),
                            label: Text('Geladen'),
                          ),
                          textAlign: TextAlign.end,
                          initialValue: numFormat.format(data?.kwhCharged),
                          keyboardType: TextInputType.number,
                          inputFormatters:  <TextInputFormatter> [
                            FilteringTextInputFormatter.allow(RegExp(r'\d*,?\d*')),
                            LengthLimitingTextInputFormatter(5)
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Eingabe erforderlich';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            data?.kwhCharged = double.parse(value!.replaceAll(',', '.'));
                          },
                        )
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(),
                      ),
                      Expanded(
                          flex: 9,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              suffixIcon: Icon(
                                Icons.euro_symbol,
                                size: 20,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(),
                              label: Text('Gesamtpreis'),
                            ),
                            textAlign: TextAlign.end,
                            initialValue: numFormat.format(data?.costOfCharge),
                            keyboardType: TextInputType.number,
                            inputFormatters:  <TextInputFormatter> [
                              FilteringTextInputFormatter.allow(RegExp(r'\d*,?\d*')),
                              LengthLimitingTextInputFormatter(6)
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Eingabe erforderlich';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              data?.costOfCharge = double.parse(value!.replaceAll(',', '.'));
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
      ),
    );
  }
}

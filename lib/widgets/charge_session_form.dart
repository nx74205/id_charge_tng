import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:id_charge_tng/model/charge_session_dto.dart';
import 'package:id_charge_tng/services/charge_session_service.dart';
import 'package:intl/intl.dart';
import 'package:date_field/date_field.dart';

class ChargeSessionForm extends StatefulWidget {
  const ChargeSessionForm({super.key});

  @override
  State<ChargeSessionForm> createState() => _ChargeSessionFormState();
}

class _ChargeSessionFormState extends State<ChargeSessionForm> {

  final _chargeSessionService = new ChargeSessionService();

  final _formGlobalKey = GlobalKey<FormState>();
  final dateFormat = DateFormat('dd-MM-yyyy HH:mm');
  final numFormat = NumberFormat("#,###.##", 'de-DE');

  bool _formHasChanged = false;

  final _mileageTextcontroller = TextEditingController();
  final _bcTextController = TextEditingController();
  final _fromSocTextController = TextEditingController();
  final _toSocTextController = TextEditingController();
  final _tripLengthTextController = TextEditingController();
  final _kwhChargedTextController = TextEditingController();
  final _costOfChargeTextController = TextEditingController();

  bool _isLocked = true;
  bool _isFirstBuild = true;

  String? _chargeType = '';
  String? _chargeProvider = '';

  late int _clientObjectVersion;
  late int _serverObjectVersion;

  ChargeSessionDto? _data;
  late Map _arguments;

  @override
  Widget build(BuildContext context) {

    List<String> chargeProviders = _chargeSessionService.CHARGE_PROVIDERS;
    List<String> chargeTypes = _chargeSessionService.CHARGE_TYPES;

    if (_isFirstBuild) {
      //_data = ModalRoute.of(context)?.settings.arguments as ChargeSessionDto;

      _arguments = ModalRoute.of(context)?.settings.arguments as Map;
      _data = _arguments['result'];

      _clientObjectVersion = _data?.clientObjectVersion ?? 0;
      _serverObjectVersion = _data?.serverObjectVersion ?? 0;
      _isLocked = _data?.locked ?? true;


      _bcTextController.text = numFormat.format(_data?.bcConsumption);
      _fromSocTextController.text = _data!.socStart.toString();
      _toSocTextController.text = _data!.socEnd.toString();
      _tripLengthTextController.text = (_data?.tripLength != null ? _data?.tripLength.toString() : '')!;

      if (!chargeTypes.contains(_data?.chargeType)) {
        _chargeType = chargeTypes[0];
        _data?.chargeType = chargeTypes[0];
      } else {
        _chargeType = _data?.chargeType;
      }

      if (!chargeProviders.contains(_data?.chargeProvider)) {
        _chargeProvider = chargeProviders[0];
        _data?.chargeProvider = chargeProviders[0];
      } else {
        _chargeProvider = _data?.chargeProvider;
      }

      _isFirstBuild = false;
    }

    _mileageTextcontroller.text = _data!.mileage.toString();
    _mileageTextcontroller.selection = TextSelection(
      baseOffset: 0,
      extentOffset: _data!.mileage.toString().length,
    );
    _kwhChargedTextController.text = numFormat.format(_data?.chargedKwPaid);
    _costOfChargeTextController.text = numFormat.format(_data?.costOfCharge);

   return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        foregroundColor: Colors.white,
        title: Text('Ladevorgang'),
        centerTitle: true,
        leading: BackButton(
          onPressed: () => {
            if (_formHasChanged) {
              showDialog<ChargeSessionDto>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Eingabe abbrechen'),
                  content: const Text('Eingabe ohne speichern beenden?'),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Weiter'),
                      onPressed: () {
                        Navigator.pop(context, _data);
                      },
                    ),
                    TextButton(
                      child: const Text('OK'),
                      onPressed: () {
                        int count = 0;
                        Navigator.popUntil(context, (route) {
                          return count++ == 2;
                        });
                      },
                    ),
                  ],
                ),
              ),
            } else {
              Navigator.pop(context)
            }
          }
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                if (_isLocked) {
                  _isLocked = false;
                } else {
                  _isLocked = true;
                }
              });
            },
            icon: (_isLocked ? Icon(Icons.lock) : Icon(Icons.lock_open))),
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              if (_formGlobalKey.currentState!.validate()) {
                _formGlobalKey.currentState!.save();
                _saveData(syncNow: false);
                _arguments['result'] = _data;
                Navigator.pop(context, _arguments);
              }
            }),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => {
              showDialog<ChargeSessionDto>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Eingabe abschließen'),
                  content: const Text('Eingabe endgültig abschließen?'),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Weiter'),
                      onPressed: () {
                        Navigator.pop(context, _data);
                      },
                    ),
                    TextButton(
                      child: const Text('OK'),
                      onPressed: () {
                        _saveData(syncNow: true);
                        Navigator.popUntil(context, ((route) {
                          if (route.settings.name == '/') {
                            //(route.settings.arguments as Map)['result'] = _data;
                            return true;
                          } else {
                            return false;
                          }
                        }));
                      },
                    ),
                  ],
                ),
              ),
            },
          )
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
                    decoration: InputDecoration(
                      enabled: !_isLocked,
                      filled: true,
                      fillColor: Colors.white,
                      border: const OutlineInputBorder(),
                      label: const Text('Start Ladesession'),
                      prefixIcon: const Icon(
                              color: Colors.blue,
                              Icons.calendar_today_rounded
                            )
                    ),
                    initialValue: _data?.startOfChargeDate,
                    dateFormat: dateFormat,
                    onChanged: (DateTime? value) {
                      _data?.startOfChargeDate = value;
                      _formHasChanged = true;
                    },
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        flex: 6,
                        child: TextFormField(
                          controller: _mileageTextcontroller,
                          autofocus: true,
                          decoration: InputDecoration(
                            enabled: !_isLocked,
                            suffixText: "Km",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(),
                            label: Text('Kilometerstand'),
                          ),
                          textAlign: TextAlign.end,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                            LengthLimitingTextInputFormatter(7)
                          ],
                          onTap: () => _mileageTextcontroller.selection =
                              TextSelection(baseOffset: 0, extentOffset: _mileageTextcontroller.value.text.length),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Kilometerstand fehlt';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            _data?.mileage = int.parse(value);
                            _formHasChanged = true;
                          },
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        flex: 4,
                        child: TextFormField(
                          controller: _tripLengthTextController,
                          decoration: InputDecoration(
                            enabled: !_isLocked,
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
                          keyboardType: TextInputType.number,
                          onTap: () => _tripLengthTextController.selection =
                              TextSelection(baseOffset: 0, extentOffset: _tripLengthTextController.value.text.length),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Distanz fehlt';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            _data?.tripLength = int.parse(value);
                            _formHasChanged = true;
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
                          items: chargeTypes.map((p) {
                            return DropdownMenuItem(
                                value: p,
                                child: Text(p),
                            );
                          }).toList(),
                          onChanged: (value){
                            setState(() {
                              _chargeType = value!;
                              print(_chargeType);
                            });
                            _formHasChanged = true;
                          },
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: DropdownButtonFormField(
                          value: _chargeProvider,
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(),
                            label: Text('Provider'),
                          ),
                          items: chargeProviders.map((p) {
                            return DropdownMenuItem(
                              value: p,
                              child: Text(p),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _chargeProvider = value!;
                            });
                            _formHasChanged = true;
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
                          controller: _bcTextController,
                          decoration: const InputDecoration(
                            suffixText: "kWh",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(),
                            label: Text('BC Verbr.'),
                          ),
                          textAlign: TextAlign.end,
                          keyboardType: TextInputType.number,
                          inputFormatters:  <TextInputFormatter> [
                            FilteringTextInputFormatter.allow(RegExp(r'\d*,?\d*')),
                            LengthLimitingTextInputFormatter(5)
                          ],
                          onTap: () => _bcTextController.selection =
                              TextSelection(baseOffset: 0, extentOffset: _bcTextController.value.text.length),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Eingabe erforderlich';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            _data?.bcConsumption = double.parse(value.replaceAll(',', '.'));
                            _formHasChanged = true;
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
                            controller: _fromSocTextController,
                            decoration: InputDecoration(
                              enabled: !_isLocked,
                              suffixText: "%",
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(),
                              label: Text('Von SOC'),
                            ),
                            textAlign: TextAlign.end,
                            keyboardType: TextInputType.number,
                            inputFormatters:  <TextInputFormatter> [
                              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                              LengthLimitingTextInputFormatter(2)
                            ],
                            onTap: () => _fromSocTextController.selection =
                                TextSelection(baseOffset: 0, extentOffset: _fromSocTextController.value.text.length),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Eingabe erforderlich';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              _data?.socStart = int.parse(value);
                              _formHasChanged = true;
                            },
                          )
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                          flex: 4,
                          child: TextFormField(
                            controller: _toSocTextController,
                            decoration: InputDecoration(
                              enabled: !_isLocked,
                              suffixText: "%",
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(),
                              label: Text('Bis SOC'),
                            ),
                            textAlign: TextAlign.end,
                            keyboardType: TextInputType.number,
                            inputFormatters:  <TextInputFormatter> [
                              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                              LengthLimitingTextInputFormatter(3)
                            ],
                            onTap: () => _toSocTextController.selection =
                                TextSelection(baseOffset: 0, extentOffset: _toSocTextController.value.text.length),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Eingabe erforderlich';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              _data?.socEnd = int.parse(value);
                              _formHasChanged = true;
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
                          controller: _kwhChargedTextController,
                          decoration: const InputDecoration(
                            suffixText: "kWh",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(),
                            label: Text('Geladen'),
                          ),
                          textAlign: TextAlign.end,
                          keyboardType: TextInputType.number,
                          inputFormatters:  <TextInputFormatter> [
                            FilteringTextInputFormatter.allow(RegExp(r'\d*,?\d*')),
                            LengthLimitingTextInputFormatter(5)
                          ],
                          onTap: () => _kwhChargedTextController.selection =
                              TextSelection(baseOffset: 0, extentOffset: _kwhChargedTextController.value.text.length),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Eingabe erforderlich';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            _data?.chargedKwPaid = double.parse(value.replaceAll(',', '.'));
                            _formHasChanged = true;
                          },
                        )
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        flex: 9,
                        child: TextFormField(
                          controller: _costOfChargeTextController,
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
                          keyboardType: TextInputType.number,
                          inputFormatters:  <TextInputFormatter> [
                            FilteringTextInputFormatter.allow(RegExp(r'\d*,?\d*')),
                            LengthLimitingTextInputFormatter(6)
                          ],
                          onTap: () => _costOfChargeTextController.selection =
                              TextSelection(baseOffset: 0, extentOffset: _costOfChargeTextController.value.text.length),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Eingabe erforderlich';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            _data?.costOfCharge = double.parse(value.replaceAll(',', '.'));
                            _formHasChanged = true;
                          },
                        )
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                          flex: 9,
                          child: TextFormField(
                            initialValue: _data?.chargingStatus,
                            decoration: const InputDecoration(
                              enabled: false,
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(),
                              label: Text('Ladestatus'),
                            ),
                            textAlign: TextAlign.left,
                          )
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _saveData({required bool syncNow}) {
    if (syncNow) {
      _data?.chargingStatus = "COMPLETED";
    }
    _data?.chargeType = _chargeType;
    _data?.chargeProvider = _chargeProvider;
    _data?.clientObjectVersion = _clientObjectVersion + 1;
    _data?.serverObjectVersion = _serverObjectVersion;
    _data?.locked = _isLocked;
    _data?.hasChanged = true;
  }
}



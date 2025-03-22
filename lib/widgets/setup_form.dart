import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:id_charge_tng/model/mqtt_credentials.dart';

import '../services/mqtt/MQTTAppState.dart';
import '../services/mqtt/MQTT_Manager.dart';
import '../services/secure_storage.dart';

class SetupForm extends StatefulWidget {
  const SetupForm({super.key});

  @override
  State<SetupForm> createState() => _SetupFormState();
}

class _SetupFormState extends State<SetupForm> {

  late MQTTAppState currentAppState = MQTTAppState();
  late MQTTManager manager;

  final _formGlobalKey = GlobalKey<FormState>();
  bool _formHasChanged = false;
  bool _isObscured = true;
  bool _saveEnabled = false;

  final _identifierController = TextEditingController();
  final _hostController = TextEditingController();
  final _portController = TextEditingController();
  final _vinController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  final SecureStorage _secureStorage = SecureStorage();

  final List<String> _connectTypeOptions = [
    'MQTT',
    'WS',
    'WSS'
  ];

  String? _connectTypeOption = 'MQTT';


  @override
  void initState() {
    super.initState();
    fetchSecureStorageData();
  }

  Future<void> fetchSecureStorageData() async {
    _identifierController.text = await _secureStorage.getIdentifier() ?? 'IDCharge TNG';
    _hostController.text = await _secureStorage.getHost() ?? '';
    _portController.text = await _secureStorage.getPort() ?? '1883';
    _vinController.text = await _secureStorage.getVin() ?? '';
    _usernameController.text = await _secureStorage.getUsername() ?? '';
    _passwordController.text = await _secureStorage.getPassword() ?? '';
    _connectTypeOption = await _secureStorage.getConnectType() ?? _connectTypeOptions[0];

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        foregroundColor: Colors.white,
        title: Text('MQTT Konfiguration'),
        centerTitle: true,
        leading: BackButton(
          onPressed: () => {
            if (_formHasChanged) {
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Eingabe abbrechen'),
                  content: const Text('Eingabe ohne speichern beenden?'),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Weiter'),
                      onPressed: () {
                        Navigator.pop(context);
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
            icon: Icon(Icons.done),
            onPressed: !_saveEnabled ? null : () async {
              if (_formGlobalKey.currentState!.validate()) {
                await _secureStorage.setIdentifier(_identifierController.text);
                await _secureStorage.setHost(_hostController.text);
                await _secureStorage.setPort(_portController.text);
                await _secureStorage.setVin(_vinController.text);
                await _secureStorage.setConnectType(_connectTypeOption!);
                await _secureStorage.setUserName(_usernameController.text);
                await _secureStorage.setPassword(_passwordController.text);

                if (context.mounted) {
                  Navigator.of(context).pop(_saveEnabled);
                }
              }
            }
          ),
        ]

      ),
      body: Card(
        color: Colors.white,
        margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        elevation: 5,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15)
        ),
        child: Form(
          key: _formGlobalKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
            child: Column(
              children: [
                const SizedBox(height: 20),
                TextFormField(
                  controller: _vinController,
                  autofocus: true,
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                      label: Text("Fahrzeug VIN"),
                      hintText: "WVW..."
                  ),
                  textAlign: TextAlign.left,
                  textCapitalization: TextCapitalization.characters,
                  inputFormatters:  <TextInputFormatter> [
                    LengthLimitingTextInputFormatter(17)
                  ],

                  keyboardType: TextInputType.text,
                  onTap: () => _vinController.selection =
                      TextSelection(baseOffset: 0, extentOffset: _vinController.value.text.length),
                  onChanged: (value) {
                    _formHasChanged = true;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Eingabe erforderlich';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _identifierController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    label: Text("MQTT Identifier"),
                  ),
                  textAlign: TextAlign.left,
                  keyboardType: TextInputType.text,
                  onTap: () => _identifierController.selection =
                      TextSelection(baseOffset: 0, extentOffset: _identifierController.value.text.length),
                  onChanged: (value)  => _formHasChanged = true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Eingabe erforderlich';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: DropdownButtonFormField(
                        value: _connectTypeOption,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                          label: Text('Protokoll'),
                        ),
                        items: _connectTypeOptions.map((p) {
                          return DropdownMenuItem(
                            value: p,
                            child: Text(p),
                          );
                        }).toList(),
                        onChanged: (value){
                          _formHasChanged = true;
                          setState(() {
                            _connectTypeOption = value!;
                          });
                        },
                      ),

                    ),
                    const SizedBox(width: 2),
                    Expanded(
                      flex: 8,
                      child:  TextFormField(
                        controller: _hostController,
                        autofocus: true,
                        decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(),
                            label: Text("Servername"),
                            hintText: "mein.server.de"
                        ),
                        textAlign: TextAlign.left,
                        keyboardType: TextInputType.text,
                        onTap: () => _hostController.selection =
                            TextSelection(baseOffset: 0, extentOffset: _hostController.value.text.length),
                        onChanged: (value)  => _formHasChanged = true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Eingabe erforderlich';
                          }
                          return null;
                        },
                      )
                    ),
                    const SizedBox(width: 2),
                    Expanded(
                      flex: 4,
                      child: TextFormField(
                        controller: _portController,
                        autofocus: true,
                        decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(),
                            label: Text("Port"),
                            hintText: "1883"
                        ),
                        textAlign: TextAlign.left,
                        inputFormatters:  <TextInputFormatter> [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          LengthLimitingTextInputFormatter(5)
                        ],
                        keyboardType: TextInputType.number,
                        onTap: () => _portController.selection =
                            TextSelection(baseOffset: 0, extentOffset: _portController.value.text.length),
                        onChanged: (value)  => _formHasChanged = true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Eingabe erforderlich';
                          }
                          return null;
                        },
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _usernameController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    label: Text("Username"),
                    hintText: "Benutzer"
                  ),
                  textAlign: TextAlign.left,
                  textCapitalization: TextCapitalization.characters,
                  inputFormatters:  <TextInputFormatter> [
                    LengthLimitingTextInputFormatter(17)
                  ],
                  keyboardType: TextInputType.text,
                  onTap: () => _usernameController.selection =
                      TextSelection(baseOffset: 0, extentOffset: _usernameController.value.text.length),
                  onChanged: (value) {
                    _formHasChanged = true;
                  },
                  validator: (value) {
                    if (value!.isEmpty && !(_passwordController.text == '')) {
                      return 'Eingabe erforderlich';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _isObscured,
                  autofocus: true,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: _isObscured ? Icon(Icons.visibility) : const Icon(Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _isObscured = !_isObscured;
                        });
                      }
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    label: Text("Passwort"),
                    hintText: "Passwort"
                  ),
                  textAlign: TextAlign.left,
                  textCapitalization: TextCapitalization.characters,
                  inputFormatters:  <TextInputFormatter> [
                    LengthLimitingTextInputFormatter(17)
                  ],

                  keyboardType: TextInputType.text,
                  onTap: () => _passwordController.selection =
                      TextSelection(baseOffset: 0, extentOffset: _passwordController.value.text.length),
                  onChanged: (value) {
                    _formHasChanged = true;
                  },
                  validator: (value) {
                    if (value!.isEmpty && !(_usernameController.text == '')) {
                      return 'Eingabe erforderlich';
                    }
                    return null;
                  },

                ),
                const SizedBox(height: 15),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white
                    ),
                    onPressed: () async {
                      if (_formGlobalKey.currentState!.validate()) {
                        await _configureAndConnect(MqttCredentials(
                          identifier: _identifierController.text,
                          connectType: _connectTypeOption!,
                          host: _hostController.text,
                          port: _portController.text,
                          vin: _vinController.text,
                          userName: _usernameController.text,
                          password: _passwordController.text));
                      }
                    },
                    child: const Text('Konfiguration prüfen')
                  ),
                )
              ],
            ),
          )),

      ),
    );
  }

  Future<void> _configureAndConnect(MqttCredentials credentials) async {

    currentAppState.setAppConnectionState(MQTTAppConnectionState.notConfigured);
    manager = MQTTManager.credentials(state: currentAppState, credentials: credentials);
    String messageText;

    await manager.initializeMQTTClient();
    await manager.connect();

    if (currentAppState.getAppConnectionState == MQTTAppConnectionState.connected) {
      manager.disconnect();
      messageText = "Erfolgreich";
      await _secureStorage.setStorageStatus("VALIDATED");

      setState(() {
        _saveEnabled = true;
      });
    } else {
      messageText = "Fehlgeschlagen";
      await _secureStorage.setStorageStatus("ENTERED");
    }
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Prüfung Verbindung zum Server'),
        content: Text(messageText),
        actions: <Widget> [
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      )
    );
  }

}

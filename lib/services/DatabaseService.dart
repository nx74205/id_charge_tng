import 'dart:convert';

import 'package:id_charge_tng/model/charge_session_dto.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseService {

  static Database? _db;
  static final DatabaseService instance = DatabaseService._constructor();

  final String _tableChargeData = 'charge_data';
  final String _columnMileage = 'mileage';
  final String _columnServerObjectVersion = 'server_object_version';
  final String _columnClientObjectVersion = 'client_object_version';
  final String _columnJsonPayload = 'json_payload';

  DatabaseService._constructor();

  Future<Database> get database async {
    if (_db != null) {
      return _db!;
    } else {
      _db = await getDatabase();
      return _db!;
    }
  }

  Future<Database> getDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "master_db.db");
    final database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
        CREATE TABLE $_tableChargeData (
          $_columnMileage INTEGER PRIMARY KEY,
          $_columnServerObjectVersion INTEGER NOT NULL,
          $_columnClientObjectVersion INTEGER NOT NULL,
          $_columnJsonPayload TEXT
        )
        ''');
      },
    );
    return database;
  }

  void addChargeSession(int mileage, int serverObjectVersion, int clientObjectVersion, String payload,) async {
    final db = await database;

    ChargeSessionDto? dto = await getChargeSession(mileage);

    if (dto == null) {
      await db.insert(
          _tableChargeData,
          {
            _columnMileage : mileage,
            _columnClientObjectVersion: clientObjectVersion,
            _columnServerObjectVersion: serverObjectVersion,
            _columnJsonPayload: payload
          });

    } else {
      await db.update(
          _tableChargeData,
          {
            _columnMileage : mileage,
            _columnClientObjectVersion: clientObjectVersion,
            _columnServerObjectVersion: serverObjectVersion,
            _columnJsonPayload: payload
          },
          where: '$_columnMileage = ?',
          whereArgs: [mileage]);
    }
  }

  Future<List<ChargeSessionDto>> getChargeSessions() async {

    List<ChargeSessionDto> chargeSessionDt0List = List.empty(growable: true);
    final db = await database;

    List<Map<String, dynamic>> data = await db.query(_tableChargeData);
    for (var i = 0; i < data.length; i++) {
      chargeSessionDt0List.add(ChargeSessionDto.fromJson(json.decode(data[i]['json_payload'])));
    }

    return chargeSessionDt0List;
  }

  Future<ChargeSessionDto?> getChargeSession(int mileage) async {

    final db = await database;
    List<Map<String, dynamic>> data = await db.query(_tableChargeData,
                            where: '$_columnMileage = ?',
                            whereArgs: [mileage]);

    if (data.isNotEmpty) {
      return ChargeSessionDto.fromJson(json.decode(data.first['json_payload']));
    }

    return null;
  }

  Future<bool> delChargeSession(int mileage) async {
    final db = await database;
    int i  = await db.delete(_tableChargeData, where: '$_columnMileage = ?',
                                        whereArgs: [mileage]);

      if (i==1) {
        return true;
      } else {
        return false;
      }
    }
}
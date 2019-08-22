import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';
export 'package:qrreaderapp/src/models/scan_model.dart';

class DBProvider{

  //// Se nesecita que solo exista una instancia de [DBProvider]
  /// de manera global en la aplicación, con el fin de que no
  /// se tengan multples instancias en la aplicación, para lo cual
  /// se usan 2 propiedades [static]
  
  //Esta es la instancia a la base de datos.
  static Database _database;

  //// [db] contiene una intancia a un constructor privado
  /// [DBProvider._()] para evitar que [db] se este reinicializando
  /// para cuando se nesecite se hace referencia a esta propiedad [db]
  //se declara final para evitar que se cambie por algun error.
  static final DBProvider db = DBProvider._();
  
  // el _ indica que es privado
  DBProvider._();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB(); 

    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    //path de donde se encuentra la base de datos inclullendo el archivo.
    final path = join( documentsDirectory.path, 'ScansDB.db' );

    //// [version] si se hace algun cambio en la aplicación la cual contiene ahora mas 
    /// tablas dentro de la base de datos o nuevas relaciones o cualquier cambio que no sea
    /// con los datos de la base de datos si no con la estructura.
    /// se debe incrementar en 1, 
    /// al hacer cambios y llamar openDatabase en la [version: 1] llamara a esa enstancia.
    /// para que realice los cambios que se hicieron a la base de datos debemos llamar a la
    /// [version: 2] o alguna otra diferente a la que ya teniamos y se hagan los cambios.
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db){},
      onCreate: (Database db, int version) async {
        await db.execute(
          'CREATE TABLE Scans('
          ' id INTEGER PRIMARY KEY,'
          ' tipo TEXT,'
          ' valor TEXT'
          ')'
        );
      }
    );
  }

  // CREAR regitro de base de datos

  nuevoScanRaw(ScanModel nuevoScanModel) async {

    final db = await database;

    final res =  await db.rawInsert(
      "INSERT INTO Scans (id, tipo. valor) "
      "VALUES ( ${nuevoScanModel.id}, '${nuevoScanModel.tipo}', '${nuevoScanModel.valor}' )"
    );

    return res;
  }

  nuevoScan(ScanModel nuevoScan) async {
    final db  = await database;
    final res = await db.insert('Scans', nuevoScan.toJson());
    return res;
  }

  //SELECT - Obtener información
  Future<ScanModel> getScanId(int id) async {
    final db = await database;
    final res = await db.query('Scans',where: 'id = ?', whereArgs: [id]);
    return res.isNotEmpty ? ScanModel.fromJson(res.first) : null;
  }

  Future <List<ScanModel>> getTodosScans() async{
    final db = await database;
    final res = await db.query('Scans');

    List<ScanModel> list =  res.isNotEmpty 
                              ? res.map((c)=>ScanModel.fromJson(c)).toList()
                              : [];
    return list;
  }

  Future <List<ScanModel>> getScansPortipo(String tipo) async{
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM Scans WHERE tipo = '$tipo'");

    List<ScanModel> list =  res.isNotEmpty 
                              ? res.map((c)=>ScanModel.fromJson(c)).toList()
                              : [];
    return list;
  }

  //actualizar registros
  Future<int> updateScan(ScanModel nuevoScan) async{
    final db = await database;

    final res = await db.update('Scans', nuevoScan.toJson(), where: 'id = ?', whereArgs: [nuevoScan.id]);
    return res;
  }

  //Eliminar registros
  Future<int> deleteScan(int id) async {
    final db = await database;
    final res = await db.delete('Scans',where: 'id = ?', whereArgs: [id]);
    return res;
  }

  Future<int> deleteAll() async {
    final db = await database;
    final res = await db.rawDelete("DELETE FROM Scans");
    return res;
  }
}
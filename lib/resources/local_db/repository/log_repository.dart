import 'package:bluu/models/log.dart';
//import 'package:bluu/resources/local_db/db/hive_methods.dart';
import 'package:meta/meta.dart';
import 'package:bluu/resources/local_db/db/sqlite_methods.dart';

class LogRepository {
  static SqliteMethods dbObject;
  static bool isHive;

  static init({@required bool isHive, @required String dbName}) {
    dbObject = SqliteMethods();
  //  dbObject.openDb(dbName); 
    dbObject.init();
  }

  static addLogs(Log log) => dbObject.addLogs(log);

  static deleteLogs(int logId) => dbObject.deleteLogs(logId);

  static getLogs() => dbObject.getLogs();

  static close() => dbObject.close();
}

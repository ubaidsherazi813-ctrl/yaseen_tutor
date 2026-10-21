import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';

abstract class UserDatabase {
  Future<int> insert(String table, Map<String, Object?> values);
  Future<List<Map<String, Object?>>> query(
    String table, {
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
  });
  Future<int> update(
    String table,
    Map<String, Object?> values, {
    String? where,
    List<Object?>? whereArgs,
  });
  Future<int> delete(
    String table, {
    String? where,
    List<Object?>? whereArgs,
  });
}

abstract class DbServiceBase {
  UserDatabase get user;
  Future<void> init(SharedPreferences prefs);
  Future<List<Ayat>> loadAyaat();
  Future<List<Topic>> loadTopics();
  Future<List<AppUser>> loadUsers();
}

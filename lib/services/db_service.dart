import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';
import 'db_interface.dart';
import 'db_stub.dart'
    if (dart.library.io) 'db_native.dart'
    if (dart.library.js_interop) 'db_web.dart'
    if (dart.library.html) 'db_web.dart';

export 'db_interface.dart';

class DbService implements DbServiceBase {
  late final DbServiceBase _impl;

  DbService() {
    _impl = createDbService();
  }

  @override
  UserDatabase get user => _impl.user;

  @override
  Future<void> init(SharedPreferences prefs) => _impl.init(prefs);

  @override
  Future<List<Ayat>> loadAyaat() => _impl.loadAyaat();

  @override
  Future<List<Topic>> loadTopics() => _impl.loadTopics();

  @override
  Future<List<AppUser>> loadUsers() => _impl.loadUsers();
}

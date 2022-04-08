import 'dart:async';
import 'package:note/model/models.dart';
import 'local_database.dart';

class ModelsStore {
  static const String storeName = "note7";

  final _store = intMapStoreFactory.store(storeName);

  Future<Database> get _db async => await LocalDatabase.instance.database;

  Future<dynamic> save(Models entity) async {
    List<Models> vals = [];
    await _store.add(await _db, entity.toJson());
    vals = await findAll();
    return vals;
  }

  update(Models entity) async {
    final finder = Finder(filter: Filter.byKey(entity.key));
    await _store.update(await _db, entity.toJson(), finder: finder);
  }

  delete(Models entity) async {
    final finder = Finder(filter: Filter.byKey(entity.key));
    var dbs = await _db;
    await _store.delete(dbs, finder: finder);
  }

  Future<Stream<List<Models>>> stream() async {
    var streamTransformer = StreamTransformer<
        List<RecordSnapshot<int, Map<String, dynamic>>>,
        List<Models>>.fromHandlers(
      handleData: _streamTransformerHandlerData,
    );

    return _store.query().onSnapshots(await _db).transform(streamTransformer);
  }

  Future<List<Models>> findAll() async {
    final snapshot = await _store.find(await _db);
    return snapshot.map((e) {
      return Models.fromDatabase(e);
    }).toList();
  }

  _streamTransformerHandlerData(
      List<RecordSnapshot<int, Map<String, dynamic>>> snapshotList,
      EventSink<List<Models>> sink) {
    List<Models> resultSet = [];
    for (var element in snapshotList) {
      resultSet.add(Models.fromDatabase(element));
    }
    sink.add(resultSet);
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:note/model/models.dart';
import 'local_database.dart';

class ModelsStore {
  static const String storeName = "note6";

  final _store = intMapStoreFactory.store(storeName);
  Future<Database> get _db async => await LocalDatabase.instance.database;

  save(Models entity) async {
    debugPrint("SAVING $entity");
    await _store.add(await _db, entity.toJson());
    debugPrint("okkkkkkkkk $entity");
  }

  update(Models entity) async {
    debugPrint("UPDATING $entity");
    final finder = Finder(filter: Filter.byKey(entity.key));
    await _store.update(await _db, entity.toJson(), finder: finder);
  }

  // delete(Models entity) async {
  //   debugPrint("DELETING $entity");
  //   final finder = Finder(filter: Filter.byKey(entity.key));
  //   await _store.delete(await _db, finder: finder);
  // }

  Future<Stream<List<Models>>> stream() async {
    debugPrint("Geting Data Stream");
    var streamTransformer = StreamTransformer<
        List<RecordSnapshot<int, Map<String, dynamic>>>,
        List<Models>>.fromHandlers(
      handleData: _streamTransformerHandlerData,
    );

    return _store
        .query()
        .onSnapshots(await _db)
        .transform(streamTransformer);
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

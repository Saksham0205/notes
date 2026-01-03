import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

part 'app_database.g.dart';

class Notes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get content => text()();
}

@DriftDatabase(tables: [Notes])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<List<Note>> getAllNotes() {
    return select(notes).get();
  }

  Stream<List<Note>> watchNotes() {
    return select(notes).watch();
  }

  Future<void> addNote(String content) {
    return into(notes).insert(NotesCompanion(content: Value(content)));
  }

  Future<void> updateNote(int id, String newContent) {
    return (update(notes)..where((tbl) => tbl.id.equals(id)))
        .write(NotesCompanion(content: Value(newContent)));
  }

  Future<void> deleteNote(int id) {
    return (delete(notes)..where((tbl) => tbl.id.equals(id))).go();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'notes.db'));
    
    // Make sure the correct SQLite library is loaded on Android
    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }
    
    return NativeDatabase(file);
  });
}

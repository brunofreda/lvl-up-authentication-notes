// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:path/path.dart' show join;
// import 'package:path_provider/path_provider.dart';
// import 'package:sqflite/sqflite.dart';
//
// import '../../extensions/list/filter.dart';
// import 'crud_exceptions.dart';
//
// class NotesService {
//   Database? _db;
//
//   List<DatabaseNote> _notes = [];
//
//   DatabaseUser? _user;
//   late final StreamController<List<DatabaseNote>> _notesStreamController;
//
//   static final NotesService _shared = NotesService._sharedInstance();
//
//   factory NotesService() => _shared;
//
//   NotesService._sharedInstance() {
//     _notesStreamController =
//         StreamController<List<DatabaseNote>>.broadcast(onListen: () {
//       _notesStreamController.sink.add(_notes);
//     });
//   }
//
//   Stream<List<DatabaseNote>> get allNotes {
//     return _notesStreamController.stream.filter((note) {
//       final currentUser = _user;
//
//       if (currentUser != null) {
//         return note.userId == currentUser.id;
//       } else {
//         throw UserShouldBeSetBeforeReadingAllNotes();
//       }
//     });
//   }
//
//   Future<void> open() async {
//     if (_db != null) {
//       throw DatabaseAlreadyOpenException();
//     }
//
//     try {
//       final docsPath = await getApplicationDocumentsDirectory();
//       final dbPath = join(docsPath.path, dbName);
//       final db = await openDatabase(dbPath);
//
//       _db = db;
//
//       await db.execute(createUserTable);
//       await db.execute(createNoteTable);
//       await _cacheNotes();
//     } on MissingPlatformDirectoryException {
//       throw UnableToGetDocumentsDirectory();
//     }
//   }
//
//   Future<void> _ensureDbIsOpen() async {
//     try {
//       await open();
//     } on DatabaseAlreadyOpenException {
//       // Empty.
//     }
//   }
//
//   Future<void> close() async {
//     final db = _db;
//
//     if (db == null) {
//       throw DataBaseIsNotOpen();
//     } else {
//       await db.close();
//
//       _db = null;
//     }
//   }
//
//   Database _getDatabaseOrThrow() {
//     final db = _db;
//
//     if (db == null) {
//       throw DataBaseIsNotOpen();
//     } else {
//       return db;
//     }
//   }
//
//   Future<DatabaseUser> createUser({required String email}) async {
//     await _ensureDbIsOpen();
//
//     final db = _getDatabaseOrThrow();
//     final results = await db.query(
//       userTable,
//       limit: 1,
//       where: 'email = ?',
//       whereArgs: [email.toLowerCase()],
//     );
//
//     if (results.isNotEmpty) {
//       throw UserAlreadyExists();
//     }
//
//     final userId = await db.insert(userTable, {
//       emailColumn: email.toLowerCase(),
//     });
//
//     return DatabaseUser(id: userId, email: email);
//   }
//
//   Future<DatabaseUser> getUser({required String email}) async {
//     await _ensureDbIsOpen();
//
//     final db = _getDatabaseOrThrow();
//     final results = await db.query(
//       userTable,
//       limit: 1,
//       where: 'email = ?',
//       whereArgs: [email.toLowerCase()],
//     );
//
//     if (results.isEmpty) {
//       throw CouldNotFindUser();
//     } else {
//       return DatabaseUser.fromRow(results.first);
//     }
//   }
//
//   Future<DatabaseUser> getOrCreateUser({
//     required String email,
//     bool setAsCurrentUser = true,
//   }) async {
//     try {
//       final user = await getUser(email: email);
//
//       if (setAsCurrentUser) {
//         _user = user;
//       }
//
//       return user;
//     } on CouldNotFindUser {
//       final createdUser = await createUser(email: email);
//
//       if (setAsCurrentUser) {
//         _user = createdUser;
//       }
//
//       return createdUser;
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//   Future<void> deleteUser({required String email}) async {
//     await _ensureDbIsOpen();
//
//     final db = _getDatabaseOrThrow();
//     final deletedCount = await db.delete(
//       userTable,
//       where: 'email = ?',
//       whereArgs: [email.toLowerCase()],
//     );
//
//     if (deletedCount != 1) {
//       throw CouldNotDeleteUser();
//     }
//   }
//
//   Future<void> _cacheNotes() async {
//     final allNotes = await getAllNotes();
//
//     _notes = allNotes.toList();
//     _notesStreamController.add(_notes);
//   }
//
//   Future<DatabaseNote> createNote({required DatabaseUser owner}) async {
//     await _ensureDbIsOpen();
//
//     final db = _getDatabaseOrThrow();
//     final dbUser = await getUser(email: owner.email);
//
//     if (dbUser != owner) {
//       throw CouldNotFindUser();
//     }
//
//     const text = '';
//
//     final noteId = await db.insert(noteTable, {
//       userIdColumn: owner.id,
//       textColumn: text,
//       isSyncedWithCloudColumn: 1,
//     });
//
//     final note = DatabaseNote(
//       id: noteId,
//       userId: owner.id,
//       text: text,
//       isSyncedWithCloud: true,
//     );
//
//     _notes.add(note);
//     _notesStreamController.add(_notes);
//
//     return note;
//   }
//
//   Future<DatabaseNote> getNote({required int id}) async {
//     await _ensureDbIsOpen();
//
//     final db = _getDatabaseOrThrow();
//     final notes = await db.query(
//       noteTable,
//       limit: 1,
//       where: 'id = ?',
//       whereArgs: [id],
//     );
//
//     if (notes.isEmpty) {
//       throw CouldNotFindNote();
//     } else {
//       final note = DatabaseNote.fromRow(notes.first);
//       final noteIndex = _notes.indexWhere((notesNote) => notesNote.id == id);
//       _notes[noteIndex] = note;
//
//       _notesStreamController.add(_notes);
//
//       return note;
//     }
//   }
//
//   Future<DatabaseNote> updateNote({
//     required DatabaseNote note,
//     required String text,
//   }) async {
//     await _ensureDbIsOpen();
//
//     final db = _getDatabaseOrThrow();
//
//     await getNote(id: note.id);
//
//     final updatesCount = await db.update(
//       noteTable,
//       {
//         textColumn: text,
//         isSyncedWithCloudColumn: 0,
//       },
//       where: 'id = ?',
//       whereArgs: [note.id],
//     );
//
//     if (updatesCount == 0) {
//       throw CouldNotUpdateNote();
//     } else {
//       final updatedNote = await getNote(id: note.id);
//       final noteIndex =
//           _notes.indexWhere((notesNote) => notesNote.id == note.id);
//       _notes[noteIndex] = updatedNote;
//
//       _notesStreamController.add(_notes);
//
//       return updatedNote;
//     }
//   }
//
//   Future<Iterable<DatabaseNote>> getAllNotes() async {
//     await _ensureDbIsOpen();
//
//     final db = _getDatabaseOrThrow();
//     final notes = await db.query(noteTable);
//
//     return notes.map((notesRow) => DatabaseNote.fromRow(notesRow));
//   }
//
//   Future<void> deleteNote({required int id}) async {
//     await _ensureDbIsOpen();
//
//     final db = _getDatabaseOrThrow();
//     final deletedCount = await db.delete(
//       noteTable,
//       where: 'id = ?',
//       whereArgs: [id],
//     );
//
//     if (deletedCount == 0) {
//       throw CouldNotDeleteNote();
//     } else {
//       _notes.removeWhere((note) => note.id == id);
//       _notesStreamController.add(_notes);
//     }
//   }
//
//   Future<int> deleteAllNotes() async {
//     await _ensureDbIsOpen();
//
//     final db = _getDatabaseOrThrow();
//     final numberOfDeletions = await db.delete(noteTable);
//
//     _notes = [];
//     _notesStreamController.add(_notes);
//
//     return numberOfDeletions;
//   }
// }
//
// @immutable
// class DatabaseUser {
//   const DatabaseUser({
//     required this.id,
//     required this.email,
//   });
//
//   final int id;
//   final String email;
//
//   DatabaseUser.fromRow(Map<String, Object?> map)
//       : id = map[idColumn] as int,
//         email = map[emailColumn] as String;
//
//   @override
//   String toString() => 'User, ID = $id, email = $email';
//
//   @override
//   bool operator ==(covariant DatabaseUser other) => id == other.id;
//
//   @override
//   int get hashCode => id.hashCode;
// }
//
// class DatabaseNote {
//   const DatabaseNote({
//     required this.id,
//     required this.userId,
//     required this.text,
//     required this.isSyncedWithCloud,
//   });
//
//   final int id;
//   final int userId;
//   final String text;
//   final bool isSyncedWithCloud;
//
//   DatabaseNote.fromRow(Map<String, Object?> map)
//       : id = map[idColumn] as int,
//         userId = map[userIdColumn] as int,
//         text = map[textColumn] as String,
//         isSyncedWithCloud =
//             (map[isSyncedWithCloudColumn] as int) == 1 ? true : false;
//
//   @override
//   String toString() => 'Note, ID = $id, userId = $userId, text = $text, '
//       'isSyncedWithCloud = $isSyncedWithCloud';
//
//   @override
//   bool operator ==(covariant DatabaseNote other) => id == other.id;
//
//   @override
//   int get hashCode => id.hashCode;
// }
//
// const dbName = 'notes.db';
// const userTable = 'user';
// const noteTable = 'note';
// const idColumn = 'id';
// const emailColumn = 'email';
// const userIdColumn = 'user_id';
// const textColumn = 'text';
// const isSyncedWithCloudColumn = 'is_synced_with_cloud';
// const createUserTable = '''
//     CREATE TABLE IF NOT EXISTS "user" (
//       "id"	INTEGER NOT NULL,
//       "email"	TEXT NOT NULL UNIQUE,
//       PRIMARY KEY("id" AUTOINCREMENT)
//     );
//   ''';
// const createNoteTable = '''
//     CREATE TABLE IF NOT EXISTS "note" (
//       "id"	INTEGER NOT NULL,
//       "user_id"	INTEGER NOT NULL,
//       "text"	TEXT,
//       "is_synced_with_cloud"	INTEGER NOT NULL DEFAULT 0,
//       PRIMARY KEY("id" AUTOINCREMENT),
//       FOREIGN KEY("user_id") REFERENCES "user"("id")
//     );
//   ''';

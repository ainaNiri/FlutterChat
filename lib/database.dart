// import 'dart:async';

// import 'package:flutter/widgets.dart';

// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';

// // Avoid errors caused by flutter upgrade.
// // Importing 'package:flutter/widgets.dart' is required.
// // ignore: non_constant_identifier_names
// void main() async {
//   // Avoid errors caused by flutter upgrade.
//   // Importing 'package:flutter/widgets.dart' is required.
//   WidgetsFlutterBinding.ensureInitialized();
//   // Open the database and store the reference.
//   final Future<Database> database = openDatabase(
//     // Set the path to the database. Note: Using the `join` function from the
//     // `path` package is best practice to ensure the path is correctly
//     // constructed for each platform.
//     join(await getDatabasesPath(), 'doggie_database.db'),
//     // When the database is first created, create a table to store dogs.
//     onCreate: (db, version) {
//       return db.execute(
//         "CREATE TABLE dogs(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)",
//       );
//     },
//     // Set the version. This executes the onCreate function and provides a
//     // path to perform database upgrades and downgrades.
//   );

//   Future<void> insertDog(Dog dog) async {
//     // Get a reference to the database.
//     final Database db = await database;

//     // Insert the Dog into the correct table. Also specify the
//     // `conflictAlgorithm`. In this case, if the same dog is inserted
//     // multiple times, it replaces the previous data.
//     await db.insert(
//       'dogs',
//       dog.toMap(),
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//   }

//   Future<List<Dog>> dogs() async {
//     // Get a reference to the database.
//     final Database db = await database;

//     // Query the table for all The Dogs.
//     final List<Map<String, dynamic>> maps = await db.query('dogs');

//     // Convert the List<Map<String, dynamic> into a List<Dog>.
//     return List.generate(maps.length, (i) {
//       return Dog(
//         id: maps[i]['id'],
//         name: maps[i]['name'],
//         age: maps[i]['age'],
//       );
//     });
//   }

//   Future<void> updateDog(Dog dog) async {
//     // Get a reference to the database.
//     final db = await database;

//     // Update the given Dog.
//     await db.update(
//       'dogs',
//       dog.toMap(),
//       // Ensure that the Dog has a matching id.
//       where: "id = ?",
//       // Pass the Dog's id as a whereArg to prevent SQL injection.
//       whereArgs: [dog.id],
//     );
//   }

//   Future<void> deleteDog(int id) async {
//     // Get a reference to the database.
//     final db = await database;

//     // Remove the Dog from the database.
//     await db.delete(
//       'dogs',
//       // Use a `where` clause to delete a specific dog.
//       where: "id = ?",
//       // Pass the Dog's id as a whereArg to prevent SQL injection.
//       whereArgs: [id],
//     );
//   }

//   var fido = Dog(
//     id: 0,
//     name: 'Fido',
//     age: 35,
//   );

//   // Insert a dog into the database.
//   await insertDog(fido);

//   // Print the list of dogs (only Fido for now).
//   print(await dogs());

//   // Update Fido's age and save it to the database.
//   fido = Dog(
//     id: fido.id,
//     name: fido.name,
//     age: fido.age + 7,
//   );
//   await updateDog(fido);

//   // Print Fido's updated information.
//   print(await dogs());

//   // Delete Fido from the database.
//   await deleteDog(fido.id);

//   // Print the list of dogs (empty).
//   print(await dogs());
// }

// class Dog {
//   final int id;
//   final String name;
//   final int age;

//   Dog({this.id, this.name, this.age});

//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'name': name,
//       'age': age,
//     };
//   }

//   // Implement toString to make it easier to see information about
//   // each dog when using the print statement.
//   @override
//   String toString() {
//     return 'Dog{id: $id, name: $name, age: $age}';
//   }
// }


// // var databasesPath = await getDatabasesPath();
// // String path = join(databasesPath, 'demo.db');

// // // Delete the database
// // await deleteDatabase(path);

// // // open the database
// // Database database = await openDatabase(path, version: 1,
// //     onCreate: (Database db, int version) async {
// //   // When creating the db, create the table
// //   await db.execute(
// //       'CREATE TABLE Test (id INTEGER PRIMARY KEY, name TEXT, value INTEGER, num REAL)');
// // });

// // // Insert some records in a transaction
// // await database.transaction((txn) async {
// //   int id1 = await txn.rawInsert(
// //       'INSERT INTO Test(name, value, num) VALUES("some name", 1234, 456.789)');
// //   print('inserted1: $id1');
// //   int id2 = await txn.rawInsert(
// //       'INSERT INTO Test(name, value, num) VALUES(?, ?, ?)',
// //       ['another name', 12345678, 3.1416]);
// //   print('inserted2: $id2');
// // });

// // // Update some record
// // int count = await database.rawUpdate(
// //     'UPDATE Test SET name = ?, value = ? WHERE name = ?',
// //     ['updated name', '9876', 'some name']);
// // print('updated: $count');

// // // Get the records
// // List<Map> list = await database.rawQuery('SELECT * FROM Test');
// // List<Map> expectedList = [
// //   {'name': 'updated name', 'id': 1, 'value': 9876, 'num': 456.789},
// //   {'name': 'another name', 'id': 2, 'value': 12345678, 'num': 3.1416}
// // ];
// // print(list);
// // print(expectedList);
// // assert(const DeepCollectionEquality().equals(list, expectedList));

// // // Count the records
// // count = Sqflite
// //     .firstIntValue(await database.rawQuery('SELECT COUNT(*) FROM Test'));
// // assert(count == 2);

// // // Delete a record
// // count = await database
// //     .rawDelete('DELETE FROM Test WHERE name = ?', ['another name']);
// // assert(count == 1);

// // // Close the database
// // await database.close();
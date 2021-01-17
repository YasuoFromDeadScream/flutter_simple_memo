import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Article {
  int id;
  final String title;
  final String body;
  final String updateDate;

  Article({this.id, this.title, this.body, this.updateDate});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'updateDate': updateDate,
    };
  }

  @override
  String toString() {
    return 'Article{id: $id}';
  }
}

Future<void> insertArticle(Article article) async {
  debugPrint("insertArticle start");
  final database = openDatabase(
    join(await getDatabasesPath(), 'article_database.db'),
  version: 1,
  );
  // Get a reference to the database.
  final Database db = await database;

  await db.insert(
    'articles',
    article.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
  debugPrint("insertArticle end");
}

Future<void> deleteArticle(int id) async {
  final database = openDatabase(
    join(await getDatabasesPath(), 'article_database.db'),
    version: 1,
  );
  // Get a reference to the database.
  final db = await database;

  // Remove the Dog from the database.
  await db.delete(
    'articles',
    // Use a `where` clause to delete a specific dog.
    where: "id = ?",
    // Pass the Dog's id as a whereArg to prevent SQL injection.
    whereArgs: [id],
  );
}

void createData() async {
  debugPrint("createData start");
  final database = openDatabase(
    join(await getDatabasesPath(), 'article_database.db'),
    onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE articles(id INTEGER PRIMARY KEY, title TEXT, body TEXT, updateDate TEXT)",
      );
    },
    version: 1,
  );

  // Get a reference to the database.
  final Database db = await database;

  debugPrint("createData end");
}

Future<List<Article>> getArticles(String searchStr) async {
  final database = openDatabase(
    join(await getDatabasesPath(), 'article_database.db'),
    onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE articles(id INTEGER PRIMARY KEY, title TEXT, body TEXT, updateDate TEXT)",
      );
    },
    version: 1,
  );

  // Get a reference to the database.
  final Database db = await database;

  List<Map<String, dynamic>> maps;
  // Query the table for all The Dogs.
  if(searchStr != null && searchStr.length > 0){
    maps = await db.query('articles',where: 'title like ? or body like ?',whereArgs: ["%$searchStr%","%$searchStr%"],orderBy: "updateDate DESC");
  }else{
    maps = await db.query('articles',orderBy: "updateDate DESC");
  }

  // Convert the List<Map<String, dynamic> into a List<Dog>.
  return List.generate(maps.length, (i) {
    return Article(
      id: maps[i]['id'],
      title: maps[i]['title'],
      body: maps[i]['body'],
      updateDate: maps[i]['updateDate'],
    );
  });
}

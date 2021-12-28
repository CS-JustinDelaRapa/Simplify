import 'package:intl/intl.dart';
import 'package:simplify/model/grade_tracker/course.dart';
import 'package:simplify/model/grade_tracker/factorContent.dart';
import 'package:simplify/model/grade_tracker/gradeFactor.dart';
import 'package:simplify/model/task.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:simplify/model/diary.dart';
import 'package:simplify/model/gradeTracker.dart';

//push push push
class DatabaseHelper {
  //create an instance of our DatabaseHelper object, meaning gawa tayong brand ng object (DatabaseHelper)
  static final DatabaseHelper instance = new DatabaseHelper();

  //gawa tayong instance ng Database object, para magamit yung mga SQL commands (CRUD)
  static Database? _database;

//check natin kung may laman yung _database
  Future<Database> get database async {
    //if _database is not null, we will return it as not null
    if (_database != null) return _database!;

    //
    _database = await _generatePath('db_simplify!');

    return _database!;
  }

  Future<Database> _generatePath(String dbname) async {
    final dbPath = await getDatabasesPath();

    final fullPath = join(dbPath, dbname);

    return await openDatabase(fullPath, version: 1, onCreate: _createTable);
  }

//**Table */
  Future _createTable(Database query, int version) async {
    await query.execute('''
CREATE TABLE $tableDiary(
  ${TblDiaryField.id} INTEGER PRIMARY KEY AUTOINCREMENT,
  ${TblDiaryField.title} TEXT NOT NULL,
  ${TblDiaryField.description} TEXT NOT NULL,
  ${TblDiaryField.dateCreated} TEXT NOT NUll
  )
''');
    await query.execute('''
CREATE TABLE $tableTask(
  ${TblTaskField.id} INTEGER PRIMARY KEY AUTOINCREMENT,
  ${TblTaskField.title} TEXT NOT NULL,
  ${TblTaskField.description} TEXT NOT NULL,
  ${TblTaskField.dateSched} TEXT NOT NUll,
  ${TblTaskField.isSmartAlert} BOOLEAN NOT NULL,
  ${TblTaskField.isDone} BOOLEAN NOT NULL
  )
''');
    await query.execute('''
CREATE TABLE $tableCourse(
  ${TblCourseField.id} INTEGER PRIMARY KEY AUTOINCREMENT,
  ${TblCourseField.courseName} TEXT NOT NULL,
  ${TblCourseField.courseGrade} REAL NOT NULL
  )
''');
    await query.execute('''
CREATE TABLE $tableGradeFactor(
  ${TblFactorField.id} INTEGER PRIMARY KEY AUTOINCREMENT,
  ${TblFactorField.factorName} TEXT NOT NULL,
  ${TblFactorField.factorPercentage} REAL NOT NULL,
  ${TblFactorField.factorGrade} REAL NOT NULL,
  ${TblFactorField.fkCourse} INTEGER NOT NULL
  )
''');
    await query.execute('''
CREATE TABLE $tableFactorContent(
  ${TblContentField.id} INTEGER PRIMARY KEY AUTOINCREMENT,
  ${TblContentField.contentName} TEXT NOT NULL,
  ${TblContentField.contentScore} REAL NOT NULL,
  ${TblContentField.contentTotal} REAL NOT NULL,
  ${TblContentField.fkContent} INTEGER NOT NULL
  )
''');
  }

//Future class will return a Diary object || (Diary diaryCreate) will make an instance of our Diary object
  Future createDiary(Diary diaryCreate) async {
    final reference = await instance.database;

    //irereturn nito ang Primary key ng table, which is ID
    await reference.insert(tableDiary, diaryCreate.toJson());
  }

//**Diary */

  Future<List<Diary>> readAllDiary() async {
    final reference = await instance.database;

    //SELECT * FROM tbl_diary ORDER BY dateTime
    final fromTable =
        await reference.query(tableDiary, orderBy: '${TblDiaryField.id} DESC');
    return fromTable.map((fromSQL) => Diary.fromJson(fromSQL)).toList();
  }

  Future<Diary> readDiary(int searchKey) async {
    final reference = await instance.database;

    final specificID = await reference.query(
      tableDiary,
      columns: TblDiaryField.diaryFieldNames,
      where: '${TblDiaryField.id} = ?',
      whereArgs: [searchKey],
    );

    if (specificID.isNotEmpty) {
      return Diary.fromJson(specificID.first);
    } else {
      throw Exception('ID $searchKey not found');
    }
  }

  Future<int> updateDiary(Diary diaryInstance) async {
    final reference = await instance.database;

    return reference.update(tableDiary, diaryInstance.toJson(),
        where: '${TblDiaryField.id} = ?', whereArgs: [diaryInstance.id]);
  }

  Future<int> deleteDiary(int searchKey) async {
    final refererence = await instance.database;

    return refererence.delete(tableDiary,
        where: '${TblDiaryField.id} = ?', whereArgs: [searchKey]);
  }

//**Task */
  Future createTask(Task taskCreate) async {
    final reference = await instance.database;
    //irereturn nito ang Primary key ng table, which is ID
    int id = await reference.insert(tableTask, taskCreate.toJson());
    return id;
  }

  Future<List<Task>> readAllTask() async {
    final reference = await instance.database;

    final fromTable = await reference.query(tableTask,
        orderBy: '${TblTaskField.isDone} ASC, ${TblTaskField.dateSched} ASC');

    return fromTable.map((fromSQL) => Task.fromJson(fromSQL)).toList();
  }

  Future<List<Task>> readAllTaskToday() async {
    final DateTime now = new DateTime.now();
    var newToday =
        new DateTime(now.year, now.month, now.day, now.hour, now.minute);
    var newDateTodayMinus23 = new DateTime(
        now.year, now.month, now.day - 1, now.hour, now.minute + 1);
    String date = DateFormat('yyyy-MM-dd').format(now);
    final reference = await instance.database;
    final fromTable = await reference.query(tableTask,
        where:
            'NOT ${TblTaskField.isDone} and ${TblTaskField.dateSched} LIKE ? or NOT ${TblTaskField.isDone} and date_Schedule < ? AND date_Schedule > ?',
        whereArgs: ['%$date%', '$newToday', '$newDateTodayMinus23'],
        orderBy: '${TblTaskField.dateSched} ASC');
    return fromTable.map((fromSQL) => Task.fromJson(fromSQL)).toList();
  }

  Future<List<Task>> readUnfinishedTask() async {
    final DateTime now = new DateTime.now();
    var newDate1 =
        new DateTime(now.year, now.month, now.day, now.hour, now.minute);
    var newDate =
        new DateTime(now.year, now.month, now.day, now.hour - 23, now.minute);
    String date = DateFormat('yyyy-MM-dd').format(now);
    print(newDate.toString() + ' Date Minus 23 hrs');
    final reference = await instance.database;
    final fromTable = await reference.query(tableTask,
        where: 'NOT ${TblTaskField.isDone} and date_Schedule BETWEEN ? AND ?',
        whereArgs: ['1940-01-01 00:00:00.000', '$newDate'],
        orderBy: '${TblTaskField.dateSched} ASC');
    return fromTable.map((fromSQL) => Task.fromJson(fromSQL)).toList();
  }

  Future<Task> readTask(int searchKey) async {
    final reference = await instance.database;
    final specificID = await reference.query(
      tableTask,
      columns: TblTaskField.taskFieldNames,
      where: '${TblTaskField.id} = ?',
      whereArgs: [searchKey],
    );
    if (specificID.isNotEmpty) {
      return Task.fromJson(specificID.first);
    } else {
      throw Exception('ID $searchKey not found');
    }
  }

  Future<int> updateTask(Task taskInstance) async {
    final reference = await instance.database;

    return reference.update(tableTask, taskInstance.toJson(),
        where: '${TblTaskField.id} = ?', whereArgs: [taskInstance.id]);
  }

  Future<int> deleteTask(int searchKey) async {
    final refererence = await instance.database;

    return refererence.delete(tableTask,
        where: '${TblTaskField.id} = ?', whereArgs: [searchKey]);
  }

//Grade Tracker*************
//course**********************
  Future createCourse(Course courseCreate) async {
    final reference = await instance.database;
    //irereturn nito ang Primary key ng table, which is ID
    int id = await reference.insert(tableCourse, courseCreate.toJson());
    return id;
  }

  Future<List<Course>> readAllCourse() async {
    final reference = await instance.database;

    final fromTable = await reference.query(tableCourse,
        orderBy: '${TblCourseField.courseName} ASC');

    return fromTable.map((fromSQL) => Course.fromJson(fromSQL)).toList();
  }

//get all date from tbl_gradeFactors using course ID
  Future<List<Factor>> readCourse(int searchKey) async {
    final reference = await instance.database;
    final specificID = await reference.query(
      tableGradeFactor,
      columns: TblFactorField.factorNames,
      where: '${TblFactorField.fkCourse} = ?',
      whereArgs: [searchKey],
    );
    return specificID.map((fromSQL) => Factor.fromJson(fromSQL)).toList();
  }

  Future<int> updateCourse(Course courseInstance) async {
    final reference = await instance.database;

    return reference.update(tableCourse, courseInstance.toJson(),
        where: '${TblCourseField.id} = ?', whereArgs: [courseInstance.id]);
  }

  Future<int> deleteCourse(int searchKey) async {
    final refererence = await instance.database;

    return refererence.delete(tableCourse,
        where: '${TblCourseField.id} = ?', whereArgs: [searchKey]);
  }

//****************************
//Factor***********************
  Future createFactor(Factor factorCreate) async {
    final reference = await instance.database;
    //irereturn nito ang Primary key ng table, which is ID
    int id = await reference.insert(tableGradeFactor, factorCreate.toJson());
    return id;
  }

  Future<int> updateFactor(Factor factorInstance) async {
    final reference = await instance.database;

    return reference.update(tableGradeFactor, factorInstance.toJson(),
        where: '${TblFactorField.id} = ?', whereArgs: [factorInstance.id]);
  }

  Future<int> deleteFactor(int searchKey) async {
    final refererence = await instance.database;

    return refererence.delete(tableGradeFactor,
        where: '${TblFactorField.id} = ?', whereArgs: [searchKey]);
  }

//get all date from tbl_gradeFactors using course ID
  Future<Content> readFactor(int searchKey) async {
    final reference = await instance.database;
    final specificID = await reference.query(
      tableFactorContent,
      columns: TblContentField.contentNames,
      where: '${TblContentField.fkContent} = ?',
      whereArgs: [searchKey],
    );
    if (specificID.isNotEmpty) {
      return Content.fromJson(specificID.first);
    } else {
      throw Exception('ID $searchKey not found');
    }
  }

//*******************
//factorContent********
  Future createContent(Content contentCreate) async {
    final reference = await instance.database;
    //irereturn nito ang Primary key ng table, which is ID
    int id = await reference.insert(tableFactorContent, contentCreate.toJson());
    return id;
  }

  Future<int> updateContent(Content contentInstance) async {
    final reference = await instance.database;

    return reference.update(tableFactorContent, contentInstance.toJson(),
        where: '${TblContentField.id} = ?', whereArgs: [contentInstance.id]);
  }

  Future<int> deleteContent(int searchKey) async {
    final refererence = await instance.database;

    return refererence.delete(tableFactorContent,
        where: '${TblContentField.id} = ?', whereArgs: [searchKey]);
  }

  Future<Content> readContent(int searchKey) async {
    final reference = await instance.database;
    final specificID = await reference.query(
      tableFactorContent,
      columns: TblContentField.contentNames,
      where: '${TblContentField.id} = ?',
      whereArgs: [searchKey],
    );
    if (specificID.isNotEmpty) {
      return Content.fromJson(specificID.first);
    } else {
      throw Exception('ID $searchKey not found');
    }
  }
//==============================

  Future closeConnection() async {
    final reference = await instance.database;
    reference.close();
  }
}

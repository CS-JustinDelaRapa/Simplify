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

  Future<Task> readPriorityTask() async {
    final reference = await instance.database;
    final specificID = await reference.query(tableTask,
        // columns: TblTaskField.taskFieldNames,
        where: 'NOT ${TblTaskField.isDone}',
        orderBy: '${TblTaskField.dateSched} ASC');
    if (specificID.isNotEmpty) {
      return Task.fromJson(specificID.first);
    } else {
      final Task defaultTask;
      defaultTask = Task(
          dateSched: DateTime.now(),
          isDone: false,
          description: '',
          isSmartAlert: false,
          title: 'Welcome To Simplify!');
      return defaultTask;
    }
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

//**Grade Tracker */
  Future<List<GradeTracker>> readAllGrade() async {
    final reference = await instance.database;

    //SELECT * FROM tbl_diary ORDER BY dateTime
    final fromTable = await reference.query(tblGradeTracker,
        orderBy: '${TblGradeTrackerField.id} DESC');

    return fromTable.map((fromSQL) => GradeTracker.fromJson(fromSQL)).toList();
  }

  Future<List<GradeTracker>> readFolderItem(String searchKey) async {
    final reference = await instance.database;

    final fromTable = await reference.query(
      tblGradeTracker,
      columns: TblGradeTrackerField.gradeTrackerFieldNames,
      where: '${TblGradeTrackerField.folder} = ?',
      whereArgs: [searchKey],
    );

    if (fromTable.isNotEmpty) {
      return fromTable
          .map((fromSQL) => GradeTracker.fromJson(fromSQL))
          .toList();
    } else {
      throw Exception('Folder $searchKey not found');
    }
  }

  Future<List<GradeTracker>> readSubjectItem(
      String folderSearchKey, String subjectSearchKey) async {
    final reference = await instance.database;

    final fromTable = await reference.query(
      tblGradeTracker,
      columns: TblGradeTrackerField.gradeTrackerFieldNames,
      where:
          '${TblGradeTrackerField.folder} = ? and ${TblGradeTrackerField.subject} = ?',
      whereArgs: [folderSearchKey, subjectSearchKey],
    );

    if (fromTable.isNotEmpty) {
      return fromTable
          .map((fromSQL) => GradeTracker.fromJson(fromSQL))
          .toList();
    } else {
      throw Exception('Search keys not found');
    }
  }

  Future<int> updateGradeTracker(GradeTracker gradeTrackerInstance) async {
    final reference = await instance.database;

    return reference.update(tblGradeTracker, gradeTrackerInstance.toJson(),
        where: '${TblGradeTrackerField.id} = ?',
        whereArgs: [gradeTrackerInstance.id]);
  }

  Future<int> deleteGradeTracker(int searchKey) async {
    final refererence = await instance.database;

    return refererence.delete(tblGradeTracker,
        where: '${TblGradeTrackerField.id} = ?', whereArgs: [searchKey]);
  }

  Future closeConnection() async {
    final reference = await instance.database;

    reference.close();
  }
}

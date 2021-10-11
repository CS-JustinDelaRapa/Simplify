final String tableTask = 'tbl_task';

//minimize class for table field names
class TblTaskField {
  static final List<String> taskFieldNames = [
    id,
    title,
    description,
    dateSched,
    isSmartAlert,
    isDone
  ];

  //this are the variables that will hold the column field name of our tblDiary
  static final String id = '_id';
  static final String title = 'diary_title';
  static final String description = 'diary_description';
  static final String dateSched = 'date_Schedule';
  static final String isSmartAlert = 'isSmart';
  static final String isDone = 'isDone';
}

class Task {
  //this are the attributes of our object Diary
  //final meaning when this attributes value are set in a current object instance, it can never be changed.
  final int? id;
  final String title;
  final String description;
  final DateTime dateSched;
  final bool isSmartAlert;
  final bool isDone;
//const will just let a function to just read the value of our Diary class current value (context)
  const Task({
    //initializing our parameter, title = this, this refer's to a current method value.
    this.id,
    required this.isDone,
    required this.isSmartAlert,
    required this.title,
    required this.description,
    required this.dateSched,
  });

  Map<String, Object?> toJson() => {
        //Key: Value, Column Field: Value
        TblTaskField.id: id,
        TblTaskField.title: title,
        TblTaskField.description: description,
        TblTaskField.dateSched: dateSched.toIso8601String(),
        TblTaskField.isSmartAlert: isSmartAlert,
        TblTaskField.isDone: isDone
        //INSERT INTO tbl_Diary('_id',..) Values ('null','Tiltle'..)
      };

  //explain this well, Diary returnID is a constuctor
  Task returnID(
          { //edited here
          int? parameterID,
          String? title,
          String? description,
          DateTime? dateSched,
          bool? isSmartAlert,
          bool? isDone}) =>
      Task(
          //?? = Null-Coalsing Operator, meaning, if ParameterID is null then use the value of this(context) id, else it will return the value of ParameterID
          //if parameterID is null this line 41 will cause then an error because a ?? operator right operand must not be null.
          id: parameterID ?? this.id,
          title: title ?? this.title,
          description: description ?? this.description,
          dateSched: dateSched ?? this.dateSched,
          isSmartAlert: isSmartAlert ?? this.isSmartAlert,
          isDone: isDone ?? this.isDone); //until here

  static Task fromJson(Map<String, Object?> fromSQL) => Task(
      id: fromSQL[TblTaskField.id] as int?,
      title: fromSQL[TblTaskField.title] as String,
      description: fromSQL[TblTaskField.description] as String,
      dateSched: DateTime.parse(fromSQL[TblTaskField.dateSched] as String),
      isSmartAlert: fromSQL[TblTaskField.isSmartAlert] == 1,
      isDone: fromSQL[TblTaskField.isDone] == 1);
}

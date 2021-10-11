final String tableDiary = 'tbl_diary';

//minimize class for table field names
class TblDiaryField {
  static final List<String> diaryFieldNames = [
    id, title, description, dateCreated
  ];

  //this are the variables that will hold the column field name of our tblDiary
  static final String id = '_id';
  static final String title = 'diary_title';
  static final String description = 'diary_description';
  static final String dateCreated = 'date_created';
}

class Diary {
  //this are the attributes of our object Diary
  //final meaning when this attributes value are set in a current object instance, it can never be changed.
  final int? id;
  final String title;
  final String description;
  final DateTime dateCreated; 

//const will just let a function to just read the value of our Diary class current value (context)
  const Diary({
    //initializing our parameter, title = this, this refer's to a current method value.
    this.id,
    required this.title,
    required this.description,
    required this.dateCreated
  });
  


  Map<String, Object?> toJson() => {
    //Key: Value, Column Field: Value    
    TblDiaryField.id: id,
    TblDiaryField.title: title,
    TblDiaryField.description: description,
    TblDiaryField.dateCreated: dateCreated.toIso8601String(),
    //INSERT INTO tbl_Diary('_id',..) Values ('null','Tiltle'..)    
  };

 //explain this well, Diary returnID is a constuctor
  Diary returnID({//edited here
    int? parameterID,
    String? title,
    String? description,
    DateTime? dateCreated,
  })
      => Diary(
        //?? = Null-Coalsing Operator, meaning, if ParameterID is null then use the value of this(context) id, else it will return the value of ParameterID
        //if parameterID is null this line 41 will cause then an error because a ?? operator right operand must not be null.
      id: parameterID ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dateCreated: dateCreated ?? this.dateCreated,
  );//until here

  static Diary fromJson (Map<String, Object?> fromSQL) =>
    Diary(
      id: fromSQL[TblDiaryField.id] as int?,
      title: fromSQL[TblDiaryField.title] as String,
      description: fromSQL[TblDiaryField.description] as String,
      dateCreated: DateTime.parse(fromSQL[TblDiaryField.dateCreated] as String),
    );

}
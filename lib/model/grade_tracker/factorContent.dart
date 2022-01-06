final String tableFactorContent = 'tbl_FactorContent';

//minimize class for table field names
class TblContentField {
  static final List<String> contentNames = [
    id,
    contentName,
    contentScore,
    contentTotal,
    contentDate,
    fkContent
  ];

  //this are the variables that will hold the column field name of our tblDiary
  static final String id = '_id';
  static final String contentName = 'content_name';
  static final String contentScore = 'content_Score';
  static final String contentTotal = 'content_total';
  static final String contentDate = 'content_date';
  static final String fkContent = 'fk_factor';

}

class Content {
  //this are the attributes of our object Diary
  //final meaning when this attributes value are set in a current object instance, it can never be changed.
  final int? id;
  final String contentName;
  final double contentScore;
  final double contentTotal;
  final DateTime contentDate;
  final int fkContent;
//const will just let a function to just read the value of our Diary class current value (context)
  const Content({
    //initializing our parameter, title = this, this refer's to a current method value.
    this.id,
    required this.contentName,
    required this.contentScore,
    required this.contentTotal,
    required this.contentDate,
    required this.fkContent
  });

  Map<String, Object?> toJson() => {
        //Key: Value, Column Field: Value
        TblContentField.id: id,
        TblContentField.contentName: contentName,
        TblContentField.contentScore: contentScore,
        TblContentField.contentTotal: contentTotal,
        TblContentField.contentDate: contentDate.toIso8601String(),
        TblContentField.fkContent: fkContent,
        //INSERT INTO tbl_Diary('_id',..) Values ('null','Tiltle'..)
      };

  //explain this well, Diary returnID is a constuctor
  Content returnID(
          { //edited here
          int? parameterID,
          String? contentName,
          double? contentScore,
          double? contentTotal,
          DateTime? contentDate,
          int? fkContent,
          }) =>
      Content(
          //?? = Null-Coalsing Operator, meaning, if ParameterID is null then use the value of this(context) id, else it will return the value of ParameterID
          //if parameterID is null this line 41 will cause then an error because a ?? operator right operand must not be null.
          id: parameterID ?? this.id,
          contentName: contentName ?? this.contentName,
          contentScore: contentScore ?? this.contentScore,
          contentTotal: contentTotal ?? this.contentTotal,
          contentDate: contentDate ?? this.contentDate,
          fkContent: fkContent ?? this.fkContent
          ); //until here

  static Content fromJson(Map<String, Object?> fromSQL) => Content(
      id: fromSQL[TblContentField.id] as int?,
      contentName: fromSQL[TblContentField.contentName] as String,
      contentScore: fromSQL[TblContentField.contentScore] as double,
      contentTotal: fromSQL[TblContentField.contentTotal] as double,
      contentDate: DateTime.parse(fromSQL[TblContentField.contentDate] as String),
      fkContent: fromSQL[TblContentField.fkContent] as int,
      );
}

final String tableGradeFactor = 'tbl_gradeFactor';

//minimize class for table field names
class TblFactorField {
  static final List<String> factorNames = [
    id,
    factorName,
    factorGrade,
    factorPercentage,
    fkCourse
  ];

  //this are the variables that will hold the column field name of our tblDiary
  static final String id = '_id';
  static final String factorName = 'factor_name';
  static final String factorGrade = 'factor_Grade';
  static final String factorPercentage = 'factor_percentage';
  static final String fkCourse = 'fk_course';
}

class Factor {
  //this are the attributes of our object Diary
  //final meaning when this attributes value are set in a current object instance, it can never be changed.
  final int? id;
  final String factorName;
  double factorGrade;
  final double factorPercentage;
  final int fkCourse;
//const will just let a function to just read the value of our Diary class current value (context)
  Factor(
      {
      //initializing our parameter, title = this, this refer's to a current method value.
      this.id,
      required this.factorName,
      required this.factorGrade,
      required this.factorPercentage,
      required this.fkCourse});

  Map<String, Object?> toJson() => {
        //Key: Value, Column Field: Value
        TblFactorField.id: id,
        TblFactorField.factorName: factorName,
        TblFactorField.factorPercentage: factorPercentage,
        TblFactorField.factorGrade: factorGrade,
        TblFactorField.fkCourse: fkCourse,
        //INSERT INTO tbl_Diary('_id',..) Values ('null','Tiltle'..)
      };

  //explain this well, Diary returnID is a constuctor
  Factor returnID({
    //edited here
    int? parameterID,
    String? factorName,
    double? factorGrade,
    double? factorPercentage,
    int? fkCourse,
  }) =>
      Factor(
          //?? = Null-Coalsing Operator, meaning, if ParameterID is null then use the value of this(context) id, else it will return the value of ParameterID
          //if parameterID is null this line 41 will cause then an error because a ?? operator right operand must not be null.
          id: parameterID ?? this.id,
          factorName: factorName ?? this.factorName,
          factorGrade: factorGrade ?? this.factorGrade,
          factorPercentage: factorPercentage ?? this.factorPercentage,
          fkCourse: fkCourse ?? this.fkCourse); //until here

  static Factor fromJson(Map<String, Object?> fromSQL) => Factor(
        id: fromSQL[TblFactorField.id] as int?,
        factorName: fromSQL[TblFactorField.factorName] as String,
        factorGrade: fromSQL[TblFactorField.factorGrade] as double,
        factorPercentage: fromSQL[TblFactorField.factorPercentage] as double,
        fkCourse: fromSQL[TblFactorField.fkCourse] as int,
      );
}

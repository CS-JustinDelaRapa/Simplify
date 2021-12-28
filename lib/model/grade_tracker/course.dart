import 'dart:ui';

final String tableCourse = 'tbl_course';

//minimize class for table field names
class TblCourseField {
  static final List<String> courseNames = [
    id,
    courseName,
    courseGrade,
    // courseColor
  ];

  //this are the variables that will hold the column field name of our tblDiary
  static final String id = '_id';
  static final String courseName = 'course_name';
  static final String courseGrade = 'course_grade';
  // static final String courseColor = 'course_color';
}

class Course {
  //this are the attributes of our object Diary
  //final meaning when this attributes value are set in a current object instance, it can never be changed.
  final int? id;
  final String courseName;
  final double courseGrade;
  // final Color courseColor;
//const will just let a function to just read the value of our Diary class current value (context)
  const Course({
    //initializing our parameter, title = this, this refer's to a current method value.
    this.id,
    required this.courseName,
    required this.courseGrade,
    // required this.courseColor
  });

  Map<String, Object?> toJson() => {
        //Key: Value, Column Field: Value
        TblCourseField.id: id,
        TblCourseField.courseName: courseName,
        TblCourseField.courseGrade: courseGrade,
        // TblCourseField.courseColor: courseColor,
        //INSERT INTO tbl_Diary('_id',..) Values ('null','Tiltle'..)
      };

  //explain this well, Diary returnID is a constuctor
  Course returnID(
          { //edited here
          int? parameterID,
          String? courseName,
          double? courseGrade,
          Color? courseColor}) =>
      Course(
        //?? = Null-Coalsing Operator, meaning, if ParameterID is null then use the value of this(context) id, else it will return the value of ParameterID
        //if parameterID is null this line 41 will cause then an error because a ?? operator right operand must not be null.
        id: parameterID ?? this.id,
        courseName: courseName ?? this.courseName,
        courseGrade: courseGrade ?? this.courseGrade,
        // courseColor: courseColor ?? this.courseColor,
      ); //until here

  static Course fromJson(Map<String, Object?> fromSQL) => Course(
        id: fromSQL[TblCourseField.id] as int?,
        courseName: fromSQL[TblCourseField.courseName] as String,
        courseGrade: fromSQL[TblCourseField.courseGrade] as double,
        // courseColor: fromSQL[TblCourseField.courseColor] as Color,
      );
}

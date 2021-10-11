final String tblGradeTracker = 'tbl_gradeTracker';

class TblGradeTrackerField {
  static final List<String> gradeTrackerFieldNames = [
    id, folder, subject, subjectGrade, quizGrade, quizTotalScore, quizTotalItem, quizPercentage,
    activityGrade, activityTotalScore, activityTotalItem, activityPercentage,
    examGrade, examTotalScore, examTotalItem, examPercentage,
    attendanceGrade, attendanceTotalScore, attendanceTotalMeeting, attendancePercentage,
  ];


  static final String id = '_id';
  static final String folder = 'folderName';
  static final String subject = 'subjectName';
  static final String subjectGrade = 'subjectGrade';

  static final String quizGrade = 'quizGrade'; 
  static final String quizTotalScore = 'quizTotalScore';
  static final String quizTotalItem = 'quizTotalItem';
  static final String quizPercentage = 'quizPercentage';

  static final String activityGrade = 'activityGrade';
  static final String activityTotalScore = 'activityTotalScore';
  static final String activityTotalItem = 'activityTotalItem';
  static final String activityPercentage = 'activityPercentage';

  static final String examGrade = 'examGrade';
  static final String examTotalScore = 'examTotalScore';
  static final String examTotalItem = 'examTotalItem';
  static final String examPercentage = 'examPercentage';

  static final String attendanceGrade = 'attendanceGrade';
  static final String attendanceTotalScore = 'examTotalScore';
  static final String attendanceTotalMeeting = 'examTotalItem';
  static final String attendancePercentage = 'examPercentage';
}

class GradeTracker {
  final int? id;
  final String folder;
  final String subject;
  final double subjectGrade;

  final double quizGrade; 
  final double quizTotalScore;
  final double quizTotalItem;
  final double quizPercentage;
  
  final double activityGrade;
  final double activityTotalScore;
  final double activityTotalItem;
  final double activityPercentage;
  
  final double examGrade;
  final double examTotalScore;
  final double examTotalItem;
  final double examPercentage;
  
  final double attendanceGrade;
  final double attendanceTotalScore;
  final double attendanceTotalMeeting;
  final double attendancePercentage;
//constructor
 const GradeTracker({
   this.id,
   required this.folder,
   required this.subject,
   required this.subjectGrade,
   required this.quizGrade,
   required this.quizTotalItem,
   required this.quizTotalScore,
   required this.quizPercentage,
   required this.activityGrade,
   required this.activityTotalScore,
   required this.activityTotalItem,
   required this.activityPercentage,
   required this.examGrade,
   required this.examTotalScore,
   required this.examTotalItem,
   required this.examPercentage,
   required this.attendanceGrade,
   required this.attendanceTotalScore,
   required this.attendanceTotalMeeting,
   required this.attendancePercentage,
 });
  

  //Map key and value for table
  Map<String, Object?> toJson() =>{
    TblGradeTrackerField.id: id,
    TblGradeTrackerField.subject: subject,
    TblGradeTrackerField.subjectGrade: subjectGrade,
    
    TblGradeTrackerField.quizGrade: quizGrade,
    TblGradeTrackerField.quizTotalScore: quizTotalScore,
    TblGradeTrackerField.quizTotalItem: quizTotalItem,
    TblGradeTrackerField.quizPercentage: quizPercentage,
    
    TblGradeTrackerField.activityGrade: activityGrade,
    TblGradeTrackerField.activityTotalScore: activityTotalScore,
    TblGradeTrackerField.activityTotalItem: activityTotalItem,
    TblGradeTrackerField.activityPercentage: activityPercentage,

    TblGradeTrackerField.examGrade: examGrade,
    TblGradeTrackerField.examTotalScore: examTotalScore,
    TblGradeTrackerField.examTotalItem: examTotalItem,
    TblGradeTrackerField.examPercentage: examPercentage,

    TblGradeTrackerField.attendanceGrade: attendanceGrade,
    TblGradeTrackerField.attendanceTotalScore: attendanceTotalScore,
    TblGradeTrackerField.attendanceTotalMeeting: attendanceTotalMeeting,
    TblGradeTrackerField.attendancePercentage: attendancePercentage,
  };

  
    GradeTracker returnID({
     int? id,
     String? folder,
     String? subject,
     double? subjectGrade,
     
     double? quizGrade,
     double? quizTotalScore,
     double? quizTotalItem,
     double? quizPercentage,
     
     double? activityGrade,
     double? activityTotalScore,
     double? activityTotalItem,
     double? activityPercentage,
     
     double? examGrade,
     double? examTotalScore,
     double? examTotalItem,
     double? examPercentage,

     double? attendanceGrade,
     double? attendanceTotalScore,
     double? attendanceTotalMeeting,
     double? attendancePercentage,
  })
      => GradeTracker(
        id: id ?? this.id,
        folder: folder ?? this.folder,
        subject: subject ?? this.subject,
        subjectGrade: subjectGrade ?? this.subjectGrade,

        quizGrade: quizGrade ?? this.quizGrade,
        quizTotalScore: quizTotalScore ?? this.quizTotalScore,
        quizTotalItem: quizTotalItem ?? this.quizTotalItem,
        quizPercentage: quizPercentage ?? this.quizPercentage,

        activityGrade: activityGrade ?? this.activityGrade,
        activityTotalScore: activityTotalScore ?? this.activityTotalScore,
        activityTotalItem: activityTotalItem ?? this.activityTotalItem,
        activityPercentage: activityPercentage ?? this.activityPercentage,

        examGrade: activityGrade ?? this.activityGrade,
        examTotalScore: examTotalScore ?? this.examTotalScore,
        examTotalItem: examTotalItem ?? this.examTotalItem,
        examPercentage: examPercentage ?? this.examPercentage,

        attendanceGrade: attendanceGrade ?? this.attendanceGrade,
        attendanceTotalScore: attendanceTotalScore ?? this.attendanceTotalScore,
        attendanceTotalMeeting: attendanceTotalMeeting ?? this.attendanceTotalMeeting,
        attendancePercentage: attendancePercentage ?? this.attendancePercentage,
  );

  static GradeTracker fromJson (Map<String, Object?> fromSQL) =>
    GradeTracker(
      id: fromSQL[TblGradeTrackerField.id] as int,
      folder: fromSQL[TblGradeTrackerField.folder] as String,
      subject: fromSQL[TblGradeTrackerField.subject] as String,
      subjectGrade: fromSQL[TblGradeTrackerField.subjectGrade] as double,

      quizGrade: fromSQL[TblGradeTrackerField.quizGrade] as double,
      quizTotalScore: fromSQL[TblGradeTrackerField.quizTotalScore] as double,
      quizTotalItem: fromSQL[TblGradeTrackerField.quizTotalItem] as double,
      quizPercentage: fromSQL[TblGradeTrackerField.quizPercentage] as double,

      activityGrade: fromSQL[TblGradeTrackerField.activityGrade] as double,
      activityTotalScore: fromSQL[TblGradeTrackerField.activityTotalScore] as double,
      activityTotalItem: fromSQL[TblGradeTrackerField.activityTotalItem] as double,
      activityPercentage: fromSQL[TblGradeTrackerField.activityPercentage] as double,

      examGrade: fromSQL[TblGradeTrackerField.activityGrade] as double,
      examTotalScore: fromSQL[TblGradeTrackerField.activityTotalScore] as double,
      examTotalItem: fromSQL[TblGradeTrackerField.activityTotalItem] as double,
      examPercentage: fromSQL[TblGradeTrackerField.activityPercentage] as double,      
    
      attendanceGrade: fromSQL[TblGradeTrackerField.attendanceGrade] as double,
      attendanceTotalScore: fromSQL[TblGradeTrackerField.attendanceTotalScore] as double,
      attendanceTotalMeeting: fromSQL[TblGradeTrackerField.attendanceTotalMeeting] as double,
      attendancePercentage: fromSQL[TblGradeTrackerField.attendancePercentage] as double,    
    );
}


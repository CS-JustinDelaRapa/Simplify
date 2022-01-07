import 'gradeFactor.dart';

class Item extends Factor {
  bool isExpanded;

  Item(
      {required this.isExpanded,
      required id,
      required factorName,
      required factorGrade,
      required factorPercentage,
      required fkCourse})
      : super(
            id: id,
            factorName: factorName,
            factorPercentage: factorPercentage,
            factorGrade: factorGrade,
            fkCourse: fkCourse);
}
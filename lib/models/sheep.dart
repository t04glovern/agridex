import 'package:meta/meta.dart';

class Sheep {
  final String documentId;
  final String eid;
  final String sex;
  final int birth;
  final int visualNum;
  final List<Object> fleece;
  final List<Object> pregnancies;
  final List<Object> weights;

  Sheep({
    @required this.documentId,
    @required this.eid,
    @required this.sex,
    @required this.birth,
    @required this.visualNum,
    @required this.fleece,
    @required this.pregnancies,
    @required this.weights,
  });
}

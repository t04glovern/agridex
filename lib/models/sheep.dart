import 'package:meta/meta.dart';

class Sheep {
  final String documentId;
  final String eid;
  final String sex;
  final String avatarUrl;
  final int birth;
  final int visualNum;
  final List<Object> fleece;
  final List<Object> pregnancies;
  final List<Object> weights;

  Sheep({
    @required this.documentId,
    @required this.eid,
    @required this.sex,
    this.avatarUrl = 'https://stockhead.com.au/wp-content/uploads/2017/09/Getty-sheep.jpg',
    @required this.birth,
    @required this.visualNum,
    @required this.fleece,
    @required this.pregnancies,
    @required this.weights,
  });
}

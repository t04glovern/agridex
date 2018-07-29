import 'package:meta/meta.dart';

class Sheep {
  final String documentId;
  final String eid;
  final String tag;
  final String origin;
  final String sex;
  final String avatarUrl;
  final int birth;
  final bool postBreeder;
  final int visualNum;
  final int visualId;
  final List<Object> conditions;
  final List<Object> fleece;
  final List<Object> pregnancies;
  final List<Object> weights;

  Sheep({
    @required this.documentId,
    @required this.eid,
    @required this.tag,
    @required this.origin,
    @required this.sex,
    this.avatarUrl =
        'https://stockhead.com.au/wp-content/uploads/2017/09/Getty-sheep.jpg',
    @required this.birth,
    @required this.postBreeder,
    @required this.visualNum,
    @required this.visualId,
    @required this.conditions,
    @required this.fleece,
    @required this.pregnancies,
    @required this.weights,
  });
}

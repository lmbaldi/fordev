import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class SurveyAnswerEntity extends Equatable{

  final String image;
  final String answer;
  final bool isCurrentAccountAnswer;
  final int percent;

  List get props => [image, answer, isCurrentAccountAnswer, percent];

  SurveyAnswerEntity({
    this.image,
    @required this.answer,
    @required this.isCurrentAccountAnswer,
    @required this.percent,
  });

}

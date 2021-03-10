import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class SurveyAnswerViewModel extends Equatable {

  final String image;
  final String answer;
  final bool isCurrentAccountAnswer;
  final String percent;

  List get props => [image, answer, isCurrentAccountAnswer, percent];

  SurveyAnswerViewModel({
    this.image,
    @required this.answer,
    @required this.isCurrentAccountAnswer,
    @required this.percent,
  });
}

import 'package:meta/meta.dart';

class SurveyAnswerViewModel {
  final String image;
  final String answer;
  final bool isCurrentAccountAnswer;
  final String percent;

  SurveyAnswerViewModel({
    this.image,
    @required this.answer,
    @required this.isCurrentAccountAnswer,
    @required this.percent,
  });
}

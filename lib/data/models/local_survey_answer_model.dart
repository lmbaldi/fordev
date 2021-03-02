import 'package:fordev/domain/entities/entities.dart';
import 'package:meta/meta.dart';

class LocalSurveyAnswerModel {
  final String image;
  final String answer;
  final bool isCurrentAccountAnswer;
  final int percent;

  LocalSurveyAnswerModel({
    this.image,
    @required this.answer,
    @required this.isCurrentAccountAnswer,
    @required this.percent,
  });

  factory LocalSurveyAnswerModel.fromJson(Map json) {
    if (!json.keys.toSet().containsAll(['answer', 'isCurrentAccountAnswer', 'percent'])) {
      throw Exception();
    }
    return LocalSurveyAnswerModel(
      image: json['image'],
      answer: json['answer'],
      isCurrentAccountAnswer: bool.fromEnvironment(json['isCurrentAccountAnswer']), //conveter string para booleano
      percent: int.parse(json['percent'])
    );
  }

  SurveyAnswerEntity toEntity() => SurveyAnswerEntity(
    image: image,
    answer: answer,
    isCurrentAccountAnswer: isCurrentAccountAnswer,
    percent: percent
  );

}

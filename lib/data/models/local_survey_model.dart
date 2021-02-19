import 'package:meta/meta.dart';
import '../../domain/entities/entities.dart';

class LocalSurveyModel{
  final String id;
  final String question;
  final DateTime date;
  final bool didAnswer;

  LocalSurveyModel({
    @required this.id,
    @required this.question,
    @required this.date,
    @required this.didAnswer,
  });

  factory LocalSurveyModel.fromJson(Map json) {
    return LocalSurveyModel(
      id: json['id'],
      question: json['question'],
      date: DateTime.parse(json['date']) ,//conveter string para data
      didAnswer: bool.fromEnvironment(json['didAnswer']) ,//conveter string para booleano
    );
  }

  SurveyEntity toEntity() => SurveyEntity(
    id: id,
    question: question,
    dateTime: date,
    didAnswer: didAnswer,
  );
}

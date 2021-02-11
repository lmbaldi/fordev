import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class SurveyEntity  extends Equatable{

  List get props => ['id', 'question', 'dateTime', 'didAnswer'];

  final String id;
  final String question;
  final DateTime dateTime;
  final bool didAnswer;

  SurveyEntity({
    @required this.id,
    @required this.question,
    @required this.dateTime,
    @required this.didAnswer,
  });

}

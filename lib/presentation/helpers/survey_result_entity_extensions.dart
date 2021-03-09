import '../../ui/pages/pages.dart';
import '../../domain/entities/entities.dart';

extension SurveyResultEntityExtensions on SurveyResultEntity {
  SurveyResultViewModel toViewModel() => SurveyResultViewModel(
      surveyId: surveyId,
      question: question,
      answers: answers.map((answer) => answer.toViewModel()).toList());
}

extension SurveyAnswerEntityExtensions on SurveyAnswerEntity {
  SurveyAnswerViewModel toViewModel() => SurveyAnswerViewModel(
      image: image,
      answer: answer,
      percent: '$percent%',
      isCurrentAccountAnswer: isCurrentAccountAnswer);
}

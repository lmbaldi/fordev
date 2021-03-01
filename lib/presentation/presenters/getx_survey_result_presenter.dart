import 'package:meta/meta.dart';
import 'package:get/get.dart';

import '../../ui/pages/pages.dart';
import '../../ui/helpers/helpers.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../mixins/mixins.dart';

class GetxSurveyResultPresenter extends GetxController
    with LoadingManager, SessionManager  implements SurveyResultPresenter {
  final LoadSurveyResult loadSurveyResult;
  final String surveyId;

  GetxSurveyResultPresenter({
    @required this.loadSurveyResult,
    @required this.surveyId
  });

  final _surveyResult = Rx<SurveyResultViewModel>();

  Stream<SurveyResultViewModel> get surveyResultStream => _surveyResult.stream;

  Future<void> loadData() async {
    try {
      isLoading = true;
      final surveyResult = await loadSurveyResult.loadBySurvey(surveyId: surveyId);
      _surveyResult.value = SurveyResultViewModel(
        surveyId: surveyResult.surveyId,
        question: surveyResult.question,
        answers: surveyResult.answers.map((answer) => SurveyAnswerViewModel(
          image: answer.image,
          answer: answer.answer,
          percent: '${answer.percent}%',
          isCurrentAccountAnswer: answer.isCurrentAccountAnswer
        )).toList()
      );

    } on DomainError catch(error) {
      if(error == DomainError.accessDenied) {
        isSessionExpired = true;
      }else{
        _surveyResult.subject.addError(UIError.unexpected.description);
      }
    } finally {
      isLoading = false;
    }
  }
}
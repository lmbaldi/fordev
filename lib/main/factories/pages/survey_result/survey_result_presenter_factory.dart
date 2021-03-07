import '../../factories.dart';
import '../../../../ui/pages/pages.dart';
import '../../../../presentation/presenters/presenters.dart';

SurveyResultPresenter makeGetxSurveyResultPresenter(String surveyId) {
  return GetxSurveyResultPresenter(
    loadSurveyResult: makeRemoteLoadSurveyResultWithLocalFallback(surveyId),
    surveyId: surveyId
  );
}


import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:get/get.dart';

import '../../ui/pages/pages.dart';
import '../../ui/helpers/helpers.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../mixins/mixins.dart';

class GetxSurveysPresenter extends GetxController
    with SessionManager, LoadingManager, NavigationManager implements SurveysPresenter {

  final LoadSurveys loadSurveys;

  GetxSurveysPresenter({@required this.loadSurveys});

  final _surveys = Rx<List<SurveyViewModel>>();

  Stream<List<SurveyViewModel>> get surveysStream => _surveys.stream;

  Future<void> loadData() async {
    try {
      isLoading = true;
      final surveys = await loadSurveys.load();
      _surveys.value = surveys
          .map((survey) => SurveyViewModel(
              id: survey.id,
              question: survey.question,
              date: DateFormat('dd MMM yyyy').format(survey.dateTime),
              didAnswer: survey.didAnswer))
          .toList();
    } on DomainError catch (error) {
      if (error == DomainError.accessDenied) {
        isSessionExpired = true;
      } else {
        _surveys.subject.addError(UIError.unexpected.description);
      }
    } finally {
      isLoading = false;
    }
  }

  void goToSurveyResult(String surveyId) {
    navigateTo = '/survey_result/${surveyId}';
  }
}

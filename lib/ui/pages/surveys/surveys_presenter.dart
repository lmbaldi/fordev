import 'survey_view_model.dart';

abstract class SurveysPresenter{

  Future<void> loadData();
  Stream<bool> get isLoadingStream;
  Stream<List<SurveyViewModel>> get  surveysStream;

}
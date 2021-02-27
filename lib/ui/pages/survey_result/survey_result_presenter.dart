import '../pages.dart';

abstract class SurveyResultPresenter{
  Future<void> loadData();
  Stream<bool> get isLoadingStream;
  Stream<SurveyResultViewModel> get  surveyResultStream;
}
import '../pages.dart';

abstract class SurveyResultPresenter{
  Future<void> loadData();
  Stream<bool> get isLoadingStream;
  Stream<bool> get isSessionExpiredStream;
  Stream<SurveyResultViewModel> get  surveyResultStream;
}
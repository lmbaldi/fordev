import 'package:meta/meta.dart';
import '../pages.dart';

abstract class SurveyResultPresenter{
  Future<void> loadData();
  Future<void> save({@required String answer});
  Stream<bool> get isLoadingStream;
  Stream<bool> get isSessionExpiredStream;
  Stream<SurveyResultViewModel> get  surveyResultStream;
}
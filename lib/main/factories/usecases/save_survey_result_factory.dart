
import '../../../data/usescases/usecases.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../main/factories/factories.dart';

SaveSurveyResult makeRemoteSaveSurveyResult(String surveyId) {
  return RemoteSaveSurveyResult(
      httpClient: makeAuthorizeHttpClientDecorator(),
      url: makeApiUrl('surveys/$surveyId/results'));
}





import '../../../data/usescases/usecases.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../main/factories/factories.dart';

LoadSurveyResult makeRemoteLoadSurveyResult(String surveyId) {
  return RemoteLoadSurveyResult(
      httpClient: makeAuthorizeHttpClientDecorator(),
      url: makeApiUrl('surveys/$surveyId/results'));
}


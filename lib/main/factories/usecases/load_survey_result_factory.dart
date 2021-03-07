
import '../../../data/usescases/usecases.dart';
import '../../../domain/usecases/usecases.dart';
import '../../composites/composites.dart';
import '../../../main/factories/factories.dart';

LoadSurveyResult makeRemoteLoadSurveyResult(String surveyId) {
  return RemoteLoadSurveyResult(
      httpClient: makeAuthorizeHttpClientDecorator(),
      url: makeApiUrl('surveys/$surveyId/results'));
}

LoadSurveyResult makeLocalLoadSurveyResult(String surveyId) {
  return LocalLoadSurveyResult(cacheStorage: makeLocalStorageAdapter());
}

LoadSurveyResult makeRemoteLoadSurveyResultWithLocalFallback(String surveyId) {
  return RemoteLoadSurveysResultWithLocalFallback(
      remote: makeRemoteLoadSurveyResult(surveyId),
      local: makeLocalLoadSurveyResult(surveyId)
  );
}


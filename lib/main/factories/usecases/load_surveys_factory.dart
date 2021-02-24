import '../../../data/usescases/usecases.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../main/composites/composites.dart';
import '../../../main/factories/factories.dart';

LoadSurveys makeRemoteLoadSurveys() {
  return RemoteLoadSurveys(
      httpClient: makeAuthorizeHttpClientDecorator(),
      url: makeApiUrl('surveys'));
}

LoadSurveys makeLocalLoadSurveys() {
  return LocalLoadSurveys(cacheStorage: makeLocalStorageAdapter());
}

LoadSurveys makeRemoteLocalLoadSurveysWithFallback() {
  return RemoteLoadSurveysWithLocalFallback(
      remote: makeRemoteLoadSurveys(), local: makeLocalLoadSurveys());
}

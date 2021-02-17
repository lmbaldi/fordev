import 'package:fordev/data/usescases/usecases.dart';
import 'package:fordev/domain/usecases/usecases.dart';
import 'package:fordev/main/factories/http/http.dart';

LoadSurveys makeRemoteLoadSurveys() {
  return  RemoteLoadSurveys(
      httpClient: makeHttpAdapter(),
      url: makeApiUrl('surveys')
  );
}

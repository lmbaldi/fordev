
import 'package:test/test.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:fordev/data/usescases/usecases.dart';

class RemoteLoadSurveysWithLocalFallback {

  final RemoteLoadSurveys remote;

  RemoteLoadSurveysWithLocalFallback({@required this.remote});

  Future<void> load() async {
    await remote.load();
  }
  
}

class RemoteLoadSurveysSpy  extends Mock implements RemoteLoadSurveys{}

void main () {

  RemoteLoadSurveysSpy remote;
  RemoteLoadSurveysWithLocalFallback sut;

  setUp((){
    remote = RemoteLoadSurveysSpy();
    sut = RemoteLoadSurveysWithLocalFallback( remote: remote);
  });
  
  test('Should call remote load', () async {
    await sut.load();
    verify(remote.load()).called(1);
  });
}


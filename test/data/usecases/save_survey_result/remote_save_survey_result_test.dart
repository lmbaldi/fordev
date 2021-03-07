import 'package:test/test.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:fordev/data/http/http.dart';
import 'package:fordev/data/usescases/usecases.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  RemoteSaveSurveyResult sut;
  HttpClientSpy httpClient;
  String url;
  String answer;

  setUp(() {
    answer = faker.lorem.sentence();
    url = faker.internet.httpsUrl();
    httpClient = HttpClientSpy();
    sut = RemoteSaveSurveyResult(url: url, httpClient: httpClient);
  });

  //testar a integracao com http client
  test('should call HttpClient with correct values', () async {
    await sut.save(answer: answer);
    verify(httpClient.request(url: url, method: 'PUT', body: {'answer': answer}));
  });

}

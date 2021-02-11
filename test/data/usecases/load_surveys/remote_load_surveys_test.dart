import 'package:test/test.dart';
import 'package:faker/faker.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:fordev/data/http/http.dart';
import 'package:fordev/data/models/models.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/domain/entities/entities.dart';

class RemoteLoadSurveys {
  final String url;
  final HttpClient<List<Map>> httpClient;

  RemoteLoadSurveys({@required this.url, @required this.httpClient});

  Future<List<SurveyEntity>> load() async {

    try{
      final httpResponse = await httpClient.request(url: url, method: 'GET');
      return httpResponse
          .map((json) => RemoteSurveyModel.fromJson(json).toEntity())
          .toList();
    } on HttpError catch(error){
      throw error == HttpError.forbidden
          ? DomainError.accessDenied
          : DomainError.unexpected;
    }
  }
}

class HttpClientSpy extends Mock implements HttpClient<List<Map>> {}

void main() {
  RemoteLoadSurveys sut;
  HttpClientSpy httpClient;
  String url;
  List<Map> list;

  List<Map> mockValidData() => [
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(50),
          'didAnswer': faker.randomGenerator.boolean(),
          'date': faker.date.dateTime().toIso8601String()
        },
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(50),
          'didAnswer': faker.randomGenerator.boolean(),
          'date': faker.date.dateTime().toIso8601String()
        },
      ];

  PostExpectation mockRequest() => when(
      httpClient.request(url: anyNamed('url'), method: anyNamed('method')));

  void mockHttpData(List<Map> data) {
    list = data;
    mockRequest().thenAnswer((_) async => data);
  }

  void mockHttpError(HttpError error) {
    mockRequest().thenThrow(error);
  }

  setUp(() {
    url = faker.internet.httpsUrl();
    httpClient = HttpClientSpy();
    sut = RemoteLoadSurveys(url: url, httpClient: httpClient);
    mockHttpData(mockValidData());
  });

  //testar a integracao com http client
  test('should call HttpClient with correct values', () async {
    await sut.load();
    verify(httpClient.request(url: url, method: 'GET'));
  });

  test('should return surveys on 200', () async {
    final surveys = await sut.load();
    expect(surveys, [
      SurveyEntity(
        id: list[0]['id'],
        question: list[0]['question'],
        dateTime: DateTime.parse(list[0]['date']),
        didAnswer: list[0]['didAnswer'],
      ),
      SurveyEntity(
        id: list[1]['id'],
        question: list[1]['question'],
        dateTime: DateTime.parse(list[1]['date']),
        didAnswer: list[1]['didAnswer'],
      ),
    ]);
  });

  test('should return surveys on 200', () async {
    final surveys = await sut.load();
    expect(surveys, [
      SurveyEntity(
        id: list[0]['id'],
        question: list[0]['question'],
        dateTime: DateTime.parse(list[0]['date']),
        didAnswer: list[0]['didAnswer'],
      ),
      SurveyEntity(
        id: list[1]['id'],
        question: list[1]['question'],
        dateTime: DateTime.parse(list[1]['date']),
        didAnswer: list[1]['didAnswer'],
      ),
    ]);
  });

  test('should throw UnexpectedError if HttpClient returns 200 with invalid data', () async {
    mockHttpData([{'invalid_key': 'invalid_value'}]);
    final future  =  sut.load();
    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw AccessDeniedError if HttpClient returns 403', () async {
    mockHttpError(HttpError.forbidden);
    final future = sut.load();
    expect(future, throwsA(DomainError.accessDenied));
  });

  test('Should throw unexpectedError if HttpClient returns 404', () async {
    mockHttpError(HttpError.notFound);
    final future = sut.load();
    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw unexpectedError if HttpClient returns 500', () async {
    mockHttpError(HttpError.serverError);
    final future = sut.load();
    expect(future, throwsA(DomainError.unexpected));
  });
}
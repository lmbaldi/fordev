import 'package:test/test.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:fordev/data/http/http.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/data/usescases/usecases.dart';
import 'package:fordev/domain/entities/entities.dart';

import '../../../mocks/mocks.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  RemoteSaveSurveyResult sut;
  HttpClientSpy httpClient;
  String url;
  String answer;
  Map surveyResult;

 PostExpectation mockRequest() => when(
      httpClient.request(
        url: anyNamed('url'),
        method: anyNamed('method'),
        body: anyNamed('body')
      ));

  void mockHttpData(Map data) {
    surveyResult = data;
    mockRequest().thenAnswer((_) async => data);
  }

  void mockHttpError(HttpError error) {
    mockRequest().thenThrow(error);
  }

  setUp(() {
    answer = faker.lorem.sentence();
    url = faker.internet.httpsUrl();
    httpClient = HttpClientSpy();
    sut = RemoteSaveSurveyResult(url: url, httpClient: httpClient);
    mockHttpData(FakeSurveyResultFactory.makeApiJson());
  });

  //testar a integracao com http client
  test('should call HttpClient with correct values', () async {
    await sut.save(answer: answer);
    verify(httpClient.request(url: url, method: 'PUT', body: {'answer': answer}));
  });

  test('should return surveyResult on 200', () async {
    final result = await sut.save(answer: answer);
    expect(
        result,
        SurveyResultEntity(
          surveyId: surveyResult['surveyId'],
          question: surveyResult['question'],
          answers: [
            SurveyAnswerEntity(
              image: surveyResult['answers'][0]['image'],
              answer: surveyResult['answers'][0]['answer'],
              isCurrentAccountAnswer: surveyResult['answers'][0]['isCurrentAccountAnswer'],
              percent: surveyResult['answers'][0]['percent'],
            ),
            SurveyAnswerEntity(
              answer: surveyResult['answers'][1]['answer'],
              isCurrentAccountAnswer: surveyResult['answers'][1]['isCurrentAccountAnswer'],
              percent: surveyResult['answers'][1]['percent'],
            )
          ],
        ));
  });

  test('should throw UnexpectedError if HttpClient returns 200 with invalid data',
      () async {
    mockHttpData(FakeSurveyResultFactory.makeInvalidApiJson());
    final future = sut.save(answer: answer);
    expect(future, throwsA(DomainError.unexpected));
  });


  test('Should throw AccessDeniedError if HttpClient returns 403', () async {
    mockHttpError(HttpError.forbidden);
    final future = sut.save(answer: answer);
    expect(future, throwsA(DomainError.accessDenied));
  });

  test('Should throw unexpectedError if HttpClient returns 404', () async {
    mockHttpError(HttpError.notFound);
    final future = sut.save(answer: answer);
    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw unexpectedError if HttpClient returns 500', () async {
    mockHttpError(HttpError.serverError);
    final future = sut.save(answer: answer);
    expect(future, throwsA(DomainError.unexpected));
  });

}

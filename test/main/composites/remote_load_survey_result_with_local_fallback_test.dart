import 'package:test/test.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:fordev/main/composites/composites.dart';
import 'package:fordev/data/usescases/usecases.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/domain/entities/entities.dart';

import '../../mocks/mocks.dart';

class RemoteLoadSurveyResultSpy extends Mock implements RemoteLoadSurveyResult {}
class LocalLoadSurveyResultSpy extends Mock implements LocalLoadSurveyResult {}

void main() {
  RemoteLoadSurveyResultWithLocalFallback sut;
  RemoteLoadSurveyResultSpy remote;
  LocalLoadSurveyResultSpy local;
  String surveyId;
  SurveyResultEntity remoteSurveyResult;
  SurveyResultEntity localSurveyResult;

  PostExpectation mockRemoteLoadBySurveyCall() => when(remote.loadBySurvey(surveyId: anyNamed('surveyId')));

  void mockRemoteLoadBySurvey() {
    remoteSurveyResult = FakeSurveyResultFactory.makeEntity();
    mockRemoteLoadBySurveyCall().thenAnswer((_) async => remoteSurveyResult);
  }

  void mockRemoteLoadError(DomainError error) => mockRemoteLoadBySurveyCall().thenThrow(error);

  PostExpectation mockLocalLoadCall() => when(local.loadBySurvey(surveyId: anyNamed('surveyId')));

  void mockLocalLoadBySurvey(){
    localSurveyResult = FakeSurveyResultFactory.makeEntity();
    mockLocalLoadCall().thenAnswer((_) async => localSurveyResult);
  }

  void mockLocalLoadError() => mockLocalLoadCall().thenThrow(DomainError.unexpected);

  setUp(() {
    surveyId = faker.guid.guid();
    remote = RemoteLoadSurveyResultSpy();
    local = LocalLoadSurveyResultSpy();
    sut = RemoteLoadSurveyResultWithLocalFallback(remote: remote, local: local);
    FakeSurveyResultFactory.makeEntity();
    mockRemoteLoadBySurvey();
    mockLocalLoadBySurvey();
  });

  test('Should call remote LoadBySurvey', () async {
    await sut.loadBySurvey(surveyId: surveyId);
    verify(remote.loadBySurvey(surveyId: surveyId)).called(1);
  });

  test('Should call local save with remote data', () async {
    await sut.loadBySurvey(surveyId: surveyId);
    verify(local.save(remoteSurveyResult)).called(1);
  });

  test('Should return remote data', () async {
    final response =  await sut.loadBySurvey(surveyId: surveyId);
    expect(response, remoteSurveyResult);
  });

  test('Should rethrow if remote LoadBySurvey throws AccessDeniedError', () async {
    mockRemoteLoadError(DomainError.accessDenied);
    final future =  sut.loadBySurvey(surveyId: surveyId);
    expect(future, throwsA(DomainError.accessDenied));
  });

  test('Should call local LoadBySurvey on remote error', () async {
    mockRemoteLoadError(DomainError.unexpected);
    await sut.loadBySurvey(surveyId: surveyId);
    verify(local.validate(surveyId)).called(1);
    verify(local.loadBySurvey(surveyId: surveyId)).called(1);
  });

  test('Should return local data', () async {
    mockRemoteLoadError(DomainError.unexpected);
    final response =  await sut.loadBySurvey(surveyId: surveyId);
    expect(response, localSurveyResult);
  });

  test('Should throw UnexpectedError if local load fails', () async {
    mockRemoteLoadError(DomainError.unexpected);
    mockLocalLoadError();
    final future  =   sut.loadBySurvey(surveyId: surveyId);
    expect(future, throwsA(DomainError.unexpected));
  });

}

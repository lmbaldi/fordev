import 'package:test/test.dart';
import 'package:meta/meta.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:fordev/data/usescases/usecases.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/usecases/usecases.dart';

class RemoteLoadSurveyResultWithLocalFallback implements LoadSurveyResult{
  final RemoteLoadSurveyResult remote;
  final LocalLoadSurveyResult local;

  RemoteLoadSurveyResultWithLocalFallback({
    @required this.remote,
    @required this.local
  });

  Future<SurveyResultEntity> loadBySurvey({String surveyId}) async {
    try{
      final surveyResult =  await remote.loadBySurvey(surveyId: surveyId);
      await local.save(surveyId: surveyId, surveyResult: surveyResult);
      return surveyResult;
    } catch(error){
      if(error == DomainError.accessDenied){
        rethrow;
      }
      await local.validate(surveyId);
      return await local.loadBySurvey(surveyId: surveyId);
    }
  }
}

class RemoteLoadSurveyResultSpy extends Mock implements RemoteLoadSurveyResult {}
class LocalLoadSurveyResultSpy extends Mock implements LocalLoadSurveyResult {}

void main() {
  RemoteLoadSurveyResultWithLocalFallback sut;
  RemoteLoadSurveyResultSpy remote;
  LocalLoadSurveyResultSpy local;
  String surveyId;
  SurveyResultEntity remoteResult;
  SurveyResultEntity localResult;

  PostExpectation mockRemoteLoadCall() => when(remote.loadBySurvey(surveyId: anyNamed('surveyId')));

   mockSurveyResult(){
    return remoteResult = SurveyResultEntity(
      surveyId: faker.guid.guid(),
      question: faker.lorem.sentence(),
      answers: [SurveyAnswerEntity(
        answer: faker.lorem.sentence(),
        percent: faker.randomGenerator.integer(100),
        isCurrentAccountAnswer: faker.randomGenerator.boolean()
      )]
    );

  }

  void mockRemoteLoad() {
    remoteResult = mockSurveyResult();
    mockRemoteLoadCall().thenAnswer((_) async => remoteResult);
  }

  void mockRemoteLoadError(DomainError error) => mockRemoteLoadCall().thenThrow(error);

  PostExpectation mockLocalLoadCall() => when(local.loadBySurvey(surveyId: anyNamed('surveyId')));

  void mockLocalLoad(){
    localResult = mockSurveyResult();
    mockLocalLoadCall().thenAnswer((_) async => localResult);
  }

  void mockLocalLoadError() => mockLocalLoadCall().thenThrow(DomainError.unexpected);

  setUp(() {
    surveyId = faker.guid.guid();
    remote = RemoteLoadSurveyResultSpy();
    local = LocalLoadSurveyResultSpy();
    sut = RemoteLoadSurveyResultWithLocalFallback(remote: remote, local: local);
    mockSurveyResult();
    mockRemoteLoad();
    mockLocalLoad();
  });

  test('Should call remote LoadBySurvey', () async {
    await sut.loadBySurvey(surveyId: surveyId);
    verify(remote.loadBySurvey(surveyId: surveyId)).called(1);
  });

  test('Should call local save with remote data', () async {
    await sut.loadBySurvey(surveyId: surveyId);
    verify(local.save(surveyId: surveyId, surveyResult: remoteResult)).called(1);
  });

  test('Should return remote data', () async {
    final response =  await sut.loadBySurvey(surveyId: surveyId);
    expect(response, remoteResult);
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
    expect(response, localResult);
  });

  test('Should throw UnexpectedError if local load fails', () async {
    mockRemoteLoadError(DomainError.unexpected);
    mockLocalLoadError();
    final future  =   sut.loadBySurvey(surveyId: surveyId);
    expect(future, throwsA(DomainError.unexpected));
  });

}

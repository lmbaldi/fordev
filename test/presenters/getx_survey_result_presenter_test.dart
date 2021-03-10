import 'package:fordev/ui/pages/pages.dart';
import 'package:test/test.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:fordev/ui/helpers/errors/errors.dart';
import 'package:fordev/domain/usecases/usecases.dart';
import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/helpers/domain_error.dart';
import 'package:fordev/presentation/presenters/presenters.dart';

import '../mocks/mocks.dart';

class LoadSurveyResultSpy extends Mock implements LoadSurveyResult {}
class SaveSurveyResultSpy extends Mock implements SaveSurveyResult {}

void main() {
  GetxSurveyResultPresenter sut;
  LoadSurveyResultSpy loadSurveyResult;
  SaveSurveyResultSpy saveSurveyResult;
  SurveyResultEntity loadResult;
  SurveyResultEntity saveResult;
  String surveyId;
  String answer;

  PostExpectation mockLoadSurveyResultCall() => when(loadSurveyResult.loadBySurvey(surveyId: anyNamed('surveyId')));

  void mockLoadSurveyResult(SurveyResultEntity data) {
    loadResult = data;
    mockLoadSurveyResultCall().thenAnswer((_) async => loadResult);
  }

  PostExpectation mockSaveSurveyResultCall() => when(saveSurveyResult.save(answer: anyNamed('answer')));

  void mockSaveSurveyResult(SurveyResultEntity data) {
    saveResult = data;
    mockSaveSurveyResultCall().thenAnswer((_) async => saveResult);
  }

  mockLoadSurveyResultError(DomainError error) => mockLoadSurveyResultCall().thenThrow(error);
  mockSaveSurveyResultError(DomainError error) => mockSaveSurveyResultCall().thenThrow(error);

  SurveyResultViewModel maptoViewModel(SurveyResultEntity entity){
    return  SurveyResultViewModel(
        surveyId: entity.surveyId,
        question: entity.question,
        answers: [
          SurveyAnswerViewModel(
              image: entity.answers[0].image,
              answer: entity.answers[0].answer,
              isCurrentAccountAnswer: entity.answers[0].isCurrentAccountAnswer,
              percent: '${entity.answers[0].percent}%'
          ),
          SurveyAnswerViewModel(
              answer: entity.answers[1].answer,
              isCurrentAccountAnswer: entity.answers[1].isCurrentAccountAnswer,
              percent: '${entity.answers[1].percent}%'
          )
        ]
    );
  }

  setUp(() {
    surveyId = faker.guid.guid();
    answer = faker.lorem.sentence();
    loadSurveyResult = LoadSurveyResultSpy();
    saveSurveyResult = SaveSurveyResultSpy();
    sut = GetxSurveyResultPresenter(
        loadSurveyResult: loadSurveyResult,
        saveSurveyResult: saveSurveyResult,
        surveyId: surveyId,
    );
    mockLoadSurveyResult(FakeSurveyResultFactory.makeEntity());
    mockSaveSurveyResult(FakeSurveyResultFactory.makeEntity());
  });

  group('loadData', (){

    test('Should call LoadSurveyResult on loadData', () async {
      await sut.loadData();
      verify(loadSurveyResult.loadBySurvey(surveyId: surveyId)).called(1);
    });

    test('Should emit correct events on success', () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      sut.surveyResultStream.listen(expectAsync1((result) => expect(result, maptoViewModel(loadResult))));
      await sut.loadData();
    });

    test('Should emit correct events on error', () async {
      mockLoadSurveyResultError(DomainError.unexpected);
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      sut.surveyResultStream.listen(null,
          onError: expectAsync1((error) => expect(error, UIError.unexpected.description)));
      await sut.loadData();
    });

    test('Should emit correct events on access denied', () async {
      mockLoadSurveyResultError(DomainError.accessDenied);
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.isSessionExpiredStream, emits(true));

      await sut.loadData();
    });

  });


  group('save', (){

    test('Should call SaveSurveyResult on save', () async {
      await sut.save(answer: answer);
      verify(saveSurveyResult.save(answer: answer)).called(1);
    });

    test('Should emit correct events on success', () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.surveyResultStream, emitsInOrder([
        maptoViewModel(loadResult),
        maptoViewModel(saveResult),
      ]));
      await sut.loadData();
      await sut.save(answer: answer);
    });

    test('Should emit correct events on error', () async {
      mockSaveSurveyResultError(DomainError.unexpected);
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      sut.surveyResultStream.listen(null,
          onError: expectAsync1((error) => expect(error, UIError.unexpected.description)));
      await sut.save(answer: answer);
    });

    test('Should emit correct events on access denied', () async {
      mockSaveSurveyResultError(DomainError.accessDenied);
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.isSessionExpiredStream, emits(true));
      await sut.save(answer: answer);
    });

  });


}

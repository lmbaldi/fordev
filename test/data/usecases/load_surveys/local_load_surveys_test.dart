import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:fordev/data/cache/cache.dart';
import 'package:fordev/data/usescases/usecases.dart';
import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/helpers/domain_error.dart';

import '../../../mocks/mocks.dart';

class CacheStorageSpy extends Mock implements CacheStorage {}

void main() {
  group('load', () {
    CacheStorageSpy cacheStorage;
    LocalLoadSurveys sut;
    List<Map> data;

    PostExpectation mockFetchCall() => when(cacheStorage.fetch(any));

    void mockFetch(List<Map> list) {
      data = list;
      mockFetchCall().thenAnswer((_) async => data);
    }

    void mockFetchError() => mockFetchCall().thenThrow(Exception());

    setUp(() {
      cacheStorage = CacheStorageSpy();
      sut = LocalLoadSurveys(cacheStorage: cacheStorage);
      mockFetch(FakeSurveysFactory.makeCacheJson());
    });

    test('Should call CacheStorage with correct key', () async {
      await sut.load();
      verify(cacheStorage.fetch('surveys')).called(1);
    });

    test('Should return a list of surveys on success', () async {
      final surveys = await sut.load();
      expect(surveys, [
        SurveyEntity(
            id: data[0]['id'],
            question: data[0]['question'],
            dateTime: DateTime.utc(2021, 2, 18),
            didAnswer: false),
        SurveyEntity(
            id: data[0]['id'],
            question: data[1]['question'],
            dateTime: DateTime.utc(2021, 2, 12),
            didAnswer: true),
      ]);
    });

    test('Should throw UnexpectedError if cache is empty', () async {
      mockFetch([]);
      final surveys = sut.load();
      expect(surveys, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache is null', () async {
      mockFetch(null);
      final surveys = sut.load();
      expect(surveys, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache is invalid', () async {
      mockFetch(FakeSurveysFactory.makeInvalidCacheJson());
      final surveys = sut.load();
      expect(surveys, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache is incomplete', () async {
      mockFetch(FakeSurveysFactory.makeIncompleteCacheJson());
      final surveys = sut.load();
      expect(surveys, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache throws', () async {
      mockFetchError();
      final surveys = sut.load();
      expect(surveys, throwsA(DomainError.unexpected));
    });
  });

  group('validate', () {
    CacheStorageSpy cacheStorage;
    LocalLoadSurveys sut;
    List<Map> data;

    PostExpectation mockFetchCall() => when(cacheStorage.fetch(any));

    void mockFetch(List<Map> list) {
      data = list;
      mockFetchCall().thenAnswer((_) async => data);
    }

    void mockFetchError() => mockFetchCall().thenThrow(Exception());

    setUp(() {
      cacheStorage = CacheStorageSpy();
      sut = LocalLoadSurveys(cacheStorage: cacheStorage);
      mockFetch(FakeSurveysFactory.makeCacheJson());
    });

    test('Should call CacheStorage with correct key', () async {
      await sut.validate();
      verify(cacheStorage.fetch('surveys')).called(1);
    });

    test('Should delete cache if it is invalid', () async {
      mockFetch(FakeSurveysFactory.makeInvalidCacheJson());
      await sut.validate();
      verify(cacheStorage.delete('surveys')).called(1);
    });

    test('Should delete cache if it is incomplete', () async {
      mockFetch(FakeSurveysFactory.makeIncompleteCacheJson());
      await sut.validate();
      verify(cacheStorage.delete('surveys')).called(1);
    });

    test('Should delete cache if fetch fails', () async {
      mockFetchError();
      await sut.validate();
      verify(cacheStorage.delete('surveys')).called(1);
    });
  });

  group('save', () {
    CacheStorageSpy cacheStorage;
    LocalLoadSurveys sut;
    List<SurveyEntity> surveys;

    PostExpectation mockSaveCall() => when(cacheStorage.save(key: anyNamed('key'), value: anyNamed('value')));

   void mockSaveError() => mockSaveCall().thenThrow(Exception());

    setUp(() {
      cacheStorage = CacheStorageSpy();
      sut = LocalLoadSurveys(cacheStorage: cacheStorage);
      surveys = FakeSurveysFactory.makeEntities();
    });

    test('Should call CacheStorage with correct values', () async {
      final list = [
        {
          'id': surveys[0].id,
          'question': surveys[0].question,
          'date': '2021-02-18T00:00:00.000Z',
          'didAnswer': 'true'
        },
        {
          'id': surveys[1].id,
          'question': surveys[1].question,
          'date': '2021-02-12T00:00:00.000Z',
          'didAnswer': 'false'
        }
      ];
      await sut.save(surveys);
      verify(cacheStorage.save(key: 'surveys', value: list)).called(1);
    });

    test('Should throw UnexpectedError if save throws', () async {
      mockSaveError();
      final future = sut.save(surveys);
      expect(future, throwsA(DomainError.unexpected));
    });
  });

}

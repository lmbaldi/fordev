import 'package:test/test.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:fordev/data/cache/cache.dart';
import 'package:fordev/data/usescases/usecases.dart';
import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/helpers/domain_error.dart';

class FetchCacheStorageSpy extends Mock implements FetchCacheStorage {}

void main() {

  group('load', (){
    FetchCacheStorageSpy fetchCacheStorage;
    LocalLoadSurveys sut;
    List<Map> data;

    List<Map> mockValidData() => [
      {
        'id': faker.guid.guid(),
        'question': faker.randomGenerator.string(10),
        'date': '2021-02-18T00:00:00Z',
        'didAnswer': 'false',
      },
      {
        'id': faker.guid.guid(),
        'question': faker.randomGenerator.string(10),
        'date': '2021-02-12T00:00:00Z',
        'didAnswer': 'true',
      }
    ];

    PostExpectation mockFetchCall() => when(fetchCacheStorage.fetch(any));

    void mockFetch(List<Map> list) {
      data = list;
      mockFetchCall().thenAnswer((_) async => data);
    }

    void mockFetchError() => mockFetchCall().thenThrow(Exception());

    setUp(() {
      fetchCacheStorage = FetchCacheStorageSpy();
      sut = LocalLoadSurveys(fetchCacheStorage: fetchCacheStorage);
      mockFetch(mockValidData());
    });

    test('Should call FetchCacheStorage with correct key', () async {
      await sut.load();
      verify(fetchCacheStorage.fetch('surveys')).called(1);
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
      mockFetch([
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(10),
          'date': 'invalid date',
          'didAnswer': 'false',
        }
      ]);
      final surveys = sut.load();
      expect(surveys, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache is incomplete', () async {
      mockFetch([
        {
          'date': '2021-02-18T00:00:00Z',
          'didAnswer': 'false',
        }
      ]);
      final surveys = sut.load();
      expect(surveys, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache throws', () async {
      mockFetchError();
      final surveys = sut.load();
      expect(surveys, throwsA(DomainError.unexpected));
    });

  });


}

import 'package:faker/faker.dart';
import 'package:fordev/data/models/models.dart';
import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/helpers/domain_error.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';

class LocalLoadsurveys {
  final FetchCacheStorage fetchCacheStorage;

  LocalLoadsurveys({@required this.fetchCacheStorage});

  Future<List<SurveyEntity>> load() async {
    final data = await fetchCacheStorage.fetch('surveys');
    if(data.isEmpty){
      throw DomainError.unexpected;
    }
    return data
        .map<SurveyEntity>((json) => LocalSurveyModel.fromJson(json).toEntity())
        .toList();
  }
}

abstract class FetchCacheStorage {
  Future<dynamic> fetch(String key);
}

class FetchCacheStorageSpy extends Mock implements FetchCacheStorage {}

void main() {
  FetchCacheStorageSpy fetchCacheStorage;
  LocalLoadsurveys sut;
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

  void mockFetch(List<Map> list) {
    data = list;
    when(fetchCacheStorage.fetch(any)).thenAnswer((_) async => data);
  }

  setUp(() {
    fetchCacheStorage = FetchCacheStorageSpy();
    sut = LocalLoadsurveys(fetchCacheStorage: fetchCacheStorage);
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
}

import 'package:faker/faker.dart';
import 'package:fordev/ui/pages/pages.dart';
import 'package:fordev/domain/entities/entities.dart';

class FakeSurveysFactory {

  static List<Map> makeCacheJson() => [
    {
      'id': faker.guid.guid(),
      'question': faker.randomGenerator.string(10),
      'date': '2021-02-16T00:00:00Z',
      'didAnswer': 'false',
    },
    {
      'id': faker.guid.guid(),
      'question': faker.randomGenerator.string(10),
      'date': '2021-02-17T00:00:00Z',
      'didAnswer': 'true',
    }
  ];

  static List<Map> makeInvalidCacheJson() => [
    {
      'id': faker.guid.guid(),
      'question': faker.randomGenerator.string(10),
      'date': 'invalid date',
      'didAnswer': 'false',
    }
  ];

  static List<Map> makeIncompleteCacheJson() =>[
    {
      'date': '2021-02-18T00:00:00Z',
      'didAnswer': 'false',
    }
  ];

  static List<SurveyEntity> makeEntities() => [
    SurveyEntity(
        id: faker.guid.guid(),
        question: faker.randomGenerator.string(10),
        dateTime: DateTime.utc(2021, 2, 16),
        didAnswer: false),
    SurveyEntity(
        id: faker.guid.guid(),
        question: faker.randomGenerator.string(10),
        dateTime: DateTime.utc(2021, 2, 17),
        didAnswer: true),
  ];

  static List<SurveyViewModel> makeViewModel() => [
    SurveyViewModel(id: '1', question: 'Question 1', date: 'Date 1', didAnswer: true),
    SurveyViewModel(id: '2', question: 'Question 2', date: 'Date 2', didAnswer: false)
  ];

  static List<Map> makeApiJson() => [
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

  static List<Map> makeInvalidApiJson() => [{'invalid_key': 'invalid_value'}];

}

import 'package:faker/faker.dart';
import 'package:fordev/domain/entities/entities.dart';
<<<<<<< HEAD
import 'package:fordev/ui/pages/pages.dart';
=======
>>>>>>> 7854fd8105794fa2317a15ce59b8dd625ae958ec

class FakeSurveyResultFactory {

  static Map makeCacheJson() => {
    'surveyId': faker.guid.guid(),
    'question': faker.lorem.sentence(),
    'answers': [
      {
        'image': faker.internet.httpUrl(),
        'answer': faker.lorem.sentence(),
        'isCurrentAccountAnswer': 'true',
        'percent': '40'
      },
      {
        'answer': faker.lorem.sentence(),
<<<<<<< HEAD
        'isCurrentAccountAnswer': 'false',
        'percent': '60'
=======
        'isCurrentAccountAnswer': 'true',
        'percent': '40'
>>>>>>> 7854fd8105794fa2317a15ce59b8dd625ae958ec
      }
    ],
  };

  static Map makeInvalidCacheJson() => {
    'surveyId': faker.guid.guid(),
    'question': faker.lorem.sentence(),
    'answers': [
      {
        'image': faker.internet.httpUrl(),
        'answer': faker.lorem.sentence(),
        'isCurrentAccountAnswer': 'invalid bool',
        'percent': 'invalid int'
      }
    ],
  };

  static Map makeIncompleteCacheJson() => {
        'surveyId': faker.guid.guid(),
      };

  static SurveyResultEntity makeEntity() => SurveyResultEntity(
    surveyId: faker.guid.guid(),
    question: faker.lorem.sentence(),
    answers: [
      SurveyAnswerEntity(
          image: faker.internet.httpUrl(),
          answer: faker.lorem.sentence(),
          isCurrentAccountAnswer: true,
          percent: 40),
      SurveyAnswerEntity(
          answer: faker.lorem.sentence(),
          isCurrentAccountAnswer: false,
          percent: 60)
    ],
  );

<<<<<<< HEAD

  static SurveyResultViewModel mockViewModel() => SurveyResultViewModel(
      surveyId: 'Any id',
      question: 'Question',
      answers: [
        SurveyAnswerViewModel(
            image: 'Image 0',
            answer: 'Answer 0',
            isCurrentAccountAnswer: true,
            percent: '60%'
        ),
        SurveyAnswerViewModel(
            answer: 'Answer 1',
            isCurrentAccountAnswer: false,
            percent: '40%'
        ),
      ]
  );

=======
>>>>>>> 7854fd8105794fa2317a15ce59b8dd625ae958ec
  static Map makeApiJson() => {
    'surveyId': faker.guid.guid(),
    'question': faker.randomGenerator.string(50),
    'answers': [
      {
        'image': faker.internet.httpUrl(),
        'answer': faker.randomGenerator.string(20),
        'percent': faker.randomGenerator.integer(100),
        'count': faker.randomGenerator.integer(1000),
        'isCurrentAccountAnswer': faker.randomGenerator.boolean(),
      },
      {
        'answer': faker.randomGenerator.string(20),
        'percent': faker.randomGenerator.integer(100),
        'count': faker.randomGenerator.integer(1000),
        'isCurrentAccountAnswer': faker.randomGenerator.boolean(),
      }
    ],
    'date': faker.date.dateTime().toIso8601String()
  };

  static Map makeInvalidApiJson() => {'invalid_key': 'invalid_value'};

}

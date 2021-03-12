import 'package:faker/faker.dart';
<<<<<<< HEAD
import 'package:fordev/domain/entities/entities.dart';
=======
>>>>>>> 7854fd8105794fa2317a15ce59b8dd625ae958ec

class FakeAccountFactory {

  static Map makeApiJson() => {
    'accessToken': faker.guid.guid(),
    'name': faker.person.name(),
  };

<<<<<<< HEAD
  static AccountEntity makeEntity() => AccountEntity(token: faker.guid.guid());


=======
>>>>>>> 7854fd8105794fa2317a15ce59b8dd625ae958ec
}

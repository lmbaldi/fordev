import 'package:fordev/infra/cache/cache.dart';
import 'package:test/test.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FlutterSecureStorageSpy extends Mock implements FlutterSecureStorage {}

void main() {
  LocalStoreAdapter sut;
  FlutterSecureStorageSpy secureStorage;
  String key;
  String value;

  setUp(() {
    secureStorage = FlutterSecureStorageSpy();
    sut = LocalStoreAdapter(secureStorage: secureStorage);
    key = faker.lorem.word();
    value = faker.guid.guid();
  });

  void mockSaveSecureError() {
    when(secureStorage.write(key: anyNamed('key'), value: anyNamed('value')))
        .thenThrow(Exception());
  }

  test('Should call save secure with correct values', () async {
    await sut.saveSecure(key: key, value: value);
    verify(secureStorage.write(key: key, value: value));
  });

  //prevenir falha da biblioteca se ela mudar
  test('Should throw if save secure throws', () async {
    //mockar a biblioteca do  FlutterSecureStorage pra retornar uma excecao
    mockSaveSecureError();
    final future = sut.saveSecure(key: key, value: value);
    //compara apenas o tipo se retorna uma excecao
    expect(future, throwsA(TypeMatcher<Exception>()));
  });
}

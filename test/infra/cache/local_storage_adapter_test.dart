import 'package:test/test.dart';
import 'package:meta/meta.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fordev/data/cache/cache.dart';

class LocalStoreAdapter implements SaveSecureCacheStorage {
  final FlutterSecureStorage secureStorage;

  LocalStoreAdapter({@required this.secureStorage});

  Future<void> saveSecure(
      {@required String key, @required String value}) async {
    await secureStorage.write(key: key, value: value);
  }
}

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

import 'package:fordev/infra/cache/cache.dart';
import 'package:test/test.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FlutterSecureStorageSpy extends Mock implements FlutterSecureStorage {}

void main() {
  SecureStorageAdapter sut;
  FlutterSecureStorageSpy secureStorage;
  String key;
  String value;

  setUp(() {
    secureStorage = FlutterSecureStorageSpy();
    sut = SecureStorageAdapter(secureStorage: secureStorage);
    key = faker.lorem.word();
    value = faker.guid.guid();
  });

  group('saveSecure', () {
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
  });

  group('fetchSecure', () {
    PostExpectation mockFetchSecureCall() =>
        when(secureStorage.read(key: anyNamed('key')));

    void mockFetchSecure() {
      mockFetchSecureCall().thenAnswer((_) async => value);
    }

    void mockFetchSecureError() {
      mockFetchSecureCall().thenThrow(Exception());
    }

    setUp(() {
      mockFetchSecure();
    });

    test('Should call fetch secure with correct value', () async {
      await sut.fetchSecure(key);
      verify(secureStorage.read(key: key));
    });

    test('Should return correct value on success', () async {
      final fetchValue = await sut.fetchSecure(key);
      expect(fetchValue, value);
    });

    //prevenir falha da biblioteca se ela mudar
    test('Should throw if fetch secure throws', () async {
      //mockar a biblioteca do  FlutterSecureStorage pra retornar uma excecao
      mockFetchSecureError();
      final future = sut.fetchSecure(key);
      //compara apenas o tipo se retorna uma excecao
      expect(future, throwsA(TypeMatcher<Exception>()));
    });
  });
}

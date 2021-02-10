import 'package:test/test.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';

import 'package:fordev/data/cache/cache.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/data/usescases/usecases.dart';
import 'package:fordev/domain/entities/entities.dart';


class SaveCacheStorageSpy extends Mock implements SaveSecureCacheStorage {}

void main() {
  LocalSaveCurrentAccount sut;
  SaveCacheStorageSpy saveSecureCacheStorage;
  AccountEntity account;

  setUp((){
    saveSecureCacheStorage = SaveCacheStorageSpy();
    sut = LocalSaveCurrentAccount(saveSecureCacheStorage: saveSecureCacheStorage);
    account = AccountEntity(token: faker.guid.guid());
  });

  void mockError(){
    when(saveSecureCacheStorage.saveSecure(
        key: anyNamed('key'), value: anyNamed('value'))).thenThrow(Exception());
  }


  test('Should call SaveSecureCacheStorage with correct values', () async {
    await sut.save(account);
    verify(
        saveSecureCacheStorage.saveSecure(key: 'token', value: account.token));
  });

  test('Should throw Unexpected if SaveSecureCacheStorage with throws',
      () async {
    mockError();
    final future = sut.save(account);
    expect(future, throwsA(DomainError.unexpected));
  });
}

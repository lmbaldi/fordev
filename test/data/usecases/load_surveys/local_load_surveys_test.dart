
import 'package:test/test.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';

class LocalLoadsurveys {

  final FetchCacheStorage fetchCacheStorage;

  LocalLoadsurveys({@required this.fetchCacheStorage});

  Future<void> load() async {
    await fetchCacheStorage.fetch('surveys');
  }
}

abstract class FetchCacheStorage {
  Future<void> fetch(String key);
}

class FetchCacheStorageSpy extends Mock implements FetchCacheStorage {}

void main(){

  FetchCacheStorageSpy fetchCacheStorage;
  LocalLoadsurveys sut;

  setUp((){
    fetchCacheStorage = FetchCacheStorageSpy();
    sut = LocalLoadsurveys(fetchCacheStorage: fetchCacheStorage);
  });

  test('Should call FetchCacheStorage with correct key', () async{
    await sut.load();
    verify(fetchCacheStorage.fetch('surveys')).called(1);
  });
}



import 'package:test/test.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:fordev/data/cache/cache.dart';

class AuthorizeHttpClientDecorator{
  final FetchSecureCacheStorage fetchSecureCacheStorage;


  AuthorizeHttpClientDecorator({@required this.fetchSecureCacheStorage});

  Future<void> request() async {
    await fetchSecureCacheStorage.fetchSecure('token');
  }
}
//classe mock criada porque nao se pode criar uma instancia de uma inferface
class FetchSecureCacheStorageSpy extends Mock implements FetchSecureCacheStorage{}

void main(){

  FetchSecureCacheStorageSpy fetchSecureCacheStorage;
  AuthorizeHttpClientDecorator sut;

  setUp((){
    fetchSecureCacheStorage = FetchSecureCacheStorageSpy();
    sut = AuthorizeHttpClientDecorator(fetchSecureCacheStorage:fetchSecureCacheStorage);
  });

  test('Should call FetchSecureCacheStorage with correct key', () async {

    await sut.request();
    verify(fetchSecureCacheStorage.fetchSecure('token')).called(1);
  });
}
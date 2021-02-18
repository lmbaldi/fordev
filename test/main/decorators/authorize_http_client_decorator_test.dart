import 'package:faker/faker.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:fordev/data/cache/cache.dart';

class AuthorizeHttpClientDecorator{

  final FetchSecureCacheStorage fetchSecureCacheStorage;

  AuthorizeHttpClientDecorator({@required this.fetchSecureCacheStorage});

  Future<void> request({String url, String method, Map body, Map headers}) async {
    await fetchSecureCacheStorage.fetchSecure('token');
  }
}
//classe mock criada porque nao se pode criar uma instancia de uma inferface
class FetchSecureCacheStorageSpy extends Mock implements FetchSecureCacheStorage{}

void main(){

  FetchSecureCacheStorageSpy fetchSecureCacheStorage;
  AuthorizeHttpClientDecorator sut;
  String url;
  String method;
  Map body;

  setUp((){
    fetchSecureCacheStorage = FetchSecureCacheStorageSpy();
    sut = AuthorizeHttpClientDecorator(fetchSecureCacheStorage:fetchSecureCacheStorage);
    url = faker.internet.httpUrl();
    method = faker.randomGenerator.string(10);
    body = {'any_key' : 'any_value' };
  });

  test('Should call FetchSecureCacheStorage with correct key', () async {
    await sut.request(url: url, method: method, body: body);
    verify(fetchSecureCacheStorage.fetchSecure('token')).called(1);
  });
}
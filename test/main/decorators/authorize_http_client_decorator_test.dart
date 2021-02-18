import 'package:faker/faker.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:fordev/data/http/http.dart';
import 'package:fordev/data/cache/cache.dart';

class AuthorizeHttpClientDecorator implements HttpClient {
  final FetchSecureCacheStorage fetchSecureCacheStorage;
  final HttpClient decoratee;

  AuthorizeHttpClientDecorator(
      {@required this.fetchSecureCacheStorage, @required this.decoratee});

  Future<dynamic> request({String url, String method, Map body, Map headers}) async {
    try{
      final token = await fetchSecureCacheStorage.fetchSecure('token');
      final authorizedHeaders = headers ?? {}..addAll({'x-access-token': token});
      return await decoratee.request(url: url, method: method, body: body, headers: authorizedHeaders);
    } on HttpError{
      rethrow;
    } catch (error){
     throw HttpError.forbidden;
    }
  }
}

//classe mock criada porque nao se pode criar uma instancia de uma inferface
class FetchSecureCacheStorageSpy extends Mock implements FetchSecureCacheStorage {}
class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  FetchSecureCacheStorageSpy fetchSecureCacheStorage;
  AuthorizeHttpClientDecorator sut;
  HttpClientSpy httpClient;
  Map body;
  String url;
  String method;
  String token;
  String httpResponse;

  PostExpectation mockTokenCall(){
    return when(fetchSecureCacheStorage.fetchSecure(any));
  }

  void mockToken() {
    token = faker.guid.guid();
    mockTokenCall().thenAnswer((_) async => token);
  }

  void mockTokenError() => mockTokenCall().thenThrow(Exception());

  void mockHttpResponse() {
    httpResponse = faker.randomGenerator.string(50);
    when(httpClient.request(
      url: anyNamed('url'),
      method: anyNamed('method'),
      body: anyNamed('body'),
      headers: anyNamed('headers'),
    )).thenAnswer((_) async => httpResponse);
  }

  PostExpectation mockHttpResponseCall(){
    return when(httpClient.request(
      url: anyNamed('url'),
      method: anyNamed('method'),
      body: anyNamed('body'),
      headers: anyNamed('headers'),
    ));
  }
  void mockHttpResponseError(HttpError error) => mockHttpResponseCall().thenThrow(error);

  setUp(() {
    fetchSecureCacheStorage = FetchSecureCacheStorageSpy();
    httpClient = HttpClientSpy();
    sut = AuthorizeHttpClientDecorator(
        fetchSecureCacheStorage: fetchSecureCacheStorage,
        decoratee: httpClient);
    url = faker.internet.httpUrl();
    method = faker.randomGenerator.string(10);
    body = {'any_key': 'any_value'};
    mockToken();
    mockHttpResponse();
  });

  test('Should call FetchSecureCacheStorage with correct key', () async {
    await sut.request(url: url, method: method, body: body);
    verify(fetchSecureCacheStorage.fetchSecure('token')).called(1);
  });

  test('Should call decoratee with access token on header', () async {
    await sut.request(url: url, method: method, body: body);
    verify(httpClient.request(
        url: url,
        method: method,
        body: body,
        headers: {'x-access-token': token})).called(1);

    await sut.request(
        url: url,
        method: method,
        body: body,
        headers: {'any_header': 'any_value'});
    verify(httpClient.request(
            url: url,
            method: method,
            body: body,
            headers: {'x-access-token': token, 'any_header': 'any_value'}))
        .called(1);
  });

  test('Should return same result as decoratee', () async {
    final response = await sut.request(url: url, method: method, body: body);
    expect(response, httpResponse);
  });


  test('Should throw ForbiddenError if FetchSecureCacheStorage throws', () async {
    mockTokenError();
    final future = sut.request(url: url, method: method, body: body);
    expect(future, throwsA(HttpError.forbidden));
  });

  test('Should rethrow if decoratee throws', () async {
    mockHttpResponseError(HttpError.badRequest);
    final future = sut.request(url: url, method: method, body: body);
    expect(future, throwsA(HttpError.badRequest));
  });


}
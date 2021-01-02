import 'package:test/test.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:fordev/data/http/http.dart';

import 'package:fordev/domain/helpers/domain_error.dart';
import 'package:fordev/domain/usecases/usecases.dart';
import 'package:fordev/data/usescases/remote_authentication.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  RemoteAuthentication sut;
  HttpClientSpy httpClient;
  String url;
  AuthenticationParams params;

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpsUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
    params = AuthenticationParams(email: faker.internet.email(), password: faker.internet.password());
  });

  test('Should call HttpClient with correct values', () async {
    await sut.auth(params);
    verify(httpClient.request(
        url: url,
        method: "POST",
        body: {'email': params.email, 'password': params.password}));
  });

  test('Should throw unexpectedError if HttpClient returns 400', () async {
    when(httpClient.request(url: anyNamed('url'), method: anyNamed('method'), body: anyNamed('body')))
        .thenThrow(HttpError.badRequest);
    final future = sut.auth(params);
    expect(future, throwsA(DomainError.unexpected));
  });

}

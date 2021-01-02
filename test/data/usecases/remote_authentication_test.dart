import 'package:test/test.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:fordev/data/http/http.dart';

import 'package:fordev/domain/usecases/usecases.dart';
import 'package:fordev/data/usescases/remote_authentication.dart';

class HttpClientspy extends Mock implements HttpClient {}

void main() {
  RemoteAuthentication sut;
  HttpClientspy httpClient;
  String url;

  setUp(() {
    httpClient = HttpClientspy();
    url = faker.internet.httpsUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
  });

  test('Should call HttpClient with correct values', () async {
    final params = AuthenticationParams(
        email: faker.internet.email(), password: faker.internet.password());

    await sut.auth(params);

    verify(httpClient.request(
        url: url,
        method: "POST",
        body: {'email': params.email, 'password': params.password}));
  });
}

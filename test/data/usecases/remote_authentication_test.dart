import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

import 'package:fordev/domain/usecases/usecases.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({@required this.httpClient, @required this.url});

  Future<void> auth(AuthenticationParams params) async {
    final body = {'email': params.email, 'password': params.password};
    await httpClient.request(url: url, method: "POST", body: body);
  }
}

abstract class HttpClient {
  Future<void> request(
      {@required String url, @required String method, Map body});
}

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

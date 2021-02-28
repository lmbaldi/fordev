import '../../../data/http/http.dart';
import '../../../main/factories/factories.dart';
import '../../../main/decorators/decorator.dart';

HttpClient makeAuthorizeHttpClientDecorator() =>
    AuthorizeHttpClientDecorator(
      decoratee: makeHttpAdapter(),
      fetchSecureCacheStorage: makeSecureStorageAdapter(),
      deleteSecureCacheStorage: makeSecureStorageAdapter()
    );


import 'package:fordev/data/usescases/usecases.dart';
import 'package:fordev/domain/usecases/usecases.dart';
import 'package:fordev/main/factories/http/http.dart';

AddAccount makeRemoteAddAccount() {
  return  RemoteAddAccount(
      httpClient: makeHttpAdapter(),
      url: makeApiUrl('signup')
  );
}

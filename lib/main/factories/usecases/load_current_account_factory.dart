import 'package:fordev/data/usescases/usecases.dart';
import 'package:fordev/domain/usecases/usecases.dart';

import '../factories.dart';

LoadCurrentAccount makeLocalLoadCurrentAccount() {
  return LocalLoadCurrentAccount(
      fetchSecureCacheStorage: makeSecureStorageAdapter());
}

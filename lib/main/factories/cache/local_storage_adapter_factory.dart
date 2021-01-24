import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fordev/infra/cache/cache.dart';

LocalStoreAdapter makeLocalStoreAdapter() {
  final secureStorage = FlutterSecureStorage();
  return LocalStoreAdapter(secureStorage: secureStorage);
}

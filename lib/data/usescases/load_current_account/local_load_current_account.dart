import 'package:meta/meta.dart';
import 'package:fordev/data/cache/cache.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/usecases/usecases.dart';

class LocalLoadCurrentAccount implements LoadCurrentAccount {
  final FetchSecureCacheStorage fetchSecureCacheStorage;

  LocalLoadCurrentAccount({@required this.fetchSecureCacheStorage});

  Future<AccountEntity> load() async {
    try {
      final token = await fetchSecureCacheStorage.fetch('token');
      return AccountEntity(token: token);
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}


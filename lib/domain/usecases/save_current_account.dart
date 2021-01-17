
import 'package:fordev/domain/entities/entities.dart';

abstract class SaveCurrentAccount {
  Future<void> save(AccountEntity account);
}
import 'package:fordev/ui/pages/pages.dart';
import 'package:fordev/main/factories/factories.dart';
import 'package:fordev/presentation/presenters/presenters.dart';

SignUpPresenter makeGetxSignUpPresenter() {
  return GetxSignUpPresenter(
      addAccount: makeRemoteAddAccount(),
      validation: makeSignUpValidation(),
      saveCurrentAccount: makeLocalSaveCurrentAccount());
}

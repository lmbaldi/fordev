import 'package:fordev/ui/pages/pages.dart';
import 'package:fordev/main/factories/factories.dart';
import 'package:fordev/presentation/presenters/presenters.dart';

SplashPresenter makeGetxSplashPresenter() {
  return GetxSplashPresenter(
      loadCurrentAccount:  makeLocalLoadCurrentAccount()
  );
}

import 'package:fordev/ui/pages/pages.dart';
import 'package:fordev/main/factories/factories.dart';
import 'package:fordev/presentation/presenters/presenters.dart';

LoginPresenter makeLoginPresenter() {
  return StreamLoginPresenter(
      authentication: makeRemoteAuthentication(),
      validation: makeLoginValidation());
}

import 'package:fordev/ui/helpers/helpers.dart';

abstract class SignUpPresenter {
  Stream<UIError> get nameErrorStream;
  Stream<UIError> get emailErrorStream;
  Stream<UIError>  get passwordErrorStream;
  Stream<UIError>  get passwordConfirmationErrorStream;

  void validateName(nome);
  void validateEmail(String email);
  void validatePassword(String password);
  void validatePasswordConfirmation(String password);
}
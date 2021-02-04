import 'package:fordev/ui/helpers/helpers.dart';

abstract class SignUpPresenter {
  Stream<UIError> get emailErrorStream;
  Stream<UIError> get mainErrorStream;
  Stream<UIError> get nameErrorStream;
  Stream<String>  get navigateToStream;
  Stream<UIError> get passwordErrorStream;
  Stream<UIError> get passwordConfirmationErrorStream;
  Stream<bool> get isFormValidStream;
  Stream<bool> get isLoadingStream;

  void validateName(nome);
  void validateEmail(String email);
  void validatePassword(String password);
  void validatePasswordConfirmation(String password);
  Future<void> signUp();
}
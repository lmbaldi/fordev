import 'dart:async';
import 'package:get/get.dart';
import 'package:meta/meta.dart';

import '../protocols/protocols.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../../domain/usecases/usecases.dart';
import '../../domain/helpers/helpers.dart';
import '../mixins/mixins.dart';

class GetxSignUpPresenter extends GetxController
    with LoadingManager, NavigationManager, FormManager, UIErrorManager
      implements SignUpPresenter{
  final Validation validation;
  final AddAccount addAccount;
  final SaveCurrentAccount saveCurrentAccount;

  var _emailError = Rx<UIError>();
  var _nameError = Rx<UIError>();
  var _passwordError = Rx<UIError>();
  var _passwordConfirmationError = Rx<UIError>();

  String _name;
  String _email;
  String _password;
  String _passwordConfirmation;

  Stream<UIError> get emailErrorStream => _emailError.stream;
  Stream<UIError> get nameErrorStream => _nameError.stream;
  Stream<UIError> get passwordErrorStream => _passwordError.stream;
  Stream<UIError> get passwordConfirmationErrorStream => _passwordConfirmationError.stream;

  GetxSignUpPresenter({
    @required this.validation,
    @required this.addAccount,
    @required this.saveCurrentAccount
  });

  void validateEmail(String email) {
    _email = email;
    _emailError.value = _validateField('email');
    _validatForm();
  }

  void validateName(String name) {
    _name = name;
    _nameError.value = _validateField('name');
    _validatForm();
  }

  void validatePassword(String password) {
    _password = password;
    _passwordError.value = _validateField('password');
    _validatForm();
  }

  void validatePasswordConfirmation(String passwordConfirmation) {
    _passwordConfirmation = passwordConfirmation;
    _passwordConfirmationError.value = _validateField('passwordConfirmation');
    _validatForm();
  }

  UIError _validateField(String field) {
    final formData = {
      'name' : _name,
      'email' : _email,
      'password': _password,
      'passwordConfirmation': _passwordConfirmation,
    };

    final error = validation.validate(field: field, input: formData);
    switch (error) {
      case ValidationError.invalidField:
        return UIError.invalidField;
      case ValidationError.requiredField:
        return UIError.requiredField;
      default:
        return null;
    }
  }

  void _validatForm() {
    isFormValid = _emailError.value == null
        &&  _nameError.value == null
        &&  _passwordError.value == null
        &&  _passwordConfirmationError.value == null
        && _name != null
        && _email != null
        && _password != null
        && _passwordConfirmation != null;
  }

  Future<void> signUp() async {
    try{
      mainError = null;
      isLoading = true;
      final account = await addAccount.add(
          AddAccountParams(
              name: _name,
              email: _email,
              password: _password,
              passwordConfirmation: _passwordConfirmation
          )
      );
      await saveCurrentAccount.save(account);
      navigateTo = '/surveys';
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.emailInUse:
          mainError = UIError.emailInUse;
          break;
        default:
          mainError = UIError.unexpected;
      }
      isLoading = false;
    }
    _validatForm();
  }

  void goToLoginPage(){
    navigateTo = '/login';
  }

}

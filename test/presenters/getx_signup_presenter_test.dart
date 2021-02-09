import 'package:flutter_test/flutter_test.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/ui/helpers/errors/errors.dart';
import 'package:fordev/domain/usecases/usecases.dart';
import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/presentation/protocols/validation.dart';
import 'package:fordev/presentation/presenters/presenters.dart';

class ValidationSpy extends Mock implements Validation {}
class AddAccountSpy extends Mock implements AddAccount {}
class SaveCurrentAccountSpy extends Mock implements SaveCurrentAccount {}

void main() {
  GetxSignUpPresenter sut;
  ValidationSpy validation;
  AddAccountSpy addAccount;
  SaveCurrentAccountSpy saveCurrentAccount;
  String email;
  String name;
  String password;
  String passwordConfirmation;
  String token;

  PostExpectation mockValidationCall(String field) => when(validation.validate(
      field: field == null ? anyNamed('field') : field,
      input: anyNamed('input')));

  void mockValidation({String field, ValidationError value}) {
    mockValidationCall(field).thenReturn(value);
  }

  PostExpectation mockAddAccountCall() => when(addAccount.add(any));

  void mockAddAccount() {
    mockAddAccountCall().thenAnswer((_) async => AccountEntity(token));
  }

  void mockAddAccountError(DomainError error) {
    mockAddAccountCall().thenThrow(error);
  }

  PostExpectation mockSaveCurrentAccountCall() => when(saveCurrentAccount.save(any));
  void mockSaveCurrentAccountError() {
    mockSaveCurrentAccountCall().thenThrow(DomainError.unexpected);
  }

  setUp(() {
    validation = ValidationSpy();
    addAccount = AddAccountSpy();
    saveCurrentAccount = SaveCurrentAccountSpy();

    sut = GetxSignUpPresenter(
      validation: validation,
      addAccount:  addAccount,
      saveCurrentAccount: saveCurrentAccount
    );
    email = faker.internet.email();
    password = faker.internet.password();
    passwordConfirmation = faker.internet.password();
    name = faker.person.name();
    token = faker.guid.guid();
    //retornar sucesso por padrao, quando esta sem parametro
    mockValidation();
    mockAddAccount();
  });

  //field email
  test('Should call Validation with correct mail', () {
    final formData = {'name': null, 'email': email, 'password': null, 'passwordConfirmation': null};
    sut.validateEmail(email);
    verify(validation.validate(field: 'email', input: formData)).called(1);
  });

  test('Should emit invalidFieldError if email invalid', () {
    mockValidation(value: ValidationError.invalidField);
    sut.emailErrorStream
        .listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));
    //testa se o valor for igual ao ultimo(valor duplicado)
    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should emit requiredFieldError if email is empty', () {
    mockValidation(value: ValidationError.requiredField);
    sut.emailErrorStream
        .listen(expectAsync1((error) => expect(error, UIError.requiredField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));
    //testa se o valor for igual ao ultimo(valor duplicado)
    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should emit null if validation succeeds', () {
    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));
    //testa se o valor for igual ao ultimo(valor duplicado)
    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  //field name
  test('Should call Validation with correct name', () {
    final formData = {'name': name, 'email': null, 'password': null, 'passwordConfirmation': null};
    sut.validateName(name);
    verify(validation.validate(field: 'name', input: formData)).called(1);
  });

  test('Should emit invalidFieldError if name invalid', () {
    mockValidation(value: ValidationError.invalidField);
    sut.nameErrorStream
        .listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));
    //testa se o valor for igual ao ultimo(valor duplicado)
    sut.validateName(name);
    sut.validateName(name);
  });

  test('Should emit requiredFieldError if name is empty', () {
    mockValidation(value: ValidationError.requiredField);
    sut.nameErrorStream
        .listen(expectAsync1((error) => expect(error, UIError.requiredField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));
    //testa se o valor for igual ao ultimo(valor duplicado)
    sut.validateName(name);
    sut.validateName(name);
  });

  test('Should emit null if validation succeeds', () {
    sut.nameErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));
    //testa se o valor for igual ao ultimo(valor duplicado)
    sut.validateName(name);
    sut.validateName(name);
  });

  //field password
  test('Should call Validation with correct password', () {
    final formData = {'name': null, 'email': null, 'password': password, 'passwordConfirmation': null};
    sut.validatePassword(password);
    verify(validation.validate(field: 'password', input: formData)).called(1);
  });

  test('Should emit invalidFieldError if password invalid', () {
    mockValidation(value: ValidationError.invalidField);
    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));
    //testa se o valor for igual ao ultimo(valor duplicado)
    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should emit requiredFieldError if password is empty', () {
    mockValidation(value: ValidationError.requiredField);
    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, UIError.requiredField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));
    //testa se o valor for igual ao ultimo(valor duplicado)
    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should emit null if validation succeeds', () {
    sut.passwordErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));
    //testa se o valor for igual ao ultimo(valor duplicado)
    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  //field password confirmation
  test('Should call Validation with correct password confirmation', () {
    final formData = {'name': null, 'email': null, 'password': null, 'passwordConfirmation': passwordConfirmation};
    sut.validatePasswordConfirmation(passwordConfirmation);
    verify(validation.validate(field: 'passwordConfirmation', input: formData)).called(1);
  });

  test('Should emit invalidFieldError if password confirmation invalid', () {
    mockValidation(value: ValidationError.invalidField);
    sut.passwordConfirmationErrorStream
        .listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));
    //testa se o valor for igual ao ultimo(valor duplicado)
    sut.validatePasswordConfirmation(passwordConfirmation);
    sut.validatePasswordConfirmation(passwordConfirmation);
  });

  test('Should emit requiredFieldError if password confirmation is empty', () {
    mockValidation(value: ValidationError.requiredField);
    sut.passwordConfirmationErrorStream
        .listen(expectAsync1((error) => expect(error, UIError.requiredField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));
    //testa se o valor for igual ao ultimo(valor duplicado)
    sut.validatePasswordConfirmation(passwordConfirmation);
    sut.validatePasswordConfirmation(passwordConfirmation);
  });

  test('Should emit null if validation succeeds', () {
    sut.passwordConfirmationErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));
    //testa se o valor for igual ao ultimo(valor duplicado)
    sut.validatePasswordConfirmation(passwordConfirmation);
    sut.validatePasswordConfirmation(passwordConfirmation);
  });


  test('Should enable form button if all fields are valid', () async {
    expectLater(sut.isFormValidStream, emitsInOrder([false, true]));

    sut.validateName(name);
    //permite a reconstrucao da tela a cada chamada
    await Future.delayed(Duration.zero);
    sut.validateEmail(email);
    await Future.delayed(Duration.zero);
    sut.validatePassword(password);
    await Future.delayed(Duration.zero);
    sut.validatePasswordConfirmation(passwordConfirmation);
    await Future.delayed(Duration.zero);
  });

  test('Should call AddAccount with correct values', () async {
    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);
    await sut.signUp();
    verify(
        addAccount.add(
            AddAccountParams(
              name: name,
              email: email,
              password: password,
              passwordConfirmation: passwordConfirmation
            )
        )
    ).called(1);
  });

  test('Should call SaveCurrentAccount with correct value', () async {
    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);
    await sut.signUp();
    verify(saveCurrentAccount.save(AccountEntity(token))).called(1);
  });

  test('Should emit UnexpectedError if SaveCurrentAccount fails', () async {
    mockSaveCurrentAccountError();
    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.mainErrorStream.listen(expectAsync1((error) =>
        expect(error, UIError.unexpected)));
    await sut.signUp();
  });

  test('Should emit correct events on AddAccount success', () async {
    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);
    expectLater(sut.isLoadingStream, emits(true));
    await sut.signUp();
  });

  test('Should emit correct events on EmailInUseError', () async {
    mockAddAccountError(DomainError.emailInUse);
    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.mainErrorStream.listen(
        expectAsync1((error) => expect(error, UIError.emailInUse)));
    await sut.signUp();
  });

  test('Should emit correct events on UnexpectedError', () async {
    mockAddAccountError(DomainError.unexpected);
    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.mainErrorStream.listen(expectAsync1((error) =>
        expect(error, UIError.unexpected)));
    await sut.signUp();
  });

  test('Should change page on success', () async {
    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);
    sut.navigateToStream.listen(expectAsync1((page) =>
        expect(page, '/surveys')));
    await sut.signUp();
  });

  test('Should go to  SignUpPage on link click', () async {
    sut.navigateToStream.listen(expectAsync1((page) => expect(page, '/login')));
    await sut.goToLoginPage();
  });

}



















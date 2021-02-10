import 'package:flutter_test/flutter_test.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:fordev/domain/usecases/usecases.dart';
import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/helpers/domain_error.dart';
import 'package:fordev/presentation/protocols/validation.dart';
import 'package:fordev/presentation/presenters/presenters.dart';

class ValidationSpy extends Mock implements Validation {}
class AuthenticationSpy extends Mock implements Authentication {}

void main() {
  GetxLoginPresenter sut;
  ValidationSpy validation;
  AuthenticationSpy authentication;
  String email;
  String password;

  PostExpectation mockValidationCall(String field) => when(validation.validate(
      field: field == null ? anyNamed('field') : field,
      input: anyNamed('input')));

  void mockValidation({String field, String value}){
    mockValidationCall(field).thenReturn(value);
  }

  PostExpectation mockAuthenticationCall() => when(authentication.auth(any));

  void mockAuthentication(){
    mockAuthenticationCall().thenAnswer((_)  async => AccountEntity(token: faker.guid.guid()));
  }

  void mockAuthenticationError(DomainError error){
    mockAuthenticationCall().thenThrow(error);
  }

  setUp(() {
    validation = ValidationSpy();
    authentication = AuthenticationSpy();
    sut = GetxLoginPresenter(validation: validation, authentication: authentication);
    email = faker.internet.email();
    password = faker.internet.password();
    //retornar sucesso por padrao, quando esta sem parametro
    mockValidation();
    mockAuthentication();
  });

  test('Should call Validation with correct mail', () {
    final formData = {'email': email, 'password': null};
    sut.validateEmail(email);
    verify(validation.validate(field: 'email', input: formData)).called(1);
  });

  test('Should emit email error if validation fails', () {
    mockValidation(value: 'error');
    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, 'error')));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));
    //testa se o valor for igual ao ultimo(valor duplicado)
    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should emit null if validation succeeds', () {
    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));
    //testa se o valor for igual ao ultimo(valor duplicado)
    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should call Validation with correct password', () {
    final formData = {'email': null, 'password': password};
    sut.validatePassword(password);
    verify(validation.validate(field: 'password', input: formData)).called(1);
  });

  test('Should emit password error if validation fails', () {
    mockValidation(value: 'error');
    sut.passwordErrorStream.listen(expectAsync1((error) => expect(error, 'error')));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));
    //testa se o valor for igual ao ultimo(valor duplicado)
    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should emit password error as null if validation succeeds', () {
    sut.passwordErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));
    //testa se o valor for igual ao ultimo(valor duplicado)
    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should emit email error if validation fails with password valid', () {
    mockValidation(field: 'email', value: 'error');
    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, 'error')));
    sut.passwordErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validatePassword(password);
  });

  test('Should emit email error if validation fails with password valid', () {
    mockValidation(field: 'email', value: 'error');
    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, 'error')));
    sut.passwordErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validatePassword(password);
  });

  test('Should emit password and email error as null if both validation succeeds', () async {
    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.passwordErrorStream.listen(expectAsync1((error) => expect(error, null)));
    expectLater(sut.isFormValidStream, emitsInOrder([false, true]));

    sut.validateEmail(email);
    //permite a reconstrucao da tela a cada chamada
    await Future.delayed(Duration.zero);
    sut.validatePassword(password);
  });

  test('Should call Authentication with correct values', () async {
     sut.validateEmail(email);
     sut.validatePassword(password);
     await sut.auth();
     verify(authentication.auth(AuthenticationParams(email: email, password: password))).called(1);
  });

  test('Should emit correct values on Authentication success', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    await sut.auth();
  });

  test('Should emit correct events on InvalidCredentialsError', () async {
    mockAuthenticationError(DomainError.invalidCredentials);
    sut.validateEmail(email);
    sut.validatePassword(password);
    expectLater(sut.isLoadingStream, emits(false));
    sut.mainErrorStream.listen(expectAsync1((error) => expect(error, 'Credenciais Inválidas')));
    await sut.auth();
  });

  test('Should emit correct events on UnexpectedError', () async {
    mockAuthenticationError(DomainError.unexpected);
    sut.validateEmail(email);
    sut.validatePassword(password);
    expectLater(sut.isLoadingStream, emits(false));
    sut.mainErrorStream.listen(expectAsync1((error) => expect(error, 'Algo errado aconteceu. Tente novamente em breve')));
    await sut.auth();
  });

  test('Should not emit after dispose', () async {
    expectLater(sut.emailErrorStream, neverEmits(null));
    sut.dispose();
    sut.validateEmail(email);
  });
}
















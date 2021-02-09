import 'package:test/test.dart';
import 'package:fordev/validation/validators/validators.dart';
import 'package:fordev/presentation/protocols/protocols.dart';

void main() {
  EmailValidation sut;

  setUp(() {
    sut = EmailValidation('any_field');
  });

  test('Should return null if email is empty', () {
    expect(sut.validate({'any_field' : ''}), null);
  });

  test('Should return null if email is null', () {
    expect(sut.validate({'any_field' : null}), null);
  });

  test('Should return null if email is valid', () {
    expect(sut.validate({'any_field': 'teste.email@test.com'}), null);
  });

  test('Should return null if email is invalid', () {
    expect(sut.validate({'any_field': 'teste.email'}), ValidationError.invalidField);
  });
}

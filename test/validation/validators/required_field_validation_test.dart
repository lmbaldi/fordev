import 'package:test/test.dart';

import 'package:fordev/validation/validators/validators.dart';
import 'package:fordev/presentation/protocols/protocols.dart';

void main() {
  RequiredFieldValidation sut;

  setUp(() {
    sut = RequiredFieldValidation('any_field');
  });

  test('Should return null if value is not empty', () {
    expect(sut.validate('any_field'), null);
  });

  test('Should return error if value is empty', () {
    expect(sut.validate(''), ValidationError.requiredField);
  });

  test('Should return error if value is null', () {
    expect(sut.validate(null), ValidationError.requiredField);
  });
}

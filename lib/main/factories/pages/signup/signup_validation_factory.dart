import 'package:fordev/main/builders/builders.dart';
import 'package:fordev/validation/protocols/protocols.dart';
import 'package:fordev/presentation/protocols/protocols.dart';
import 'package:fordev/validation/validators/validators.dart';

Validation makeSignUpValidation() {
  return ValidationComposite(makeSignUpValidations());
}

List<FieldValidation> makeSignUpValidations(){
  return [
    //usar spread operador para concatenar a lista
    ...ValidationBuilder.field("name").required().min(3).build(),
    ...ValidationBuilder.field("email").required().email().build(),
    ...ValidationBuilder.field('password').required().min(3).build(),
    ...ValidationBuilder.field('passwordConfirmation').required().sameAs('password').build(),
  ];
}

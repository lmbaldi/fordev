import 'package:fordev/main/builders/builders.dart';
import 'package:fordev/validation/protocols/protocols.dart';
import 'package:fordev/presentation/protocols/protocols.dart';
import 'package:fordev/validation/validators/validators.dart';

Validation makeLoginValidation() {
  return ValidationComposite(makeLoginValidations());
}

List<FieldValidation> makeLoginValidations(){
  return [
    //usar spread operador para concatenar a lista
    ...ValidationBuilder.field("email").required().email().build(),
    ...ValidationBuilder.field('password').required().build()
  ];
}

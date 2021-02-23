import '../../../../main/builders/builders.dart';
import '../../../../main/composites/composites.dart';
import '../../../../validation/protocols/protocols.dart';
import '../../../../presentation/protocols/protocols.dart';

Validation makeLoginValidation() {
  return ValidationComposite(makeLoginValidations());
}

List<FieldValidation> makeLoginValidations(){
  return [
    //usar spread operador para concatenar a lista
    ...ValidationBuilder.field("email").required().email().build(),
    ...ValidationBuilder.field('password').required().min(3).build()
  ];
}

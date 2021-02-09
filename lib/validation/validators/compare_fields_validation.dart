import 'package:meta/meta.dart';
import '../../validation/protocols/protocols.dart';
import '../../presentation/protocols/protocols.dart';

class CompareFieldsValidation implements FieldValidation {
  final String field;
  final String valueToCompare;

  CompareFieldsValidation({
    @required this.field,
    @required this.valueToCompare
  });

  ValidationError validate(String value){
    return   ValidationError.invalidField;
  }
}
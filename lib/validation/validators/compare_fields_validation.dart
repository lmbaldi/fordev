import 'package:meta/meta.dart';
import '../../validation/protocols/protocols.dart';
import '../../presentation/protocols/protocols.dart';

class CompareFieldsValidation implements FieldValidation {
  final String field;
  final String fieldToCompare;

  CompareFieldsValidation({
    @required this.field,
    @required this.fieldToCompare
  });

  ValidationError validate(Map input){
    return  input[field] == input[fieldToCompare] ? null : ValidationError.invalidField;
  }
}
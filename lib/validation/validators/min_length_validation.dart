import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import '../../validation/protocols/protocols.dart';
import '../../presentation/protocols/protocols.dart';

class MinLengthValidation extends Equatable implements FieldValidation {
  final String field;
  final int size;

  List get props => [field, size];

  MinLengthValidation({
    @required this.field,
    @required this.size
  });

  ValidationError validate(Map input){
    return  input[field] != null &&
        input[field].length >= size ? null : ValidationError.invalidField;
  }
}
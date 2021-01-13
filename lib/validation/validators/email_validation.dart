import 'package:equatable/equatable.dart';

import '../protocols/protocols.dart';

class EmailValidation extends Equatable implements FieldValidation {
  final String field;

  List get props => [field];

  EmailValidation(this.field);

  String validate(String value) {
    final regex = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    final isValid = value?.isNotEmpty != true || regex.hasMatch(value);
    return isValid ? null : 'Campo inválido';
  }
}

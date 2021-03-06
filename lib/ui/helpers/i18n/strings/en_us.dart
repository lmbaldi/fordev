import 'translations.dart';

class EnUs implements Translations {
  //labels
  String get addAccount => 'Create an account';
  String get confirmPassword => 'Confirm password';
  String get email => 'Email';
  String get enter => 'Enter';
  String get login => 'Login';
  String get name => 'Name';
  String get password => 'Password';
  String get reload => 'Reload';
  String get surveys => 'Survey';

  //messages
  String get invalidCredentials => 'Invalid credentials.';
  String get invalidField => 'Invalid field.';
  String get msgEmailInUse => 'Email is already in use.';
  String get msgRequiredField => 'Required field.';
  String get unexpected => 'Something went wrong. Please try again soon.';
}
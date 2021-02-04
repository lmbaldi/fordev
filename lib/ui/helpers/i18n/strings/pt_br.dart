import 'translations.dart';

class PtBr implements Translations {
  //labels
  String get addAccount => 'Cria conta';
  String get confirmPassword => 'Confirmar senha';
  String get email => 'Email';
  String get enter => 'Entrar';
  String get login => 'Login';
  String get name => 'Nome';
  String get password => 'Senha';

  //messages
  String get invalidCredentials => 'Credenciais Inválidas.';
  String get invalidField => 'Campo inválido.';
  String get msgEmailInUse => 'O email já está em uso.';
  String get msgRequiredField => 'Campo obrigatório.';
  String get unexpected => 'Algo errado aconteceu. Tente novamente em breve.';
}
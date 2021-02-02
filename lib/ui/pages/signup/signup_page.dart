import 'package:flutter/material.dart';
import 'components/components.dart';
import '../../components/components.dart';
import '../../../ui/helpers/helpers.dart';

class SignUpPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    void _hideKeyBoard() {
      final currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
    }

    return Scaffold(
      body: Builder(builder: (context) {

        return GestureDetector(
          onTap: _hideKeyBoard,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                LoginHeader(),
                HeadLine1(text: R.string.addAccount),
                Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Form(
                    child: Column(
                      children: [
                        NameInput(),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: EmailInput(),
                        ),
                        PasswordInput(),
                        Padding(
                          padding: EdgeInsets.only(top: 8.0, bottom: 32.0),
                          child: PasswordConfirmationInput(),
                        ),
                        SignUpButton(),
                        FlatButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.exit_to_app),
                            label: Text(R.string.login)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'components/components.dart';
import '../../components/components.dart';
import '../../../ui/helpers/helpers.dart';
import 'signup_presenter.dart';
import '../../mixins/mixins.dart';

class SignUpPage extends StatelessWidget
    with KeyboardManager, LoadingManager, UiErrorManager, NavigationManager {

  final SignUpPresenter presenter;

  SignUpPage(this.presenter);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Builder(builder: (context) {

        handleLoading(context, presenter.isLoadingStream);
        handleMainError(context, presenter.mainErrorStream);
        handleNavigation(presenter.navigateToStream, clear: true);

        return GestureDetector(
          onTap:  () => hideKeyBoard(context),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                LoginHeader(),
                HeadLine1(text: R.string.addAccount),
                Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Provider(
                    create: (_) => presenter,
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
                              onPressed: presenter.goToLoginPage,
                              icon: Icon(Icons.exit_to_app),
                              label: Text(R.string.login)),
                        ],
                      ),
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

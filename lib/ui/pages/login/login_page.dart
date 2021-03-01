import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import '../pages.dart';
import 'components/components.dart';
import '../../components/components.dart';
import '../../../ui/helpers/helpers.dart';
import '../../mixins/mixins.dart';

class LoginPage extends StatelessWidget
      with KeyboardManager, LoadingManager, UiErrorManager, NavigationManager {

  final LoginPresenter presenter;

  LoginPage(this.presenter);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Builder(builder: (context) {

        handleLoading(context, presenter.isLoadingStream);
        handleMainError(context, presenter.mainErrorStream);
        handleNavigation(presenter.navigateToStream, clear: true);

        return GestureDetector(
          onTap: () => hideKeyBoard(context),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                LoginHeader(),
                HeadLine1(text: 'Login'),
                Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Provider(
                    create: (_) => presenter,
                    child: Form(
                      child: Column(
                        children: [
                          EmailInput(),
                          Padding(
                            padding: EdgeInsets.only(top: 8.0, bottom: 32.0),
                            child: PasswordInput(),
                          ),
                          LoginButton(),
                          FlatButton.icon(
                              onPressed: presenter.goToSignUpPage,
                              icon: Icon(Icons.person),
                              label: Text(R.string.addAccount)),
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

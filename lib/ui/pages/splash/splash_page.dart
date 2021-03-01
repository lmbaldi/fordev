import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../mixins/mixins.dart';
import 'splash.dart';

class SplashPage extends StatelessWidget with KeyboardManager, NavigationManager {

  final SplashPresenter presenter;

  SplashPage({@required this.presenter});

  @override
  Widget build(BuildContext context) {
    presenter.checkAccount();
    return Scaffold(
      appBar: AppBar(
        title: Text('ForDev'),
      ),
      body: Builder(
        builder: (context) {
          handleNavigation(presenter.navigateToStream, clear: true);
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:fordev/ui/pages/pages.dart';
import 'package:fordev/main/factories/factories.dart';

Widget makeLoginPage() {
    return LoginPage(makeLoginPresenter());
}

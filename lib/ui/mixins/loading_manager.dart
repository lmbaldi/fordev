import 'package:flutter/cupertino.dart';

import '../components/components.dart';

mixin LoadingManager{

  void handleLoading(BuildContext context,  Stream<bool> stream){
    stream.listen((isLoading) {
      if (isLoading == true) {
        showLoding(context);
      } else {
        hideLoaging(context);
      }
    });
  }
}


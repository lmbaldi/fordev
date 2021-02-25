import 'package:flutter/material.dart';
import '../../components/components.dart';
import './components/components.dart';

import '../../helpers/helpers.dart';
import '../pages.dart';

class SurveyResultPage extends StatelessWidget {
  final SurveyResultPresenter presenter;

  SurveyResultPage(this.presenter);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(R.string.surveys),
      ),
      body: Builder(builder: (context) {
        presenter.isLoadingStream.listen((isLoading) {
          if (isLoading == true) {
            showLoding(context);
          } else {
            hideLoaging(context);
          }
        });
        presenter.loadData();

        return StreamBuilder<dynamic>(
          stream: presenter.surveyResultStream,
          builder: (context, snapshot) {
            if(snapshot.hasError){
              return ReloadScreen(error: snapshot.error, reload: presenter.loadData);
            }
            if(snapshot.hasData){
              return SurveyResult();
            }
            return SizedBox(height: 0,);
          }
        );
      }),
    );
  }
}



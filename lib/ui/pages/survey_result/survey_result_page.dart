import 'package:flutter/material.dart';
import '../../components/components.dart';
import './components/components.dart';

import '../../mixins/mixins.dart';
import '../../helpers/helpers.dart';
import '../pages.dart';

class SurveyResultPage extends StatelessWidget
    with KeyboardManager, LoadingManager, SessionManager {
  final SurveyResultPresenter presenter;

  SurveyResultPage(this.presenter);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(R.string.surveys),
      ),
      body: Builder(builder: (context) {

        handleLoading(context, presenter.isLoadingStream);
        handleSessionExpired(presenter.isSessionExpiredStream);
        presenter.loadData();

        return StreamBuilder<SurveyResultViewModel>(
          stream: presenter.surveyResultStream,
          builder: (context, snapshot) {
            if(snapshot.hasError){
              return ReloadScreen(error: snapshot.error, reload: presenter.loadData);
            }
            if(snapshot.hasData){
              return SurveyResult(snapshot.data);
            }
            return SizedBox(height: 0,);
          }
        );
      }),
    );
  }
}



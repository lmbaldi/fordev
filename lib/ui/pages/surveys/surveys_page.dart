import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'surveys_presenter.dart';
import 'components/components.dart';
import '../../helpers/helpers.dart';
import '../../components/components.dart';
import '../../../ui/pages/surveys/surveys.dart';
import '../../mixins/mixins.dart';

class SurveysPage extends StatelessWidget
    with KeyboardManager, LoadingManager, NavigationManager, SessionManager {

  final SurveysPresenter presenter;

  SurveysPage(this.presenter);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(R.string.surveys),),
      body: Builder(
        builder: (context) {

          handleLoading(context, presenter.isLoadingStream);
          handleNavigation(presenter.navigateToStream);
          handleSessionExpired(presenter.isSessionExpiredStream);
          presenter.loadData();

          return  StreamBuilder<List<SurveyViewModel>>(
            stream: presenter.surveysStream,
            builder: (context, snapshot) {
              if(snapshot.hasError){
                return ReloadScreen(error: snapshot.error, reload: presenter.loadData);
              }
              if(snapshot.hasData){
                return Provider(
                    create: (_) => presenter,
                    child: SurveyItems(snapshot.data)
                );
              }
              return SizedBox(height: 0);
            }
          );
        },
      ),
    );
  }
}







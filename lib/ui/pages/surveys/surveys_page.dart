import 'package:flutter/material.dart';
import 'package:fordev/ui/pages/surveys/surveys.dart';

import 'surveys_presenter.dart';
import 'components/components.dart';
import '../../helpers/helpers.dart';
import '../../components/components.dart';

class SurveysPage extends StatelessWidget {

  final SurveysPresenter presenter;

  SurveysPage(this.presenter);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(R.string.surveys),),
      body: Builder(
        builder: (context) {
          presenter.isLoadingStream.listen((isLoading) {
            if (isLoading == true) {
              showLoding(context);
            } else {
              hideLoaging(context);
            }
          });
          presenter.loadData();

          return  StreamBuilder<List<SurveyViewModel>>(
            stream: presenter.surveysStream,
            builder: (context, snapshot) {
              if(snapshot.hasError){
                return ReloadScreen(error: snapshot.error, reload: presenter.loadData);
              }
              if(snapshot.hasData){
                return SurveyItems(snapshot.data);
              }
              return SizedBox(height: 0);
            }
          );
        },
      ),
    );
  }
}







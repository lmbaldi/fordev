import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'surveys_presenter.dart';
import 'components/components.dart';
import '../../helpers/helpers.dart';
import '../../components/components.dart';
import '../../../ui/pages/surveys/surveys.dart';

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

          presenter.isSessionExpiredStream.listen((isExpired) {
            if (isExpired == true) {
              Get.offAllNamed('/login');
            }
          });

          presenter.navigateToStream.listen((page) {
            if (page?.isNotEmpty == true) {
              Get.toNamed(page);
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







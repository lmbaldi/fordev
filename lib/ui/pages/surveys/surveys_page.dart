import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'surveys_presenter.dart';
import 'components/components.dart';
import '../../helpers/helpers.dart';
import '../../components/components.dart';
import '../../../ui/pages/surveys/surveys.dart';
import '../../mixins/mixins.dart';

class SurveysPage extends StatefulWidget{

  final SurveysPresenter presenter;

  SurveysPage(this.presenter);

  @override
  _SurveysPageState createState() => _SurveysPageState();
}

class _SurveysPageState extends State<SurveysPage>
    with KeyboardManager, LoadingManager, NavigationManager, SessionManager, RouteAware{
  @override
  Widget build(BuildContext context) {
    
    Get.find<RouteObserver>().subscribe(this, ModalRoute.of(context));
    
    return Scaffold(
      appBar: AppBar(title: Text(R.string.surveys),),
      body: Builder(
        builder: (context) {

          handleLoading(context, widget.presenter.isLoadingStream);
          handleNavigation(widget.presenter.navigateToStream);
          handleSessionExpired(widget.presenter.isSessionExpiredStream);
          widget.presenter.loadData();

          return  StreamBuilder<List<SurveyViewModel>>(
            stream: widget.presenter.surveysStream,
            builder: (context, snapshot) {
              if(snapshot.hasError){
                return ReloadScreen(error: snapshot.error, reload: widget.presenter.loadData);
              }
              if(snapshot.hasData){
                return Provider(
                    create: (_) => widget.presenter,
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

  @override
  void didPopNext() {
    widget.presenter.loadData();
  }

  @override
  void dispose(){
    Get.find<RouteObserver>().unsubscribe(this);
    super.dispose();
  }
}







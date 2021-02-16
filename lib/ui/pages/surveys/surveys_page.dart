import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
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
    presenter.loadData();
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

          return  StreamBuilder<List<SurveyViewModel>>(
            stream: presenter.loadSurveysStream,
            builder: (context, snapshot) {
              if(snapshot.hasError){
                return Column(
                  children: [
                    Text(snapshot.error),
                    RaisedButton(
                      child: Text(R.string.reload),
                      onPressed: (){},
                    ),
                  ],
                );
              }
              if(snapshot.hasData){
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: CarouselSlider(
                    options: CarouselOptions(
                      enlargeCenterPage: true,
                      aspectRatio: 1,
                    ),
                    items: snapshot.data.map((viewModel) => SurveyItem(viewModel)).toList(),

                  ),
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




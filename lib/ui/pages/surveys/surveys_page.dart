import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'components/components.dart';
import '../../helpers/helpers.dart';
import 'surveys_presenter.dart';

class SurveysPage extends StatelessWidget {

  final SurveysPresenter presenter;

  SurveysPage(this.presenter);

  @override
  Widget build(BuildContext context) {
    presenter.loadData();
    return Scaffold(
      appBar: AppBar(title: Text(R.string.surveys),),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: CarouselSlider(
          options: CarouselOptions(
            enlargeCenterPage: true,
            aspectRatio: 1,
          ),
          items: [
            SurveyItem(),
            SurveyItem(),
            SurveyItem(),
          ],
        ),
      ),
    );
  }
}





import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/ui/helpers/errors/errors.dart';
import 'package:fordev/ui/helpers/helpers.dart';
import 'package:fordev/ui/pages/surveys/surveys.dart';
import 'package:mockito/mockito.dart';
import 'package:get/get.dart';
import 'package:fordev/ui/pages/pages.dart';

//classe mock criada porque nao se pode criar uma instancia de uma inferface
class SurveysPresenterSpy extends Mock implements SurveysPresenter {

}

void main () {

  SurveysPresenterSpy presenter;
  StreamController<bool> isLoadingController;
  StreamController<List<SurveyViewModel>> surveysController;
  StreamController<String> navigateToController;

  void initStreams(){
    isLoadingController = StreamController<bool>();
    surveysController = StreamController<List<SurveyViewModel>>();
    navigateToController = StreamController<String>();
  }

  void mockStreams(){
    when(presenter.isLoadingStream).thenAnswer((_) => isLoadingController.stream);
    when(presenter.surveysStream).thenAnswer((_) => surveysController.stream);
    when(presenter.navigateToStream).thenAnswer((_) => navigateToController.stream);
  }

  void closeStreams(){
    isLoadingController.close();
    surveysController.close();
    navigateToController.close();
  }

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SurveysPresenterSpy();
    initStreams();
    mockStreams();
    final surveysPage = GetMaterialApp(
      initialRoute: '/surveys',
      getPages: [
        GetPage(name: '/surveys', page: () => SurveysPage(presenter)),
        GetPage(name: '/any_route', page: () => Scaffold(body: Text('fake page'))),
      ],
    );
    await tester.pumpWidget(surveysPage);
  }

  List<SurveyViewModel> makeSurveys() => [
    SurveyViewModel(id: '1', question: 'Question 1', date: 'Date 1', didAnswer: true),
    SurveyViewModel(id: '2', question: 'Question 2', date: 'Date 2', didAnswer: false)
  ];

  tearDown((){
    closeStreams();
  });

  testWidgets('Should call LoadSurveys on page load', (WidgetTester tester) async {
    await loadPage(tester);
     verify(presenter.loadData()).called(1);
  });

  testWidgets('Should handle loading correctly',(WidgetTester tester) async {
    await loadPage(tester);

    isLoadingController.add(true);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    isLoadingController.add(false);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsNothing);

    isLoadingController.add(true);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    isLoadingController.add(null);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Should present error if surveysStream fails',(WidgetTester tester) async {
    await loadPage(tester);
    surveysController.addError(UIError.unexpected.description);
    await tester.pump();
    expect(find.text(R.string.unexpected), findsOneWidget);
    expect(find.text(R.string.reload), findsOneWidget);
    expect(find.text('Question 1'), findsNothing);

  });

  testWidgets('Should present list if surveysStream succeeds',(WidgetTester tester) async {
    await loadPage(tester);

    surveysController.add(makeSurveys());
    await tester.pump();
    expect(find.text(R.string.unexpected), findsNothing);
    expect(find.text(R.string.reload), findsNothing);
    expect(find.text('Question 1'), findsWidgets);
    expect(find.text('Question 2'), findsWidgets);
    expect(find.text('Date 1'), findsWidgets);
    expect(find.text('Date 2'), findsWidgets);

  });

  testWidgets('Should call LoadSurveys on reload button click', (WidgetTester tester) async {
    await loadPage(tester);
    surveysController.addError(UIError.unexpected.description);
    await tester.pump();
    await tester.tap(find.text(R.string.reload));

    verify(presenter.loadData()).called(2);
  });

  testWidgets('Should call go to SurveyResult on survey link', (WidgetTester tester) async {
    await loadPage(tester);

    surveysController.add(makeSurveys());
    await tester.pump();
    final button = find.text('Question 1');
    await tester.tap(button);
    await tester.pump();

    verify(presenter.goToSurveyResult('1')).called(1);
  });

  testWidgets('Should change page',(WidgetTester tester) async {
    await loadPage(tester);

    navigateToController.add('/any_route');
    await tester.pumpAndSettle();
    expect(Get.currentRoute, '/any_route');
    expect(find.text('fake page'), findsOneWidget);
  });

}
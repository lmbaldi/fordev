
import 'dart:async';

import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_test_utils/image_test_utils.dart';
import 'package:fordev/ui/pages/pages.dart';
import 'package:fordev/ui/helpers/helpers.dart';
import 'package:fordev/ui/helpers/errors/errors.dart';
import 'package:fordev/ui/pages/survey_result/components/components.dart';
import '../helpers/helpers.dart';

//classe mock criada porque nao se pode criar uma instancia de uma inferface
class SurveyResultPresenterSpy extends Mock implements SurveyResultPresenter {}

void main () {

  SurveyResultPresenterSpy presenter;
  StreamController<bool> isLoadingController;
  StreamController<bool> isSessionExpiredController;
  StreamController<SurveyResultViewModel> surveyResultController;

  void initStreams(){
    isLoadingController = StreamController<bool>();
    isSessionExpiredController = StreamController<bool>();
    surveyResultController = StreamController<SurveyResultViewModel>();
  }

  void mockStreams(){
    when(presenter.isLoadingStream).thenAnswer((_) => isLoadingController.stream);
    when(presenter.isSessionExpiredStream).thenAnswer((_) => isSessionExpiredController.stream);
    when(presenter.surveyResultStream).thenAnswer((_) => surveyResultController.stream);
  }

  void closeStreams(){
    isLoadingController.close();
    isSessionExpiredController.close();
    surveyResultController.close();
  }

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SurveyResultPresenterSpy();
    initStreams();
    mockStreams();
    await provideMockedNetworkImages(() async {
      await tester.pumpWidget(
        makePage(
          path: '/survey_result/any_survey_id',
          page: () => SurveyResultPage(presenter)
        )
      );
    });
  }

  SurveyResultViewModel mackSurveyResult() => SurveyResultViewModel(
    surveyId: 'Any id',
    question: 'Question',
    answers: [
      SurveyAnswerViewModel(
        image: 'Image 0',
        answer: 'Answer 0',
        isCurrentAccountAnswer: true,
        percent: '60%'
      ),
      SurveyAnswerViewModel(
        answer: 'Answer 1',
        isCurrentAccountAnswer: false,
        percent: '40%'
      ),
    ]
  );

  tearDown((){
    closeStreams();
  });

  testWidgets('Should call LoadSurveyResult on page load', (WidgetTester tester) async {
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

    surveyResultController.addError(UIError.unexpected.description);
    await tester.pump();
    expect(find.text(R.string.unexpected), findsOneWidget);
    expect(find.text(R.string.reload), findsOneWidget);
    expect(find.text('Question'), findsNothing);
  });


  testWidgets('Should call LoadSurveyResult on reload button click', (WidgetTester tester) async {
    await loadPage(tester);
    surveyResultController.addError(UIError.unexpected.description);
    await tester.pump();
    await tester.tap(find.text(R.string.reload));

    verify(presenter.loadData()).called(2);
  });

  testWidgets('Should present valid data if surveysStream succeeds',(WidgetTester tester) async {
    await loadPage(tester);

    surveyResultController.add(mackSurveyResult());
    await provideMockedNetworkImages(() async {
      await tester.pump();
    });

    expect(find.text(R.string.unexpected), findsNothing);
    expect(find.text(R.string.reload), findsNothing);
    expect(find.text('Question'), findsOneWidget);
    expect(find.text('Answer 0'), findsOneWidget);
    expect(find.text('Answer 1'), findsOneWidget);
    expect(find.text('60%'), findsOneWidget);
    expect(find.text('40%'), findsOneWidget);
    expect(find.byType(ActiveIcon), findsOneWidget);
    expect(find.byType(DisableIcon), findsOneWidget);

    final image = tester.widget<Image>(find.byType(Image)).image as NetworkImage;
    expect(image.url, 'Image 0');
  });

  testWidgets('Should logout',(WidgetTester tester) async {
    await loadPage(tester);

    isSessionExpiredController.add(true);
    await tester.pumpAndSettle();
    expect(currentRoute, '/login');
    expect(find.text('fake login'), findsOneWidget);
  });

  testWidgets('Should not logout',(WidgetTester tester) async {
    await loadPage(tester);

    isSessionExpiredController.add(false);
    await tester.pumpAndSettle();
    expect(currentRoute, '/survey_result/any_survey_id');

    isSessionExpiredController.add(null);
    await tester.pumpAndSettle();
    expect(currentRoute, '/survey_result/any_survey_id');
  });

  testWidgets('Should call save on list item click', (WidgetTester tester) async {
    await loadPage(tester);
    surveyResultController.add(mackSurveyResult());
    await provideMockedNetworkImages(() async {
      await tester.pump();
    });
    await tester.tap(find.text('Answer 1'));
    verify(presenter.save(answer: 'Answer 1')).called(1);
  });

  testWidgets('Should not call save on current answer click', (WidgetTester tester) async {
    await loadPage(tester);
    surveyResultController.add(mackSurveyResult());
    await provideMockedNetworkImages(() async {
      await tester.pump();
    });
    await tester.tap(find.text('Answer 0'));
    verifyNever(presenter.save(answer: 'Answer 0'));
  });

}
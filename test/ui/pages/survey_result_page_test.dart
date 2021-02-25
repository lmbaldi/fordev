
import 'package:flutter_test/flutter_test.dart';
import 'package:image_test_utils/image_test_utils.dart';
import 'package:mockito/mockito.dart';
import 'package:get/get.dart';
import 'package:fordev/ui/pages/pages.dart';

//classe mock criada porque nao se pode criar uma instancia de uma inferface
class SurveyResultPresenterSpy extends Mock implements SurveyResultPresenter {

}

void main () {

  SurveyResultPresenterSpy presenter;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SurveyResultPresenterSpy();
    final surveysPage = GetMaterialApp(
      initialRoute: '/survey_result/any_survey_id;',
      getPages: [
        GetPage(name: '/survey_result/:survey_id', page: () => SurveyResultPage(presenter))
      ],
    );
    provideMockedNetworkImages(() async {
      await tester.pumpWidget(surveysPage);
    });
  }

  testWidgets('Should call LoadSurveyResult on page load', (WidgetTester tester) async {
    await loadPage(tester);
     verify(presenter.loadData()).called(1);
  });


}
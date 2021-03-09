import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import '../survey_result.dart';
import './components.dart';

class SurveyResult extends StatelessWidget {

  final SurveyResultViewModel viewModel;
  final void Function({@required String answer}) onSave;

  const SurveyResult({@required this.viewModel, @required this.onSave});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        if (index == 0) {
          return SurveyHeader(viewModel.question);
        }
        final answer = viewModel.answers[index - 1];
        return GestureDetector(
          onTap: () => answer.isCurrentAccountAnswer
              ? null
              : onSave(answer: answer.answer),
          child: SurveyAnswer(answer),
        );// subtrai um porque o primeiro elemento do array e a pergunta
      },
      itemCount: viewModel.answers.length + 1,//somar um por causa da pergunta
    );
  }
}

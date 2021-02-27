import 'package:flutter/material.dart';
import '../survey_result.dart';

class SurveyResult extends StatelessWidget {

  final SurveyResultViewModel viewModel;

  const SurveyResult(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        if (index == 0) {
          return Container(
            padding:
            EdgeInsets.only(top: 40, bottom: 20, left: 20, right: 20),
            decoration: BoxDecoration(
              color: Theme.of(context).disabledColor.withAlpha(90),
            ),
            child: Text(viewModel.question),
          );
        }
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(14.0),
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  viewModel.answers[index - 1].image != null
                  ? Image.network(
                    viewModel.answers[index - 1].image,
                    width: 40,
                  )
                  : SizedBox(height: 0),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        viewModel.answers[index - 1].answer,// subtrai um porque o primeiro elemento do array e a pergunta
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  Text(
                  viewModel.answers[index - 1].percent,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColorDark,
                    ),
                  ),
                  viewModel.answers[index -1].isCurrentAccountAnswer
                  ? ActiveIcon()
                  : DisableIcon()
                ],
              ),
            ),
            Divider(
              height: 1,
            ),
          ],
        );
      },
      itemCount: viewModel.answers.length + 1,//somar um por causa da pergunta
    );
  }
}

class ActiveIcon extends StatelessWidget {
   @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10),
      child: Icon(
        Icons.check_circle,
        color: Theme.of(context).highlightColor,
      ),
    );
  }
}

class DisableIcon extends StatelessWidget {
   @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10),
      child: Icon(
        Icons.check_circle,
        color: Theme.of(context).disabledColor,
      ),
    );
  }
}
import 'package:flutter/material.dart';
import './components.dart';
import '../survey_result.dart';

class SurveyAnswer extends StatelessWidget {

  final SurveyAnswerViewModel viewModel;

  const SurveyAnswer(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildItem(context),
        Divider(
          height: 1,
        ),
      ],
    );
  }

  Container _buildItem(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(14.0),
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            viewModel.image != null
                ? Image.network(
              viewModel.image,
              width: 40,
            )
                : SizedBox(height: 0),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  viewModel.answer,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            Text(
              viewModel.percent,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColorDark,
              ),
            ),
            viewModel.isCurrentAccountAnswer
                ? ActiveIcon()
                : DisableIcon()
          ],
        ),
      );
  }
}
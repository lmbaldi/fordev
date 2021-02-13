import 'package:flutter/material.dart';

class SurveyItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Theme.of(context).secondaryHeaderColor,
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, 1),
                  spreadRadius: 0,
                  blurRadius: 2,
                  color: Colors.black
              )
            ],
            borderRadius: BorderRadius.all(Radius.circular(10))

        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("15 ago 2021",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 20,),
            Text("which is the favourite country",
              style: TextStyle(
                  color: Colors.white, fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
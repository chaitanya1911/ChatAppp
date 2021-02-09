import 'package:flutter/material.dart';

class DateT extends StatelessWidget {
  final int day, month, year;
  final String special;
  DateT({this.day, this.month, this.year, this.special});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(child: Builder(
        builder: (context) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 20),
            color: Colors.transparent,
            child: (special == null)
                ? Text(
                    '$day $month $year',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  )
                : Text(
                    '$special',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
          );
        },
      )),
    );
  }
}

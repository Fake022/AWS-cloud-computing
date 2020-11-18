import 'package:flutter/material.dart';

class Analysis extends StatefulWidget {
  Analysis();
  @override
  _AnalysisState createState() => _AnalysisState();
}

class _AnalysisState extends State<Analysis> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "ANALYSIS",
        style: TextStyle(
            color: Colors.purple, fontSize: 25.0, fontFamily: "WorkSansBold"),
      ),
    );
  }
}

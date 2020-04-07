import 'package:flutter/material.dart';
import 'package:the_winery/ui/constants.dart';

class LoadingDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: mainColor.withOpacity(0.8),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.3,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            SizedBox(
              height: 25,
            ),
            Text(
              "Adding wine to database, please wait...",
              style: subTitleStyle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

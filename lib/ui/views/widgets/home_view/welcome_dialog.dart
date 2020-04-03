import 'package:flutter/material.dart';

class WelcomeDialog extends StatelessWidget {
  final Function addCellar;
  final Text title;
  final Text content;
  final TextEditingController controller = TextEditingController();

  WelcomeDialog({this.addCellar, this.title, this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.3,
      child: AlertDialog(
        title: title,
        content: content,
        actions: <Widget>[
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width*0.7),
            child: Row(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(hintText: "Cellar Name"),
                  ),
                ),
                Spacer(),
                RaisedButton(
                  color: Colors.white,
                  onPressed: () {
                    addCellar(controller.text);
                    Navigator.pop(context);
                  },
                  child: Text("Lets go!"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

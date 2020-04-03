import 'package:flutter/material.dart';
import 'package:wine_cellar/core/models/profile.dart';
import 'package:wine_cellar/core/viewmodels/views/settings_model.dart';

import '../../../constants.dart';

class Cellars extends StatelessWidget {
  final SettingsModel model;

  const Cellars({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.edit,
        color: mainColor,
        size: 40,
      ),
      title: Text("Edit your Cellars"),
      subtitle: StreamBuilder<List<Profile>>(
          stream: model.profiles,
          builder: (context, snapshot) {
            final double itemExtent = MediaQuery.of(context).size.height * 0.1;
            return snapshot.hasData
                ? Container(
                    height: itemExtent * snapshot.data.length,
                    child: ListView.builder(
                      itemExtent: itemExtent,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) => model.index == index
                          ? OptionsTile(
                              profile: snapshot.data[index],
                            )
                          : Card(
                              elevation: 2,
                              child: ListTile(
                                onTap: () => print("tappin"),
                                onLongPress: () => model.showOptions(index),
                                leading: Padding(
                                  padding: EdgeInsets.only(top: 7),
                                  child: CircleAvatar(
                                    child: Text(
                                      snapshot.data[index].displayName
                                          .substring(0, 1)
                                          .toUpperCase(),
                                    ),
                                  ),
                                ),
                                title: Row(children: [
                                  Text(snapshot.data[index].displayName)
                                ]),
                                dense: true,
                              ),
                            ),
                    ),
                  )
                : Container();
          }),
    );
  }
}

class OptionsTile extends StatefulWidget {
  final Profile profile;

  const OptionsTile({Key key, this.profile}) : super(key: key);

  @override
  _OptionsTileState createState() => _OptionsTileState();
}

class _OptionsTileState extends State<OptionsTile>
    with TickerProviderStateMixin {
  AnimationController _controller;

  Animation<Color> _animation1;
  Animation<Color> _animation2;

  @override
  void dispose() {
    print("disposing animated number");
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animation1 = ColorTween(begin: Colors.white, end: Colors.grey[400])
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _animation2 = ColorTween(begin: Colors.white, end: Colors.grey[500])
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation1,
      builder: (context, child) => Card(
        color: _animation1.value,
        child: ListTile(
          onTap: () => print("tappin"),
          leading: AnimatedBuilder(
            animation: _animation2,
            builder: (context,child) =>  CircleAvatar(
              foregroundColor: Colors.red,
              backgroundColor: _animation2.value,
              child: Text(
                widget.profile.displayName.substring(0, 1).toUpperCase(),
              ),
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.edit),
                splashColor: Colors.red,
                onPressed: () => Navigator.pushNamed(context, 'cellar-edit',arguments: widget.profile),
              ),
              IconButton(
                icon: Icon(Icons.delete),
                splashColor: Colors.red,
                onPressed: () => print("Delete "),
              )
            ],
          ),
          dense: true,
        ),
      ),
    );
  }
}

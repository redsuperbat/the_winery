import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wine_cellar/core/viewmodels/views/register_model.dart';
import 'package:wine_cellar/ui/constants.dart';
import 'package:wine_cellar/ui/views/base_widget.dart';
import 'package:wine_cellar/core/services/user_service.dart';

class RegisterView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final emailRegex = RegExp(r"[\w-]+@([\w-]+\.)+[\w-]+");
  @override
  Widget build(BuildContext context) {
    return BaseWidget<RegisterModel>(
      model: RegisterModel(userService: Provider.of<UserService>(context)),
      onModelReady: (model) => {},
      builder: (context, model, child) => Scaffold(
        body: SingleChildScrollView(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2),
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 45),
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Welcome to The Winery!",
                          textAlign: TextAlign.center,
                          style: titleStyle,
                        ),
                        Text(
                          "Please Register an account to continue.",
                          textAlign: TextAlign.center,
                          style: subTitleStyle,
                        ),
                      ],
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: model.emailController,
                          decoration: InputDecoration(hintText: "Email"),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Email is required";
                            } else if (!emailRegex.hasMatch(value)) {
                              return "Field must contain a valid email-address";
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(hintText: "Password"),
                          controller: model.passwordController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "password is required";
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          obscureText: true,
                          decoration:
                              InputDecoration(hintText: "Repeat Password"),
                          controller: model.verifyPwdController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Password is required";
                            } else if (value != model.passwordController.text) {
                              return "Passwords must match";
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: RaisedButton(
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          Map result = await model.register();
                          result['success']
                              ? Navigator.pushReplacementNamed(context, 'home')
                              : await showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (_) => RegisterDialog(
                                    title: result['message'],
                                  ),
                                );
                        }
                      },
                      child: model.busy
                          ? CircularProgressIndicator()
                          : Text("Register"),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RegisterDialog extends StatelessWidget {
  final String title;
  RegisterDialog({this.title});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      actions: <Widget>[
        FlatButton(
            onPressed: () => Navigator.of(context).pop(), child: Text("Return"))
      ],
    );
  }
}

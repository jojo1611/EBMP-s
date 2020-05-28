import 'package:example/auth_services.dart';
import 'package:flutter/material.dart';
class ProviderClass extends InheritedWidget {
  final AuthService auth;

  ProviderClass({Key key, Widget child, this.auth}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static ProviderClass of(BuildContext context) =>
      // ignore: deprecated_member_use
      (context.inheritFromWidgetOfExactType(ProviderClass) as ProviderClass);
}
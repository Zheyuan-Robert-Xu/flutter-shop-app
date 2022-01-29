import 'package:flutter/material.dart';

class CustomRoute<T> extends MaterialPageRoute<T> {
  //T for placeholder for the generic type that can be passed in use
  //T, S, and U for generics that have a single type parameter and where the surrounding type makes its meaning obvious.
  CustomRoute({
    WidgetBuilder? builder,
    RouteSettings? settings,
  }) : super(builder: builder!, settings: settings);
  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // TODO: implement buildTransitions
    if (settings.name == '/') {
      //the first route that loads in the app
      return child;
    }
    return FadeTransition(
      //a custom royte with a very simple fade in transition
      opacity: animation,
      child: child,
    );
  }
}

class CustomPageTransitionBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
      PageRoute<T> route,
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    // TODO: implement buildTransitions
    if (route.settings.name == '/') {
      //the first route that loads in the app
      return child;
    }
    return FadeTransition(
      //a custom royte with a very simple fade in transition
      opacity: animation,
      child: child,
    );
  }
}

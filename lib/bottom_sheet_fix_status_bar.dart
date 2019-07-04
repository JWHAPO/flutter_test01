//Flutter Modal Bottom Sheet
//Modified by Giorgio Bertolotti
//Based on https://gist.github.com/crimsonsuv/b25d5ebd04236f9be2aa66accba19446

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

const Duration _kBottomSheetDuration = const Duration(milliseconds: 200);

class _ModalBottomSheetLayout extends SingleChildLayoutDelegate {
  _ModalBottomSheetLayout(
      this.progress, this.bottomInset, this.statusBarHeight);

  final double progress;
  final double bottomInset;
  final double statusBarHeight;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return new BoxConstraints(
        minWidth: constraints.maxWidth,
        maxWidth: constraints.maxWidth,
        minHeight: 0.0,
        maxHeight: constraints.maxHeight - statusBarHeight);
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return new Offset(
        0.0, size.height - bottomInset - childSize.height * progress);
  }

  @override
  bool shouldRelayout(_ModalBottomSheetLayout oldDelegate) {
    return progress != oldDelegate.progress ||
        bottomInset != oldDelegate.bottomInset;
  }
}

class _ModalBottomSheet<T> extends StatefulWidget {
  const _ModalBottomSheet({Key key, this.route}) : super(key: key);

  final _ModalBottomSheetRoute<T> route;

  @override
  _ModalBottomSheetState<T> createState() => new _ModalBottomSheetState<T>();
}

class _ModalBottomSheetState<T> extends State<_ModalBottomSheet<T>> {
  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
        onTap: widget.route.dismissOnTap ? () => Navigator.pop(context) : null,
        child: new AnimatedBuilder(
            animation: widget.route.animation,
            builder: (BuildContext context, Widget child) {
              double bottomInset = widget.route.resizeToAvoidBottomPadding
                  ? MediaQuery.of(context).viewInsets.bottom
                  : 0.0;
              return new ClipRect(
                  child: new CustomSingleChildLayout(
                      delegate: new _ModalBottomSheetLayout(
                          widget.route.animation.value,
                          bottomInset,
                          widget.route.statusBarHeight),
                      child: new BottomSheet(
                          animationController:
                              widget.route._animationController,
                          onClosing: () => Navigator.pop(context),
                          builder: widget.route.builder)));
            }));
  }
}

class _ModalBottomSheetRoute<T> extends PopupRoute<T> {
  _ModalBottomSheetRoute({
    this.builder,
    this.theme,
    this.barrierLabel,
    RouteSettings settings,
    this.resizeToAvoidBottomPadding,
    this.dismissOnTap,
    this.statusBarHeight,
  }) : super(settings: settings);

  final WidgetBuilder builder;
  final ThemeData theme;
  final bool resizeToAvoidBottomPadding;
  final bool dismissOnTap;
  final double statusBarHeight;

  @override
  Duration get transitionDuration => _kBottomSheetDuration;

  @override
  bool get barrierDismissible => false;

  @override
  final String barrierLabel;

  @override
  Color get barrierColor => Colors.black54;

  AnimationController _animationController;

  @override
  AnimationController createAnimationController() {
    assert(_animationController == null);
    _animationController =
        BottomSheet.createAnimationController(navigator.overlay);
    return _animationController;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    Widget bottomSheet = new MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: new _ModalBottomSheet<T>(route: this),
    );
    if (theme != null) bottomSheet = new Theme(data: theme, child: bottomSheet);
    return bottomSheet;
  }
}

Future<T> showModalBottomSheetApp<T>({
  @required BuildContext context,
  @required WidgetBuilder builder,
  bool dismissOnTap: false,
  bool resizeToAvoidBottomPadding: true,
  double statusBarHeight: 0,
}) {
  assert(context != null);
  assert(builder != null);
  return Navigator.push(
      context,
      _ModalBottomSheetRoute<T>(
        builder: builder,
        theme: Theme.of(context, shadowThemeOnly: true),
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        resizeToAvoidBottomPadding: resizeToAvoidBottomPadding,
        dismissOnTap: dismissOnTap,
        statusBarHeight: statusBarHeight,
      ));
}
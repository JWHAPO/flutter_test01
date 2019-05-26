import 'package:flutter/material.dart';

@immutable
class Messagge{
  final String title;
  final String body;

  const Messagge({
    @required this.title,
    @required this.body
});
}
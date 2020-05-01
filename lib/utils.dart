import 'package:flutter/material.dart';

class device{
  String name;
  IconData icon;
  int id;

  device({this.name, this.icon, this.id});
}
class utils{
  static List<device>devices=new List<device>();
}
import 'dart:convert';

import 'package:dart_json_mapper/dart_json_mapper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
@jsonSerializable
class device{
  @JsonProperty(name: 'name')
  String name;
  @JsonProperty(ignore: true)
  String icon;
  @JsonProperty(name: 'id')
  int id;

  device({this.name, this.icon, this.id});
  Map<String,dynamic> toJson() => {
    'name': name,
    'icon': icon,
    'id': id
  };
  factory device.fromJson(Map<String, dynamic> json)
  {

return new device(
  name: json['name'],
  icon: json['icon'],
  id: json['id'],
);
    }
}
class utils{
  static List<device>devices=new List<device>();
  static Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
 static Future<void> save()
  async {

   String _data= jsonEncode(utils.devices.map((e) => e.toJson()).toList());
   print(_data);
  SharedPreferences prefs = await utils._prefs;

  prefs.setString("data", _data);
 prefs.commit();

  }
  static void load()
  {
    _prefs.then((SharedPreferences prefs) {

      if(prefs.containsKey("data")) {
        String _data= prefs.getString("data");
        List responseJson = json.decode(_data);
        utils.devices =responseJson.map((m) => new device.fromJson(m)).toList();
        print(_data);
       // utils.devices = jsonDecode(_data);
      }
    });
  }
}
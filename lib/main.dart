import 'package:flutter/material.dart';
import './ui/klimatic.dart';

void main(){
  runApp(new MaterialApp(
    title: 'Weather App',
    color: Colors.redAccent,
    home: new Klimatic()
  ));
}
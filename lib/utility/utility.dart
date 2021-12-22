import 'package:flutter/material.dart';

class Utility {
  static getImageCompnent(String img) {
    return img.isEmpty
        ? const AssetImage("assets/img/placeholder.jpg")
        : NetworkImage(img);
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';




class Utils {
  BuildContext context;
  Utils(this.context);


  Size get getScreenSize => MediaQuery.of(context).size; 
}

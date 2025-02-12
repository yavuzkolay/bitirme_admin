import 'package:bitirme_admin/widgetlar/tum_siparisler_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class TumSiparislerEkrani extends StatelessWidget {
  const TumSiparislerEkrani({super.key});
static String routName='TumSiparislerEkrani';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body:    TumSiparislerList(),
    );
  }
}
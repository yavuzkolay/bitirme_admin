//uygulama icerisinde bekleme olusunca ekranda donen daire olusacak loading icin

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingYoneticisi extends StatelessWidget {
  const LoadingYoneticisi(
      {Key? key, required this.child, required this.isLoading})
      : super(key: key);

  final Widget child;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading) ...[
          //arka planin biraz kararmasini sagladik
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          //loading dairesini ayarladik
          const Center(
            child: CircularProgressIndicator(
              color: Colors.orange,
            ),
          ),
        ]
      ],
    );
  }
}

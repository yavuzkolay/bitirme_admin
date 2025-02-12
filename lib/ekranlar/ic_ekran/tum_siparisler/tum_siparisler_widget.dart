import 'package:bitirme_admin/widgetlar/baslik_metni.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


import '../../../araclar/utils.dart';


class TumSiparislerWidget extends StatefulWidget {
  const TumSiparislerWidget(
      {Key? key,
      required this.price,
      required this.totalPrice,
      required this.productId,
      required this.userId,
      required this.imageUrl,
      required this.userName,
      required this.quantity,
      required this.orderDate, required this.userAdress})
      : super(key: key);
  final double price, totalPrice;
  final String productId, userId, imageUrl,userAdress, userName;
  final int quantity;
  final Timestamp orderDate;
  @override
  _TumSiparislerWidgetState createState() => _TumSiparislerWidgetState();
}

class _TumSiparislerWidgetState extends State<TumSiparislerWidget> {
  late String orderDateStr;
  @override
  void initState() {
    var postDate = widget.orderDate.toDate();
    orderDateStr = '${postDate.day}/${postDate.month}/${postDate.year}';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final theme = Utils(context).getTheme;
    // Color color = theme == true ? Colors.white : Colors.black;
    Size size = Utils(context).getScreenSize;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        borderRadius: BorderRadius.circular(8.0),
        color: Theme.of(context).cardColor.withOpacity(0.4),
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                flex: size.width < 650 ? 3 : 1,
                child: Image.network(
                  widget.imageUrl,

                  fit: BoxFit.fill,
                  // height: screenWidth * 0.15,
                  // width: screenWidth * 0.15,
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                flex: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    BaslikMetni(
                      metin:
                          '${widget.quantity}  Adet  \nToplam Tutar: \₺${widget.price.toStringAsFixed(2)}',
                      renk: Colors.amber,
                      uzunMetin: 16,
                      //isTitle: true,
                    ),
                    FittedBox(
                      child: Row(
                        children: [
                          BaslikMetni(
                            metin: 'Sipariş Veren Kişi:',
                            renk: Colors.blue,
                            uzunMetin: 16,
                           // isTitle: true,
                          ),
                        Text('  ${widget.userName}')
                        ],
                      ),
                    ),
                    FittedBox(
                      child: Row(
                        children: [
                      BaslikMetni(
                            metin: 'Sipariş Tarihi:',
                            renk: Colors.blue,
                            uzunMetin: 16,
                           // isTitle: true,
                          ),
                          Text('  ${orderDateStr}')
                          ],
                      ),
                    ),
                    FittedBox(
                      child: Row(
                        children: [
                      BaslikMetni(
                            metin: 'Sipariş Adresi:',
                            renk: Colors.blue,
                            uzunMetin: 16,
                           // isTitle: true,
                          ),
                          Text('  ${widget.userAdress}')
                          ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

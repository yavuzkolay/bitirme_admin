import 'package:bitirme_admin/ekranlar/ic_ekran/tum_siparisler/tum_siparisler_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class TumSiparislerList extends StatelessWidget {
  const TumSiparislerList({Key? key, this.isInDashboard = true}) : super(key: key);
  final bool isInDashboard;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StreamBuilder<QuerySnapshot>(
        //there was a null error just add those lines
        stream: FirebaseFirestore.instance.collection('ileri siparişler').snapshots(),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data!.docs.isNotEmpty) {
              return Container(
                padding:  EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: isInDashboard && snapshot.data!.docs.length > 4
                        ? snapshot.data!.docs.length //4
                        : snapshot.data!.docs.length,
                    itemBuilder: (ctx, index) {
                      return Column(
                        children: [
                          TumSiparislerWidget(
                            price: snapshot.data!.docs[index]['fiyat'],
                            totalPrice: snapshot.data!.docs[index]['toplamFiyat'],
                            productId: snapshot.data!.docs[index]['urunId'],
                            userId: snapshot.data!.docs[index]['kullaniciId'],
                            quantity: snapshot.data!.docs[index]['miktar'],
                            orderDate: snapshot.data!.docs[index]['siparisTarihi'],
                            imageUrl: snapshot.data!.docs[index]['imageUrl'],
                            userName: snapshot.data!.docs[index]['kullaniciAd'],
                             userAdress: snapshot.data!.docs[index]['kullaniciAdres'],
                          ),
                          const Divider(
                            thickness: 3,
                          ),
                        ],
                      );
                    }),
              );
            } else {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(18.0),
                  child: Text('Your store is empty'),
                ),
              );
            }
          }
          return const Center(
            child: Text(
              'Something went wrong',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
          );
        },
      ),
    );
  }
}

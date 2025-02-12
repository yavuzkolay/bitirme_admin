import 'dart:io';

import 'package:bitirme_admin/araclar/uygulama_fonksiyonlari.dart';
import 'package:bitirme_admin/ekranlar/loading_yoneticisi.dart';
import 'package:bitirme_admin/modeller/urun_modeli.dart';
import 'package:bitirme_admin/sabitler/dogrulayici.dart';
import 'package:bitirme_admin/sabitler/uygulama_sabitleri.dart';
import 'package:bitirme_admin/widgetlar/baslik_metni.dart';
import 'package:bitirme_admin/widgetlar/baslik_metni2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class UrunYuklemeEkrani extends StatefulWidget {
  static const routName = '/EditOrUploadProductScreen';

  const UrunYuklemeEkrani({super.key, this.urunModeli});

  final UrunModeli? urunModeli;

  @override
  State<UrunYuklemeEkrani> createState() => _UrunYuklemeEkraniState();
}

class _UrunYuklemeEkraniState extends State<UrunYuklemeEkrani> {
  //fotograf tanımlayıp yuklemek ıcın olusturduk
  final _formKey = GlobalKey<FormState>();
  XFile? _secilenResim;

  //etiketler icin denetleyici baslatildi
  late TextEditingController _adKontrolu,
      _fiyatKontrolu,
      _aciklamaKontrolu,
      _miktarKontrolu;
  String? _kategoriDegeri;

  bool isEditing = false;
  String? urunNetworkImage;
  bool _isLoading = false;
  String? urunFotoUrl;

  @override
  void initState() {
    if (widget.urunModeli != null) {
      isEditing = true;
      urunNetworkImage = widget.urunModeli!.urunResim;
      _kategoriDegeri = widget.urunModeli!.urunKategori;
    }
    _adKontrolu = TextEditingController(text: widget.urunModeli?.urunBaslik);
    _fiyatKontrolu = TextEditingController(text: widget.urunModeli?.urunFiyat);
    _aciklamaKontrolu =
        TextEditingController(text: widget.urunModeli?.urunAciklama);
    _miktarKontrolu =
        TextEditingController(text: widget.urunModeli?.urunMiktar);

    super.initState();
  }

  //formu temizlemek icin
  @override
  void dispose() {
    _adKontrolu.dispose();
    _fiyatKontrolu.dispose();
    _aciklamaKontrolu.dispose();
    _miktarKontrolu.dispose();
    super.dispose();
  }

  //secilen goruntu kaldirilmasi icin denetleyici
  void clearForm() {
    _adKontrolu.clear();
    _fiyatKontrolu.clear();
    _aciklamaKontrolu.clear();
    _miktarKontrolu.clear();
    removePickedImage();
  }

  //foto kaldirilmasi durumunda set ile null a esitleniyor
  void removePickedImage() {
    setState(() {
      _secilenResim = null;
      urunNetworkImage = null;
    });
  }

  Future<void> _uploadProduct() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    //kullanicidan profil foto alinip alinmadigini kontrol ediyor
    if (_secilenResim == null) {
      UygulamaFonksiyonlari.ErrorVeyaUyariDiyalogu(
          context: context,
          baslik: "Bir Fotoğraf Seçtiğinize Emin Olun",
          fct: () {});
      return;
    }
    if (isValid) {
      //hatalari islemek icin kullanilir
      try {
        setState(() {
          _isLoading = true;
        });

        final urunId = Uuid().v4();
        //profil fotosunun firebase de yuklenecegi yerin yolu verildi
        final ref = FirebaseStorage.instance
            .ref()
            .child("urunFotograflari")
            .child("$urunId.jpg");
        await ref.putFile(File(_secilenResim!.path));

        //yukledigimiz profil fotografin url si alindi
        urunFotoUrl = await ref.getDownloadURL();


        //firabase aramasi yapiyoruz
        await FirebaseFirestore.instance.collection("urunler").doc(urunId).set({
          'urunId': urunId,
          'urunBaslik': _adKontrolu.text,
          'urunFiyat': _fiyatKontrolu.text,
          'urunKategori': _kategoriDegeri,
          'urunAciklama': _aciklamaKontrolu.text,
          'urunResim': urunFotoUrl,
          'urunMiktar': _miktarKontrolu.text,
          'olusturulmaTarihi': Timestamp.now(),
        });

        Fluttertoast.showToast(
          msg: "Yeni Bir Ürün Eklendi",
          textColor: Colors.white,
        );
        if (!mounted) return;
        UygulamaFonksiyonlari.ErrorVeyaUyariDiyalogu(
            hata: false,
            context: context,
            baslik: "Ekran Temizlensin mi?",
            fct: () {
              clearForm();
            });
      } on FirebaseException catch (error) {
        await UygulamaFonksiyonlari.ErrorVeyaUyariDiyalogu(
          context: context,
          baslik: error.message.toString(),
          fct: () {},
        );
      } catch (error) {
        await UygulamaFonksiyonlari.ErrorVeyaUyariDiyalogu(
          context: context,
          baslik: error.toString(),
          fct: () {},
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  //duzenleme urunu
  Future<void> _editProduct() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    //kullanicidan profil foto alinip alinmadigini kontrol ediyor
    if (_secilenResim == null && urunNetworkImage == null) {
      UygulamaFonksiyonlari.ErrorVeyaUyariDiyalogu(
        context: context,
        baslik: "Lütfen bir fotoğraf yüleyin",
        fct: () {},
      );
      return;
    }
    if (isValid) {
      //hatalari islemek icin kullanilir
      try {
        setState(() {
          _isLoading = true;
        });

        if (_secilenResim != null) {
          //profil fotosunun firebase de yuklenecegi yerin yolu verildi
          final ref = FirebaseStorage.instance
              .ref()
              .child("urunFotograflari")
              .child("${widget.urunModeli!.urunId}.jpg");
          await ref.putFile(File(_secilenResim!.path));

          //yukledigimiz profil fotografin url si alindi
          urunFotoUrl = await ref.getDownloadURL();
        }

        //firabase aramasi yapiyoruz
        await FirebaseFirestore.instance
            .collection("urunler")
            .doc(widget.urunModeli!.urunId)
            .update({
          'urunId': widget.urunModeli!.urunId,
          'urunBaslik': _adKontrolu.text,
          'urunFiyat': _fiyatKontrolu.text,
          'urunKategori': _kategoriDegeri,
          'urunAciklama': _aciklamaKontrolu.text,
          'urunResim': urunFotoUrl ?? urunNetworkImage,
          'urunMiktar': _miktarKontrolu.text,
          'olusturulmaTarihi': widget.urunModeli!.olusturulmaTarihi,
        });

        Fluttertoast.showToast(
          msg: "Ürün Düzenlendi",
          textColor: Colors.white,
        );
        if (!mounted) return;
        UygulamaFonksiyonlari.ErrorVeyaUyariDiyalogu(
            hata: false,
            context: context,
            baslik: "Ekran Temizlensin mi?",
            fct: () {
              clearForm();
            });
      } on FirebaseException catch (error) {
        await UygulamaFonksiyonlari.ErrorVeyaUyariDiyalogu(
          context: context,
          baslik: error.message.toString(),
          fct: () {},
        );
      } catch (error) {
        await UygulamaFonksiyonlari.ErrorVeyaUyariDiyalogu(
          context: context,
          baslik: error.toString(),
          fct: () {},
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  //kayit sayfasindan alindi
  Future<void> localImagePicker() async {
    final ImagePicker picker = ImagePicker();
    await UygulamaFonksiyonlari.resimSecmeDiyalogu(
      context: context,
      kamera: () async {
        _secilenResim = await picker.pickImage(source: ImageSource.camera);
        setState(() {
          urunNetworkImage = null;
        });
      },
      galeri: () async {
        _secilenResim = await picker.pickImage(source: ImageSource.gallery);
        setState(() {});
      },
      kaldir: () {
        setState(() {
          _secilenResim = null;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return LoadingYoneticisi(
      isLoading: _isLoading,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          bottomSheet: SizedBox(
            height: kBottomNavigationBarHeight + 10,
            child: Material(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(12),
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          20,
                        ),
                      ),
                    ),
                    icon: const Icon(Icons.clear),
                    label: const Text(
                      "Temizle",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    onPressed: () {
                      clearForm();
                    },
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(12),
                      backgroundColor: Colors.tealAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          20,
                        ),
                      ),
                    ),
                    icon: const Icon(Icons.file_upload_outlined),
                    label: Text(
                      isEditing ? "Ürünü Düzenle" : "Ürünü Yükle",
                    ),
                    onPressed: () {
                      //urun yukleme kullanildi
                      if (isEditing) {
                        _editProduct();
                      } else {
                        _uploadProduct();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          appBar: AppBar(
            centerTitle: true,
            title: BaslikMetni(
              metin: isEditing ? "Ürünü Düzenle" : "Yeni Bir Ürün Ekle",
            ),
          ),
          body: SafeArea(
            //ekran kaydirilabilir yapildi ve tasma hatasi engelendi
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  if (isEditing && urunNetworkImage != null) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        urunNetworkImage!,
                        // width: size.width * 0.7,
                        height: size.width * 0.5,
                        alignment: Alignment.center,
                      ),
                    ),
                  ]
                  //urun fotografi
                  else if (_secilenResim == null) ...[
                    SizedBox(
                      width: size.width * 0.4 + 10,
                      height: size.width * 0.4,
                      child: DottedBorder(
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.image,
                                size: 80,
                                color: Colors.tealAccent,
                              ),
                              TextButton(
                                  onPressed: () {
                                    //yerel gorsel secimi
                                    localImagePicker();
                                  },
                                  child: const Text("Ürün Fotoğrafı Seçiniz")),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ] else ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(
                          _secilenResim!.path,
                        ),
                        // width: size.width * 0.7,
                        height: size.width * 0.5,
                        alignment: Alignment.center,
                      ),
                    ),
                  ],

                  //resim yukluyse altta iki tane text buton cikacak
                  if (_secilenResim != null || urunNetworkImage != null) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            localImagePicker();
                          },
                          child: const Text("Başka Bir Görsel Seç"),
                        ),
                        TextButton(
                          onPressed: () {
                            removePickedImage();
                          },
                          child: const Text(
                            "Görseli Kaldır",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    )
                  ],

                  const SizedBox(
                    height: 25,
                  ),

                  // acilir buton olusturduk, kategori sectirdik
                  DropdownButton(
                      items: UygulamaSabitleri.kategoriDropDownListe,
                      //value deger secilen kategoriyi ekranda gostermesini sagliyor
                      value: _kategoriDegeri,
                      hint: const Text("Bir Kategori Seçin"),
                      onChanged: (String? value) {
                        setState(() {
                          _kategoriDegeri = value;
                        });
                      }),
                  const SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    child: Form(
                      //form anahtari verildi
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _adKontrolu,
                            key: const ValueKey('Ürün Adı'),
                            //urun adi 80 karakter uzunlugunda en az 1 satir en fazla 2 satir olabilir
                            maxLength: 80,
                            minLines: 1,
                            maxLines: 2,
                            //klavye tipi belirlendi
                            keyboardType: TextInputType.multiline,
                            //klavyeden enter a basildiginda yeni sayira geciyor
                            textInputAction: TextInputAction.newline,
                            decoration: const InputDecoration(
                              hintText: 'Ürün Adı',
                            ),
                            validator: (value) {
                              return Dogrulayici.urunMetiniYukle(
                                deger: value,
                                geriDondurulecekString:
                                    "Lütfen geçerli bir başlık girin",
                              );
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              //tasma hatasina karsi esnek widget ile sardik
                              Flexible(
                                flex: 1,
                                child: TextFormField(
                                  controller: _fiyatKontrolu,
                                  key: const ValueKey('Fiyat \$'),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    //double bir sayi girilmesi isteniyor
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r'^(\d+)?\.?\d{0,2}'),
                                    ),
                                  ],
                                  decoration: const InputDecoration(
                                      hintText: 'Fiyat',
                                      prefix: BaslikMetni2(
                                        metin: "\₺ ",
                                        renk: Colors.blue,
                                        fontBoyut: 16,
                                      )),
                                  validator: (value) {
                                    return Dogrulayici.urunMetiniYukle(
                                      deger: value,
                                      geriDondurulecekString:
                                          "Eksik fiyat bilgisi",
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                flex: 1,
                                child: TextFormField(
                                  inputFormatters: [
                                    //miktar icin tam sayi girilesi istenir
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  //miktar denetleyicisi var
                                  controller: _miktarKontrolu,
                                  keyboardType: TextInputType.number,
                                  key: const ValueKey('Adet'),
                                  decoration: const InputDecoration(
                                    hintText: 'Adet',
                                  ),
                                  validator: (value) {
                                    return Dogrulayici.urunMetiniYukle(
                                      deger: value,
                                      geriDondurulecekString:
                                          "Eksit miktar girişi",
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            key: const ValueKey('Açıklama'),
                            //metin denetleyicisi var
                            controller: _aciklamaKontrolu,
                            minLines: 5,
                            maxLines: 8,
                            maxLength: 1000,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: const InputDecoration(
                              hintText: 'Ürün Açıklaması',
                            ),
                            validator: (value) {
                              return Dogrulayici.urunMetiniYukle(
                                deger: value,
                                geriDondurulecekString: "Geçersiz açıklama",
                              );
                            },
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: kBottomNavigationBarHeight + 10,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

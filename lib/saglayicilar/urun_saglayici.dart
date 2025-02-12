import 'package:bitirme_admin/modeller/urun_modeli.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//degisiklik dinleyicisi
class UrunSaglayici with ChangeNotifier {
  List<UrunModeli> urunler = [];

  //urunleri almak icin liste tanimladim
  List<UrunModeli> get urunAl {
    return urunler;
  }

  //urunId konrtolu yapiliyor
  UrunModeli? urunIdBul(String urunId) {
    //urun bulumazsa hata vermememisi icin if ile kontrol olusutrduk
    if (urunler.where((element) => element.urunId == urunId).isEmpty) {
      return null;
    }
    return urunler.firstWhere((element) => element.urunId == urunId);
  }

  //urunleri kategorilere ayirmamiza yaririyor.
  List<UrunModeli> kategoriBul({required String kategoriAdi}) {
    List<UrunModeli> kategoriList = urunler
        .where(
          (element) => element.urunKategori.toLowerCase().contains(
        kategoriAdi.toLowerCase(),
      ),
    )
        .toList();
    return kategoriList;
  }

  //urunleri arama kutusunda bulunmasi saglandi
  List<UrunModeli> aramaSorgusu(
      {required String aramaMetni, required List<UrunModeli> gecmisListe}) {
    List<UrunModeli> aramaList = gecmisListe
        .where(
          (element) => element.urunBaslik.toLowerCase().contains(
        aramaMetni.toLowerCase(),
      ),
    )
        .toList();
    return aramaList;
  }

  //artik urunleri firebase den okuyoruz
  final urunDb = FirebaseFirestore.instance.collection("urunler");

  Future<List<UrunModeli>> getirUrunler() async {
    try {
      await urunDb.get().then((urunAnlikFoto) {
        urunler.clear();
        //urunler = []
        for (var element in urunAnlikFoto.docs) {
          urunler.insert(0, UrunModeli.fromFirestore(element));
        }
      });
      notifyListeners();
      return urunler;
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<UrunModeli>> getirUrunAkisi() {
    try {
      return urunDb.snapshots().map((snapshot) {
        urunler.clear();
        //urunler = []
        for (var element in snapshot.docs) {
          urunler.insert(0, UrunModeli.fromFirestore(element));
        }
        return urunler;
      });
    } catch (e) {
      rethrow;
    }
  }

/*
  List<UrunModeli> urunler = [
    // Telefon
    UrunModeli(
      //1
      urunId: 'iphone14-128gb-black',
      urunBaslik: "Apple iPhone 14 Pro (128GB) - Black",
      urunFiyat: "1399.99",
      urunKategori: "Telefon",
      urunAciklama:
          "6.1-inch Super Retina XDR display with ProMotion and always-on display. Dynamic Island, a new and magical way to interact with your iPhone. 48MP main camera for up to 4x higher resolution. Cinematic mode, now in 4K Dolby Vision up to 30 fps. Action mode, for stable and smooth videos when you're on the move. Accident detection, vital safety technology that calls for help for you. All-day battery life and up to 23 hours of video playback.",
      urunResim: "https://i.ibb.co/BtMBSgK/1-iphone14-128gb-black.webp",
      urunMiktar: "10",
    ),
    UrunModeli(
      //2
      urunId: 'iphone13-mini-256gb-midnight',
      urunBaslik:
          "iPhone 13 Mini, 256GB, Midnight - Unlocked (Renewed Premium)",
      urunFiyat: "659.99",
      urunKategori: "Telefon",
      urunAciklama:
          "5.4 Super Retina XDR display. 5G Superfast downloads, high quality streaming. Cinematic mode in 1080p at 30 fps. Dolby Vision HDR video recording up to 4K at 60 fps. 2X Optical zoom range. A15 Bionic chip. New 6-core CPU with 2 performance and 4 efficiency cores. New 4-core GPU. New 16-core Neural Engine. Up to 17 hours video playback. Face ID. Ceramic Shield front. Aerospace-grade aluminum. Water resistant to a depth of 6 meters for up to 30 minutes. Compatible with MagSafe accessories and wireless chargers.",
      urunResim: "https://i.ibb.co/nbwTvXQ/2-iphone13-mini-256gb-midnight.webp",
      urunMiktar: "15",
    ),
    UrunModeli(
      //3
      urunId: 'Acheter un iPhone 14',
      urunBaslik: "iPhone 14",
      urunFiyat: "1199.99",
      urunKategori: "Telefon",
      urunAciklama:
          "Les détails concernant la livraison dans votre région s’afficheront sur la page de validation de la commande.",
      urunResim: "https://i.ibb.co/G7nXCW4/3-i-Phone-14.jpg",
      urunMiktar: "144",
    ),
    UrunModeli(
      //4
      urunId: const Uuid().v4(),
      urunBaslik:
          "Samsung Galaxy S22 Ultra 5G - 256GB - Phantom Black (Unlocked)",
      urunFiyat: "1199.99",
      urunKategori: "Telefon",
      urunAciklama:
          "About this item\n6.8 inch Dynamic AMOLED 2X display with a 3200 x 1440 resolution\n256GB internal storage, 12GB RAM\n108MP triple camera system with 100x Space Zoom and laser autofocus\n40MP front-facing camera with dual pixel AF\n5000mAh battery with fast wireless charging and wireless power share\n5G capable for lightning fast download and streaming",
      urunResim:
          "https://i.ibb.co/z5zMDCx/4-Samsung-Galaxy-S22-Ultra-5-G-256-GB-Phantom-Black-Unlocked.webp",
      urunMiktar: "2363",
    ),
    UrunModeli(
      //5
      urunId: const Uuid().v4(),
      urunBaslik:
          "Samsung Galaxy S21 Ultra 5G | Factory Unlocked Android Cell Phone | US Version 5G Smartphone",
      urunFiyat: "1199.99",
      urunKategori: "Telefon",
      urunAciklama:
          "About this item\nPro Grade Camera: Zoom in close with 100X Space Zoom, and take photos and videos like a pro with our easy-to-use, multi-lens camera.\n100x Zoom: Get amazing clarity with a dual lens combo of 3x and 10x optical zoom, or go even further with our revolutionary 100x Space Zoom.\nHighest Smartphone Resolution: Crystal clear 108MP allows you to pinch, crop and zoom in on your photos to see tiny, unexpected details, while lightning-fast Laser Focus keeps your focal point clear\nAll Day Intelligent Battery: Intuitively manages your cellphone’s usage, so you can go all day without charging (based on average battery life under typical usage conditions).\nPower of 5G: Get next-level power for everything you love to do with Samsung Galaxy 5G; More sharing, more gaming, more experiences and never miss a beat",
      urunResim: "https://i.ibb.co/ww5WjkV/5-Samsung-Galaxy-S21-Ultra-5-G.png",
      urunMiktar: "3625",
    ),
    UrunModeli(
      //6
      urunId: const Uuid().v4(),
      urunBaslik:
          "OnePlus 9 Pro 5G LE2120 256GB 12GB RAM Factory Unlocked (GSM Only | No CDMA - not Compatible with Verizon/Sprint) International Version - Morning Mist",
      urunFiyat: "1099.99",
      urunKategori: "Telefon",
      urunAciklama:
          "About this item\n6.7 inch LTPO Fluid2 AMOLED, 1B colors, 120Hz, HDR10+, 1300 nits (peak)\n256GB internal storage, 12GB RAM\nQuad rear camera: 48MP, 50MP, 8MP, 2MP\n16MP front-facing camera\n4500mAh battery with Warp Charge 65T (10V/6.5A) and 50W Wireless Charging\n5G capable for lightning fast download and streaming",
      urunResim:
          "https://i.ibb.co/0yhgKVv/6-One-Plus-9-Pro-5-G-LE2120-256-GB-12-GB-RAM.png",
      urunMiktar: "3636",
    ),

    UrunModeli(
      //7
      urunId: const Uuid().v4(),
      urunBaslik: "Samsung Galaxy Z Flip3 5G",
      urunFiyat: "999.99",
      urunKategori: "Telefon",
      urunAciklama:
          "About this item\nGet the latest Galaxy experience on your phone.\nFOLDING DISPLAY - Transform the way you capture, share and experience content.\nCAPTURE EVERYTHING - With the wide-angle camera and the front camera, take stunning photos and videos from every angle.\nWATER RESISTANT - Use your Galaxy Z Flip3 5G even when it rains.\nONE UI 3.1 - Enjoy the Galaxy Z Flip3 5G’s sleek, premium design and all the features you love from the latest One UI 3.1. ",
      urunResim: "https://i.ibb.co/NstFstg/7-Samsung-Galaxy-Z-Flip3-5-G.png",
      urunMiktar: "525",
    ),
    UrunModeli(
      //8
      urunId: const Uuid().v4(),
      urunBaslik: "Apple introduces iPhone 14 and iPhone 14 Plus",
      urunFiyat: "1199.99",
      urunKategori: "Telefon",
      urunAciklama:
          "A new, larger 6.7-inch size joins the popular 6.1-inch design, featuring a new dual-camera system, Crash Detection, a smartphone industry-first safety service with Emergency SOS via satellite, and the best battery life on iPhone",
      urunResim: "https://i.ibb.co/8P1HBm4/8-iphone14plushereo.jpg",
      urunMiktar: "2526",
    ),
    UrunModeli(
      //9
      urunId: const Uuid().v4(),
      urunBaslik: "Xiaomi Redmi Note 10 Pro",
      urunFiyat: "249.99",
      urunKategori: "Telefon",
      urunAciklama:
          "About this item\n6.67-inch 120Hz AMOLED display with TrueColor\n108MP quad rear camera system with 8K video support\nQualcomm Snapdragon 732G processor\n5020mAh (typ) high-capacity battery\n33W fast charging support and 33W fast charger included in the box",
      urunResim: "https://i.ibb.co/W3QcVMv/9-Xiaomi-Redmi-Note-10-Pro.png",
      urunMiktar: "353",
    ),
    UrunModeli(
      //10
      urunId: const Uuid().v4(),
      urunBaslik: "OnePlus 10 Pro 5G",
      urunFiyat: "899.99",
      urunKategori: "Telefon",
      urunAciklama:
          "About this item\n6.7 inch Fluid AMOLED Display with LTPO, 120 Hz refresh rate, 10-bit color, HDR10+, and adaptive refresh rate\nQualcomm Snapdragon 8 Gen 1 with Adreno 730 GPU\n4500 mAh battery with Warp Charge 65T (10V/6.5A) + Wireless Warp Charge 50\n256GB Internal Storage | 12GB RAM\nOxygenOS 12 based on Android 12 with Play Store",
      urunResim: "https://i.ibb.co/9vGVHQk/10-One-Plus-10-Pro-5-G.png",
      urunMiktar: "3873",
    ),
    UrunModeli(
      //11
      urunId: const Uuid().v4(),
      urunBaslik: "Google Pixel 6",
      urunFiyat: "799.99",
      urunKategori: "Telefon",
      urunAciklama:
          "About this item\nPowered by Google Tensor chip, designed for mobile, the Google Pixel 6 delivers exceptional AI-powered experiences.\n6.4-inch Full HD+ display with 90Hz refresh rate and HDR10+.\n50MP + 12MP dual rear camera system, 4K/60fps video recording.\n8MP front camera with Night Sight, portrait mode and more.\nBuilt-in Titan M2 security chip for advanced security.\nAndroid 12 OS with three years of updates and monthly security patches.",
      urunResim: "https://i.ibb.co/0K8ZxZj/11-Google-Pixel-6.png",
      urunMiktar: "62332",
    ),
    // Laptop
    // https://i.ibb.co/MDcGHsb/12-ASUS-ROG-Zephyrus-G15.jpg
    UrunModeli(
      //12
      urunId: const Uuid().v4(),
      urunBaslik: "ASUS ROG Zephyrus G15",
      urunFiyat: "1599.99",
      urunKategori: "Laptop",
      urunAciklama:
          "About this item\nUltra Slim Gaming Laptop, 15.6” 144Hz FHD Display, GeForce GTX 1660 Ti Max-Q, AMD Ryzen 7 4800HS, 16GB DDR4, 512GB PCIe NVMe SSD, Wi-Fi 6, RGB Keyboard, Windows 10 Home, GA502IU-ES76",
      urunResim: "https://i.ibb.co/kMR5mpR/12-ASUS-ROG-Zephyrus-G15.png",
      urunMiktar: "525",
    ),
    UrunModeli(
      //13
      urunId: const Uuid().v4(),
      urunBaslik: "Acer Predator Helios 300",
      urunFiyat: "1199.99",
      urunKategori: "Laptop",
      urunAciklama:
          "About this item\n10th Generation Intel Core i7-10750H 6-Core Processor (Up to 5.0 GHz) with Windows 10 Home 64 Bit\nOverclockable NVIDIA GeForce RTX 3060 Laptop GPU with 6 GB of dedicated GDDR6 VRAM, NVIDIA DLSS, NVIDIA Dynamic Boost 2.0, NVIDIA GPU Boost\n15.6\" Full HD (1920 x 1080) Widescreen LED-backlit IPS Display (144Hz Refresh Rate, 3ms Overdrive Response Time & 300nit Brightness)",
      urunResim: "https://i.ibb.co/tcB3HXJ/13-Acer-Predator-Helios-300.webp",
      urunMiktar: "5353",
    ),
    UrunModeli(
      //14
      urunId: const Uuid().v4(),
      urunBaslik: "Razer Blade 15 Base",
      urunFiyat: "1599.99",
      urunKategori: "Laptop",
      urunAciklama:
          "About this item\nMore power: The 10th Gen Intel Core i7-10750H processor provides the ultimate level of performance with up to 5.0 GHz max turbo and 6 cores\nSupercharger: NVIDIA GeForce GTX 1660 Ti graphics delivers faster, smoother gameplay\nThin and compact: The CNC aluminum unibody frame houses incredible performance in the most compact footprint possible, while remaining remarkably durable and just 0.78\" thin",
      urunResim: "https://i.ibb.co/XDtWpXC/14-Razer-Blade-15-Base.png",
      urunMiktar: "5335",
    ),
    UrunModeli(
      //15
      urunId: const Uuid().v4(),
      urunBaslik: "MSI GS66 Stealth",
      urunFiyat: "1999.99",
      urunKategori: "Laptop",
      urunAciklama:
          "About this item\n15.6\" FHD, Anti-Glare Wide View Angle 240Hz 3ms | NVIDIA GeForce RTX 2070 Max-Q 8G GDDR6\nIntel Core i7-10750H 2.6 - 5.0GHz | Intel Wi-Fi 6 AX201(22 ax)\n16GB (8G2) DDR4 3200MHz | 2 Sockets | Max Memory 64GB\nUSB 3.2 Gen2 3 | Thunderbolt 31 PD charge",
      urunResim: "https://i.ibb.co/0Q4xHVn/15-MSI-GS66-Stealth.png",
      urunMiktar: "2599",
    ),

    // Saat
    UrunModeli(
      //16
      urunId: const Uuid().v4(),
      urunBaslik: "Apple Watch Series 7",
      urunFiyat: "399.99",
      urunKategori: "Saat",
      urunAciklama:
          "About this item\nAlways-On Retina display has been redesigned to be larger, yet still always on, so you can easily see the time and your watch face.\nAdvanced workout features let you measure your blood oxygen level, sleep, and heart rate, and there are cycling, yoga, and dance workouts to choose from.\nChoose from new watch faces, new colors, and new bands, including the Hermès Fastener, which is inspired by the buckle on the straps of Hermès horse harnesses.\nApple Watch Series 7 has a water resistance rating of 50 meters under ISO standard 22810:2010.",
      urunResim: "https://i.ibb.co/8cNwrbJ/16-Apple-Watch-Series-7.png",
      urunMiktar: "535352",
    ),
    UrunModeli(
      //17
      urunId: const Uuid().v4(),
      urunBaslik: "Samsung Galaxy Watch 4",
      urunFiyat: "249.99",
      urunKategori: "Saat",
      urunAciklama:
          "About this item\nTake your fitness to the next level with advanced sensors that track your body composition, heart rate, sleep quality, and more.\nThe watch automatically detects and tracks over 90 different exercises, from running and cycling to swimming and rowing.\nGalaxy Watch 4 lets you control your smart home devices right from your wrist, so you can turn off the lights, adjust the thermostat, and more.\nThe watch comes with a choice of watch faces, so you can customize it to match your style.",
      urunResim: "https://i.ibb.co/tsq0VD8/17-Samsung-Galaxy-Watch-4.png",
      urunMiktar: "252",
    ),
    UrunModeli(
      //18
      urunId: const Uuid().v4(),
      urunBaslik: "Fitbit Sense Advanced Smartwatch",
      urunFiyat: "299.95",
      urunKategori: "Saat",
      urunAciklama:
          "About this item\nThe Fitbit Sense is an advanced smartwatch that tracks your heart rate, skin temperature, and stress levels.\nIt also has built-in GPS and lets you control your Spotify music right from your wrist.\nThe watch comes with a choice of watch faces, and you can customize it with a variety of bands.\nThe battery lasts up to 6 days, so you can wear it all week without needing to recharge it.",
      urunResim:
          "https://i.ibb.co/jrVQppF/18-Fitbit-Sense-Advanced-Smartwatch.png",
      urunMiktar: "526",
    ),
    UrunModeli(
      //19
      urunId: const Uuid().v4(),
      urunBaslik: "Garmin Forerunner 945 LTE",
      urunFiyat: "649.99",
      urunKategori: "Saat",
      urunAciklama:
          "About this item\nThe Garmin Forerunner 945 LTE is a high-end GPS running watch with LTE connectivity, so you can leave your phone at home.\nIt has built-in music storage and lets you pay for purchases with Garmin Pay.\nThe watch comes with a choice of watch faces, and you can customize it with a variety of bands.\nThe battery lasts up to 10 days in smartwatch mode and up to 36 hours in GPS mode with music.",
      urunResim: "https://i.ibb.co/xXhSfTh/19-Garmin-Forerunner-945-LTE.png",
      urunMiktar: "58385",
    ),
    // Moda
    UrunModeli(
      //20
      urunId: const Uuid().v4(),
      urunBaslik: "Nike Air Force 1 '07",
      urunFiyat: "90.88",
      urunKategori: "Moda",
      urunAciklama:
          "About this item\nFull-grain leather in the upper adds a premium look and feel.\nOriginally designed for performance hoops, Nike Air cushioning adds lightweight, all-day comfort.\nThe padded, low-cut collar looks sleek and feels great.\nPerforations on the toe provide airflow for breathability.\nThe non-marking rubber sole adds traction and durability.",
      urunResim: "https://i.ibb.co/8r1Ny2n/20-Nike-Air-Force-1-07.png",
      urunMiktar: "7544",
    ),
    UrunModeli(
      //21
      urunId: const Uuid().v4(),
      urunBaslik: "Adidas Ultraboost 21",
      urunFiyat: "180.53",
      urunKategori: "Moda",
      urunAciklama:
          "About this item\nResponsive Boost midsole\n3D Heel Frame\nSock-like fit\nPrimeknit+ upper\nStretchweb outsole with Continental™ Rubber",
      urunResim: "https://i.ibb.co/QM1dLww/21-Adidas-Ultraboost-21.webp",
      urunMiktar: "7654",
    ),
    UrunModeli(
      //22
      urunId: const Uuid().v4(),
      urunBaslik: "Converse Chuck Taylor All Star High Top",
      urunFiyat: "55.12",
      urunKategori: "Moda",
      urunAciklama:
          "About this item\n100% Synthetic\nImported\nRubber sole\nShaft measures approximately 4.5 from arch\nPlatform measures approximately 0.25\nLace-up, high-top sneaker\nOrthoLite insole for cushioning\nMedial eyelets for airflow\nCanvas upper",
      urunResim:
          "https://i.ibb.co/TBQv7G6/22-Converse-Chuck-Taylor-All-Star-High-Top.png",
      urunMiktar: "36437",
    ),
    UrunModeli(
      //23
      urunId: const Uuid().v4(),
      urunBaslik: "New Balance Fresh Foam 1080v11",
      urunFiyat: "149.99",
      urunKategori: "Moda",
      urunAciklama:
          "About this item\nSynthetic and mesh upper for a breathable and supportive fit\nFresh Foam midsole cushioning is precision engineered to deliver an ultra-cushioned, lightweight ride\nBlown rubber outsole provides durability and traction\nLace closure ensures a secure fit\nOrtholite cushioning adds extra comfort",
      urunResim:
          "https://i.ibb.co/k2BtR9X/23-New-Balance-Fresh-Foam-1080v11.webp",
      urunMiktar: "36637",
    ),
    UrunModeli(
      //24
      urunId: const Uuid().v4(),
      urunBaslik: "Vans Old Skool",
      urunFiyat: "60.33",
      urunKategori: "Moda",
      urunAciklama:
          "About this item\nCanvas and suede upper for durability\nReinforced toe cap for added durability\nPadded collar for support and flexibility\nVulcanized construction for durability and grip\nSignature rubber waffle outsole for traction",
      urunResim: "https://i.ibb.co/NNDk3pt/24-Vans-Old-Skool.png",
      urunMiktar: "3637",
    ),
    UrunModeli(
      //25
      urunId: const Uuid().v4(),
      urunBaslik: "Adidas Ultraboost 21",
      urunFiyat: "180.7",
      urunKategori: "Moda",
      urunAciklama:
          "About this item\nBoost cushioning technology delivers comfort and energy return with every step\n3D Heel Frame cradles the heel for natural fit and optimal movement of the Achilles\nPrimeknit+ upper adapts to the changing shape of your foot through the gait cycle\nTorsion System provides a stable feel from heel strike to toe-off\nStretchweb outsole flexes naturally for an energized ride",
      urunResim: "https://i.ibb.co/VmvdBqC/25-Adidas-Ultraboost-21.webp",
      urunMiktar: "8565",
    ),
    UrunModeli(
      //26
      urunId: const Uuid().v4(),
      urunBaslik: "Nike Air Max 270",
      urunFiyat: "150.78",
      urunKategori: "Moda",
      urunAciklama:
          "About this item\nLarge Max Air unit delivers plush cushioning and all-day comfort\nNeoprene stretch bootie design delivers a snug fit\n3-piece midsole offers durability and a smooth transition\nMono-mesh window in the quarter and engineered mesh in the forefoot provide durability\nRubber toe tip provides durability and grip during training movements such as planks and push-ups",
      urunResim: "https://i.ibb.co/Tk3WDX1/26-Nike-Air-Max-270.png",
      urunMiktar: "6437",
    ),
    UrunModeli(
      //27
      urunId: const Uuid().v4(),
      urunBaslik: "New Balance Fresh Foam 1080v11",
      urunFiyat: "149.99",
      urunKategori: "Moda",
      urunAciklama:
          "About this item\nFresh Foam midsole cushioning is precision engineered to deliver an ultra-cushioned, lightweight ride\nSynthetic/mesh upper\nOrtholite sockliner for comfort\nBlown rubber outsole provides durability\nUltra Heel design hugs the back of the foot for a snug, supportive fit",
      urunResim:
          "https://i.ibb.co/5rxL1Ck/27-New-Balance-Fresh-Foam-1080v11.png",
      urunMiktar: "7853",
    ),
    UrunModeli(
      //28
      urunId: const Uuid().v4(),
      urunBaslik: "Puma Future Z 1.1 FG/AG Soccer Cleats",
      urunFiyat: "199.99",
      urunKategori: "Moda",
      urunAciklama:
          "About this item\nAdaptive FUZIONFIT+ compression band for unparalleled fit and lockdown\nMATRYXEVO woven upper constructed with reactive Kevlar and Carbon yarns for support during fast-forward motion\nDynamic Motion System outsole provides grip and agility\nGripControl Pro coating for better ball control",
      urunResim: "https://i.ibb.co/8bMhmCj/28-Puma-Future-Z-1-1-FG.webp",
      urunMiktar: "474",
    ),
    // Clothes
    UrunModeli(
      //29
      urunId: const Uuid().v4(),
      urunBaslik: "Ray-Ban Wayfarer Sunglasses",
      urunFiyat: "150.75",
      urunKategori: "Accessories",
      urunAciklama:
          "About this item\n100% UV protection: Ray-Ban sunglass lenses are coated with 100% UV protection to protect your eyes from all harmful UV rays\nPolarized sunglasses: These classic Ray-Ban Wayfarer sunglasses feature polarized lenses to reduce glare and enhance clarity\nIconic style: The Wayfarer is one of Ray-Ban's most recognizable and classic designs, available in a variety of lens and frame colors\nDurable construction: These Ray-Ban sunglasses are built to last with high-quality materials and construction",
      urunResim: "https://i.ibb.co/FDMK4Lq/29-Ray-Ban-Wayfarer-Sunglasses.png",
      urunMiktar: "7436",
    ),
    UrunModeli(
      //30
      urunId: const Uuid().v4(),
      urunBaslik: "Herschel Supply Co. Settlement Backpack",
      urunFiyat: "64.99",
      urunKategori: "Accessories",
      urunAciklama:
          "About this item\nSignature striped fabric liner\n15 inch laptop sleeve\nFront storage pocket with key clip\nInternal media pocket with headphone port\nClassic woven label\nDimensions: 17.75 inches (H) x 12.25 inches (W) x 5.75 inches (D)",
      urunResim:
          "https://i.ibb.co/1GV6Nrv/30-Herschel-Supply-Co-Settlement-Backpack.png",
      urunMiktar: "3637",
    ),
    UrunModeli(
      //31
      urunId: const Uuid().v4(),
      urunBaslik: "Fitbit Charge 5 Advanced Fitness Tracker",
      urunFiyat: "179.95",
      urunKategori: "Accessories",
      urunAciklama:
          "About this item\nAdvanced sensors track daily activity, sleep, and stress levels\nUp to 7-day battery life\nEasily track heart rate and exercise metrics\nReceive notifications and control music from your wrist\nWater-resistant up to 50m\nConnect to your phone's GPS to track outdoor activities",
      urunResim:
          "https://i.ibb.co/Wz2yzQ7/31-Fitbit-Charge-5-Advanced-Fitness-Tracker.png",
      urunMiktar: "347343",
    ),
    UrunModeli(
      //32
      urunId: const Uuid().v4(),
      urunBaslik: "Fjallraven Kanken Classic Backpack",
      urunFiyat: "79.95",
      urunKategori: "Accessories",
      urunAciklama:
          "About this item\nVinylon F fabric is durable and water-resistant\nClassic design with a spacious main compartment and front zippered pocket\nPadded shoulder straps for comfortable carrying\nDual top handles for easy transport\nReflective logo for visibility in low light\nDimensions: 15 inches (H) x 10.6 inches (W) x 5.1 inches (D)",
      urunResim:
          "https://i.ibb.co/sjH157B/32-Fjallraven-Kanken-Classic-Backpack.jpg",
      urunMiktar: "7585",
    ),
    UrunModeli(
      //33
      urunId: const Uuid().v4(),
      urunBaslik: "Nike Air Force 1 '07",
      urunFiyat: "90.99",
      urunKategori: "Moda",
      urunAciklama:
          "About this item\nFull-grain leather in the upper adds a premium look and feel.\nThe low-cut silhouette adds a simple, streamlined look.\nPadding at the collar feels soft and comfortable.\nNon-marking rubber in the sole adds traction and durability.",
      urunResim: "https://i.ibb.co/G5kWzbM/33-Nike-Air-Force-1.webp",
      urunMiktar: "47548",
    ),
    UrunModeli(
      //34
      urunId: const Uuid().v4(),
      urunBaslik: "Adidas Ultraboost 21",
      urunFiyat: "180.99",
      urunKategori: "Moda",
      urunAciklama:
          "About this item\nadidas Primeknit+ textile upper\nLace closure\nBoost midsole\nContinental™ Rubber outsole\nadidas Torsion System",
      urunResim: "https://i.ibb.co/X7tVsZ1/34-Adidas-Ultraboost-21.webp",
      urunMiktar: "7485",
    ),
    UrunModeli(
      //35
      urunId: const Uuid().v4(),
      urunBaslik: "Converse Chuck Taylor All Star Low Top",
      urunFiyat: "50.9",
      urunKategori: "Moda",
      urunAciklama:
          "About this item\nLow-top sneaker with canvas upper\nIconic silhouette\nOrthoLite insole for comfort\nDiamond outsole tread\nUnisex Sizing",
      urunResim:
          "https://i.ibb.co/TBQv7G6/22-Converse-Chuck-Taylor-All-Star-High-Top.png",
      urunMiktar: "47433",
    ),
    UrunModeli(
      //36
      urunId: const Uuid().v4(),
      urunBaslik: "Vans Old Skool Classic Skate Moda",
      urunFiyat: "65.99",
      urunKategori: "Moda",
      urunAciklama:
          "About this item\nSuede and Canvas Upper\nRe-enforced toecaps\nPadded collars\nSignature rubber waffle outsole",
      urunResim: "https://i.ibb.co/NNDk3pt/24-Vans-Old-Skool.png",
      urunMiktar: "383",
    ),
  ];
   */
}

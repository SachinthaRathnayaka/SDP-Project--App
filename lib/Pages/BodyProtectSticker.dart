import 'package:flutter/material.dart';
import 'package:sachir_vehicle_care/Pages/ServiceDetailsTemplate.dart';

class BodyProtectStickerScreen extends StatelessWidget {
  const BodyProtectStickerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ServiceDetailsTemplate(
      title: 'Body Stickering',
      price: '25,000 LKR',
      mainImage: 'lib/assets/BodySticker.jpg',
      sliderImages: [
        'lib/assets/BW7.jpg',
        'lib/assets/BS1.jpg',
        'lib/assets/BS2.jpg',
        'lib/assets/BS3.jpg',
        'lib/assets/BW6.jpg',
      ],
      descriptionPoints: [
        'Full body surface wash before sticker',
        'Application of high-quality protective film or vinyl stickers',
        'Coverage for scratch-prone areas (doors, bumpers, side mirrors, etc.)',
        'Water-resistant and UV-blocking material',
        'Precision cutting for a clean, professional finish',
      ],
    );
  }
}
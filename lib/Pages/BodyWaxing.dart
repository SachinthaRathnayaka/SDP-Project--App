import 'package:flutter/material.dart';
import 'package:sachir_vehicle_care/Pages/ServiceDetailsTemplate.dart';

class BodyWaxingScreen extends StatelessWidget {
  const BodyWaxingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ServiceDetailsTemplate(
      title: 'Body waxing',
      price: '14,500 LKR',
      mainImage: 'lib/assets/BodyWaxing.jpg',
      sliderImages: [
        'lib/assets/BW7.jpg',
        'lib/assets/BW8.jpg',
        'lib/assets/BW9.jpg',
        'lib/assets/BW1.jpg',
        'lib/assets/BW4.jpg',
        'lib/assets/BW2.jpg',
        'lib/assets/BW5.jpg',
        'lib/assets/BW3.jpg',
        'lib/assets/BW6.jpg',
      ],
      descriptionPoints: [
        'Full body surface wash before waxing',
        'Application of high-quality automotive wax',
        'Gentle hand or machine buffing for even finish',
        'UV protection layer to preserve paint color',
      ],
    );
  }
}
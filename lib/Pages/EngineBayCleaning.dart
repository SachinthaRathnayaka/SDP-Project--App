import 'package:flutter/material.dart';
import 'package:sachir_vehicle_care/Pages/ServiceDetailsTemplate.dart';

class EngineBayCleaningScreen extends StatelessWidget {
  const EngineBayCleaningScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ServiceDetailsTemplate(
      title: 'Engine Bay Cleaning',
      price: 'LKR. 650',
      mainImage: 'lib/assets/EngineCleaning.jpg',
      sliderImages: [
        'lib/assets/EC1.jpg',
        'lib/assets/EC2.jpg',
        'lib/assets/EC3.jpg',
        'lib/assets/EC4.jpg',
        'lib/assets/EC5.jpg',
      ],
      descriptionPoints: [
        'Safe engine compartment cleaning',
        'Removes dirt, grease and oil stains',
        'Improves engine cooling',
        'Helps identify leaks and worn components',
        'Enhances vehicle resale value',
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:sachir_vehicle_care/Pages/ServiceDetailsTemplate.dart';

class HeadLightCleaningScreen extends StatelessWidget {
  const HeadLightCleaningScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ServiceDetailsTemplate(
      title: 'Head Light Cleaning',
      price: '1,200 LKR',
      mainImage: 'lib/assets/HeadLightClean.jpg',
      sliderImages: [
        'lib/assets/HL3.jpg',
        'lib/assets/HL4.jpg',
        'lib/assets/HeadLightClean.jpg',
        'lib/assets/HL2.jpg',
      ],
      descriptionPoints: [
        'Surface cleaning to remove dirt and grime',
        'Oxidation and yellowing removal',
        'Headlight lens polishing',
        'Protective coating application to prevent future dullness',
      ],
    );
  }
}
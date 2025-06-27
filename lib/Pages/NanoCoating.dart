import 'package:flutter/material.dart';
import 'package:sachir_vehicle_care/Pages/ServiceDetailsTemplate.dart';

class NanoCoatingScreen extends StatelessWidget {
  const NanoCoatingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ServiceDetailsTemplate(
      title: 'NANO Coating',
      price: '18,000 LKR',
      mainImage: 'lib/assets/NanoCoating.jpg',
      sliderImages: [
        'lib/assets/FS6.jpg',
        'lib/assets/NanoCoating.jpg',
        'lib/assets/NC1.jpg',
        'lib/assets/NC2.jpg',
      ],
      descriptionPoints: [
        'Deep surface preparation and cleaning',
        'Application of premium nano-ceramic coating',
        'Protective layer that bonds with vehicle paint',
        'Curing process for durable finish',
      ],
    );
  }
}
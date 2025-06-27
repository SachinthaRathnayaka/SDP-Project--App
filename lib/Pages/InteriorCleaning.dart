import 'package:flutter/material.dart';
import 'package:sachir_vehicle_care/Pages/ServiceDetailsTemplate.dart';

class InteriorCleaningScreen extends StatelessWidget {
  const InteriorCleaningScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ServiceDetailsTemplate(
      title: 'Interior Cleaning',
      price: 'LKR. 3,500',
      mainImage: 'lib/assets/InteriorCleaning.jpg',
      sliderImages: [
        'lib/assets/IC1.jpg',
        'lib/assets/IC2.jpg',
        'lib/assets/IC3.jpg',
        'lib/assets/IC4.jpg',
        'lib/assets/IC5.jpg',
        'lib/assets/IC6.jpg',
      ],
      descriptionPoints: [
        'Complete interior vacuum cleaning',
        'Dashboard and console polishing',
        'Seat and carpet shampoo',
        'Air vent cleaning and sanitizing',
        'Window and glass interior cleaning',
      ],
    );
  }
}
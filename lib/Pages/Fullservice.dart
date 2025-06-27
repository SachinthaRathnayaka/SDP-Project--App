import 'package:flutter/material.dart';
import 'package:sachir_vehicle_care/Pages/ServiceBooking.dart';
import 'package:sachir_vehicle_care/Pages/ServiceDetailsTemplate.dart'; // This will contain the shared UI template

class FullServiceDetailsScreen extends StatelessWidget {
  const FullServiceDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ServiceDetailsTemplate(
      title: 'Full Service',
      price: '7,500 LKR',
      mainImage: 'lib/assets/Fullservice.jpg',
      sliderImages: [
        'lib/assets/FS1.jpg',
        'lib/assets/UnderBodyClean.jpg',
        'lib/assets/FS2.jpg',
        'lib/assets/FS3.jpg',
        'lib/assets/FS7.jpg',
        'lib/assets/FS4.jpg',
        'lib/assets/FS5.jpg',
        'lib/assets/FS6.jpg',
      ],
      descriptionPoints: [
        'Exterior body wash',
        'Under career cleaning & Oiling',
        'Interior full cleaning & Polish',
        'Engine bay cleaning',
        'Body waxing',
        'Full glass cleaning',
        'Tyre cleaning with removing and waxing',
      ],
    );
  }
}
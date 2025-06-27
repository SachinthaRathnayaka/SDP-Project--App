import 'package:flutter/material.dart';
import 'package:sachir_vehicle_care/Pages/ServiceBooking.dart';
import 'package:sachir_vehicle_care/Pages/ServiceDetailsTemplate.dart'; // This will contain the shared UI template

class ServiceDetailsScreen extends StatelessWidget {
  const ServiceDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ServiceDetailsTemplate(
      title: 'Body Wash',
      price: '1,500 LKR',
      mainImage: 'lib/assets/Bodywash.jpg',
      sliderImages: [
        'lib/assets/BodyWash1.jpg',
        'lib/assets/BodyWash2.jpg',
        'lib/assets/BodyWash3.jpg',
      ],
      descriptionPoints: [
        'Exterior body wash',
        'Full glass cleaning',
        'Tyre cleaning and waxing',
        'Body waxing',
      ],
    );
  }
}
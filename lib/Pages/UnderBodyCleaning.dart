import 'package:flutter/material.dart';
import 'package:sachir_vehicle_care/Pages/ServiceBooking.dart';
import 'package:sachir_vehicle_care/Pages/ServiceDetailsTemplate.dart'; // This will contain the shared UI template

class UBCleaningDetailsScreen extends StatelessWidget {
  const UBCleaningDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ServiceDetailsTemplate(
      title: 'Under Body Cleaning',
      price: '1,000 LKR',
      mainImage: 'lib/assets/UnderBodyClean.jpg',
      sliderImages: [
        'lib/assets/UnderBodyClean.jpg',
        'lib/assets/UBW1.jpg',
        'lib/assets/UBW2.jpg',
      ],
      descriptionPoints: [
        'Complete under body cleaning',
        'Removes dirt and mud accumulated underneath',
        'Prevents rust and corrosion',
        'Suitable for all vehicle types',
      ],
    );
  }
}
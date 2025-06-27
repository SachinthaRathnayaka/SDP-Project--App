class WorkshopService {
  final String id;
  final String name;
  final String description;
  final double price;
  final int duration; // in minutes
  final String? imageUrl;

  WorkshopService({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.duration,
    this.imageUrl,
  });

  factory WorkshopService.fromJson(Map<String, dynamic> json) {
    return WorkshopService(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: double.parse(json['price'].toString()),
      duration: json['duration'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'duration': duration,
      'imageUrl': imageUrl,
    };
  }
}

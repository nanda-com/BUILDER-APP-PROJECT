class JobModel {
  final String id;
  final String title;
  final String category;
  final double wagePerHour;
  final double lat;
  final double lng;
  final String address;
  final String city;
  final String duration; // e.g. "4 hrs"
  final String shiftTime; // e.g. "6:00 PM – 10:00 PM"
  final String date; // e.g. "Today" | "Tomorrow" | "17 Mar"
  final String description;
  final List<String> requirements;
  final String employerId;
  final String employerName;
  final double employerRating;
  final bool employerVerified;
  final int workersNeeded;
  final int workersBooked;
  final String status; // 'open' | 'filled' | 'closed'
  double? distanceKm; // computed at runtime

  JobModel({
    required this.id,
    required this.title,
    required this.category,
    required this.wagePerHour,
    required this.lat,
    required this.lng,
    required this.address,
    required this.city,
    required this.duration,
    required this.shiftTime,
    required this.date,
    required this.description,
    required this.requirements,
    required this.employerId,
    required this.employerName,
    required this.employerRating,
    required this.employerVerified,
    required this.workersNeeded,
    required this.workersBooked,
    required this.status,
    this.distanceKm,
  });

  bool get isOpen => status == 'open' && workersBooked < workersNeeded;
  int get slotsLeft => workersNeeded - workersBooked;
  double get totalEarnings => wagePerHour * _parseDurationHours();

  double _parseDurationHours() {
    final match = RegExp(r'(\d+(\.\d+)?)').firstMatch(duration);
    return match != null ? double.tryParse(match.group(1)!) ?? 4.0 : 4.0;
  }

  String get distanceLabel {
    if (distanceKm == null) return '—';
    if (distanceKm! < 1) return '${(distanceKm! * 1000).toInt()} m';
    return '${distanceKm!.toStringAsFixed(1)} km';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'wagePerHour': wagePerHour,
      'lat': lat,
      'lng': lng,
      'address': address,
      'city': city,
      'duration': duration,
      'shiftTime': shiftTime,
      'date': date,
      'description': description,
      'requirements': requirements,
      'employerId': employerId,
      'employerName': employerName,
      'employerRating': employerRating,
      'employerVerified': employerVerified,
      'workersNeeded': workersNeeded,
      'workersBooked': workersBooked,
      'status': status,
    };
  }

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      wagePerHour: (json['wagePerHour'] ?? 0).toDouble(),
      lat: (json['lat'] ?? 0).toDouble(),
      lng: (json['lng'] ?? 0).toDouble(),
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      duration: json['duration'] ?? '',
      shiftTime: json['shiftTime'] ?? '',
      date: json['date'] ?? '',
      description: json['description'] ?? '',
      requirements: List<String>.from(json['requirements'] ?? []),
      employerId: json['employerId'] ?? '',
      employerName: json['employerName'] ?? '',
      employerRating: (json['employerRating'] ?? 0).toDouble(),
      employerVerified: json['employerVerified'] ?? false,
      workersNeeded: json['workersNeeded'] ?? 0,
      workersBooked: json['workersBooked'] ?? 0,
      status: json['status'] ?? 'open',
    );
  }
}

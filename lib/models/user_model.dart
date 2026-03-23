class UserModel {
  final String id;
  final String name;
  final String phone;
  final String role; // 'worker' | 'employer'
  final double trustScore; // 0-100
  final double rating; // 0-5
  final String? avatarInitials;
  final double lat;
  final double lng;
  final String city;
  final List<String> skills;
  final double walletBalance;
  final int jobsCompleted;
  final bool isVerified;

  const UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.role,
    required this.trustScore,
    required this.rating,
    this.avatarInitials,
    required this.lat,
    required this.lng,
    required this.city,
    required this.skills,
    required this.walletBalance,
    required this.jobsCompleted,
    required this.isVerified,
  });

  String get initials {
    if (avatarInitials != null) return avatarInitials!;
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.substring(0, 2).toUpperCase();
  }

  String get trustLabel {
    if (trustScore >= 80) return 'Excellent';
    if (trustScore >= 60) return 'Good';
    if (trustScore >= 40) return 'Average';
    return 'New';
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? role,
    double? trustScore,
    double? rating,
    String? avatarInitials,
    double? lat,
    double? lng,
    String? city,
    List<String>? skills,
    double? walletBalance,
    int? jobsCompleted,
    bool? isVerified,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      trustScore: trustScore ?? this.trustScore,
      rating: rating ?? this.rating,
      avatarInitials: avatarInitials ?? this.avatarInitials,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      city: city ?? this.city,
      skills: skills ?? this.skills,
      walletBalance: walletBalance ?? this.walletBalance,
      jobsCompleted: jobsCompleted ?? this.jobsCompleted,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}

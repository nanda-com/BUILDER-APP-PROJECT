import 'api_service.dart';
import '../models/user_model.dart';
class AuthService {
  static UserModel? _currentUser;
  static UserModel? get currentUser => _currentUser;

  /// Authenticates user with Node.js backend. Creates user if doesn't exist.
  static Future<UserModel> loginWithPhone(
      String phone, String role, String name) async {
    try {
      final response = await ApiService.post(
          '/auth/login', {'phone': phone, 'role': role, 'name': name});

      final token = response['token'];
      final userData = response['user'];

      await ApiService.saveToken(token);

      // Map MongoDB user to local UserModel
      _currentUser = _mapUser(userData);

      // Update the mock data service's static user for compatibility with existing UI
      // MockDataService.currentUser = _currentUser; // removed

      return _currentUser!;
    } catch (e) {
      // print('Login error: $e'); // removed
      rethrow;
    }
  }

  static Future<bool> checkAuth() async {
    final token = await ApiService.getToken();
    if (token == null) return false;

    try {
      final response = await ApiService.get('/auth/me');
      _currentUser = _mapUser(response);
      return true;
    } catch (e) {
      await ApiService.removeToken();
      return false;
    }
  }

  static Future<void> logout() async {
    await ApiService.removeToken();
    _currentUser = null;
  }

  static UserModel _mapUser(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? 'unknown',
      name: json['name'] ?? 'User',
      phone: json['phone'] ?? '',
      role: json['role'] ?? 'worker',
      trustScore: (json['trustScore'] ?? 100).toDouble(),
      rating: (json['rating'] ?? 0).toDouble(),
      avatarInitials: null,
      lat: (json['lat'] ?? 12.9716).toDouble(),
      lng: (json['lng'] ?? 77.5946).toDouble(),
      city: json['city'] ?? 'Bengaluru',
      skills: List<String>.from(json['skills'] ?? []),
      walletBalance: (json['walletBalance'] ?? 0).toDouble(),
      jobsCompleted: json['jobsCompleted'] ?? 0,
      isVerified: json['isVerified'] ?? false,
    );
  }
}

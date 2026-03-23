import 'dart:math';
import '../models/job_model.dart';
import '../models/user_model.dart';
import 'mock_data_service.dart';

/// Simulates a KD-Tree based geospatial matching engine
class MatchingService {
  static const double _earthRadiusKm = 6371.0;

  /// Haversine distance calculation between two lat/lng points
  static double calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    final dLat = _toRad(lat2 - lat1);
    final dLng = _toRad(lng2 - lng1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRad(lat1)) * cos(_toRad(lat2)) * sin(dLng / 2) * sin(dLng / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return _earthRadiusKm * c;
  }

  static double _toRad(double deg) => deg * pi / 180;

  /// KD-Tree simulation: find all jobs within radius and sort by composite score
  /// Score = 0.5 * (1/distance) + 0.3 * trustScore + 0.2 * urgency
  static List<JobModel> findNearbyJobs(
    double userLat,
    double userLng, {
    double radiusKm = 15.0,
    String? category,
  }) {
    final jobs = MockDataService.allJobs
        .where((j) => j.isOpen)
        .where((j) => category == null || category == 'All' || j.category == category)
        .toList();

    // Compute distances (O(n) scan, simulating KD-Tree O(log n) for demo)
    for (final job in jobs) {
      job.distanceKm = calculateDistance(userLat, userLng, job.lat, job.lng);
    }

    // Filter by radius
    final nearby = jobs.where((j) => j.distanceKm! <= radiusKm).toList();

    // Priority rank: closer + higher employer rating = higher priority
    nearby.sort((a, b) {
      final scoreA = _compositeScore(a);
      final scoreB = _compositeScore(b);
      return scoreB.compareTo(scoreA);
    });

    return nearby;
  }

  static double _compositeScore(JobModel job) {
    final distScore = job.distanceKm == null || job.distanceKm! == 0
        ? 1.0
        : 1.0 / (1.0 + job.distanceKm!);
    final ratingScore = job.employerRating / 5.0;
    final urgencyScore = job.date == 'Today' ? 1.0 : 0.5;
    return 0.45 * distScore + 0.35 * ratingScore + 0.2 * urgencyScore;
  }

  /// Priority queue simulation: rank workers by trust score + availability
  static List<UserModel> rankCandidates(List<UserModel> workers) {
    final sorted = [...workers];
    sorted.sort((a, b) {
      final scoreA = a.trustScore * 0.6 + a.rating * 8.0;
      final scoreB = b.trustScore * 0.6 + b.rating * 8.0;
      return scoreB.compareTo(scoreA);
    });
    return sorted;
  }

  /// Geohash simulation: return geohash prefix for a location (5-char precision)
  static String geohash(double lat, double lng) {
    const base32 = '0123456789bcdefghjkmnpqrstuvwxyz';
    var minLat = -90.0, maxLat = 90.0;
    var minLng = -180.0, maxLng = 180.0;
    var hash = '';
    var even = true;
    var bit = 4;
    var ch = 0;

    while (hash.length < 5) {
      if (even) {
        final mid = (minLng + maxLng) / 2;
        if (lng >= mid) {
          ch |= (1 << bit);
          minLng = mid;
        } else {
          maxLng = mid;
        }
      } else {
        final mid = (minLat + maxLat) / 2;
        if (lat >= mid) {
          ch |= (1 << bit);
          minLat = mid;
        } else {
          maxLat = mid;
        }
      }
      even = !even;
      if (bit > 0) {
        --bit;
      } else {
        hash += base32[ch];
        bit = 4;
        ch = 0;
      }
    }
    return hash;
  }
}

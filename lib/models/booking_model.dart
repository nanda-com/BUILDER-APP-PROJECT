class BookingModel {
  final String id;
  final String jobId;
  final String workerId;
  final String jobTitle;
  final String employerName;
  final String shiftTime;
  final String date;
  final String address;
  final double wagePerHour;
  final String duration;
  final String status; // 'confirmed' | 'in_progress' | 'completed' | 'cancelled'
  final DateTime bookedAt;
  final double? earnedAmount;

  const BookingModel({
    required this.id,
    required this.jobId,
    required this.workerId,
    required this.jobTitle,
    required this.employerName,
    required this.shiftTime,
    required this.date,
    required this.address,
    required this.wagePerHour,
    required this.duration,
    required this.status,
    required this.bookedAt,
    this.earnedAmount,
  });

  String get statusLabel {
    switch (status) {
      case 'confirmed': return 'Confirmed';
      case 'in_progress': return 'In Progress';
      case 'completed': return 'Completed';
      case 'cancelled': return 'Cancelled';
      default: return status;
    }
  }
}

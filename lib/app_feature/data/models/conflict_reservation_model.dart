import 'package:equatable/equatable.dart';

class ConflictingReservation extends Equatable {
  final DateTime startTime;
  final DateTime endTime;

  const ConflictingReservation({
    required this.startTime,
    required this.endTime,
  });

  @override
  List<Object?> get props => [startTime, endTime];
}

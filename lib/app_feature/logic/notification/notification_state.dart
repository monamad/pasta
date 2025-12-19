part of 'notification_cubit.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationLoaded extends NotificationState {
  final List<SessionWithDetails> doneSessions;
  final int? highlightSessionId;

  const NotificationLoaded({
    required this.doneSessions,
    this.highlightSessionId,
  });

  @override
  List<Object?> get props => [doneSessions, highlightSessionId];
}

class NotificationError extends NotificationState {
  final String message;

  const NotificationError(this.message);

  @override
  List<Object?> get props => [message];
}

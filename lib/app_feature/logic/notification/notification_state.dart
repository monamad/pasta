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
  final bool hasMore;
  final int currentPage;
  final bool isLoadingMore;

  const NotificationLoaded({
    required this.doneSessions,
    this.highlightSessionId,
    this.hasMore = false,
    this.currentPage = 0,
    this.isLoadingMore = false,
  });

  NotificationLoaded copyWith({
    List<SessionWithDetails>? doneSessions,
    int? highlightSessionId,
    bool? hasMore,
    int? currentPage,
    bool? isLoadingMore,
  }) {
    return NotificationLoaded(
      doneSessions: doneSessions ?? this.doneSessions,
      highlightSessionId: highlightSessionId ?? this.highlightSessionId,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [
    doneSessions,
    highlightSessionId,
    hasMore,
    currentPage,
    isLoadingMore,
  ];
}

class NotificationError extends NotificationState {
  final String message;

  const NotificationError(this.message);

  @override
  List<Object?> get props => [message];
}

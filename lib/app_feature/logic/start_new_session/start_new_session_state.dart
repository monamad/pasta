part of 'start_new_session_cubit.dart';

@immutable
sealed class StartNewSessionState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class StartNewSessionInitial extends StartNewSessionState {}

final class StartNewSessionLoading extends StartNewSessionState {}

final class StartNewSessionDataLoaded extends StartNewSessionState {
  final List<GameTableData> availableTables;
  final List<GameTableData> busyTables;

  StartNewSessionDataLoaded(this.availableTables, this.busyTables);
  @override
  List<Object?> get props => [availableTables, busyTables];
}

final class StartNewSessionError extends StartNewSessionState {
  final String message;
  StartNewSessionError(this.message);
  @override
  List<Object?> get props => [message];
}

final class StartNewSessionSubmitted extends StartNewSessionState {}

final class StartNewSessionSubmitError extends StartNewSessionState {
  final List<GameTableData> availableTables;
  final List<GameTableData> busyTables;
  final String message;
  final DateTime timestamp;
  StartNewSessionSubmitError(
    this.message,
    this.availableTables,
    this.busyTables,
  ) : timestamp = DateTime.now();
  @override
  List<Object?> get props => [message, availableTables, busyTables, timestamp];
}

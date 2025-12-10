part of 'start_new_session_cubit.dart';

@immutable
sealed  class StartNewSessionState {}

final class StartNewSessionInitial extends StartNewSessionState {}

final class StartNewSessionLoading extends StartNewSessionState {}

final class StartNewSessionDataLoaded extends StartNewSessionState {
  final List<GameTableData> availableTables;

  StartNewSessionDataLoaded(this.availableTables);
}

final class StartNewSessionError extends StartNewSessionState {
  final String message;
  StartNewSessionError(this.message);
}

final class StartNewSessionSubmitted extends StartNewSessionState {}

final class StartNewSessionSubmitError extends StartNewSessionState {
  final List<GameTableData> availableTables;
  final String message;
  StartNewSessionSubmitError(this.message, this.availableTables);
}

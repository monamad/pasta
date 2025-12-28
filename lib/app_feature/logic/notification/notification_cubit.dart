import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pasta/app_feature/data/repos/session_repository.dart';
import 'package:pasta/app_feature/data/models/session_model_with_details.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final SessionRepository _sessionRepository;
  static const int _pageSize = 30;

  NotificationCubit(this._sessionRepository) : super(NotificationInitial());

  Future<void> load({int? highlightSessionId}) async {
    emit(NotificationLoading());
    try {
      final doneSessions = await _sessionRepository.getDoneSessions(
        limit: _pageSize,
        offset: 0,
      );

      final hasMore = doneSessions.length == _pageSize;

      emit(
        NotificationLoaded(
          doneSessions: doneSessions,
          highlightSessionId: highlightSessionId,
          hasMore: hasMore,
          currentPage: 0,
        ),
      );

      if (highlightSessionId != null) {
        await Future.delayed(const Duration(seconds: 2));
        if (isClosed) return;
        emit(
          NotificationLoaded(
            doneSessions: doneSessions,
            highlightSessionId: null,
            hasMore: hasMore,
            currentPage: 0,
          ),
        );
      }
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> loadMore() async {
    final currentState = state;
    if (currentState is! NotificationLoaded ||
        currentState.highlightSessionId != null) {
      return;
    }
    if (!currentState.hasMore || currentState.isLoadingMore) return;

    emit(currentState.copyWith(isLoadingMore: true));

    try {
      final nextPage = currentState.currentPage + 1;
      final newSessions = await _sessionRepository.getDoneSessions(
        limit: _pageSize,
        offset: nextPage * _pageSize,
      );
      final hasMore = newSessions.length == _pageSize;
      if (isClosed) return;
      emit(
        NotificationLoaded(
          doneSessions: [...currentState.doneSessions, ...newSessions],
          highlightSessionId: currentState.highlightSessionId,
          hasMore: hasMore,
          currentPage: nextPage,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      emit(currentState.copyWith(isLoadingMore: false));
    }
  }
}

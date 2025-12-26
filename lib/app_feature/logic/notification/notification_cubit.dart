import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pasta/app_feature/data/repos/session_repository.dart';
import 'package:pasta/app_feature/data/models/session_model_with_details.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final SessionRepository _sessionRepository;

  NotificationCubit(this._sessionRepository) : super(NotificationInitial());

  Future<void> load({int? highlightSessionId}) async {
    emit(NotificationLoading());
    try {
      final doneSessions = await _sessionRepository.getDoneSessions();
      final shouldHighlight =
          highlightSessionId != null &&
          doneSessions.any((s) => s.session.id == highlightSessionId);

      emit(
        NotificationLoaded(
          doneSessions: doneSessions,
          highlightSessionId: shouldHighlight ? highlightSessionId : null,
        ),
      );

      if (shouldHighlight) {
        await Future.delayed(const Duration(seconds: 2));
        if (isClosed) return;
        emit(
          NotificationLoaded(
            doneSessions: doneSessions,
            highlightSessionId: null,
          ),
        );
      }
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }
}

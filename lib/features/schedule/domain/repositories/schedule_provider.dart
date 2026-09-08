import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hafiz/features/auth/domain/repositories/auth_provider.dart';
import 'package:hafiz/features/schedule/data/repositories/schedule_repository_impl.dart';
import 'package:hafiz/features/schedule/domain/entities/schedule_event.dart';
import 'package:hafiz/features/schedule/domain/entities/session.dart';
import 'package:hafiz/features/schedule/domain/repositories/schedule_repository.dart';

/// Schedule repository provider.
final scheduleRepositoryProvider = Provider<ScheduleRepository>((ref) {
  return ScheduleRepositoryImpl();
});

/// Events for a date range provider.
final eventsProvider = FutureProvider.autoDispose
    .family<List<ScheduleEvent>, ({DateTime start, DateTime end})>(
        (ref, params) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];

  final result = await ref.read(scheduleRepositoryProvider).getEvents(
        organizationId: user.id,
        startDate: params.start,
        endDate: params.end,
      );

  return result.fold(
    (failure) => throw failure,
    (events) => events,
  );
});

/// Single event provider.
final eventProvider =
    FutureProvider.autoDispose.family<ScheduleEvent, String>((ref, id) async {
  final result =
      await ref.read(scheduleRepositoryProvider).getEvent(id);
  return result.fold(
    (failure) => throw failure,
    (event) => event,
  );
});

/// Sessions for a date range provider.
final sessionsProvider = FutureProvider.autoDispose
    .family<List<Session>, ({DateTime start, DateTime end})>(
        (ref, params) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];

  final result = await ref.read(scheduleRepositoryProvider).getSessions(
        organizationId: user.id,
        startDate: params.start,
        endDate: params.end,
      );

  return result.fold(
    (failure) => throw failure,
    (sessions) => sessions,
  );
});

/// Single session provider.
final sessionProvider =
    FutureProvider.autoDispose.family<Session, String>((ref, id) async {
  final result =
      await ref.read(scheduleRepositoryProvider).getSession(id);
  return result.fold(
    (failure) => throw failure,
    (session) => session,
  );
});

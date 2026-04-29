import '../entities/submission_event.dart';

abstract class SubmissionsStreamRepository {
  /// Long-lived stream of every submission event for the current user.
  /// Re-subscribing returns a new connection.
  Stream<SubmissionEvent> watch();
}

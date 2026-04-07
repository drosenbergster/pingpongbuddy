sealed class Failure {
  const Failure(this.message);
  final String message;
}

final class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message);
}

final class PipelineFailure extends Failure {
  const PipelineFailure(super.message);
}

final class VideoFileFailure extends Failure {
  const VideoFileFailure(super.message);
}

final class SubscriptionFailure extends Failure {
  const SubscriptionFailure(super.message);
}

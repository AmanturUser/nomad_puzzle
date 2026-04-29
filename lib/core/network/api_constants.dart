class ApiConstants {
  const ApiConstants._();

  /// TKNR backend. Change this when the host moves.
  static const String baseUrl = 'https://parallel.airun.kg';

  // Auth
  static const String authLogin = '/api/v1/auth/login';
  static const String authRegister = '/api/v1/auth/register';

  // Users
  static const String me = '/api/v1/users/me';
  static const String meAvatar = '/api/v1/users/me/avatar';
  static const String meProfile = '/api/v1/users/me/profile';
  static const String meSubmissions = '/api/v1/users/me/submissions';
  static const String meStream = '/api/v1/users/me/stream';
  static const String meBookings = '/api/v1/users/me/bookings';
  static const String mePayments = '/api/v1/users/me/payments';
  static const String meReviews = '/api/v1/users/me/reviews';

  // Challenges
  static const String challenges = '/api/v1/challenges';
  static String challengeById(int id) => '/api/v1/challenges/$id';
  static String submitChallenge(int id) => '/api/v1/challenges/$id/submit';
  static String challengeSubmissions(int id) =>
      '/api/v1/challenges/$id/submissions';

  // Submissions
  static String submissionById(int id) => '/api/v1/submissions/$id';
  static String submissionStream(int id) => '/api/v1/submissions/$id/stream';

  // Reference
  static const String countries = '/api/v1/countries';
  static String countryById(int id) => '/api/v1/countries/$id';
  static const String interests = '/api/v1/interests';
  static const String languages = '/api/v1/languages';

  // Tour catalog (public, no auth required)
  static const String catalogTours = '/api/v1/catalog/tours';
  static String catalogTourById(int id) => '/api/v1/catalog/tours/$id';
  static String catalogTourDepartures(int id) =>
      '/api/v1/catalog/tours/$id/departures';

  // AI agent (Jel Aidar)
  static const String agentSessions = '/api/v1/agent/sessions';
  static String agentSessionById(int id) => '/api/v1/agent/sessions/$id';
  static String agentSessionMessages(int id) =>
      '/api/v1/agent/sessions/$id/messages';

  // Voice
  static const String voiceTranscribe = '/api/v1/voice/transcribe';
  static const String voiceSynthesize = '/api/v1/voice/synthesize';

  static const String profile = '/api/v1/users/me';

  static const Duration connectTimeout = Duration(seconds: 20);
  static const Duration receiveTimeout = Duration(seconds: 30);
}

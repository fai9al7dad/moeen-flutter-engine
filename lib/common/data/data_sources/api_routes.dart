class ApiRoutes {
  static const String baseUrl = "https://api.example.com";
  static const String register = "/api/auth/register";
  static const String login = "/api/auth/login";
  static const String me = "/api/users/me";
  static const String createForgotPasswordToken =
      "/api/auth/create-forgot-password-token";
  static const String verifyForgotPasswordToken =
      "/api/auth/verify-forgot-password-token";
  static const String deleteUser = "/api/users/delete-user";
  // duos
  static const String getDuos = "/api/duo/all-duos";
  static const String getDuoInvites = "/api/duo/view-invites";
  static const String getPendingDuoInvites = "/api/duo/view-pending-invites";
  static const String sendDuoInvite = "/api/duo/send-invite";
  static const String acceptDuoInvite = "/api/duo/accept-invite";
  static const String rejectDuoInvite = "/api/duo/reject-invite";
  static const String deletePendingDuoInvite = "/api/duo/delete-pending-invite";
}

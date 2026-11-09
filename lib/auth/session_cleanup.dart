/// Invoked when the API layer drops a Sanctum session (401).
/// AuthController registers this so the home ZIP cannot keep the old user.
void Function()? onSessionRevoked;

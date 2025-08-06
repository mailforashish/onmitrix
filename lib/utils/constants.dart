class Constants {
  // API Constants
  static const String baseUrl = 'YOUR_BASE_URL';
  static const int appId = 1;

  // SharedPreferences Keys
  static const String keyToken = 'token';
  static const String keyUserId = 'user_id';
  static const String keyUsername = 'username';
  static const String keyEmail = 'email';
  static const String keyProfileImage = 'profile_image';
  static const String keyIsLoggedIn = 'is_logged_in';

  // Animation Assets
  static const String animLoading = 'assets/animations/loading_circular.json';
  static const String animMoneyAdded = 'assets/animations/money_added.json';
  static const String animEmptyBox = 'assets/animations/empty_box.json';
  static const String animBackgroundGradient = 'assets/animations/background_gradient.json';

  // Error Messages
  static const String errorNetworkConnection = 'Please check your internet connection';
  static const String errorSomethingWentWrong = 'Something went wrong';
  static const String errorInvalidCredentials = 'Invalid username or password';
  static const String errorFieldRequired = 'This field is required';

  // Success Messages
  static const String successLogin = 'Login successful';
  static const String successLogout = 'Logout successful';
  static const String successProfileUpdate = 'Profile updated successfully';

  // Button Text
  static const String buttonLogin = 'Login';
  static const String buttonSignUp = 'Sign Up';
  static const String buttonSave = 'Save';
  static const String buttonCancel = 'Cancel';
  static const String buttonUpdate = 'Update';
  static const String buttonDelete = 'Delete';
}
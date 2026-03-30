class AppStrings {
  // App
  static const appName = 'Kiponnect';
  static const appTagline = 'Connect. Share. Grow.';
  static const appVersion = '1.0.0';
  
  // Auth - Splash
  static const splashTitle = 'Kiponnect';
  static const splashSubtitle = 'Connect. Share. Grow.';
  
  // Auth - Login
  static const loginTitle = 'Welcome Back';
  static const loginSubtitle = 'Sign in to access your Kiponnect account';
  static const loginEmailLabel = 'Corporate Email / ID';
  static const loginEmailHint = 'Enter your email or student ID';
  static const loginButton = 'Войти';
  static const noAccountText = 'Don\'t have an account?';
  static const requestAccessText = 'Request College Access';
  
  // Auth - OTP
  static const otpTitle = 'Verify OTP';
  static const otpSubtitle = 'Enter the 4-digit code sent to';
  static const otpVerifyButton = 'Verify';
  static const otpResendText = 'Resend code in';
  static const otpResendButtonText = 'Didn\'t receive code? Resend';
  
  // Home
  static const homeTitle = 'Kiponnect';
  static const createNewTitle = 'Create New';
  static const createPost = 'Post';
  static const createQuestion = 'Ask Question';
  static const createNotes = 'Share Notes';
  
  // Schedule
  static const scheduleTitle = 'Smart Schedule';
  static const currentClass = 'Now';
  
  // Academic
  static const academicTitle = 'Academic Hub';
  static const academicQA = 'Q&A';
  static const academicNotes = 'Notes';
  
  // Messenger
  static const messengerTitle = 'Messenger';
  
  // Profile
  static const profileTitle = 'Profile';
  static const profileEditButton = 'Edit Profile';
  static const profileMyPosts = 'My Posts';
  static const profileSavedNotes = 'Saved Notes';
  static const profileSchedule = 'Schedule';
  static const profileAchievements = 'Achievements';
  
  // Burger Menu
  static const menuCampusMaps = 'Campus Maps';
  static const menuCollegeFM = 'College FM';
  static const menuBulletin = 'Bulletin Board 2.0';
  static const menuHelp = 'Help & Support';
  static const menuAbout = 'About Kiponnect';
  static const menuSettings = 'Settings';
  static const menuSignOut = 'Sign Out';
  
  // Common
  static const cancel = 'Cancel';
  static const confirm = 'Confirm';
  static const save = 'Save';
  static const delete = 'Delete';
  static const share = 'Share';
  static const download = 'Download';
  static const upload = 'Upload';
  static const search = 'Search';
  static const loading = 'Loading...';
  static const noData = 'No data available';
  static const error = 'Error';
  static const success = 'Success';
  static const warning = 'Warning';
  
  // Error Messages
  static const errorEmptyEmail = 'Please enter your email or ID';
  static const errorInvalidEmail = 'Please enter a valid email or ID';
  static const errorNetworkError = 'Network error. Please try again.';
  static const errorServerError = 'Server error. Please try again later.';
  static const errorUnauthorized = 'Unauthorized. Please login again.';
  static const errorTimeout = 'Request timeout. Please try again.';
  
  // Success Messages
  static const successOTPSent = 'OTP sent successfully';
  static const successLogin = 'Login successful';
  static const successPostCreated = 'Post created successfully';
  static const successNoteSaved = 'Note saved successfully';
  
  // Feature Coming Soon
  static const featureComingSoon = 'feature coming soon!';
  
  // Footer
  static const footerPoweredBy = 'Powered by College Infrastructure';
  static const footerTagline = 'Made for Students, By Students';
  
  // About
  static const aboutTitle = 'About Kiponnect';
  static const aboutDescription =
      'Kiponnect connects college students in a private, secure environment to share knowledge, collaborate, and build community.';
}

class AppConstants {
  // Dimensions
  static const double borderRadiusLarge = 24.0;
  static const double borderRadiusMedium = 20.0;
  static const double borderRadiusSmall = 16.0;
  static const double borderRadiusExtra = 12.0;
  
  static const double buttonHeight = 56.0;
  static const double buttonHeightSmall = 48.0;
  static const double buttonHeightCompact = 40.0;
  
  static const double standardPadding = 16.0;
  static const double compactPadding = 12.0;
  static const double largePadding = 24.0;
  static const double extraLargePadding = 32.0;
  
  static const double iconSizeStandard = 24.0;
  static const double iconSizeSmall = 20.0;
  static const double iconSizeLarge = 28.0;
  static const double iconSizeExtraLarge = 32.0;
  
  // Durations
  static const Duration animationDurationFast = Duration(milliseconds: 150);
  static const Duration animationDurationMedium = Duration(milliseconds: 300);
  static const Duration animationDurationSlow = Duration(milliseconds: 500);
  static const Duration splashDisplayDuration = Duration(seconds: 4);
  static const Duration otpResendDuration = Duration(seconds: 60);
  
  // OTP
  static const int otpLength = 4;
  
  // Pagination
  static const int pageLimit = 20;
  
  // Timeouts
  static const Duration networkTimeout = Duration(seconds: 30);
}

class AppRegexPatterns {
  // Email pattern
  static final emailPattern = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  
  // Student ID pattern (optional - can be customized)
  static final studentIdPattern = RegExp(
    r'^\d{6,}$',
  );
  
  // Phone number pattern
  static final phonePattern = RegExp(
    r'^\+?[\d\s\-()]{10,}$',
  );
  
  // URL pattern
  static final urlPattern = RegExp(
    r'^https?://',
  );
}

class AppValidators {
  static String? validateEmail(String? email) {
    if (email?.isEmpty ?? true) {
      return AppStrings.errorEmptyEmail;
    }
    if (!AppRegexPatterns.emailPattern.hasMatch(email!)) {
      return AppStrings.errorInvalidEmail;
    }
    return null;
  }
  
  static String? validateStudentId(String? id) {
    if (id?.isEmpty ?? true) {
      return 'Student ID cannot be empty';
    }
    if (id!.length < 4) {
      return 'Student ID is too short';
    }
    return null;
  }
  
  static String? validateOTP(String? otp) {
    if (otp?.length != AppConstants.otpLength) {
      return 'OTP must be 4 digits';
    }
    return null;
  }
  
  static String? validatePassword(String? password) {
    if (password?.isEmpty ?? true) {
      return 'Password cannot be empty';
    }
    if (password!.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }
  
  static String? validateName(String? name) {
    if (name?.isEmpty ?? true) {
      return 'Name cannot be empty';
    }
    if (name!.length < 2) {
      return 'Name is too short';
    }
    return null;
  }
}

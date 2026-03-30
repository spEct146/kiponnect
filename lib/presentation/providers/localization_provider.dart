import 'package:flutter/material.dart';

class LocalizationProvider extends ChangeNotifier {
  String _language = 'en';
  
  String get language => _language;
  
  final Map<String, Map<String, String>> _strings = {
    'en': {
      // Auth
      'welcomeBack': 'Welcome Back',
      'signInSubtitle': 'Sign in to access your Kiponnect account',
      'corporateEmail': 'Corporate Email / ID',
      'enterEmail': 'Enter your email or student ID',
      'login': 'Войти',
      'noAccount': 'Don\'t have an account?',
      'requestAccess': 'Request College Access',
      'verifyOtp': 'Verify OTP',
      'enterCode': 'Enter the 4-digit code sent to',
      'verify': 'Verify',
      'resendCode': 'Resend code in',
      'didntReceive': 'Didn\'t receive code? Resend',
      
      // Home
      'kiponnect': 'Kiponnect',
      'createNew': 'Create New',
      'post': 'Post',
      'askQuestion': 'Ask Question',
      'shareNotes': 'Share Notes',
      
      // Schedule
      'smartSchedule': 'Smart Schedule',
      'now': 'Now',
      
      // Academic
      'academicHub': 'Academic Hub',
      'qa': 'Q&A',
      'notes': 'Notes',
      
      // Messenger
      'messenger': 'Messenger',
      
      // Profile
      'profile': 'Profile',
      'editProfile': 'Edit Profile',
      'myPosts': 'My Posts',
      'savedNotes': 'Saved Notes',
      'schedule': 'Schedule',
      'achievements': 'Achievements',
      
      // Menu
      'campusMaps': 'Campus Maps',
      'collegeFM': 'College FM',
      'bulletinBoard': 'Bulletin Board 2.0',
      'helpSupport': 'Help & Support',
      'about': 'About Kiponnect',
      'settings': 'Settings',
      'signOut': 'Sign Out',
      
      // Common
      'cancel': 'Cancel',
      'confirm': 'Confirm',
      'save': 'Save',
      'delete': 'Delete',
      'share': 'Share',
      'download': 'Download',
      'upload': 'Upload',
      'search': 'Search',
      'loading': 'Loading...',
      'noData': 'No data available',
      'error': 'Error',
      'success': 'Success',
      'warning': 'Warning',
      'comingSoon': 'feature coming soon!',
      
      // Errors
      'emptyEmail': 'Please enter your email or ID',
      'invalidEmail': 'Please enter a valid email or ID',
    },
    'ru': {
      // Auth
      'welcomeBack': 'Добро пожаловать обратно',
      'signInSubtitle': 'Войдите, чтобы получить доступ к вашей учетной записи Kiponnect',
      'corporateEmail': 'Корпоративная почта / ID',
      'enterEmail': 'Введите вашу почту или ID студента',
      'login': 'Войти',
      'noAccount': 'Нет учетной записи?',
      'requestAccess': 'Запросить доступ к колледжу',
      'verifyOtp': 'Подтвердить OTP',
      'enterCode': 'Введите 4-значный код, отправленный на',
      'verify': 'Подтвердить',
      'resendCode': 'Отправить код повторно через',
      'didntReceive': 'Не получили код? Отправить повторно',
      
      // Home
      'kiponnect': 'Kiponnect',
      'createNew': 'Создать новое',
      'post': 'Пост',
      'askQuestion': 'Задать вопрос',
      'shareNotes': 'Поделиться заметками',
      
      // Schedule
      'smartSchedule': 'Умное расписание',
      'now': 'Сейчас',
      
      // Academic
      'academicHub': 'Академический хаб',
      'qa': 'Q&A',
      'notes': 'Заметки',
      
      // Messenger
      'messenger': 'Мессенджер',
      
      // Profile
      'profile': 'Профиль',
      'editProfile': 'Редактировать профиль',
      'myPosts': 'Мои посты',
      'savedNotes': 'Сохраненные заметки',
      'schedule': 'Расписание',
      'achievements': 'Достижения',
      
      // Menu
      'campusMaps': 'Карты кампуса',
      'collegeFM': 'Колледж FM',
      'bulletinBoard': 'Доска объявлений 2.0',
      'helpSupport': 'Помощь и поддержка',
      'about': 'О Kiponnect',
      'settings': 'Настройки',
      'signOut': 'Выйти',
      
      // Common
      'cancel': 'Отмена',
      'confirm': 'Подтвердить',
      'save': 'Сохранить',
      'delete': 'Удалить',
      'share': 'Поделиться',
      'download': 'Скачать',
      'upload': 'Загрузить',
      'search': 'Поиск',
      'loading': 'Загрузка...',
      'noData': 'Нет данных',
      'error': 'Ошибка',
      'success': 'Успех',
      'warning': 'Предупреждение',
      'comingSoon': 'функция скоро появится!',
      
      // Errors
      'emptyEmail': 'Пожалуйста, введите вашу почту или ID',
      'invalidEmail': 'Пожалуйста, введите действительную почту или ID',
    },
  };
  
  String getString(String key) {
    return _strings[_language]?[key] ?? key;
  }
  
  void setLanguage(String lang) {
    _language = lang;
    notifyListeners();
  }
}
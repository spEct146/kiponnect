# Kiponnect - Architecture & Development Guide

## Project Overview

**Kiponnect** is a private social network for college students built with Flutter and Dart. It follows **Clean Architecture** principles with Material 3 design language and deep dark mode theming.

---

## Architecture Overview

### Folder Structure

```
lib/
├── core/
│   ├── constants/
│   │   └── app_colors.dart          # Color palette constants
│   ├── theme/
│   │   └── app_theme.dart           # Material 3 theme configuration
│   └── utils/
│       └── (utility functions)
│
├── data/                            # Data Layer
│   ├── datasources/                 # API/Local data sources
│   ├── models/                      # Data transfer objects (DTOs)
│   └── repositories/                # Repository implementations
│
├── domain/                          # Domain Layer
│   ├── entities/                    # Business entities (with Equatable)
│   ├── repositories/                # Abstract repository interfaces
│   └── usecases/                    # Business logic layers
│
└── presentation/                    # Presentation Layer
    ├── screens/
    │   ├── auth/                    # Authentication flow
    │   │   ├── splash_screen.dart
    │   │   ├── login_screen.dart
    │   │   └── otp_screen.dart
    │   ├── home/                    # Main feed (Threads-style)
    │   ├── schedule/                # Smart timetable
    │   ├── academic/                # Q&A & Notes hub
    │   ├── messenger/               # Chats
    │   └── profile/                 # User profile
    ├── widgets/
    │   ├── common/                  # Reusable components
    │   │   ├── kiponnect_button.dart
    │   │   ├── kiponnect_text_field.dart
    │   │   ├── kiponnect_card.dart
    │   │   ├── avatar_widget.dart
    │   │   ├── post_card.dart
    │   │   └── burger_menu.dart
    │   └── navigation/
    │       └── kiponnect_bottom_nav_bar.dart
    └── providers/                   # State management (Provider/BLoC)
```

---

## Design System

### Color Palette

- **Primary Background**: `#121212` (Deep Dark)
- **Surface**: `#1E1E1E` (Dark Surface)
- **Surface Variant**: `#2A2A2A`
- **Brand Accent**: `#FF7A00` (Vibrant Orange)
- **Text Primary**: `#FFFFFF`
- **Text Secondary**: `#B3B3B3`
- **Text Tertiary**: `#7A7A7A`

### Typography

- **Font Family**: Inter (from Google Fonts)
- **Display**: 32px, 28px, 24px (bold)
- **Headline**: 22px, 20px, 18px (semi-bold)
- **Title**: 16px, 14px, 12px (semi-bold)
- **Body**: 16px, 14px, 12px (regular)
- **Label**: 14px, 12px, 10px (medium/semi-bold)

### Component Styling

- **Border Radius**: 24px+ for main components, 16px for cards, 12px for small elements
- **Button Height**: 56px (standard)
- **Padding**: 16px (standard horizontal), 12px (compact)
- **Icons Size**: 24px (standard), 20px (compact), 28px (large)

---

## Feature Modules

### 1. Authentication (`/lib/presentation/screens/auth/`)

**Splash Screen**
- Logo with fade-in animation
- Auto-navigates to login after 4 seconds

**Login Screen**
- Email/Student ID input field
- "Войти" (Enter) button
- Validation and error handling
- Sign-up request link

**OTP Screen**
- 4 separate input fields with orange borders
- Auto-focus behavior on input
- Resend timer (60 seconds)
- Verification animation

### 2. Main Feed (`/lib/presentation/screens/home/`)

- **Threads-style layout** with post cards
- **Pull-to-refresh** with haptic feedback
- **Post Card Components**:
  - Avatar, Author name, Timestamp
  - Content with image support
  - Reaction buttons (likes, comments, shares)
  - Custom icons for college-themed reactions

### 3. Smart Schedule (`/lib/presentation/screens/schedule/`)

- **Horizontal day selector** (swipeable cards)
- **Class cards** with:
  - Time slot
  - Subject name
  - Room number
  - Teacher name
- **Current class highlighting** with orange border
- Dynamic color coding

### 4. Academic Hub (`/lib/presentation/screens/academic/`)

**Q&A Section**
- Question list with tags (#Math, #Exam, etc.)
- Upvote/Downvote system with orange accent
- Search functionality
- "Ask Question" floating button

**Notes Exchange**
- Grid view of documents
- Summary preview (AI-generated or manual)
- Download button
- Rating system

### 5. Messenger (`/lib/presentation/screens/messenger/`)

- **Chat list** with:
  - Circular avatars
  - Online status indicators
  - Last message preview
  - Unread count badge
- **Individual chat UI** (future):
  - Voice message support
  - "Disappearing messages" (long-press to activate)
  - Double-tap reactions
  - Typing indicators

### 6. User Profile (`/lib/presentation/screens/profile/`)

- **Header section**:
  - Large avatar
  - Year/Group badge
  - Achievements scrollable list
- **Tab navigation**:
  - My Posts
  - Saved Notes
  - Personal Schedule

### 7. Navigation Bar

**Custom Bottom Navigation**
- **Cut-out design** using `CustomPainter`
- **5 tabs**: Home, Search, Create (+), Chats, Profile
- **Orange accent** with smooth animations
- **Glow effect** on active icon

### 8. Burger Menu

- Campus Maps
- College FM (Audio stream)
- Bulletin Board 2.0
- Help & Support
- About Kiponnect
- Settings
- Sign Out

---

## Reusable Components

### `KiponnectButton`
```dart
KiponnectButton(
  label: 'Войти',
  isLoading: false,
  onPressed: () {},
  isOutlined: false,  // Optional: for outlined style
)
```

### `KiponnectTextField`
```dart
KiponnectTextField(
  label: 'Email',
  hintText: 'Enter your email',
  isPassword: false,
  prefixIcon: Icon(Icons.email),
)
```

### `KiponnectCard`
```dart
KiponnectCard(
  padding: EdgeInsets.all(16),
  onTap: () {},
  child: Text('Content'),
)
```

### `AvatarWidget`
```dart
AvatarWidget(
  initials: 'JD',
  size: 48,
  showOnlineIndicator: true,
  isOnline: true,
)
```

### `PostCard`
```dart
PostCard(
  authorName: 'John Doe',
  timestamp: '2 hours ago',
  content: 'Post content...',
  likesCount: 123,
  onLike: () {},
)
```

---

## Routing Configuration

```dart
routes: {
  '/splash': (context) => SplashScreen(),
  '/login': (context) => LoginScreen(),
  '/home': (context) => HomeScreen(),
  '/schedule': (context) => ScheduleScreen(),
  '/academic': (context) => AcademicScreen(),
  '/messenger': (context) => MessengerScreen(),
  '/profile': (context) => ProfileScreen(),
}

onGenerateRoute: (settings) {
  if (settings.name == '/otp') {
    final email = settings.arguments as String;
    return MaterialPageRoute(
      builder: (context) => OtpScreen(email: email),
    );
  }
}
```

---

## Domain Entities

All entities inherit from `Equatable` for easy comparison:

### `User`
- id, email, fullName, avatar
- college, department, year
- postsCount, followersCount, followingCount

### `Post`
- id, authorId, authorName, content
- imageUrls, likesCount, commentsCount, sharesCount
- isLiked, createdAt

### `Chat` & `ChatMessage`
- id, name, participantIds
- lastMessage, lastMessageTime
- message content, type, isDisappearing

### `Class`
- id, subject, room, teacher
- startTime, endTime, day

### `Question` & `Note`
- Academic hub entities with ratings, votes, tags

---

## State Management (Future)

**Recommended**: Provider + Repository pattern

```dart
// Example structure (to be implemented)
class PostProvider extends ChangeNotifier {
  List<Post> _posts = [];
  
  void fetchPosts() async {
    _posts = await _postRepository.getPosts();
    notifyListeners();
  }
}
```

---

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # UI & Design
  google_fonts: ^6.1.0
  
  # State Management  
  provider: ^6.0.0
  
  # Networking
  dio: ^5.3.1
  
  # Local Storage
  shared_preferences: ^2.2.2
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  
  # Dependency Injection
  get_it: ^7.6.0
  
  # Image Caching
  cached_network_image: ^3.3.0
  
  # Utilities
  intl: ^0.19.0
  equatable: ^2.0.5
```

---

## Development Guidelines

### Code Style
- Use meaningful variable names
- Comment complex logic
- Follow Dart style guide
- Use `const` constructors where possible

### Asset Organization
```
assets/
├── images/
│   ├── logo.png
│   └── ...
└── icons/
    ├── custom_icons.svg
    └── ...
```

### Future Additions
1. State management with Provider/BLoC
2. API integration with Dio
3. Local database with Hive
4. Notifications with Firebase
5. Image upload functionality
6. Real-time chat with WebSockets
7. Voice message recording
8. Offline sync

---

## Version History

- **v1.0.0** - Initial release with core features
  - Authentication flow
  - Main feed
  - Smart schedule
  - Academic hub
  - Messenger (chat list)
  - User profile
  - Custom navigation bar
  - Burger menu

---

## Contact & Support

For questions or contributions, please reach out through the Help & Support menu within the app.

**Made for Students, By Students** 🎓

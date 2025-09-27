# Flutter Frontend - Banquet Booking App

A Flutter mobile application for booking banquets and venues with a beautiful, user-friendly interface.

## 🚀 Quick Start

### Prerequisites

- Flutter SDK 3.10+
- Android Studio or VS Code
- Android device/emulator or iOS simulator

### Installation

```bash
cd frontend
flutter pub get
cp .env.example .env
# The .env file is already configured for local development
flutter run
```

## 📱 Features

### Home Screen

- Professional header with user profile
- Search functionality
- Service category cards with images
- Smooth navigation to booking forms

### Banquet Booking Form

- Event type selection dropdown
- Dependent location dropdowns (Country → State → City)
- Multiple event date picker
- Number of adults input
- Visual catering preference selector (Veg/Non-veg)
- Multi-select cuisine options with images
- Budget input with INR currency
- Get offer within timeframe selector
- Additional notes text area
- Form validation and submission
- Success dialog with request ID

## 🛠️ Tech Stack

- **Framework**: Flutter 3+
- **State Management**: Provider
- **HTTP Client**: Dio
- **Image Caching**: cached_network_image
- **Form Handling**: flutter_form_builder
- **Date Picker**: flutter_datetime_picker_plus
- **Environment Config**: flutter_dotenv

## 📁 Project Structure

```
lib/
├── main.dart                    # App entry point
├── models/
│   ├── category.dart           # Category data model
│   ├── location.dart           # Location data model
│   └── cuisine.dart            # Cuisine data model
├── screens/
│   ├── home_screen.dart        # Home screen with categories
│   └── banquet_form_screen.dart # Booking form screen
├── services/
│   └── api_service.dart        # API client for backend communication
├── state/
│   └── app_state.dart          # App state management
└── widgets/
    ├── category_card.dart      # Reusable category card
    ├── cuisine_selector.dart   # Multi-select cuisine widget
    └── success_dialog.dart     # Success confirmation dialog
```

## 🎨 UI/UX Features

- Material Design 3 components
- Smooth animations and transitions
- Loading states and error handling
- Form validation with user-friendly messages
- Responsive design for different screen sizes
- Professional color scheme matching the designs

## ⚙️ Configuration

The app uses environment variables for configuration:

```bash
# .env file
BASE_URL=http://localhost:5000/api
APP_NAME=Banquet Booking
API_TIMEOUT=30000
```

## 🔄 State Management

Uses Provider for:

- API data loading states
- Form data management
- Error handling
- Loading indicators

## 🌐 API Integration

- RESTful API calls to Node.js backend
- Automatic error handling and retry logic
- Loading states for better UX
- Form data validation before submission

## 📱 Supported Platforms

- Android (API level 21+)
- iOS (iOS 11.0+)

## 🧪 Development Commands

```bash
flutter run                # Run in debug mode
flutter run --release      # Run in release mode
flutter build apk          # Build Android APK
flutter build ios          # Build iOS app
flutter clean               # Clean build files
```

## 🔍 Testing the App

1. Start the backend server first
2. Run `flutter run`
3. Navigate through the home screen
4. Tap "BANQUETS & VENUES" to open the booking form
5. Fill out the form and submit
6. Verify success dialog shows request ID

## 🐛 Troubleshooting

- Ensure backend is running before starting the app
- Check network connectivity for image loading
- Verify API URL in .env file matches backend URL
- Run `flutter clean` if build issues occur

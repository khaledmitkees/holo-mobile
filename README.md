# Holo Mobile Challenge

A modern Flutter e-commerce application built with clean architecture principles, featuring product browsing and cart management functionality.

## 🚀 Features

- **Product Catalog**: Browse products with detailed information, ratings, and images
- **Shopping Cart**: Add, update, and remove items with persistent storage
- **Smart Cart Management**: Items automatically removed when quantity reaches zero
- **Empty State Handling**: Graceful empty cart display
- **Responsive Design**: Modern UI with Material Design 3
- **Offline Support**: Local storage for cart persistence
- **Loading States**: Smooth loading indicators and error handling

## 🏗️ Architecture

This project follows **Clean Architecture** principles with clear separation of concerns:

```
lib/
├── core/                    # Core infrastructure
│   ├── constants/          # App constants
│   ├── di/                 # Dependency injection
│   ├── error/              # Error handling
│   ├── logging/            # Logging infrastructure
│   └── network/            # Network layer
├── design_system/          # UI components & theming
│   ├── components/         # Reusable UI components
│   ├── themes/             # App themes
│   └── tokens/             # Design tokens
└── features/               # Feature modules
    ├── products/           # Product catalog feature
    │   ├── data/           # Data layer (models, datasources, repositories)
    │   ├── domain/         # Domain layer (entities, use cases)
    │   └── presentation/   # Presentation layer (pages, blocs, providers)
    └── carts/              # Shopping cart feature
        ├── data/           # Data layer
        ├── domain/         # Domain layer
        └── presentation/   # Presentation layer
```

## 🛠️ Tech Stack

- **Framework**: Flutter 3.7.2+
- **State Management**: BLoC Pattern with flutter_bloc
- **Dependency Injection**: get_it
- **HTTP Client**: Dio
- **Local Storage**: SharedPreferences
- **Image Caching**: cached_network_image
- **Testing**: mockito, bloc_test
- **Code Generation**: build_runner

## 📦 Dependencies

### Core Dependencies
- `flutter_bloc: ^8.1.6` - State management
- `get_it: ^8.0.2` - Dependency injection
- `dio: ^5.9.0` - HTTP client
- `equatable: ^2.0.5` - Value equality
- `cached_network_image: ^3.3.1` - Image caching
- `shared_preferences: ^2.2.2` - Local storage
- `logger: ^2.4.0` - Logging

### Development Dependencies
- `mockito: ^5.4.4` - Mocking for tests
- `bloc_test: ^9.1.7` - BLoC testing utilities
- `build_runner: ^2.4.13` - Code generation

## 🚦 Getting Started

### Prerequisites
- Flutter SDK 3.29.2 (as specified in `.fvmrc`)
- Dart SDK 3.7.2 or higher (as specified in `pubspec.yaml`)
- Android Studio / VS Code
- iOS Simulator / Android Emulator

**Using FVM (Flutter Version Management):**
```bash
# Install the specified Flutter version
fvm install 3.29.2

# Use the project's Flutter version
fvm use 3.29.2

# Run commands with FVM
fvm flutter --version
fvm flutter pub get
fvm flutter run
```

**Verify Your Current Versions:**
```bash
# Check your Flutter version (regular Flutter)
flutter --version

# Check your Flutter version (with FVM)
fvm flutter --version

# Check your Dart version
dart --version
```

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/holo_mobile_challenge.git
   cd holo_mobile_challenge
   ```

2. **Install dependencies**
   ```bash
   fvm flutter pub get
   ```

3. **Generate code (for mocks and other generated files)**
   ```bash
   fvm flutter packages pub run build_runner build
   ```

4. **Run the app**
   ```bash
   fvm flutter run
   ```

### Running Tests

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/features/products/presentation/bloc/products_bloc_test.dart
```

## 📱 App Structure

### Products Feature
- **Products List**: Display all products with images, titles, prices, and ratings
- **Add to Cart**: Add products to shopping cart with quantity selection
- **Product Details**: View detailed product information

### Cart Feature
- **Cart Management**: View, update, and remove cart items
- **Quantity Controls**: Increase/decrease item quantities
- **Smart Removal**: Items removed when quantity reaches zero
- **Empty State**: Clean empty cart display
- **Persistent Storage**: Cart data persists between app sessions
- **Total Calculation**: Real-time cart total updates

## 🧪 Testing

The project includes comprehensive test coverage:

- **Unit Tests**: Core business logic and use cases
- **Widget Tests**: UI components and user interactions
- **BLoC Tests**: State management and event handling
- **Integration Tests**: End-to-end feature testing

**Test Coverage**: 138+ tests covering all major functionality

## 🎨 Design System

The app features a consistent design system with:

- **Common Components**: Reusable UI elements (buttons, app bars, loading overlays)
- **Material Design 3**: Modern Material Design principles
- **Responsive Layout**: Adapts to different screen sizes
- **Consistent Theming**: Unified color scheme and typography
- **Error Handling**: User-friendly error states and messages

## 🔧 Configuration

### API Configuration
The app uses the [Fake Store API](https://fakestoreapi.com/) for product data:
- Base URL: `https://fakestoreapi.com`
- No authentication required
- RESTful endpoints for products and carts

### Local Storage
- Cart data persisted using SharedPreferences
- Automatic data synchronization between local and remote state

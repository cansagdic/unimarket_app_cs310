# UniMarket

UniMarket is a mobile marketplace application developed using Flutter and Firebase, specifically designed for university students. It provides a trusted platform for students to buy, sell, or exchange second-hand items within their community.

## Overview

- **Community Focus**: Tailored for university environments to foster trust.
- **Real-Time**: Utilizes Firebase for real-time data synchronization.
- **Cross-Platform**: Built with Flutter for seamless Android and iOS experiences.
- **Secure**: Authentication via Firebase Auth ensures secure access.

## Features

- **User Authentication**: Secure Login and Registration with email.
- **Product Marketplace**: Browse, search, and filter product listings in real-time.
- **Listing Management**: Easily upload and manage items for sale.
- **Favorites**: Save interesting items for later reference.
- **Messaging**: Direct in-app communication between buyers and sellers.
- **Profile Management**: customizable user profiles and seller views.

## Setup and Run Instructions

### Prerequisites
- **Flutter SDK**: Version `^3.9.2`
- **Git**

### Installation

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/cansagdic/unimarket_app_cs310.git
    cd unimarket_app_cs310
    ```

2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Run the application:**
    ```bash
    flutter run
    ```

## Running Tests

To run the tests for the application, use the following command:

```bash
flutter test
```

### Test Descriptions

#### 1. Unit Tests (`test/theme_provider_test.dart`)
Tests the `ThemeProvider` class which manages the app's dark/light theme:
- **Initial theme test**: Verifies that the app starts in light mode by default.
- **Toggle theme test**: Ensures toggling switches from light to dark mode correctly.

#### 2. Widget Tests (`test/home_page_widget_test.dart`)
Tests the main navigation UI components:
- **App bar title test**: Verifies the app bar displays "UniMarket" title correctly.
- **Navigation bar items test**: Ensures all 5 navigation items (Home, Search, Favourites, Messages, Profile) are present with correct icons and labels.

## Known Limitations or Bugs

- Minor UI inconsistencies may be observed on devices with varying screen sizes or aspect ratios, although responsive design efforts have been made.
- Please report any other issues found during testing.

## Contributors

- Ertuğrul Soydal
- Baran Utku Güler
- Bartu Yılmaz
- Erdem Akay

---
*Developed as part of the CS310 course.*

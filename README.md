# 📱 Lumiform iOS App

A native iOS application that fetches, parses, and displays a JSON hierarchy composed of Pages, Sections, and Questions. The app presents the content visually in a way that reflects its hierarchical relationships using varying font sizes, icons, and interactive elements for images.

## 📋 Table of Contents
- [Features](#features)
- [Architecture](#architecture)
- [Testing](#testing)
- [Future Improvements](#future-improvements)
- [Installation](#installation)
- [API Endpoint](#api-endpoint)

## ✨ Features

- Hierarchical content display with intuitive visual indicators
- Dynamic font sizing based on content hierarchy
- Fetch JSON from a remote endpoint
- Parse and display content in a structured manner
- Support for multiple content types:
  - Pages 📄
  - Sections 📁
  - Questions:
    - Text-based questions 📝
    - Image-based questions 🖼️ with full-screen preview
- Offline capabilities:
  - Data persistence through caching
  - Automatic cache updates when online
  - Seamless offline/online switching
- Error handling:
  - Network error management
  - User-friendly error messages
- Pull-to-refresh functionality
- Loading state indicators

## 🏗️ Architecture

The app follows the MVVM (Model-View-ViewModel) architecture pattern with the following components:

### Models
- `ContentItem`: Represents the hierarchical structure of pages, sections, and questions
- `ContentItemType`: Defines the types of content (page, section, question)
- `QuestionType`: Defines the types of questions (text, image)

### Views
- `ContentListView`: Main view displaying the content hierarchy
- `ContentItemView`: Reusable view for rendering individual content items with visual hierarchy
- `ImageDetailView`: Full-screen view for displaying question images
- `LoadingView`: Loading state indicator
- `ErrorView`: Error state display with retry functionality

### ViewModels
- `ContentViewModel`: Manages content state and business logic

### Services
- `NetworkService`: Handles API communication
- `CacheService`: Manages local data persistence
- `ReachabilityService`: Monitors network connectivity

### Repositories
- `ContentRepository`: Coordinates between network and cache services, handles offline/online switching

## 🧪 Testing

The project includes:
- Unit tests using Swift's latest Testing framework (@Test macro)
- Async/await test support for asynchronous operations
- Comprehensive test coverage for ViewModels and Services
- Mock implementations for dependency isolation
- Network error simulation and state management testing

## 🚀 Future Improvements

### 📦 Modularization
- Extract services into a separate module for better isolation and reusability
- Create a dedicated networking module
- Separate UI components into a design system module

### ⚡️ Performance
- Implement image caching and preloading
- Add pagination for large content hierarchies

### 👩‍💻 Developer Experience
- Add SwiftLint for code style consistency
- Implement CI/CD pipeline
- Add documentation generation

## 🛠️ Installation

1. Clone the repository
2. Open `Lumiform.xcodeproj` in Xcode
3. Build and run the project

## 🔌 API Endpoint

The app fetches data from:
```
https://run.mocky.io/v3/d403fba7-413f-40d8-bec2-afe6ef4e201e
```

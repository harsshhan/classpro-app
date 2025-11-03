# 🎓 ClassPro – SRM Academia

**ClassPro** is a Flutter-based mobile app that provides SRM students a faster, cleaner, and smarter way to access their **profile, marks, and attendance** — all in one place.  

This project is a **mobile port** of the open-source [ClassPro Web](https://github.com/rahuletto/classpro) and its [Backend API](https://github.com/rahuletto/goscraper) originally developed by my friend.  
While the **web interface and backend** belong to his project, this **Flutter app version** was **fully developed by me**.

---

## 🚀 Why ClassPro

The official SRM portal is slow, confusing, and not mobile-friendly.  
ClassPro fixes that with:
- Smooth and modern UI/UX
- Streamlined navigation between sections
- Fast, cached data loading
- Smart utilities like **Gradex** for grade planning


---

## 🧩 Core Features

### 🔐 Login & Authentication
- Secure login using SRM credentials (via the third-party API)
- Saves session tokens for quick auto-login

---

### 👤 Profile
- Displays detailed personal and academic info:
  - Name, Register Number, Department, Year, Semester
  - Faculty, Program details

---

### 📊 Marks
- Fetches internal and external marks
- Clean subject-wise view with color-coded performance
- Auto calculation of total marks and percentages

---

### 🧮 Gradex (Grade Prediction)

Gradex helps you calculate **how much you need in the end-semester** to reach your desired grade based on your internal marks.


## 📁 File Structure
```
classpro-app/
├── lib/                          # Core application code
├── assets/                       # Images, icons, and static assets
├── android/                      # Android-specific configuration
├── ios/                          # iOS-specific configuration
├── linux/                        # Linux-specific configuration
├── provider/                     # State management
│   └── user_provider.dart       # User state management
├── screens/                      # UI screens
│   ├── connectionScreen.dart    # Connection/network screen
│   ├── gradex.dart              # Grade management screen
│   ├── home.dart                # Home screen
│   ├── loading_screen.dart      # Loading/splash screen
│   └── login.dart               # Authentication screen
├── services/                     # Business logic and API integrations
│   ├── api_service.dart         # API communication
│   └── initializer.dart         # App initialization logic
├── utils/                        # Utility functions
│   └── network_utils.dart       # Network helper functions
├── widgets/                      # Reusable UI components
│   ├── attendance.dart          # Attendance widget
│   ├── gradex_widget.dart       # Grade display widget
│   ├── marks.dart               # Marks/grades widget
│   ├── score_box.dart           # Score display component
│   ├── side_drawer.dart         # Navigation drawer
│   └── timetable.dart           # Timetable widget
├── main.dart                    # Entry point
├── styles.dart                  # App-wide styles and themes
├── pubspec.yaml                 # Dependencies configuration
├── .gitignore
└── README.md                    # Project documentation
```

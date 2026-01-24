# Flutter App Folder-Structure

```
lib/
├── core/                          # Shared across features
│   ├── di/                        # Dependency injection
│   ├── errors/                    # Error handling
│   ├── utils/                     # Helpers, extensions, constants
│   ├── theme/                     # App theme, colors, text styles
│   └── widgets/                   # Reusable UI components
│
├── features/                      # Feature modules
│   ├── authentication/
│   │   ├── data/
│   │   │   ├── datasources/       # Remote/Local data sources
│   │   │   ├── models/            # DTOs, JSON serialization
│   │   │   └── repositories/      # Repository implementations
│   │   ├── domain/
│   │   │   ├── entities/          # Business objects
│   │   │   ├── repositories/      # Repository contracts
│   │   │   └── usecases/          # Business logic
│   │   └── presentation/
│   │       ├── bloc/              # State management (Bloc/Cubit/Riverpod)
│   │       ├── pages/             # Full screens
│   │       └── widgets/           # Feature-specific widgets
│   │
│   ├── home/
│   └── profile/
│
├── config/                        # App configuration
│   ├── routes/                    # Navigation/routing
│   ├── environment/               # Env variables (dev/staging/prod)
│   └── app_config.dart
│
└── main.dart                      # Entry point
```
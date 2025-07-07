# Ordo - Task Management App

A modern Flutter task management application with a beautiful Liquid Glass theme option.

## Features

### Core Features
- ✅ **Task Management**: Create, edit, and delete tasks
- ✅ **Priority Levels**: Set task priority (Urgent, Important, Normal)
- ✅ **Voice Tasks**: Record voice notes for tasks
- ✅ **Spoiler Text**: Hide sensitive information in task descriptions
- ✅ **Multi-language Support**: Arabic, English, Korean, Chinese, Russian, Turkish, Spanish

### New: Liquid Glass Theme 🌟
- 🎨 **Liquid Glass Design**: Beautiful glassmorphism effect with advanced visual effects
- 🌊 **Smooth Animations**: Fluid transitions and hover effects
- 💎 **Glass Cards**: Transparent cards with blur effects
- ✨ **Gradient Buttons**: Stunning gradient buttons with glow effects
- 🎯 **Theme Toggle**: Easy switch between classic and Liquid Glass themes

## Liquid Glass Theme Features

The Liquid Glass theme provides:
- **Glassmorphism Effects**: Semi-transparent elements with backdrop blur
- **Advanced Shadows**: Multi-layered shadows for depth
- **Gradient Accents**: Beautiful color gradients throughout the UI
- **Smooth Transitions**: Animated theme switching
- **Responsive Design**: Adapts to different screen sizes

## Screenshots

### Classic Theme
![Classic Theme](screenshots/classic-theme.png)

### Liquid Glass Theme
![Liquid Glass Theme](screenshots/liquid-glass-theme.png)

## Getting Started

### Prerequisites
- Flutter SDK (>=3.4.3)
- Dart SDK
- Android Studio / VS Code

### Installation

1. Clone the repository:
```bash
git clone https://github.com/sandkshnbh/ordo.git
cd ordo
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## How to Use Liquid Glass Theme

1. Open the app
2. Go to Settings (⚙️ icon in the top-left)
3. Find "Liquid Glass Theme" section
4. Toggle the switch to enable/disable the theme
5. Enjoy the beautiful glassmorphism effects!

## Project Structure

```
lib/
├── core/
│   ├── theme.dart              # Classic theme
│   └── liquid_glass_theme.dart # Liquid Glass theme
├── providers/
│   ├── task_provider.dart      # Task state management
│   ├── locale_provider.dart    # Language management
│   └── theme_provider.dart     # Theme state management
├── screens/
│   ├── home_screen.dart        # Main screen
│   ├── add_task_screen.dart    # Add/edit tasks
│   └── settings_screen.dart    # App settings
├── widgets/
│   ├── task_card.dart          # Task display
│   ├── liquid_glass_card.dart  # Liquid Glass components
│   └── spoiler_text.dart       # Hidden text component
└── l10n/                       # Localization files
```

## Dependencies

- `flutter_localizations`: Multi-language support
- `provider`: State management
- `hive`: Local data storage
- `shared_preferences`: Theme preferences
- `font_awesome_flutter`: Icons
- `google_fonts`: Typography
- `record`: Voice recording
- `url_launcher`: External links

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Author

**Sand Kshnbh**
- Telegram: [@sndkshnbh](https://t.me/sndkshnbh)
- Twitter: [@sandkshnbh](https://twitter.com/sandkshnbh)

## Acknowledgments

- Liquid Glass design inspired by modern UI/UX trends
- Glassmorphism effects for enhanced visual appeal
- Flutter community for excellent packages and support

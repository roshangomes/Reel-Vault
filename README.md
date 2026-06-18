# ReelVault

A Flutter app for saving and organizing links from Instagram, TikTok, YouTube, and anywhere else — sorted into categories so you can actually find them later.

## Features

- **6 built-in categories** — Want to visit, Watch, Try, Learn, Buy, Do
- **Save any link** — paste a URL, add a title and optional notes
- **Browse & search** — filter by category or search across title, notes, and URL
- **Mark as done** — check off reels you've watched or visited
- **Share intent** — share links directly from other apps into ReelVault (requires Share Extension setup on iOS)
- **Local storage** — all data stays on your device via SharedPreferences
- **Dark mode** — follows system appearance

## Screenshots

_Coming soon_

## Getting Started

### Prerequisites

- Flutter SDK `>=3.0.0`
- Xcode (for iOS)
- Android Studio (for Android)
- CocoaPods (for iOS native plugins)

### Install

```bash
git clone https://github.com/roshangomes/Reel-Vault.git
cd Reel-Vault
flutter pub get
```

### iOS setup

```bash
pod install --project-directory=ios
flutter run
```

### Android setup

```bash
flutter run
```

## Project Structure

```
lib/
├── constants/
│   └── categories.dart       # Category definitions (id, label, icon, color)
├── models/
│   └── reel.dart             # Reel data model
├── providers/
│   └── reel_provider.dart    # State management (ChangeNotifier)
├── screens/
│   ├── home_screen.dart      # Category grid view
│   ├── browse_screen.dart    # List view with search & filters
│   └── add_edit_screen.dart  # Add / edit reel form
├── services/
│   └── storage_service.dart  # SharedPreferences persistence
├── widgets/
│   └── reel_tile.dart        # Reel list item widget
└── main.dart                 # App entry point + share intent listener
```

## Dependencies

| Package | Purpose |
|---|---|
| `provider` | State management |
| `shared_preferences` | Local data persistence |
| `receive_sharing_intent` | Handle shared URLs from other apps |
| `url_launcher` | Open links in external browser/app |
| `uuid` | Generate unique IDs for reels |
| `intl` | Date formatting |

## Share Extension (iOS)

To enable sharing links directly from Safari, Instagram, etc., you need to add a Share Extension target in Xcode. See the `ios/ShareExtension/` folder for the required files and follow the [receive_sharing_intent setup guide](https://pub.dev/packages/receive_sharing_intent).

## Roadmap

- [ ] Auto-fetch page title and thumbnail when pasting a URL
- [ ] Share Extension fully wired up in Xcode
- [ ] iCloud / Google Drive backup
- [ ] Custom categories
- [ ] Sort and filter options

## License

MIT

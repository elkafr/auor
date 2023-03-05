# auor

A new Flutter application.

## ting Started

This project is a starting point for a Flutter application.

A few resources to  you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help ting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


## How to use provider 
```instatnce of appState --> final _store = Provider.of<AppState>(context); to  data --->  print(_store.DisplayText);```


 ## locatization
 ```flutter pub pub run intl_translation:extract_to_arb --output-dir=lib/l10n lib/locale/localization.dart```

 ```flutter pub pub run intl_translation:generate_from_arb --output-dir=lib/l10n --no-use-deferred-loading lib/l10n/intl_en.arb lib/l10n/intl_messages.arb lib/l10n/intl_ar.arb lib/locale/localization.dart```


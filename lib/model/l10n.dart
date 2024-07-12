import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class S {
  S(this.locale);

  final Locale locale;

  static S? of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  static const LocalizationesDelegete delegate = LocalizationesDelegete();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'Register': 'Don´t have an account yet? join now',
      'SingIn': 'Sing In',
      'Login': 'Login',
      'Email': 'Email',
      'Guest': 'Guest',
      'AppName': 'Tezdo',
      'UserName': 'User name',
      'Password': 'Password',
      'Buy': 'Buy',
      'Price': 'Price',
      'Ratings': 'Ratings',
      'Votes': 'Votes',
    },
  };

  String get appName {
    return _localizedValues[locale.languageCode]!['AppName'] ?? '';
  }

  String get signIn {
    return _localizedValues[locale.languageCode]!['SingIn'] ?? '';
  }

  String get login {
    return _localizedValues[locale.languageCode]!['Login'] ?? '';
  }

  String get email {
    return _localizedValues[locale.languageCode]!['Email'] ?? '';
  }

  String get guest {
    return _localizedValues[locale.languageCode]!['Guest'] ?? '';
  }

  String get register {
    return _localizedValues[locale.languageCode]!['Register'] ?? '';
  }

  String get userName {
    return _localizedValues[locale.languageCode]!['UserName'] ?? '';
  }

  String get password {
    return _localizedValues[locale.languageCode]!['Password'] ?? '';
  }

  String get buy {
    return _localizedValues[locale.languageCode]!['Buy'] ?? '';
  }

  String get price {
    return _localizedValues[locale.languageCode]!['Price'] ?? '';
  }

  String get ratings {
    return _localizedValues[locale.languageCode]!['Ratings'] ?? '';
  }

  String get votes {
    return _localizedValues[locale.languageCode]!['Votes'] ?? '';
  }
}

class LocalizationesDelegete extends LocalizationsDelegate<S> {
  const LocalizationesDelegete();

  @override
  bool isSupported(Locale locale) => ['en'].contains(locale.languageCode);

  @override
  Future<S> load(Locale locale) {
    return SynchronousFuture<S>(S(locale));
  }

  @override
  bool shouldReload(LocalizationesDelegete old) => false;
}

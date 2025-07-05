import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fa.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('es'),
    Locale('fa'),
    Locale('ko'),
    Locale('pl'),
    Locale('ru'),
    Locale('tr'),
    Locale('zh')
  ];

  /// No description provided for @app_title.
  ///
  /// In en, this message translates to:
  /// **'Ordo'**
  String get app_title;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @add_task.
  ///
  /// In en, this message translates to:
  /// **'Add Task'**
  String get add_task;

  /// No description provided for @edit_task.
  ///
  /// In en, this message translates to:
  /// **'Edit Task'**
  String get edit_task;

  /// No description provided for @save_task.
  ///
  /// In en, this message translates to:
  /// **'Save Task'**
  String get save_task;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @active_tasks.
  ///
  /// In en, this message translates to:
  /// **'You have {count} active task'**
  String active_tasks(Object count);

  /// No description provided for @active_tasks_other.
  ///
  /// In en, this message translates to:
  /// **'You have {count} active tasks'**
  String active_tasks_other(Object count);

  /// No description provided for @no_tasks.
  ///
  /// In en, this message translates to:
  /// **'No tasks currently'**
  String get no_tasks;

  /// No description provided for @task_title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get task_title;

  /// No description provided for @task_description.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get task_description;

  /// No description provided for @priority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get priority;

  /// No description provided for @urgent.
  ///
  /// In en, this message translates to:
  /// **'Urgent'**
  String get urgent;

  /// No description provided for @important.
  ///
  /// In en, this message translates to:
  /// **'Important'**
  String get important;

  /// No description provided for @normal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get normal;

  /// No description provided for @confirm_delete.
  ///
  /// In en, this message translates to:
  /// **'Confirm Delete'**
  String get confirm_delete;

  /// No description provided for @delete_question.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this task?'**
  String get delete_question;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @unexpected_error.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred, please try again.'**
  String get unexpected_error;

  /// No description provided for @blur_selected_text.
  ///
  /// In en, this message translates to:
  /// **'Blur Selected Text'**
  String get blur_selected_text;

  /// No description provided for @select_text_first.
  ///
  /// In en, this message translates to:
  /// **'Select text first to blur.'**
  String get select_text_first;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @liquid_glass_theme.
  ///
  /// In en, this message translates to:
  /// **'Liquid Glass Theme'**
  String get liquid_glass_theme;

  /// No description provided for @enable_liquid_glass.
  ///
  /// In en, this message translates to:
  /// **'Enable Liquid Glass Theme'**
  String get enable_liquid_glass;

  /// No description provided for @liquid_glass_description.
  ///
  /// In en, this message translates to:
  /// **'Apply liquid glass design with advanced visual effects'**
  String get liquid_glass_description;

  /// No description provided for @profile_card_title.
  ///
  /// In en, this message translates to:
  /// **'Profile Card'**
  String get profile_card_title;

  /// No description provided for @profile_card_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Flutter App Developer'**
  String get profile_card_subtitle;

  /// No description provided for @profile_card_description.
  ///
  /// In en, this message translates to:
  /// **'I\'m Sand Kshnbh, a Flutter app developer interested in open source software development.\nContact me via: Telegram and Twitter X'**
  String get profile_card_description;

  /// No description provided for @profile_card_telegram.
  ///
  /// In en, this message translates to:
  /// **'My Telegram Channel'**
  String get profile_card_telegram;

  /// No description provided for @profile_card_twitter.
  ///
  /// In en, this message translates to:
  /// **'My Twitter X Account'**
  String get profile_card_twitter;

  /// No description provided for @strike_style.
  ///
  /// In en, this message translates to:
  /// **'Strike Style'**
  String get strike_style;

  /// No description provided for @strike_straight.
  ///
  /// In en, this message translates to:
  /// **'Straight'**
  String get strike_straight;

  /// No description provided for @strike_zigzag.
  ///
  /// In en, this message translates to:
  /// **'Zigzag'**
  String get strike_zigzag;

  /// No description provided for @strike_scribble.
  ///
  /// In en, this message translates to:
  /// **'Scribble'**
  String get strike_scribble;

  /// No description provided for @strike_dashed.
  ///
  /// In en, this message translates to:
  /// **'Dashed'**
  String get strike_dashed;

  /// No description provided for @strike_wave.
  ///
  /// In en, this message translates to:
  /// **'Wave'**
  String get strike_wave;

  /// No description provided for @strike_aqua.
  ///
  /// In en, this message translates to:
  /// **'Aqua'**
  String get strike_aqua;

  /// No description provided for @strike_flame.
  ///
  /// In en, this message translates to:
  /// **'Flame'**
  String get strike_flame;

  /// No description provided for @audio_feature_in_progress.
  ///
  /// In en, this message translates to:
  /// **'Audio feature is under development'**
  String get audio_feature_in_progress;

  /// No description provided for @pin.
  ///
  /// In en, this message translates to:
  /// **'Pin'**
  String get pin;

  /// No description provided for @pin_feature_in_progress.
  ///
  /// In en, this message translates to:
  /// **'Pin feature is under development'**
  String get pin_feature_in_progress;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en', 'es', 'fa', 'ko', 'pl', 'ru', 'tr', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
    case 'fa': return AppLocalizationsFa();
    case 'ko': return AppLocalizationsKo();
    case 'pl': return AppLocalizationsPl();
    case 'ru': return AppLocalizationsRu();
    case 'tr': return AppLocalizationsTr();
    case 'zh': return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}

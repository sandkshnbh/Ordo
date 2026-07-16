import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:expressive_sheet/expressive_sheet.dart';
import 'package:expressive_snack/expressive_snack.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ordo/common/common.dart';
import 'package:ordo/common/localization/app_localizations.dart';
import 'package:ordo/common/localization/locale_cubit.dart';
import 'package:ordo/common/services/update_checker.dart';
import 'package:ordo/features/chat/cubits/chat_cubit.dart';
import 'package:ordo/features/menu/widgets/menu_header.dart';
import 'package:ordo/features/menu/widgets/menu_section.dart';
import 'package:ordo/features/menu/widgets/menu_tile.dart';
import 'package:ordo/features/menu/widgets/version_indicator.dart';
import 'package:ordo/features/menu/widgets/developer_signature.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Map<String, int> _statistics = {'notes': 0, 'tasks': 0, 'completedTasks': 0};

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    final stats = await context.read<ChatCubit>().getStatistics();
    if (mounted) {
      setState(() {
        _statistics = stats;
      });
    }
  }

  String _languageLabel(Locale locale, {bool isSystem = false}) {
    const labels = {
      'en': '🇺🇸 English',
      'ar': '🇱🇾 العربية',
      'ru': '🇷🇺 Русский',
      'ko': '🇰🇷 한국어',
      'fa': '🇮🇷 فارسی',
      'es': '🇪🇸 Español',
      'es-MX': '🇲🇽 Español (MX)',
      'pt-BR': '🇧🇷 Português (BR)',
      'id': '🇮🇩 Bahasa Indonesia',
      'vi': '🇻🇳 Tiếng Việt',
      'zh': '🇨🇳 中文',
      'fil': '🇵🇭 Filipino',
      'ur': '🇵🇰 اردو',
      'si': '🇱🇰 සිංහල',
      'pl': '🇵🇱 Polski',
    };
    final label = labels[locale.toLanguageTag()] ??
        labels[locale.languageCode] ??
        '🇺🇸 English';
    return isSystem ? '${AppLocalizations.of(context).translate('system')} ($label)' : label;
  }

  void _showLanguagePicker(BuildContext context) {
    final current = context.read<LocaleCubit>().state;
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    showExpressiveSheet(
      context: context,
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Material(
              color: cs.surfaceContainerHigh,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(52),
              ),
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: cs.secondaryContainer,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.language_rounded,
                          size: 32,
                          color: cs.onSecondaryContainer,
                        ),
                      ),
                    ),
                    16.gap,
                    Text(
                      AppLocalizations.of(context).translate('language'),
                      textAlign: TextAlign.center,
                      style: tt.titleLarge?.copyWith(
                        fontFamily: 'Unbounded',
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                      ),
                    ),
                    24.gap,
                    Flexible(
                      child: Scrollbar(
                        thumbVisibility: true,
                        child: SingleChildScrollView(
                          primary: true,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _LangTile(
                                label: AppLocalizations.of(context).translate('system'),
                                selected: context.read<LocaleCubit>().isSystem,
                                onTap: () {
                                  context.read<LocaleCubit>().setSystem();
                                  Navigator.of(ctx).pop();
                                },
                              ),
                              2.gap,
                              _LangTile(
                                label: '🇺🇸 English',
                                selected: current.languageCode == 'en',
                                onTap: () {
                                  context.read<LocaleCubit>().setLocale(
                                    const Locale('en'),
                                  );
                                  Navigator.of(ctx).pop();
                                },
                              ),
                              2.gap,
                              _LangTile(
                                label: '🇱🇾 العربية',
                                selected: current.languageCode == 'ar',
                                onTap: () {
                                  context.read<LocaleCubit>().setLocale(
                                    const Locale('ar'),
                                  );
                                  Navigator.of(ctx).pop();
                                },
                              ),
                              2.gap,
                              _LangTile(
                                label: '🇷🇺 Русский',
                                selected: current.languageCode == 'ru',
                                onTap: () {
                                  context.read<LocaleCubit>().setLocale(
                                    const Locale('ru'),
                                  );
                                  Navigator.of(ctx).pop();
                                },
                              ),
                              2.gap,
                              _LangTile(
                                label: '🇰🇷 한국어',
                                selected: current.languageCode == 'ko',
                                onTap: () {
                                  context.read<LocaleCubit>().setLocale(
                                    const Locale('ko'),
                                  );
                                  Navigator.of(ctx).pop();
                                },
                              ),
                              2.gap,
                              _LangTile(
                                label: '🇮🇷 فارسی',
                                selected: current.languageCode == 'fa',
                                onTap: () {
                                  context.read<LocaleCubit>().setLocale(
                                    const Locale('fa'),
                                  );
                                  Navigator.of(ctx).pop();
                                },
                              ),
                              2.gap,
                              _LangTile(
                                label: '🇪🇸 Español',
                                selected: current.languageCode == 'es',
                                onTap: () {
                                  context.read<LocaleCubit>().setLocale(
                                    const Locale('es'),
                                  );
                                  Navigator.of(ctx).pop();
                                },
                              ),
                              2.gap,
                              _LangTile(
                                label: '🇮🇩 Bahasa Indonesia',
                                selected: current.languageCode == 'id',
                                onTap: () {
                                  context.read<LocaleCubit>().setLocale(
                                    const Locale('id'),
                                  );
                                  Navigator.of(ctx).pop();
                                },
                              ),
                              2.gap,
                              _LangTile(
                                label: '🇻🇳 Tiếng Việt',
                                selected: current.languageCode == 'vi',
                                onTap: () {
                                  context.read<LocaleCubit>().setLocale(
                                    const Locale('vi'),
                                  );
                                  Navigator.of(ctx).pop();
                                },
                              ),
                              2.gap,
                              _LangTile(
                                label: '🇨🇳 中文',
                                selected: current.languageCode == 'zh',
                                onTap: () {
                                  context.read<LocaleCubit>().setLocale(
                                    const Locale('zh'),
                                  );
                                  Navigator.of(ctx).pop();
                                },
                              ),
                              2.gap,
                              _LangTile(
                                label: '🇲🇽 Español (MX)',
                                selected: current.toLanguageTag() == 'es-MX',
                                onTap: () {
                                  context.read<LocaleCubit>().setLocale(
                                    const Locale('es', 'MX'),
                                  );
                                  Navigator.of(ctx).pop();
                                },
                              ),
                              2.gap,
                              _LangTile(
                                label: '🇧🇷 Português (BR)',
                                selected: current.toLanguageTag() == 'pt-BR',
                                onTap: () {
                                  context.read<LocaleCubit>().setLocale(
                                    const Locale('pt', 'BR'),
                                  );
                                  Navigator.of(ctx).pop();
                                },
                              ),
                              2.gap,
                              _LangTile(
                                label: '🇵🇭 Filipino',
                                selected: current.languageCode == 'fil',
                                onTap: () {
                                  context.read<LocaleCubit>().setLocale(
                                    const Locale('fil'),
                                  );
                                  Navigator.of(ctx).pop();
                                },
                              ),
                              2.gap,
                              _LangTile(
                                label: '🇵🇰 اردو',
                                selected: current.languageCode == 'ur',
                                onTap: () {
                                  context.read<LocaleCubit>().setLocale(
                                    const Locale('ur'),
                                  );
                                  Navigator.of(ctx).pop();
                                },
                              ),
                              2.gap,
                              _LangTile(
                                label: '🇱🇰 සිංහල',
                                selected: current.languageCode == 'si',
                                onTap: () {
                                  context.read<LocaleCubit>().setLocale(
                                    const Locale('si'),
                                  );
                                  Navigator.of(ctx).pop();
                                },
                              ),
                              2.gap,
                              _LangTile(
                                label: '🇵🇱 Polski',
                                selected: current.languageCode == 'pl',
                                onTap: () {
                                  context.read<LocaleCubit>().setLocale(
                                    const Locale('pl'),
                                  );
                                  Navigator.of(ctx).pop();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Icon(
                        Icons.expand_more_rounded,
                        size: 18,
                        color: cs.onSurfaceVariant.withValues(alpha: 0.4),
                      ),
                    ),
                    8.gap,
                    SizedBox(
                      height: 56,
                      child: OutlinedButton(
                        style: FilledButton.styleFrom(
                          textStyle: tt.titleMedium,
                        ),
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: Text(
                          AppLocalizations.of(context).translate('cancel'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Lottie.asset('assets/SK/icon/left.json', width: 28, height: 28),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          AppLocalizations.of(context).translate('settings'),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontFamily: 'Unbounded',
            fontWeight: FontWeight.w600,
            letterSpacing: -0.3,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          MenuHeader(
                notesCount: _statistics['notes']?.toString() ?? '0',
                tasksCount: _statistics['tasks']?.toString() ?? '0',
              )
              .animate()
              .fadeIn(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOut,
              )
              .slideY(begin: 0.1, end: 0),
          const SizedBox(height: 32),

          const SizedBox(height: 32),

          // Support Section
          MenuSection(
                label: AppLocalizations.of(context).translate('support'),
                children: [
                  MenuTile(
                    icon: Icons.card_giftcard_rounded,
                    title: AppLocalizations.of(context).translate('buyMeACoffee'),
                    subtitle: 'USDT (TRC20): TSqLvSjij9KnqVCaU63mpp2bEqbnaoBpgR',
                    onTap: () async {
                      final uri = Uri.parse(
                        'https://link.trustwallet.com/send?coin=195&address=TSqLvSjij9KnqVCaU63mpp2bEqbnaoBpgR&token_id=TR7NHqjeKQxGTCi8q8ZY4pL8otSzgjLj6t',
                      );
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri, mode: LaunchMode.externalApplication);
                      }
                    },
                  ),
                ],
              )
              .animate()
              .fadeIn(
                duration: const Duration(milliseconds: 400),
                delay: const Duration(milliseconds: 100),
                curve: Curves.easeOut,
              )
              .slideY(begin: 0.1, end: 0),

          const SizedBox(height: 32),

          // Data Section
          MenuSection(
                label: AppLocalizations.of(context).translate('data'),
                children: [
                  MenuTile(
                    icon: Icons.download_rounded,
                    title: AppLocalizations.of(context).translate('dataExport'),
                    onTap: () async {
                      final cubit = context.read<ChatCubit>();
                      try {
                        final data = await cubit.exportData();
                        final dir = await getApplicationDocumentsDirectory();
                        final file = File('${dir.path}/ordo_export.txt');
                        await file.writeAsString(data);
                        await SharePlus.instance.share(
                          ShareParams(
                            files: [XFile(file.path)],
                            subject: AppLocalizations.of(context).translate('myOrdoData'),
                          ),
                        );
                      } catch (e) {
                        showExpressiveSnack(
                          context: context,
                          message: AppLocalizations.of(context).translate('failedToExportData'),
                          icon: Icons.error_outline,
                        );
                      }
                    },
                  ),
                  MenuTile(
                    icon: Icons.upload_rounded,
                    title: AppLocalizations.of(context).translate('dataImport'),
                    onTap: () async {
                      final cubit = context.read<ChatCubit>();
                      try {
                        final confirmed = await StyledSheet.show(
                          context,
                          icon: Icons.upload_rounded,
                          title: AppLocalizations.of(context).translate('importDataTitle'),
                          message:
                              AppLocalizations.of(context).translate('importDataMessage'),
                          confirmLabel: AppLocalizations.of(context).translate('importLabel'),
                          destructive: false,
                        );
                        if (confirmed) {
                          final dir = await getApplicationDocumentsDirectory();
                          final file = File('${dir.path}/ordo_export.txt');
                          if (await file.exists()) {
                            final data = await file.readAsString();
                            await cubit.importData(data);
                            showExpressiveSnack(
                              context: context,
                              message: AppLocalizations.of(context).translate('dataImportedSuccessfully'),
                              icon: Icons.check_circle_outline,
                            );
                          } else {
                            showExpressiveSnack(
                              context: context,
                              message: AppLocalizations.of(context).translate('noExportFileFound'),
                              icon: Icons.error_outline,
                            );
                          }
                        }
                      } catch (e) {
                        showExpressiveSnack(
                          context: context,
                          message: AppLocalizations.of(context).translate('failedToImportData'),
                          icon: Icons.error_outline,
                        );
                      }
                    },
                  ),
                ],
              )
              .animate()
              .fadeIn(
                duration: const Duration(milliseconds: 400),
                delay: const Duration(milliseconds: 100),
                curve: Curves.easeOut,
              )
              .slideY(begin: 0.1, end: 0),

          const SizedBox(height: 32),

          // Preferences Section
          BlocBuilder<ThemeModeCubit, ThemeMode>(
                builder: (context, themeMode) {
                  return BlocBuilder<DynamicColorCubit, bool>(
                    builder: (context, dynamicColor) {
                      return BlocBuilder<AmoledModeCubit, bool>(
                        builder: (context, amoled) {
                          return BlocBuilder<SpecialThemeCubit, bool>(
                            builder: (context, specialTheme) {
                              return BlocBuilder<SkipWelcomeCubit, bool>(
                                builder: (context, skipWelcome) {
                                  return MenuSection(
                                    label: AppLocalizations.of(context)
                                        .translate('preferences'),
                                    children: [
                                      MenuTile(
                                        icon: Icons.language_rounded,
                                        title: AppLocalizations.of(context)
                                            .translate('language'),
                                        subtitle: _languageLabel(
                                          context.watch<LocaleCubit>().state,
                                          isSystem: context.watch<LocaleCubit>().isSystem,
                                        ),
                                        onTap: () => _showLanguagePicker(
                                          context,
                                        ),
                                      ),
                                      MenuTile(
                                        icon: Icons.brightness_6_outlined,
                                        title: AppLocalizations.of(context).translate('darkTheme'),
                                        trailing: Switch(
                                          value: themeMode == ThemeMode.dark,
                                          thumbIcon:
                                              const WidgetStateProperty<
                                                Icon?
                                              >.fromMap({
                                                WidgetState.selected: Icon(
                                                  Icons.dark_mode_rounded,
                                                ),
                                                WidgetState.any: Icon(
                                                  Icons.light_mode_rounded,
                                                ),
                                              }),
                                          onChanged: (_) {
                                            context
                                                .read<ThemeModeCubit>()
                                                .toggle();
                                          },
                                        ),
                                      ),
                                      BlocBuilder<NotificationsCubit, bool>(
                                        builder: (context, notificationsEnabled) {
                                          return MenuTile(
                                            icon: Icons
                                                .notifications_active_outlined,
                                            title: AppLocalizations.of(context).translate('notifications'),
                                            subtitle: AppLocalizations.of(context).translate('taskReminders'),
                                            trailing: Switch(
                                              value: notificationsEnabled,
                                              thumbIcon:
                                                  const WidgetStateProperty<
                                                    Icon?
                                                  >.fromMap({
                                                    WidgetState.selected: Icon(
                                                      Icons
                                                          .notifications_rounded,
                                                    ),
                                                    WidgetState.any: Icon(
                                                      Icons
                                                          .notifications_outlined,
                                                    ),
                                                  }),
                                              onChanged: (value) {
                                                context
                                                    .read<NotificationsCubit>()
                                                    .setEnabled(value);
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                      BlocBuilder<SendButtonStyleCubit, bool>(
                                        builder: (context, separate) {
                                          return MenuTile(
                                            icon: Icons.send_rounded,
                                            title: AppLocalizations.of(context).translate('separateSendButton'),
                                            subtitle: separate
                                                ? AppLocalizations.of(context).translate('hexagonalButtonNextToBox')
                                                : AppLocalizations.of(context).translate('buttonInsideComposeBox'),
                                            trailing: Switch(
                                              value: separate,
                                              onChanged: (value) {
                                                context
                                                    .read<
                                                      SendButtonStyleCubit
                                                    >()
                                                    .setSeparate(value);
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                      BlocBuilder<SwipeToDeleteCubit, bool>(
                                        builder: (context, enabled) {
                                          return MenuTile(
                                            icon: Icons.swipe_rounded,
                                            title: AppLocalizations.of(context).translate('swipeToDelete'),
                                            subtitle: enabled
                                                ? AppLocalizations.of(context).translate('swipeCardsToDelete')
                                                : AppLocalizations.of(context).translate('longPressForActions'),
                                            trailing: Switch(
                                              value: enabled,
                                              onChanged: (value) {
                                                context
                                                    .read<SwipeToDeleteCubit>()
                                                    .setEnabled(value);
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                      BlocBuilder<CompactModeCubit, bool>(
                                        builder: (context, compact) {
                                          return MenuTile(
                                            icon: Icons
                                                .space_dashboard_rounded,
                                            title: AppLocalizations.of(context).translate('compactCards'),
                                            subtitle: compact
                                                ? AppLocalizations.of(context).translate('hideIconsOnNoteTaskCards')
                                                : AppLocalizations.of(context).translate('showIconsOnNoteTaskCards'),
                                            trailing: Switch(
                                              value: compact,
                                              onChanged: (value) {
                                                context
                                                    .read<CompactModeCubit>()
                                                    .setEnabled(value);
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                      MenuTile(
                                        icon: Icons.contrast_rounded,
                                        title: AppLocalizations.of(context).translate('amoledMode'),
                                        subtitle: AppLocalizations.of(context).translate('trueBlackBackground'),
                                        trailing: Switch(
                                          value: amoled,
                                          thumbIcon:
                                              const WidgetStateProperty<
                                                Icon?
                                              >.fromMap({
                                                WidgetState.selected: Icon(
                                                  Icons.contrast_rounded,
                                                ),
                                                WidgetState.any: Icon(
                                                  Icons.contrast_outlined,
                                                ),
                                              }),
                                          onChanged: (value) {
                                            context
                                                .read<AmoledModeCubit>()
                                                .setEnabled(value);
                                          },
                                        ),
                                      ),
                                      MenuTile(
                                        icon: Icons.palette_outlined,
                                        title: AppLocalizations.of(context).translate('dynamicColor'),
                                        subtitle: AppLocalizations.of(context).translate('useWallpaperColors'),
                                        trailing: Switch(
                                          value: dynamicColor,
                                          thumbIcon:
                                              const WidgetStateProperty<
                                                Icon?
                                              >.fromMap({
                                                WidgetState.selected: Icon(
                                                  Icons.palette_rounded,
                                                ),
                                                WidgetState.any: Icon(
                                                  Icons.palette_outlined,
                                                ),
                                              }),
                                          onChanged: (value) {
                                            context
                                                .read<DynamicColorCubit>()
                                                .setEnabled(value);
                                          },
                                        ),
                                      ),
                                      MenuTile(
                                        icon: Icons.auto_awesome_outlined,
                                        title: AppLocalizations.of(context).translate('specialTheme'),
                                        subtitle: AppLocalizations.of(context).translate('customColorScheme'),
                                        trailing: Switch(
                                          value: specialTheme,
                                          thumbIcon:
                                              const WidgetStateProperty<
                                                Icon?
                                              >.fromMap({
                                                WidgetState.selected: Icon(
                                                  Icons.auto_awesome_rounded,
                                                ),
                                                WidgetState.any: Icon(
                                                  Icons.auto_awesome_outlined,
                                                ),
                                              }),
                                          onChanged: (value) {
                                            context
                                                .read<SpecialThemeCubit>()
                                                .setEnabled(value);
                                          },
                                        ),
                                      ),
                                      MenuTile(
                                        icon: Icons.skip_next_outlined,
                                        title: AppLocalizations.of(context).translate('skipWelcome'),
                                        subtitle:
                                            AppLocalizations.of(context).translate('goDirectlyToHomeOnLaunch'),
                                        trailing: Switch(
                                          value: skipWelcome,
                                          thumbIcon:
                                              const WidgetStateProperty<
                                                Icon?
                                              >.fromMap({
                                                WidgetState.selected: Icon(
                                                  Icons.skip_next_rounded,
                                                ),
                                                WidgetState.any: Icon(
                                                  Icons.skip_next_outlined,
                                                ),
                                              }),
                                          onChanged: (value) {
                                            context
                                                .read<SkipWelcomeCubit>()
                                                .setEnabled(value);
                                          },
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                },
              )
              .animate()
              .fadeIn(
                duration: const Duration(milliseconds: 400),
                delay: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
              )
              .slideY(begin: 0.1, end: 0),

          const SizedBox(height: 32),

          // Support Section
          MenuSection(
                label: AppLocalizations.of(context).translate('support'),
                children: [
                  MenuTile(
                    icon: Icons.update_rounded,
                    title: AppLocalizations.of(context).translate('checkForUpdates'),
                    onTap: () async {
                      showExpressiveSnack(
                        context: context,
                        message: AppLocalizations.of(context).translate('checkingForUpdates'),
                        icon: Icons.refresh_rounded,
                      );

                      final updateInfo = await UpdateChecker.checkForUpdates();

                      if (!mounted) return;

                      if (updateInfo == null) {
                        showExpressiveSnack(
                          context: context,
                          message: AppLocalizations.of(context).translate('failedToCheckForUpdates'),
                          icon: Icons.error_outline,
                        );
                        return;
                      }

                      if (updateInfo['hasUpdate'] == true) {
                        final isDark =
                            Theme.of(context).brightness == Brightness.dark;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                Icon(
                                  Icons.new_releases_rounded,
                                  color: isDark
                                      ? cs.primary
                                      : cs.onPrimaryContainer,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    '${AppLocalizations.of(context).translate('updateAvailable')} v${updateInfo['latestVersion']}',
                                    style: TextStyle(
                                      color: isDark
                                          ? cs.onSurface
                                          : cs.onPrimaryContainer,
                                      fontSize: 13,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            backgroundColor: isDark
                                ? cs.surfaceContainerHigh
                                : cs.primaryContainer,
                            duration: const Duration(seconds: 8),
                            action: SnackBarAction(
                              label: AppLocalizations.of(context).translate('download'),
                              textColor: cs.primary,
                              onPressed: () {
                                launchUrl(
                                  Uri.parse(updateInfo['downloadUrl']),
                                  mode: LaunchMode.externalApplication,
                                );
                              },
                            ),
                          ),
                        );
                      } else {
                        showExpressiveSnack(
                          context: context,
                          message: AppLocalizations.of(context).translate('youAreUsingLatestVersion'),
                          icon: Icons.check_circle_outline,
                        );
                      }
                    },
                  ),
                  MenuTile(
                    icon: Icons.telegram_rounded,
                    title: AppLocalizations.of(context).translate('joinTelegramGroup'),
                    subtitle: AppLocalizations.of(context).translate('getSupportAndUpdates'),
                    onTap: () {
                      launchUrl(
                        Uri.parse('https://t.me/ordosk5'),
                        mode: LaunchMode.externalApplication,
                      );
                    },
                  ),
                  MenuTile(
                    icon: Icons.favorite_rounded,
                    title: AppLocalizations.of(context).translate('supportTheDeveloper'),
                    background: cs.secondaryContainer,
                    foreground: cs.onSecondaryContainer,
                    onTap: () {
                      launchUrl(
                        Uri.parse(AppValues.makerGithubUrl),
                        mode: LaunchMode.externalApplication,
                      );
                    },
                  ),
                  MenuTile(
                    icon: Icons.lightbulb_rounded,
                    title: AppLocalizations.of(context).translate('suggestAFeature'),
                    onTap: () {
                      launchUrl(
                        Uri.parse(
                          '${AppValues.makerGithubUrl}/ordo/issues/new',
                        ),
                        mode: LaunchMode.externalApplication,
                      );
                    },
                  ),
                  MenuTile(
                    icon: Icons.bug_report_rounded,
                    title: AppLocalizations.of(context).translate('reportAnIssue'),
                    onTap: () {
                      launchUrl(
                        Uri.parse(
                          '${AppValues.makerGithubUrl}/ordo/issues/new',
                        ),
                        mode: LaunchMode.externalApplication,
                      );
                    },
                  ),
                ],
              )
              .animate()
              .fadeIn(
                duration: const Duration(milliseconds: 400),
                delay: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              )
              .slideY(begin: 0.1, end: 0),

          const SizedBox(height: 32),

          // Data Management Section
          MenuSection(
                label: AppLocalizations.of(context).translate('dangerZone'),
                children: [
                  MenuTile(
                    icon: Icons.delete_forever_rounded,
                    title: AppLocalizations.of(context).translate('deleteAllData'),
                    foreground: cs.error,
                    onTap: () async {
                      final confirmed = await StyledSheet.show(
                        context,
                        icon: Icons.delete_forever_rounded,
                        title: AppLocalizations.of(context).translate('deleteAllData'),
                        message:
                            AppLocalizations.of(context).translate('deleteAllDataConfirmation'),
                        confirmLabel: AppLocalizations.of(context).translate('delete'),
                        destructive: true,
                      );
                      if (confirmed) {
                        context.read<ChatCubit>().clearAllMessages();
                        showExpressiveSnack(
                          context: context,
                          message: AppLocalizations.of(context).translate('allDataDeleted'),
                          icon: Icons.delete_rounded,
                        );
                      }
                    },
                  ),
                ],
              )
              .animate()
              .fadeIn(
                duration: const Duration(milliseconds: 400),
                delay: const Duration(milliseconds: 400),
                curve: Curves.easeOut,
              )
              .slideY(begin: 0.1, end: 0),

          const SizedBox(height: 64),
          Center(
            child:
                SvgPicture.asset(
                  'assets/SK/ordo.svg',
                  width: 80,
                  height: 80,
                  colorFilter: ColorFilter.mode(
                    cs.onSurfaceVariant,
                    BlendMode.srcIn,
                  ),
                ).animate().fadeIn(
                  duration: const Duration(milliseconds: 400),
                  delay: const Duration(milliseconds: 500),
                  curve: Curves.easeOut,
                ),
          ),
          const VersionIndicator(showCircle: false).animate().fadeIn(
            duration: const Duration(milliseconds: 400),
            delay: const Duration(milliseconds: 600),
            curve: Curves.easeOut,
          ),
          const SizedBox(height: 8),
          const DeveloperSignature().animate().fadeIn(
            duration: const Duration(milliseconds: 400),
            delay: const Duration(milliseconds: 700),
            curve: Curves.easeOut,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _LangTile extends StatelessWidget {
  const _LangTile({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Material(
      color: selected ? cs.primaryContainer : cs.surfaceContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(
                selected
                    ? Icons.check_circle_rounded
                    : Icons.circle_outlined,
                size: 24,
                color: selected ? cs.primary : cs.onSurfaceVariant,
              ),
              16.gap,
              Text(
                label,
                style: tt.bodyLarge?.copyWith(
                  color: selected ? cs.onPrimaryContainer : cs.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

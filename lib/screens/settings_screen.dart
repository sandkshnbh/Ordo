import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ordo/providers/locale_provider.dart';
import 'package:ordo/providers/strike_style_provider.dart';
import 'package:ordo/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:ordo/providers/card_customization_provider.dart';

class NeonIconButton extends StatelessWidget {
  final IconData icon;
  final Color glowColor;
  final VoidCallback onTap;
  final Color iconColor;
  final double size;
  final String? tooltip;

  const NeonIconButton({
    super.key,
    required this.icon,
    required this.glowColor,
    required this.onTap,
    this.iconColor = Colors.white,
    this.size = 28,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final button = GestureDetector(
      onTap: onTap,
      child: Container(
        width: size + 28,
        height: size + 18,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          color: glowColor.withOpacity(0.13),
          border: Border.all(color: glowColor.withOpacity(0.7), width: 2),
          boxShadow: [
            BoxShadow(
              color: glowColor.withOpacity(0.55),
              blurRadius: 18,
              spreadRadius: 1,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: Icon(icon, color: iconColor, size: size),
        ),
      ),
    );
    return tooltip != null ? Tooltip(message: tooltip!, child: button) : button;
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  static const languages = [
    {'code': 'ar', 'label': 'AR', 'flag': '🇱🇾'},
    {'code': 'en', 'label': 'EN', 'flag': '🇺🇸'},
    {'code': 'ko', 'label': 'KO', 'flag': '🇰🇷'},
    {'code': 'zh', 'label': 'ZH', 'flag': '🇨🇳'},
    {'code': 'ru', 'label': 'RU', 'flag': '🇷🇺'},
    {'code': 'tr', 'label': 'TR', 'flag': '🇹🇷'},
    {'code': 'es', 'label': 'ES', 'flag': '🇪🇸'},
    {'code': 'pl', 'label': 'PL', 'flag': '🇵🇱'},
    {'code': 'fa', 'label': 'FA', 'flag': '🇮🇷'},
  ];

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    String currentLang = localeProvider.locale?.languageCode ?? 'ar';

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Material(
            color: Colors.white.withOpacity(0.10),
            shape: const CircleBorder(),
            elevation: 2,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => Navigator.of(context).pop(),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.arrow_back_ios_new_rounded,
                    color: Colors.white, size: 22),
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Text(AppLocalizations.of(context)!.language,
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.10),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: Border.all(
                  color: Colors.white.withOpacity(0.15),
                  width: 1.2,
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: currentLang,
                  dropdownColor: const Color(0xFF232323),
                  icon: const Icon(Icons.arrow_drop_down_rounded,
                      color: Colors.white, size: 28),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                  borderRadius: BorderRadius.circular(20),
                  items: languages
                      .map((lang) => DropdownMenuItem<String>(
                            value: lang['code'],
                            child: Row(
                              children: [
                                Text(lang['flag']!,
                                    style: const TextStyle(fontSize: 22)),
                                const SizedBox(width: 8),
                                Text(lang['label']!,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18)),
                              ],
                            ),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null && value != currentLang) {
                      localeProvider.setLocale(Locale(value));
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
            Consumer<StrikeStyleProvider>(
              builder: (context, strikeProvider, _) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.strike_style,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.15),
                          width: 1.2,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<StrikeStyle>(
                          isExpanded: true,
                          value: strikeProvider.style,
                          dropdownColor: const Color(0xFF232323),
                          icon: const Icon(Icons.arrow_drop_down_rounded,
                              color: Colors.white, size: 28),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                          borderRadius: BorderRadius.circular(20),
                          items: [
                            DropdownMenuItem(
                              value: StrikeStyle.straight,
                              child: Text(AppLocalizations.of(context)!
                                  .strike_straight),
                            ),
                            DropdownMenuItem(
                              value: StrikeStyle.zigzag,
                              child: Text(
                                  AppLocalizations.of(context)!.strike_zigzag),
                            ),
                            DropdownMenuItem(
                              value: StrikeStyle.scribble,
                              child: Text(AppLocalizations.of(context)!
                                  .strike_scribble),
                            ),
                            DropdownMenuItem(
                              value: StrikeStyle.dashed,
                              child: Text(
                                  AppLocalizations.of(context)!.strike_dashed),
                            ),
                            DropdownMenuItem(
                              value: StrikeStyle.wave,
                              child: Text(
                                  AppLocalizations.of(context)!.strike_wave),
                            ),
                            DropdownMenuItem(
                              value: StrikeStyle.aqua,
                              child: Text(
                                  AppLocalizations.of(context)!.strike_aqua),
                            ),
                            DropdownMenuItem(
                              value: StrikeStyle.flame,
                              child: Text(
                                  AppLocalizations.of(context)!.strike_flame),
                            ),
                          ],
                          onChanged: (style) {
                            if (style != null) strikeProvider.setStyle(style);
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
            Consumer<CardCustomizationProvider>(
              builder: (context, cardCustom, _) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('تخصيص كرت المهام',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('إظهار ظل الكرت',
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                      Switch(
                        value: cardCustom.showShadow,
                        onChanged: (val) => cardCustom.setShowShadow(val),
                        activeColor: Colors.blueAccent,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('لون مخصص للكرت',
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                      Switch(
                        value: cardCustom.useCustomColor,
                        onChanged: (val) => cardCustom.setUseCustomColor(val),
                        activeColor: Colors.blueAccent,
                      ),
                    ],
                  ),
                  if (cardCustom.useCustomColor)
                    Row(
                      children: [
                        Text('اختر اللون:',
                            style:
                                TextStyle(color: Colors.white, fontSize: 15)),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () async {
                            Color picked = cardCustom.customColor;
                            await showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                backgroundColor: Colors.grey[900],
                                title: const Text('اختر اللون',
                                    style: TextStyle(color: Colors.white)),
                                content: SingleChildScrollView(
                                  child: ColorPicker(
                                    pickerColor: picked,
                                    onColorChanged: (color) => picked = color,
                                    enableAlpha: false,
                                    showLabel: false,
                                    pickerAreaHeightPercent: 0.7,
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    child: const Text('تم',
                                        style: TextStyle(
                                            color: Colors.blueAccent)),
                                    onPressed: () {
                                      cardCustom.setCustomColor(picked);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: cardCustom.customColor,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Center(
              child: Text(
                'صفحة الإعدادات',
                style: TextStyle(fontSize: 20, color: Colors.white70),
              ),
            ),
            const SizedBox(height: 32),
            Card(
              elevation: 0,
              color: Colors.transparent,
              margin: const EdgeInsets.only(top: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(38),
              ),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(38),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(Icons.person,
                                color: Colors.white, size: 32),
                          ),
                          Spacer(),
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: Colors.white, width: 2.2),
                            ),
                            child: CircleAvatar(
                              radius: 32,
                              backgroundColor: Colors.grey.shade900,
                              backgroundImage:
                                  AssetImage('assets/icons/sk.png'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Text(
                        AppLocalizations.of(context)!.profile_card_title,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        AppLocalizations.of(context)!.profile_card_subtitle,
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 18),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 15,
                            height: 1.6,
                          ),
                          children: [
                            TextSpan(
                                text: AppLocalizations.of(context)!
                                    .profile_card_description),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          NeonIconButton(
                            icon: FontAwesomeIcons.telegram,
                            glowColor: Color(0xFF00C6FF),
                            onTap: () =>
                                _launchUrl(Uri.parse('https://t.me/sndkshnbh')),
                            tooltip: AppLocalizations.of(context)!
                                .profile_card_telegram,
                            size: 28,
                          ),
                          const SizedBox(width: 16),
                          NeonIconButton(
                            icon: FontAwesomeIcons.twitter,
                            glowColor: Color(0xFF1DA1F2),
                            onTap: () => _launchUrl(
                                Uri.parse('https://twitter.com/sandkshnbh')),
                            tooltip: AppLocalizations.of(context)!
                                .profile_card_twitter,
                            size: 28,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

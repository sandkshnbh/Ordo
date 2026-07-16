import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:expressive_sheet/expressive_sheet.dart';
import 'package:ordo/common/common.dart';
import 'package:ordo/common/localization/app_localizations.dart';
import 'package:ordo/features/chat/cubits/chat_cubit.dart';

class ChatCreationSheet extends StatefulWidget {
  const ChatCreationSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showExpressiveSheet<void>(
      context: context,
      builder: (context) => const ChatCreationSheet(),
    );
  }

  @override
  State<ChatCreationSheet> createState() => _ChatCreationSheetState();
}

class _ChatCreationSheetState extends State<ChatCreationSheet> {
  final TextEditingController _controller = TextEditingController();
  bool _isCreating = false;

  List<String> _getSuggestions(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return [
      l10n.translate('suggestionMyThoughts'),
      l10n.translate('suggestionDailyTasks'),
      l10n.translate('suggestionProjectIdeas'),
      l10n.translate('suggestionPersonalNotes'),
      l10n.translate('suggestionWorkJournal'),
    ];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _createChat() {
    final title = _controller.text.trim();
    if (title.isEmpty) return;

    setState(() => _isCreating = true);

    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      context.read<ChatCubit>().createNewChat(title: title);
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, BottomPadding.of(context)),
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
                8.gap,
                Text(
                  AppLocalizations.of(context).translate('newChat'),
                  textAlign: TextAlign.center,
                  style: tt.headlineLarge?.copyWith(
                    color: cs.onSurface,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ).animate().fadeIn().slideY(begin: 0.2, end: 0),
                24.gap,
                TextField(
                      controller: _controller,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context).translate('enterChatNameHint'),
                        hintStyle: TextStyle(
                          color: cs.onSurfaceVariant.withValues(alpha: 0.7),
                        ),
                        filled: true,
                        fillColor: cs.surfaceContainerHighest,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                      ),
                      style: TextStyle(color: cs.onSurface, fontSize: 16),
                      onSubmitted: (_) => _createChat(),
                    )
                    .animate(delay: const Duration(milliseconds: 100))
                    .fadeIn()
                    .slideY(begin: 0.2, end: 0),
                16.gap,
                Text(
                      AppLocalizations.of(context).translate('suggestions'),
                      style: tt.titleSmall?.copyWith(
                        color: cs.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                    .animate(delay: const Duration(milliseconds: 150))
                    .fadeIn()
                    .slideY(begin: 0.2, end: 0),
                12.gap,
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _getSuggestions(context).map<Widget>((suggestion) {
                    return _SuggestionChip(
                          label: suggestion,
                          onTap: () {
                            _controller.text = suggestion;
                            _createChat();
                          },
                        )
                        .animate(
                          delay: Duration(
                            milliseconds:
                                200 + _getSuggestions(context).indexOf(suggestion) * 50,
                          ),
                        )
                        .fadeIn()
                        .slideX(begin: 0.2, end: 0);
                  }).toList(),
                ),
                24.gap,
                FilledButton(
                      onPressed: _isCreating ? null : _createChat,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: _isCreating
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: cs.onPrimary,
                              ),
                            )
                          : Text(
                              AppLocalizations.of(context).translate('createChat'),
                              style: tt.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    )
                    .animate(delay: const Duration(milliseconds: 300))
                    .fadeIn()
                    .slideY(begin: 0.2, end: 0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SuggestionChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _SuggestionChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: cs.outlineVariant.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: tt.labelMedium?.copyWith(color: cs.onSurfaceVariant),
        ),
      ),
    );
  }
}

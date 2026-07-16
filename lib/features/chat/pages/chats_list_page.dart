import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:motor/motor.dart';
import 'package:material_shapes/material_shapes.dart';
import 'package:lottie/lottie.dart';
import 'package:ordo/common/common.dart';
import 'package:ordo/common/localization/app_localizations.dart';
import 'package:ordo/common/widgets/styled_sheet.dart';
import 'package:ordo/features/chat/cubits/chat_cubit.dart';
import 'package:ordo/features/chat/widgets/chat_creation_sheet.dart';
import 'package:ordo/data/database.dart';

class ChatsListPage extends StatelessWidget {
  const ChatsListPage({super.key, this.onBack});

  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              automaticallyImplyLeading: false,
              leading: IconButton(
                icon: Lottie.asset(
                  'assets/SK/icon/left.json',
                  width: 28,
                  height: 28,
                ),
                onPressed: onBack ?? () => Navigator.of(context).pop(),
              ),
              title: Text(
                AppLocalizations.of(context).translate('chats'),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontFamily: 'Unbounded',
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.3,
                  color: cs.onSurface,
                ),
              ),
              centerTitle: true,
            ),
            SliverToBoxAdapter(
              child: BlocBuilder<ChatCubit, ChatState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(64),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (state.chats.isEmpty) {
                    return _EmptyState(cs: cs);
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
            BlocBuilder<ChatCubit, ChatState>(
              builder: (context, state) {
                if (state.isLoading || state.chats.isEmpty) {
                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                }

                return SliverPadding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 80),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final chat = state.chats[index];
                      final cubit = context.read<ChatCubit>();
                      final isCurrentChat = cubit.chatId == chat.id;

                      return _ChatTile(
                            chat: chat,
                            isCurrentChat: isCurrentChat,
                            onTap: () async {
                              await cubit.switchChat(chat.id);
                              if (context.mounted) {
                                if (onBack != null) {
                                  onBack!();
                                } else {
                                  Navigator.pop(context);
                                }
                              }
                            },
                            onDelete: () async {
                              final l10n = AppLocalizations.of(context);
                              final confirmed = await StyledSheet.show(
                                context,
                                icon: Icons.delete_outline,
                                title: l10n.translate('deleteChatTitle'),
                                message: l10n.translate('deleteChatMessage'),
                                confirmLabel: l10n.translate('delete'),
                                destructive: true,
                              );
                              if (confirmed) {
                                await cubit.deleteChat(chat);
                              }
                            },
                          )
                          .animate(delay: Duration(milliseconds: index * 60))
                          .fadeIn(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeOut,
                          )
                          .slideY(begin: 0.15, end: 0);
                    }, childCount: state.chats.length),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: _CreateChatButton(),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final ColorScheme cs;

  const _EmptyState({required this.cs});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(64),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.chat_bubble_outline_rounded,
              size: 64,
              color: cs.onSurfaceVariant,
            ),
          ).animate().scale(
            duration: const Duration(milliseconds: 600),
            curve: Curves.elasticOut,
          ),
          const SizedBox(height: 32),
          Text(
            AppLocalizations.of(context).translate('noChatsYet'),
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: cs.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ).animate().fadeIn(delay: const Duration(milliseconds: 200)),
          const SizedBox(height: 12),
          Text(
            AppLocalizations.of(context).translate('startNewConversationHint'),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: cs.onSurfaceVariant.withValues(alpha: 0.8),
            ),
          ).animate().fadeIn(delay: const Duration(milliseconds: 300)),
        ],
      ),
    );
  }
}

class _ChatTile extends StatefulWidget {
  final Chat chat;
  final bool isCurrentChat;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _ChatTile({
    required this.chat,
    required this.isCurrentChat,
    required this.onTap,
    required this.onDelete,
  });

  @override
  State<_ChatTile> createState() => _ChatTileState();
}

class _ChatTileState extends State<_ChatTile> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SingleMotionBuilder(
      motion: const MaterialSpringMotion.standardSpatialFast(),
      value: _pressed ? 1.0 : 0.0,
      builder: (context, t, child) {
        final scale = 1 - 0.01 * t;

        return Transform.scale(
          scale: scale,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Material(
              color: widget.isCurrentChat
                  ? cs.primaryContainer
                  : cs.surfaceContainerHigh,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: widget.onTap,
                onHighlightChanged: (highlighted) {
                  setState(() => _pressed = highlighted);
                },
                splashColor: cs.primary.withValues(alpha: 0.08),
                highlightColor: cs.primary.withValues(alpha: 0.04),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: widget.isCurrentChat
                              ? cs.primary.withValues(alpha: 0.15)
                              : cs.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          Icons.chat_bubble_rounded,
                          color: widget.isCurrentChat
                              ? cs.primary
                              : cs.onSurfaceVariant,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.chat.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    fontWeight: widget.isCurrentChat
                                        ? FontWeight.w800
                                        : FontWeight.w700,
                                    color: widget.isCurrentChat
                                        ? cs.onPrimaryContainer
                                        : cs.onSurface,
                                    letterSpacing: -0.3,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _formatDate(context, widget.chat.updatedAt),
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: widget.isCurrentChat
                                        ? cs.onPrimaryContainer.withValues(
                                            alpha: 0.7,
                                          )
                                        : cs.onSurfaceVariant.withValues(
                                            alpha: 0.7,
                                          ),
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      widget.isCurrentChat
                          ? _ActiveBadge(cs: cs)
                          : _DeleteButton(onPressed: widget.onDelete),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatDate(BuildContext context, DateTime date) {
    final l10n = AppLocalizations.of(context);
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return l10n.translate('justNow');
    } else if (difference.inHours < 1) {
      return l10n.translate('minutesAgo').replaceAll('{minutes}', difference.inMinutes.toString());
    } else if (difference.inDays < 1) {
      return l10n.translate('hoursAgo').replaceAll('{hours}', difference.inHours.toString());
    } else if (difference.inDays < 7) {
      return l10n.translate('daysAgo').replaceAll('{days}', difference.inDays.toString());
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

class _ActiveBadge extends StatelessWidget {
  final ColorScheme cs;

  const _ActiveBadge({required this.cs});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: cs.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            AppLocalizations.of(context).translate('active'),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: cs.onPrimary,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

class _DeleteButton extends StatefulWidget {
  final VoidCallback onPressed;

  const _DeleteButton({required this.onPressed});

  @override
  State<_DeleteButton> createState() => _DeleteButtonState();
}

class _DeleteButtonState extends State<_DeleteButton> {
  bool _pressed = false;

  static const Motion _spatialIn = MaterialSpringMotion.expressiveSpatialFast();
  static const Motion _spatialOut = MaterialSpringMotion.standardSpatialFast();
  static const Motion _effectIn = MaterialSpringMotion.expressiveEffectsFast();
  static const Motion _effectOut = MaterialSpringMotion.standardEffectsFast();

  static final MaterialShapeBorder _circle = MaterialShapeBorder(
    shape: MaterialShapes.circle,
  );
  static final MaterialShapeBorder _sunny = MaterialShapeBorder(
    shape: MaterialShapes.sunny,
  );

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final double target = _pressed ? 1 : 0;

    return Tooltip(
      message: AppLocalizations.of(context).translate('deleteChatTooltip'),
      child: InkResponse(
        onTap: widget.onPressed,
        onHighlightChanged: (highlighted) {
          setState(() => _pressed = highlighted);
        },
        radius: 26,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: SingleMotionBuilder(
          value: target,
          motion: _pressed ? _spatialIn : _spatialOut,
          builder: (context, spatial, child) {
            return SingleMotionBuilder(
              value: target,
              motion: _pressed ? _effectIn : _effectOut,
              builder: (context, effect, child) {
                final double fade = effect.clamp(0.0, 1.0);

                return SizedBox(
                  width: 48,
                  height: 48,
                  child: Center(
                    child: Transform.scale(
                      scale: 1 + 0.12 * spatial,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: ShapeDecoration(
                          color: cs.errorContainer.withValues(alpha: fade),
                          shape:
                              ShapeBorder.lerp(_circle, _sunny, spatial) ??
                              _circle,
                        ),
                        child: Icon(
                          Icons.delete_outline_rounded,
                          size: 22,
                          color: Color.lerp(
                            cs.onSurfaceVariant,
                            cs.onErrorContainer,
                            fade,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _CreateChatButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: cs.primary,
        borderRadius: BorderRadius.circular(28),
      ),
      child: FloatingActionButton.extended(
        onPressed: () async {
          await ChatCreationSheet.show(context);
        },
        icon: const Icon(Icons.add_rounded),
        label: Text(AppLocalizations.of(context).translate('newChat')),
        backgroundColor: Colors.transparent,
        foregroundColor: cs.onPrimary,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      ),
    ).animate().fadeIn().scale(
      duration: const Duration(milliseconds: 500),
      curve: Curves.elasticOut,
    );
  }
}

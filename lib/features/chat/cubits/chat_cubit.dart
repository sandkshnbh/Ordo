import 'dart:async';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ordo/common/services/notification_service.dart';
import 'package:ordo/data/database.dart';
import 'package:drift/drift.dart';

class ChatState {
  final List<Message> messages;
  final List<Chat> chats;
  final bool isLoading;

  ChatState({
    required this.messages,
    required this.chats,
    this.isLoading = false,
  });
}

class ChatCubit extends Cubit<ChatState> {
  final AppDatabase db;
  final NotificationService _notificationService;
  int? chatId;
  StreamSubscription? _chatsSubscription;
  StreamSubscription? _messagesSubscription;

  ChatCubit(this.db, NotificationService? notificationService)
    : _notificationService = notificationService ?? NotificationService(),
      super(ChatState(messages: [], chats: [], isLoading: true)) {
    _init();
  }

  @override
  Future<void> close() async {
    await _chatsSubscription?.cancel();
    await _messagesSubscription?.cancel();
    return super.close();
  }

  Future<void> _init() async {
    // Get or create a default chat
    final chats = await db.select(db.chats).get();
    if (chats.isEmpty) {
      chatId = await db
          .into(db.chats)
          .insert(ChatsCompanion.insert(title: 'My Thoughts'));
    } else {
      chatId = chats.first.id;
    }

    _loadChats();
    _loadMessages();
  }

  void _loadChats() {
    _chatsSubscription?.cancel();
    _chatsSubscription =
        (db.select(
          db.chats,
        )..orderBy([(c) => OrderingTerm.desc(c.updatedAt)])).watch().listen(
          (chats) {
            emit(
              ChatState(
                messages: state.messages,
                chats: chats,
                isLoading: state.isLoading,
              ),
            );
          },
          onError: (e) {
            emit(
              ChatState(
                messages: state.messages,
                chats: state.chats,
                isLoading: false,
              ),
            );
          },
        );
  }

  void _loadMessages() {
    _messagesSubscription?.cancel();
    _messagesSubscription =
        (db.select(db.messages)
              ..where((m) => m.chatId.equals(chatId!))
              ..orderBy([(m) => OrderingTerm.desc(m.createdAt)]))
            .watch()
            .listen(
              (messages) {
                emit(
                  ChatState(
                    messages: messages,
                    chats: state.chats,
                    isLoading: false,
                  ),
                );
              },
              onError: (e) {
                emit(
                  ChatState(messages: [], chats: state.chats, isLoading: false),
                );
              },
            );
  }

  Future<void> switchChat(int newChatId) async {
    chatId = newChatId;
    _loadMessages();
  }

  Future<void> createNewChat({String title = 'New Chat'}) async {
    chatId = await db
        .into(db.chats)
        .insert(ChatsCompanion.insert(title: title));
    emit(ChatState(messages: [], chats: state.chats, isLoading: false));
    _loadMessages();
  }

  Future<void> sendMessage(
    String content,
    String type, {
    DateTime? reminderTime,
  }) async {
    // Create chat if it doesn't exist
    if (chatId == null) {
      chatId = await db
          .into(db.chats)
          .insert(ChatsCompanion.insert(title: 'New Chat'));
      _loadMessages();
    }

    final messageId = await db
        .into(db.messages)
        .insert(
          MessagesCompanion.insert(
            chatId: chatId!,
            type: type,
            content: content,
            reminderTime: reminderTime != null
                ? Value(reminderTime)
                : const Value.absent(),
          ),
        );
    // Update chat timestamp
    await (db.update(db.chats)..where((c) => c.id.equals(chatId!))).write(
      ChatsCompanion(updatedAt: Value(DateTime.now())),
    );

    // Schedule notification if reminder is set
    if (reminderTime != null && type == 'task') {
      await _notificationService.scheduleTaskReminder(
        id: messageId,
        title: 'Task Reminder',
        body: content,
        scheduledTime: reminderTime,
      );
    }
  }

  Future<void> addReaction(Message message, String emoji) async {
    final current = _decodeReactions(message.reactions);
    if (current.contains(emoji)) return;
    current.add(emoji);
    await (db.update(db.messages)..where((m) => m.id.equals(message.id))).write(
      MessagesCompanion(reactions: Value(_encodeReactions(current))),
    );
    _loadMessages();
  }

  Future<void> removeReaction(Message message, String emoji) async {
    final current = _decodeReactions(message.reactions);
    if (!current.remove(emoji)) return;
    await (db.update(db.messages)..where((m) => m.id.equals(message.id))).write(
      MessagesCompanion(
        reactions: Value(current.isEmpty ? null : _encodeReactions(current)),
      ),
    );
    _loadMessages();
  }

  List<String> _decodeReactions(String? raw) {
    if (raw == null || raw.isEmpty) return [];
    return List<String>.from(jsonDecode(raw) as List);
  }

  String? _encodeReactions(List<String> reactions) {
    if (reactions.isEmpty) return null;
    return jsonEncode(reactions);
  }

  Future<void> editMessage(Message message, String newContent) async {
    await (db.update(db.messages)..where((m) => m.id.equals(message.id))).write(
      MessagesCompanion(content: Value(newContent)),
    );
    _loadMessages();
  }

  Future<void> toggleTask(Message message) async {
    await (db.update(db.messages)..where((m) => m.id.equals(message.id))).write(
      MessagesCompanion(isCompleted: Value(!message.isCompleted)),
    );
    _loadMessages();
  }

  Future<void> deleteMessage(Message message) async {
    await (db.delete(db.messages)..where((m) => m.id.equals(message.id))).go();
  }

  Future<void> deleteChat(Chat chat) async {
    await (db.delete(db.messages)..where((m) => m.chatId.equals(chat.id))).go();
    await (db.delete(db.chats)..where((c) => c.id.equals(chat.id))).go();

    // If we deleted the current chat, switch to another
    if (chatId == chat.id) {
      final chats = await db.select(db.chats).get();
      if (chats.isNotEmpty) {
        await switchChat(chats.first.id);
      } else {
        // Create a new chat if no chats left
        await createNewChat();
      }
    }
  }

  Future<void> clearAllMessages() async {
    if (chatId == null) return;
    await (db.delete(db.messages)..where((m) => m.chatId.equals(chatId!))).go();
  }

  Future<String> exportData() async {
    final msgs = await (db.select(
      db.messages,
    )..orderBy([(m) => OrderingTerm.asc(m.createdAt)])).get();

    final buffer = StringBuffer();
    buffer.writeln('Ordo Data Export');
    buffer.writeln('Generated on: ${DateTime.now().toIso8601String()}');
    buffer.writeln('--------------------------------------------------');
    for (var m in msgs) {
      final type = m.type.toUpperCase();
      final status = m.isCompleted ? '[x]' : '[ ]';
      final prefix = m.type == 'task' ? '$status ' : '';
      buffer.writeln('[${m.createdAt}] $type: $prefix${m.content}');
    }
    return buffer.toString();
  }

  Future<void> importData(String data) async {
    final lines = data.split('\n');
    for (var line in lines) {
      if (line.startsWith('[') && line.contains(']:')) {
        try {
          final timestampEnd = line.indexOf(']');
          final typeEnd = line.indexOf(':', timestampEnd);

          final typeStr = line.substring(timestampEnd + 2, typeEnd).trim();
          final content = line.substring(typeEnd + 1).trim();

          final type = typeStr.toLowerCase() == 'TASK' ? 'task' : 'note';
          final isCompleted = content.startsWith('[x]');
          final actualContent = isCompleted
              ? content.substring(3).trim()
              : content.startsWith('[ ]')
              ? content.substring(3).trim()
              : content;

          await db
              .into(db.messages)
              .insert(
                MessagesCompanion.insert(
                  chatId: chatId!,
                  type: type,
                  content: actualContent,
                  isCompleted: Value(isCompleted),
                ),
              );
        } catch (e) {
          // Skip malformed lines
          continue;
        }
      }
    }
  }

  Future<Map<String, int>> getStatistics() async {
    final allMessages = await db.select(db.messages).get();
    final notesCount = allMessages.where((m) => m.type == 'note').length;
    final tasksCount = allMessages.where((m) => m.type == 'task').length;
    final completedTasksCount = allMessages
        .where((m) => m.type == 'task' && m.isCompleted)
        .length;

    return {
      'notes': notesCount,
      'tasks': tasksCount,
      'completedTasks': completedTasksCount,
    };
  }
}

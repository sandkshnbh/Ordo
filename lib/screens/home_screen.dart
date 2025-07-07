import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ordo/screens/add_task_screen.dart';
import 'package:ordo/widgets/task_card.dart';
import 'package:provider/provider.dart';
import 'package:ordo/providers/task_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ordo/screens/settings_screen.dart';
import 'package:ordo/l10n/app_localizations.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:ordo/models/task_model.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:mic_stream/mic_stream.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:record/record.dart';
import 'package:record/record.dart';

class HomeScreen extends StatefulWidget {
  final bool openAddTask;
  const HomeScreen({super.key, this.openAddTask = false});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final bool _showingAddTask = false;
  bool _fabPressed = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.openAddTask) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _openAddTaskSheet());
    }
  }

  void _openAddTaskSheet() async {
    setState(() => _fabPressed = true);
    await Future.delayed(const Duration(milliseconds: 120));
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    await showAddTaskSheet(context, taskProvider);
    await taskProvider.loadTasks();
    setState(() => _fabPressed = false);
  }

  void _openVoiceTaskSheet() async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => VoiceTaskSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final taskProvider = Provider.of<TaskProvider>(context);

    return Stack(
      children: [
        AnimatedScale(
          scale: _showingAddTask ? 0.93 : 1.0,
          duration: const Duration(milliseconds: 350),
          curve: Curves.ease,
          child: AbsorbPointer(
            absorbing: _showingAddTask,
            child: Scaffold(
              appBar: AppBar(
                title: Text(AppLocalizations.of(context)!.app_title),
                centerTitle: true,
                leading: IconButton(
                  icon: const Icon(Icons.settings_rounded),
                  tooltip: AppLocalizations.of(context)!.settings,
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const SettingsScreen(),
                      ),
                    );
                  },
                ),
              ),
              body: RefreshIndicator(
                onRefresh: () => taskProvider.loadTasks(),
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          AppLocalizations.of(context)!.active_tasks(
                            taskProvider.activeTasks.length,
                          ),
                          style: theme.textTheme.titleLarge,
                        ),
                      ),
                    ),
                    if (taskProvider.isLoading && taskProvider.tasks.isEmpty)
                      const SliverFillRemaining(
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (taskProvider.tasks.isEmpty)
                      SliverFillRemaining(
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                'assets/icons/ordo.png',
                                width: 180,
                                height: 180,
                              ),
                              const SizedBox(height: 18),
                              Text(
                                AppLocalizations.of(context)!.no_tasks,
                                style: const TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final task = taskProvider.tasks[index];
                            return TaskCard(task: task);
                          },
                          childCount: taskProvider.tasks.length,
                        ),
                      ),
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                heroTag: 'add_task',
                backgroundColor: Theme.of(context).colorScheme.primary,
                elevation: 8,
                onPressed: _openAddTaskSheet,
                tooltip: AppLocalizations.of(context)!.add_task,
                shape: const CircleBorder(),
                child: const Icon(Icons.add, size: 36),
              ),
            ),
          ),
        ),
        if (_showingAddTask)
          AnimatedOpacity(
            opacity: _showingAddTask ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 350),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                color: Colors.black.withOpacity(0.15),
              ),
            ),
          ),
      ],
    );
  }
}

class VoiceTaskSheet extends StatefulWidget {
  const VoiceTaskSheet({super.key});

  @override
  State<VoiceTaskSheet> createState() => _VoiceTaskSheetState();
}

class _VoiceTaskSheetState extends State<VoiceTaskSheet>
    with SingleTickerProviderStateMixin {
  final AudioRecorder _audioRecorder = AudioRecorder();
  bool _isRecording = false;
  String? _filePath;
  Duration _duration = Duration.zero;
  Timer? _timer;
  final _titleController = TextEditingController();
  static const int _maxSeconds = 30;
  late AnimationController _barsAnim;
  Stream<List<int>>? _micStream;
  final List<int> _webAudioBuffer = [];

  @override
  void initState() {
    super.initState();
    _barsAnim = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _barsAnim.repeat(reverse: true);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _titleController.dispose();
    _barsAnim.dispose();
    super.dispose();
  }

  void _startRecording() async {
    try {
      if (kIsWeb) {
        // تسجيل صوتي للويب باستخدام mic_stream
        _webAudioBuffer.clear();
        _micStream = MicStream.microphone(
          audioSource: AudioSource.DEFAULT,
          sampleRate: 44100,
          channelConfig: ChannelConfig.CHANNEL_IN_MONO,
          audioFormat: AudioFormat.ENCODING_PCM_16BIT,
        );
        if (_micStream == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    'ميزة التسجيل الصوتي غير مدعومة في متصفحك. جرب متصفح Chrome أو استخدم التطبيق على أندرويد.')),
          );
          return;
        }
        _micStream!.listen((data) {
          _webAudioBuffer.addAll(data);
        });
        setState(() {
          _isRecording = true;
          _duration = Duration.zero;
        });
        _timer = Timer.periodic(const Duration(seconds: 1), (_) {
          setState(() {
            if (_duration.inSeconds < _maxSeconds) {
              _duration = _duration + const Duration(seconds: 1);
            } else {
              _stopRecording();
            }
          });
        });
      } else {
        // تسجيل صوتي للهاتف باستخدام record
        final hasPermission = await _audioRecorder.hasPermission();
        if (hasPermission) {
          final tempDir = await getTemporaryDirectory();
          final fileName =
              'voice_task_${DateTime.now().millisecondsSinceEpoch}.m4a';
          final filePath = path.join(tempDir.path, fileName);
          await _audioRecorder.start(const RecordConfig(), path: filePath);
          setState(() {
            _isRecording = true;
            _duration = Duration.zero;
            _filePath = filePath;
          });
          _timer = Timer.periodic(const Duration(seconds: 1), (_) {
            setState(() {
              if (_duration.inSeconds < _maxSeconds) {
                _duration = _duration + const Duration(seconds: 1);
              } else {
                _stopRecording();
              }
            });
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('يجب منح إذن التسجيل الصوتي')),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(kIsWeb
                ? 'ميزة التسجيل الصوتي غير مدعومة في متصفحك. جرب متصفح Chrome أو استخدم التطبيق على أندرويد.'
                : 'تعذر بدء التسجيل الصوتي: $e')),
      );
    }
  }

  void _stopRecording() async {
    if (kIsWeb) {
      _timer?.cancel();
      setState(() {
        _isRecording = false;
      });
      // حفظ البيانات كملف wav (مؤقتًا: لا يتم الحفظ الفعلي، فقط محاكاة)
      const tempDir = '/';
      final fileName =
          'voice_task_${DateTime.now().millisecondsSinceEpoch}.wav';
      final filePath = tempDir + fileName;
      _filePath = filePath;
      // ملاحظة: يجب استخدام مكتبة إضافية لتحويل PCM إلى WAV وحفظه فعليًا على الويب
    } else {
      await _audioRecorder.stop();
      _timer?.cancel();
      setState(() {
        _isRecording = false;
      });
    }
  }

  void _saveVoiceTask() {
    if (_filePath != null && _titleController.text.trim().isNotEmpty) {
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      taskProvider.addVoiceTask(
        _titleController.text.trim(),
        _filePath!,
        Priority.normal,
      );
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم حفظ المهمة الصوتية!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى إدخال عنوان للمهمة')),
      );
    }
  }

  Widget _buildBars() {
    int totalBars = 16;
    int activeBars = (_duration.inSeconds / _maxSeconds * totalBars).ceil();
    return Stack(
      alignment: Alignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(totalBars, (i) {
            final isActive = i < activeBars;
            final animValue = _barsAnim.value;
            final barHeight = isActive && _isRecording
                ? 20 +
                    10 * (0.5 + 0.5 * (1 - (i / totalBars - animValue).abs()))
                : 20.0;
            final color = isActive
                ? Color.lerp(Colors.deepOrange, Colors.orange, i / totalBars)!
                : Colors.white.withOpacity(0.13);
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 1),
              width: 5,
              height: barHeight,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ),
        // الأرقام فوق الشريط
        Positioned(
          top: -22,
          left: 38,
          child: Text('10',
              style: TextStyle(color: Colors.orange.shade300, fontSize: 14)),
        ),
        Positioned(
          top: -22,
          right: 38,
          child: Text('20',
              style: TextStyle(color: Colors.orange.shade300, fontSize: 14)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 340,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 28),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 340),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '${_duration.inSeconds}s',
                    style: const TextStyle(
                      fontSize: 30,
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                      child: AnimatedBuilder(
                    animation: _barsAnim,
                    builder: (context, child) => _buildBars(),
                  )),
                  const SizedBox(width: 8),
                  const Text(
                    'تسجيل',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Center(
              child: GestureDetector(
                onTap: _isRecording ? _stopRecording : _startRecording,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.deepOrange,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepOrange.withOpacity(0.3),
                        blurRadius: 16,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Center(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: _isRecording
                            ? Colors.orange.shade900
                            : Colors.orange.shade400.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (_filePath != null && !_isRecording) ...[
              const SizedBox(height: 24),
              TextField(
                controller: _titleController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'عنوان المهمة',
                  labelStyle: TextStyle(color: Colors.white70),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white30),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepOrange),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _saveVoiceTask,
                icon: const Icon(Icons.save),
                label: const Text('حفظ المهمة'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _filePath = null;
                    _duration = Duration.zero;
                    _titleController.clear();
                  });
                },
                icon: const Icon(Icons.refresh),
                label: const Text('تسجيل جديد'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade900,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

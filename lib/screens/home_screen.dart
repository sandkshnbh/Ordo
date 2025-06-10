import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:animations/animations.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../utils/localization.dart';
import 'add_task_screen.dart';
import 'settings_screen.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final int index;

  const TaskItem({
    Key? key,
    required this.task,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(task.id.toString()),
      background: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(
          FontAwesomeIcons.trash,
          color: Colors.white,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        context.read<TaskProvider>().deleteTask(index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF313131),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: task.isCompleted
                ? const Color(0xFFB2FF59)
                : const Color(0xFF6F6F6F),
            width: task.isCompleted ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color.fromRGBO(0, 0, 0, 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 12,
            ),
            title: AnimatedCrossFade(
              duration: const Duration(milliseconds: 300),
              crossFadeState: task.isCompleted
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              firstChild: Text(
                task.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'SK',
                ),
              ),
              secondChild: Text(
                task.title,
                style: const TextStyle(
                  color: Color(0xFFB2FF59),
                  fontSize: 16,
                  decoration: TextDecoration.lineThrough,
                  fontFamily: 'SK',
                ),
              ),
            ),
            leading: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: task.isCompleted
                      ? const Color(0xFFB2FF59)
                      : const Color(0xFF6F6F6F),
                  width: 2,
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(50),
                  onTap: () {
                    context.read<TaskProvider>().toggleTaskCompletion(index);
                  },
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return ScaleTransition(
                        scale: animation,
                        child: child,
                      );
                    },
                    child: task.isCompleted
                        ? const Icon(
                            FontAwesomeIcons.check,
                            key: ValueKey('check'),
                            color: Color(0xFFB2FF59),
                            size: 20,
                          )
                        : const Icon(
                            FontAwesomeIcons.circle,
                            key: ValueKey('circle'),
                            color: Color(0xFF6F6F6F),
                            size: 20,
                          ),
                  ),
                ),
              ),
            ),
            trailing: IconButton(
              icon: const Icon(
                FontAwesomeIcons.penToSquare,
                color: Color(0xFF6F6F6F),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddTaskScreen(
                      task: task,
                      index: index,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF313131),
      appBar: AppBar(
        backgroundColor: const Color(0xFF313131),
        elevation: 0,
        title: Text(
          Localization.tr('app_name'),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            fontFamily: 'SK',
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(FontAwesomeIcons.gear, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Consumer<TaskProvider>(
            builder: (context, taskProvider, child) {
              final tasks = taskProvider.tasks;

              if (tasks.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        FontAwesomeIcons.clipboardList,
                        size: 64,
                        color: Color(0xFF6F6F6F),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        Localization.tr('no_tasks'),
                        style: const TextStyle(
                          color: Color(0xFF6F6F6F),
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'SK',
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return PageTransitionSwitcher(
                    transitionBuilder: (
                      Widget child,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation,
                    ) {
                      return FadeThroughTransition(
                        animation: animation,
                        secondaryAnimation: secondaryAnimation,
                        child: child,
                      );
                    },
                    child: TaskItem(
                      key: ValueKey(tasks[index].id),
                      task: tasks[index],
                      index: index,
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: OpenContainer(
          transitionDuration: const Duration(milliseconds: 500),
          openBuilder: (context, _) => const AddTaskScreen(),
          closedShape: const CircleBorder(),
          closedColor: const Color(0xFFB2FF59),
          closedBuilder: (context, openContainer) {
            return FloatingActionButton(
              onPressed: openContainer,
              backgroundColor: const Color(0xFFB2FF59),
              child: const Icon(
                FontAwesomeIcons.plus,
                color: Color(0xFF313131),
                size: 24,
              ),
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

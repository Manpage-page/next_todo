import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:next_todo/application/state/providers/selected_index_notifier.dart';
import 'package:next_todo/application/state/providers/tab_list_notifier.dart';
import 'package:next_todo/application/state/all_todos_provider.dart';
import 'package:next_todo/presentation/constants/colors.dart';
import 'package:next_todo/application/state/providers/todolist_notifier.dart';

class TodoSearchDelegate extends SearchDelegate<void> {
  TodoSearchDelegate(this.ref);
  final WidgetRef ref;

  @override
  String get searchFieldLabel => '検索';
  @override
  TextStyle? get searchFieldStyle =>
      const TextStyle(color: Colors.white, fontSize: 18);

  @override
  InputDecorationTheme get searchFieldDecorationTheme => InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF2B2B33),
    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
    prefixIconColor: AppColors.emeraldgreen,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(32),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(32),
      borderSide: BorderSide.none,
    ),
    hintStyle: const TextStyle(color: AppColors.emeraldgreen),
  );

  @override
  Widget buildLeading(BuildContext context) => IconButton(
    icon: const Icon(Icons.keyboard_arrow_left, color: AppColors.emeraldgreen),
    onPressed: () => close(context, null),
  );

  @override
  ThemeData appBarTheme(BuildContext context) {
    final base = Theme.of(context);
    return base.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: AppColors.emeraldgreen),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      colorScheme: base.colorScheme.copyWith(surface: Colors.black),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.emeraldgreen,
        selectionColor: AppColors.emeraldgreen,
        selectionHandleColor: AppColors.emeraldgreen,
      ),
      scaffoldBackgroundColor: Colors.black,
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
      ),
      textTheme: base.textTheme.apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Consumer で包んで watch させる
    return Consumer(
      builder: (context, ref2, _) {
        final allTodos = ref2.watch(allTodosProvider);
        final List<TodoWithTab> suggestions =
            query.isEmpty
                ? []
                : allTodos
                    .where((e) => e.title.contains(query))
                    .toList(growable: false);

        return _SuggestionList(
          items: suggestions,
          onToggle: (item) {
            // 状態を更新
            ref2
                .read(todoListNotifierProvider(item.tabName).notifier)
                .toggleDoneById(item.id);
            //即時にこの画面を再ビルド
            //showSuggestions(context);
          },
          onNavigate: (item) => _selectItem(context, item),
        );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) => buildSuggestions(context);

  @override
  List<Widget>? buildActions(BuildContext context) => [
    if (query.isNotEmpty)
      IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
  ];

  void _selectItem(BuildContext context, TodoWithTab item) {
    final tabs = ref.read(tabListNotifierProvider).value ?? [];
    final index = tabs.indexWhere((tab) => tab == item.tabName);
    if (index != -1) {
      ref.read(selectedIndexNotifierProvider.notifier).update(index);
    }
    close(context, null);
  }
}

// 検索候補リスト
class _SuggestionList extends StatelessWidget {
  const _SuggestionList({
    required this.items,
    required this.onToggle,
    required this.onNavigate,
  });

  final List<TodoWithTab> items;
  final ValueChanged<TodoWithTab> onToggle;
  final ValueChanged<TodoWithTab> onNavigate;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(
        child: Text('該当なし', style: TextStyle(color: AppColors.emeraldgreen)),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      itemCount: items.length,
      separatorBuilder: (_, __) => const Divider(height: 0),
      itemBuilder: (context, i) {
        final todo = items[i];
        final isDone = todo.isDone;

        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
          leading: IconButton(
            icon: Icon(isDone ? Icons.check_circle : Icons.circle_outlined),
            color: isDone ? AppColors.emeraldgreen : Colors.white,
            onPressed: () => onToggle(todo),
            splashRadius: 22,
          ),
          title: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => onToggle(todo),
            onLongPress: () => onNavigate(todo),
            child: Text(
              todo.title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                decoration:
                    isDone ? TextDecoration.lineThrough : TextDecoration.none,
                decorationColor: Colors.white54,
                decorationThickness: 2,
              ),
            ),
          ),
          subtitle: Text(
            todo.tabName,
            style: const TextStyle(
              color: Color.fromARGB(255, 160, 160, 160),
              fontSize: 12,
            ),
          ),
        );
      },
    );
  }
}

/*class TodoSearchDelegate extends SearchDelegate<void> {
  TodoSearchDelegate(this.ref);

  final WidgetRef ref;

  @override
  String get searchFieldLabel => '検索'; //ヒントテキスト

  @override
  TextStyle? get searchFieldStyle =>
      const TextStyle(color: Colors.white, fontSize: 18); //検索文字の設定

  @override
  InputDecorationTheme get searchFieldDecorationTheme => InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF2B2B33),
    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
    prefixIconColor: AppColors.emeraldgreen,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(32),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(32),
      borderSide: BorderSide.none,
    ),
    hintStyle: const TextStyle(color: AppColors.emeraldgreen),
  );

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.keyboard_arrow_left,
        color: AppColors.emeraldgreen,
      ),
      onPressed: () => close(context, null),
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    final base = Theme.of(context);

    return base.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: AppColors.emeraldgreen),
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      colorScheme: base.colorScheme.copyWith(surface: Colors.black),

      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.emeraldgreen,
        selectionColor: AppColors.emeraldgreen,
        selectionHandleColor: AppColors.emeraldgreen,
      ),

      scaffoldBackgroundColor: Colors.black,
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
      ),

      textTheme: base.textTheme.apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final allTodos = ref.watch(allTodosProvider);
    final List<TodoWithTab> suggestions =
        query.isEmpty
            ? []
            : allTodos
                .where((e) => e.title.contains(query))
                .toList(growable: false);

    return _SuggestionList(
      items: suggestions,
      onSelected: (item) => _selectItem(context, item),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  @override
  List<Widget>? buildActions(BuildContext context) => [
    if (query.isNotEmpty)
      IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
  ];

  void _selectItem(BuildContext context, TodoWithTab item) {
    final tabsAsync = ref.read(tabListNotifierProvider);

    final tabs = tabsAsync.value ?? [];

    final index = tabs.indexWhere(
      (tab) => tab == item.tabName,
    ); //tabs.indexOf(item.tabName);
    if (index != -1) {
      ref.read(selectedIndexNotifierProvider.notifier).update(index);
    }
    close(context, null);
  }
}

class _SuggestionList extends StatelessWidget {
  const _SuggestionList({required this.items, required this.onSelected});

  final List<TodoWithTab> items;
  final ValueChanged<TodoWithTab> onSelected;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(
        child: Text('該当なし', style: TextStyle(color: AppColors.emeraldgreen)),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      itemCount: items.length,
      separatorBuilder: (_, __) => const Divider(height: 0),
      itemBuilder: (context, i) {
        final todo = items[i];
        return ListTile(
          leading: const Icon(Icons.circle_outlined),
          title: Text(
            todo.title,
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
          subtitle: Text(
            todo.tabName,
            style: const TextStyle(
              color: Color.fromARGB(255, 160, 160, 160),
              fontSize: 12,
            ),
          ),
          onTap: () => onSelected(todo),
        );
      },
    );
  }
}
*/

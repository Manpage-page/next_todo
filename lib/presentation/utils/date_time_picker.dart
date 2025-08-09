import 'package:flutter/material.dart';
import 'package:next_todo/presentation/constants/colors.dart';
//日付と時間を選択するダイアログを順番に表示
//選ばれた日時を [DateTime] として返す

Future<DateTime?> pickDateTime(
  BuildContext context, {
  DateTime? initial,
}) async {
  final now = DateTime.now();
  final initialDate = initial ?? now;

  // 共通のカラースキームと各ピッカーのテーマを定義
  ThemeData _pickerTheme(BuildContext ctx) {
    // ダーク寄りの配色: グレー背景, エメラルド強調
    final scheme = const ColorScheme.dark(
      primary: AppColors.emeraldgreen, // 強調色(選択色やOKボタンなど)
      onPrimary: Colors.black, // primary上の文字色
      surface: AppColors.grey, // ダイアログ面の背景
      onSurface: Colors.white, // surface上の文字色
    );
    return Theme.of(ctx).copyWith(
      colorScheme: scheme,
      // DatePicker (Flutter 3.7+)
      datePickerTheme: const DatePickerThemeData(
        backgroundColor: AppColors.grey,
        headerBackgroundColor: AppColors.grey,
        headerForegroundColor: AppColors.emeraldgreen,
        // 既定テキスト色は colorScheme の onSurface/onPrimary に従う
      ),
      // TimePicker
      timePickerTheme: const TimePickerThemeData(
        backgroundColor: AppColors.grey, // 背景グレー
        hourMinuteTextColor: AppColors.emeraldgreen, // 時刻の数字をエメラルド
        hourMinuteColor: Colors.black, // 背景はブラックで
        dayPeriodTextColor: Colors.white, // ダイヤル数字は白
        dialHandColor: AppColors.emeraldgreen, // 針はエメラルド
        dialBackgroundColor: Color(0xFF2A2A2D),
        entryModeIconColor: AppColors.emeraldgreen, // アイコンの色
        helpTextStyle: TextStyle(color: Colors.white70),
      ),
    );
  }

  // ==== DatePicker ====
  final date = await showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: DateTime(now.year - 1),
    lastDate: DateTime(now.year + 5),
    helpText: '期限を選択',
    builder: (ctx, child) => Theme(data: _pickerTheme(ctx), child: child!),
  );
  if (date == null) return null;

  // ==== TimePicker ====
  final time = await showTimePicker(
    context: context,
    initialTime:
        initial != null
            ? TimeOfDay.fromDateTime(initial)
            : const TimeOfDay(hour: 23, minute: 59),
    helpText: '通知時間 (任意)',
    builder: (ctx, child) => Theme(data: _pickerTheme(ctx), child: child!),
  );

  // 時刻は任意, 未選択なら 23:59
  return DateTime(
    date.year,
    date.month,
    date.day,
    time?.hour ?? 23,
    time?.minute ?? 59,
  );
}

/// 指定日の 23:59 を返すユーティリティ
DateTime endOfDay(DateTime d) => DateTime(d.year, d.month, d.day, 23, 59);

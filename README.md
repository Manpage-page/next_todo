# next_todo

現在未完成のFlutterのシンプルなtodoアプリです

問題点
##
- ＋ボタンを押した際にtabbarviewも生成されてしまう
- ファイルやその中身を全く整理できていないため、落ち着いたら要リファクタリング
- 新しいタブを追加した際に、インデックスがそのタブに設定されない（というかタブのリストをいじると選択状態が必ずindex = 0になってしまう）
- tab追加画面のUIを変更したらコードがうまく動かなくなった
- 
##


現在の機能としては追加、削除のみとなっていますが
今後実装予定の機能として
##
- Uiの改善
- タスクの期限設定・カレンダー表示
- ダークモード・ホワイトモードの切り替え
- 設定項目・ドロワーのメニュー実装
- 検索システム
- undoボタンの実装
など...
##
さらに追加したい内容として

- AIを用いて、過去のリストのパターンから新たなタスクの提案
- 自分のやりたいことをAIに投げ込むことでその段階的なTodoリストを自動作成・カレンダーと自動連携
- 過去期限を延ばしがちだったタスクを優先的に強調して表示するシステム


## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

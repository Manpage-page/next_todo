# テスト・デバッグ環境構築ガイド

このドキュメントでは、Gemini 連携機能を含むローカル開発環境の構築手順と、テスト・デバッグを実行する際のコマンドをまとめています。

## 前提条件

- Flutter 3.27 以降（Dart 3.7 系）
- Android/iOS エミュレーターまたは Web ランタイム
- Google Gemini API キー

Flutter のインストール手順は公式ドキュメントを参照してください。FVM を利用している場合は以下で本プロジェクトに必要なバージョンを取得できます。

```bash
fvm install 3.27.0
fvm use 3.27.0
```

## 依存関係の取得

```bash
flutter pub get
```

## Gemini API キーの設定

アプリは `GEMINI_API_KEY` という Dart 定数で API キーを読み込みます。実行時に `--dart-define` で渡してください。

```bash
flutter run --dart-define=GEMINI_API_KEY=YOUR_GEMINI_KEY
```

テストやデバッグで複数の定数を渡す場合は JSON ファイルを用意し、`--dart-define-from-file` も利用できます。

```bash
# dart_defines.json を作成して "GEMINI_API_KEY" を設定
flutter run --dart-define-from-file=dart_defines.json
```

API キーを設定せずに Gemini 機能を呼び出した場合、UI 上に「API キーが設定されていません」というエラーメッセージが表示されます。

## 単体テスト

Gemini 連携部分はモック可能なサービスに切り出されており、`dart test` だけで確認できます。

```bash
dart test test/task_extract_service_test.dart
```

Flutter 全体のテストを実行する場合は以下のコマンドを使用してください。

```bash
flutter test
```

> **注意:** CI やコンテナ環境などで Flutter SDK がインストールされていない場合、このコマンドは失敗します。その場合は SDK を追加するか、`dart test` のみ実行してください。

## デバッグの流れ

1. `flutter run --dart-define=GEMINI_API_KEY=...` でアプリを起動します。
2. 右下の吹き出し FAB から Gemini 抽出モーダルを開きます。
3. 任意の文章を入力し **タスク抽出** を押すと、Gemini が JSON で返した結果を UI が解析して候補を表示します。
4. タスクを選択して「選択した N 件を追加」を押すと、現在表示中のタブにタスクが追加されます。
5. 解析に失敗した場合はモーダル内に詳細なエラーが表示されます。API キー未設定や JSON 解析失敗などのケースを個別にハンドリングしています。

## ログ出力の活用

- 開発時は `flutter run -d macos --dart-define=GEMINI_API_KEY=...` のように実行し、コンソールに出力されるログを確認してください。
- Gemini API からのレスポンスで例外が発生した場合、`TaskExtractionException` として UI に表示されます。必要に応じて `catchError` で StackTrace を記録してください。

以上でローカル環境で Gemini 機能を含めたテスト・デバッグを行う準備が整います。

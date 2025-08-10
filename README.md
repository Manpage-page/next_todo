# next_todo

flutterで作成したAIを搭載したtodoアプリです
通常のtodoアプリとしての機能に加えて入力欄に文章を入力するとAIが内容を自動で分割、優先度をつけ、タスクを追加することができます。

基本画面は下の通りで右上Appbarには検索ボタン、その下’＋’ボタンはタブ追加ボタン、左に並んでいるのがタブです。
また、下のFABは左から削除ボタン、AI呼び出しボタン、タスク追加ボタンです。
<p align="center">
  <img src="https://github.com/user-attachments/assets/8328784e-bc44-463c-9b24-1458ff9ec798" width="250" alt="スクリーンショット 2025-08-10 145951" />
</p>


タスク追加ボタンを押すと以下のように入力画面が開きます
<p align="center">
  <img src="https://github.com/user-attachments/assets/22b92384-d71e-4268-a5f8-e96629b6ce96" width="300" alt="スクリーンショット 2025-08-10 150615" />
</p>

タスクは文字色の変更ができ、期限も設定することができます
<p align="center">
  <img src="https://github.com/user-attachments/assets/72501d34-09e3-4eea-9635-46c4b2a01118" width="300" alt="スクリーンショット 2025-08-10 151119" />
</p>

検索画面ではこのように検索の候補が出力されます
<p align="center">
  <img src="https://github.com/user-attachments/assets/dc4f7d3a-0124-49e2-8913-c59914134fd5" width="300" alt="スクリーンショット 2025-08-10 151240" />
</p>

チェックを入れるとこのような状態になります
<p align="center">
  <img src="https://github.com/user-attachments/assets/17b2f4bf-3f78-43ed-aec7-a8aa6b2aba00" width="300" alt="スクリーンショット 2025-08-10 151346" />
</p>

タブ追加ボタンを押すと以下のようにタブ名入力画面が開きます
<p align="center">
  <img src="https://github.com/user-attachments/assets/df2d4116-0e63-4951-a580-7dbe173c273e" width="300" alt="スクリーンショット 2025-08-10 150746" />
</p>

ドロワーボタンをタップするとこのように作成したタブの並び替え・編集ボタンが表示されます
<p align="center">
  <img src="https://github.com/user-attachments/assets/2ef5a9d8-b0ca-4122-9c6e-4c4a2e3b39f4" width="300" alt="スクリーンショット" />
</p>




##
- Uiの改善
- タスクの期限設定・カレンダー表示
- ダークモード・ホワイトモードの切り替え
- 設定項目・ドロワーのメニュー実装
など...
##<img width="693" height="1470" alt="スクリーンショット 2025-08-10 151119" src="https://github.com/user-attachments/assets/47d2085d-932f-423e-9ac7-3e2f91cb6b29" />

さらに追加したい内容として

- AIを用いて、過去のリストのパターンから新たなタスクの提案
- 自分のやりたいことをAIに投げ込むことでその段階的なTodoリストを自動作成・カレンダーと自動連携　（UXやカレンダーとの自動連携がまだ足りていない）
- 過去期限を延ばしがちだったタスクを優先的に強調して表示するシステム


## Getting Started

This project
is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter
.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.



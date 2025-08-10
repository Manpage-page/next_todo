# next_todo

flutterで作成したAIを搭載したtodoアプリです  
通常のtodoアプリとしての機能に加えて入力欄に文章を入力するとAIが内容を自動で分割、優先度をつけ、タスクを追加することができます。

##作成したきっかけ
複雑な長文を読み、それに従って作業をする場合、タスクを分割してtodoアプリに入れたいものの、何から始めたらいいかわからない時もあると思います。  
そんな時にこのアプリに長文を投げ込むことで、タスクをわかりやすく短文に分割し、優先度をつけてtodoリストに入れられる仕組みがあると便利になるだろうと思い作りました。


基本画面は下の通りで右上Appbarには検索ボタン、その下’＋’ボタンはタブ追加ボタン、左に並んでいるのがタブです。
また、下のFABは左から削除ボタン、AI呼び出しボタン、タスク追加ボタンです。
<p align="center">
  <img src="https://github.com/user-attachments/assets/8328784e-bc44-463c-9b24-1458ff9ec798" width="250" alt="スクリーンショット 2025-08-10 145951" />
</p>


タスク追加ボタンを押すと以下のように入力画面が開きます
<p align="center">
  <img src="https://github.com/user-attachments/assets/22b92384-d71e-4268-a5f8-e96629b6ce96" width="250" alt="スクリーンショット 2025-08-10 150615" />
</p>

タスクは文字色の変更ができ、期限も設定することができます
<p align="center">
  <img src="https://github.com/user-attachments/assets/72501d34-09e3-4eea-9635-46c4b2a01118" width="250" alt="スクリーンショット 2025-08-10 151119" />
</p>

検索画面ではこのように検索の候補が出力されます
<p align="center">
  <img src="https://github.com/user-attachments/assets/dc4f7d3a-0124-49e2-8913-c59914134fd5" width="250" alt="スクリーンショット 2025-08-10 151240" />
</p>

チェックを入れるとこのような状態になります
<p align="center">
  <img src="https://github.com/user-attachments/assets/17b2f4bf-3f78-43ed-aec7-a8aa6b2aba00" width="250" alt="スクリーンショット 2025-08-10 151346" />
</p>

タブ追加ボタンを押すと以下のようにタブ名入力画面が開きます
<p align="center">
  <img src="https://github.com/user-attachments/assets/df2d4116-0e63-4951-a580-7dbe173c273e" width="250" alt="スクリーンショット 2025-08-10 150746" />
</p>

ドロワーボタンをタップするとこのように作成したタブの並び替え・編集ボタンが表示されます
<p align="center">
  <img src="https://github.com/user-attachments/assets/2ef5a9d8-b0ca-4122-9c6e-4c4a2e3b39f4" width="250" alt="スクリーンショット" />
</p>

この画面ではタブの削除と並び替えを行うことができます
<p align="center">
  <img src="https://github.com/user-attachments/assets/7fa7f19d-e6d9-4014-849e-593cd5b0f249" width="250" alt="スクリーンショット" />
</p>

AI呼び出しボタンを開くと、以下のように文章を入力・貼り付けることができます
<p align="center">
  <img src="https://github.com/user-attachments/assets/368b1d84-82ea-43f6-9824-314356a530c3" width="250" alt="スクリーンショット 2025-08-10 152157" />
</p>

タスク抽出ボタンを押すと、内容の分割・期限設定・優先度を表示し、タスクの候補の一覧が出力されます。
(この画面では年を明示せず2024年となっているが、現在は年を明示しない場合今年になるよう修正済み)
<p align="center">
  <img src="https://github.com/user-attachments/assets/36a82bc7-21f3-4017-861b-5b93dcc8d016" width="250" alt="スクリーンショット" />
</p>

タスク候補の中から、実際に追加したいものを選択し、選択したN件を追加を押すとタスクが追加されます
<p align="center">
  <img src="https://github.com/user-attachments/assets/c7d7531a-7f3e-4cc9-89c2-6b23af926930" height="300" alt="スクリーンショット" />
  <img src="https://github.com/user-attachments/assets/39e26aca-1133-4a46-97bf-0a4006ff77e3" height="300" alt="スクリーンショット 2025-08-10 153028" />
</p>






今後の変更内容
##
- Uiの改善
- タスクの期限設定・カレンダー表示
- ダークモード・ホワイトモードの切り替え
- 設定項目・ドロワーのメニュー実装
など...

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



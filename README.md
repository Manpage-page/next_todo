# NextTodo — AI がタスクを自動生成する TODO アプリ
https://ai-todo-3lr.pages.dev/

## 📝 はじめに

NextTodo は、文章を入力するだけで AI が自動でタスクを抽出し、  
優先度・締め切りまで自動生成してくれる **AIタスク管理アプリ** です。  

従来の「タスクを自分で整理する」手間をなくし、  
**本当に取り組むべき行動に集中できる環境** をつくることを目的として開発しました。  

Flutter × Gemini API による軽量・高速 UI で、  
誰でも直感的に使える設計になっています。  

---

## 🎯 コンセプト
-「やるべきことはあるのに、整理するのが面倒」  
-「計画づくりに時間を使ってしまう」  
-「学業・仕事・研究でタスクが散乱する」  
  
こういった課題を解決するため、  
**“タスク整理の自動化” に取り組んだアプリ**が NextTodo です。  

AI が文章を解析してタスクを生成することで、  
ユーザーは **考える → 行動する** のサイクルにすぐ移れます。  


## 💻 使用技術

| 種類      | 使用技術                        |
| ------- | --------------------------- |
| フロントエンド | **Flutter (Dart)**          |
| 状態管理    | Riverpod                    |
| ルーティング  | go_router                   |
| モデル・型生成 | Freezed / json_serializable |
| データ保存  | sharedPreferences             |
| AI      | Google Gemini API           |
| デプロイ    | Cloudflare Pages            |
| 対応端末    | モバイル / Web                  |


## ⚙️ 主な機能
### ✔️ AI が文章からタスクを自動生成
- 文章を投げるだけでタスク・優先度・締切案を自動抽出
- Gemini API による解析
- JSON 形式でタスクを返し、アプリ側で整形

### ✔️ タスク管理（追加／編集／削除）
- シンプルで見やすい UI
- タスクの完了管理

### ✔️ 3 タブ構成の直観的 UI
- ホーム：AIタスク入力 & 自動生成
- タスク一覧：タスク管理

✔️ Web アプリとして即利用可能

## 🎥 デモ
基本の画面です  
<img width="300" alt="image" src="https://github.com/user-attachments/assets/8e741136-b1b9-4628-b91e-e07e5789d6b7" /><br>
タスク追加画面では以下のように色、期限を設定できます  
<img width="300" alt="image" src="https://github.com/user-attachments/assets/36bad9a2-a636-4112-b575-f2ed3503bc7e" /><br>
期限を選択すると日程と時間・分を設定できます  
<img width="300" alt="image" src="https://github.com/user-attachments/assets/749c9561-a994-402a-86ad-33759950ca6a" /><br>
検索ボタンを押すとタスクを検索することができます  
<img width="300" alt="image" src="https://github.com/user-attachments/assets/0523b366-2a56-436d-bdeb-28e19a44ecaf" /><br>
検索ボタン下の＋ボタンを押すとタブを追加できます  
<img width="300" alt="image" src="https://github.com/user-attachments/assets/e2758461-3855-47f0-a140-e7bf677073e8" /><br>
追加後はこのような表示になります  
<img width="300" alt="image" src="https://github.com/user-attachments/assets/eb77c7b2-5b34-4648-965d-5c1fa53390a3" /><br>
左側のドロワーを開き編集ボタンを押すとこのようにタブバーの編集ができます  
<img width="300" alt="image" src="https://github.com/user-attachments/assets/8b0f247b-b214-449c-a87c-21074732c610" /><br>

## AI機能について  
文章を入力するとこのようにタスクが自動で抽出され、期日もまとめてくれます(個人情報の部分は加工してあります)  
<img width="300" alt="スクリーンショット 2025-11-14 111641" src="https://github.com/user-attachments/assets/0db16b48-4292-48b0-b843-f863479821f6" /><br>
選択し追加すると無事反映されました(個人情報の部分は加工してあります)  
<img width="300" alt="スクリーンショット 2025-11-14 112317" src="https://github.com/user-attachments/assets/70bf9faa-178e-4fe5-a1f7-72c76c9e7e87" /><br>




## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

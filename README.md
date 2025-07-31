# Photogram

Ruby on Rails と Stimulus を使って開発中の、シンプルな SNS アプリです。

画像付き投稿、フォロー機能、コメント・いいね、ホット投稿の表示など、基本的なSNSの仕組みを実装しています。

<img width="758" height="941" alt="image" src="https://github.com/user-attachments/assets/c9a97201-f6b5-4359-b418-3aaa9f9c961f" />

## ✨ 主な機能
- Devise を使ったユーザー認証
- タイムライン表示（以下を新着順で統合表示）
  - フォロー中ユーザーの投稿
  - 直近24時間以内に作成された「いいね」が多い投稿（最大5件）
- ページ遷移なしのインタラクション（Stimulus 利用）
  - コメント投稿
  - •	アバター画像の変更
  - いいね（ハートアイコン）の切り替え
- モデルレベルのバリデーション
  - 投稿キャプション：最大400文字
  - 投稿画像：JPEG/PNG/GIFのみ・最大5MB・最大8枚まで
  - アバター画像：JPEG/PNG/GIFのみ・最大5MB
- RSpec によるモデル単体テストを実装済み

## 🛠 セットアップ手順

```bash
git clone https://github.com/aym0546/photogram.git
cd photogram
bundle install
yarn install
bin/rails db:setup
bin/rails server
```

## 🚀 使い方
1. サインアップまたはログイン
2. プロフィール画面からアバター画像を設定
3. 他のユーザーをフォロー
4. タイムラインで投稿をチェック
5. いいね・コメントなど、各種アクションが即時反映されます

## ✅ 開発メモ
- Stimulus を活用して非同期UIを構築（comments, likes, avatar, follow など）
- 投稿一覧取得（PostsController#index）では、フォロー中の投稿 + ホット投稿を合成して新着順に表示
- モデルスペック（spec/models/）にてバリデーションをしっかり検証
- FactoryBot + Faker + 画像フィクスチャで信頼性の高いテストを構築

## 🧪 テスト実行方法

```bash
bundle exec rspec
```

投稿・ユーザー・コメントモデルのバリデーションに関するテストが実行されます。
※メンション通知メール機能は今後の拡張予定

## 📁 主な構成
- app/controllers — 各種コントローラー
- app/javascript/controllers — Stimulus の各コントローラー（コメント、いいね、アバター更新、フォローなど）
- app/javascript/utils/flash.js — 全画面共通のフラッシュ通知用ユーティリティ
- spec/factories — FactoryBot によるテストデータ定義
- spec/fixtures/files — JPEG/PNG/GIF/不正画像などの画像ファイル（テスト用）

## 🙌 フィードバック・貢献

学習を目的としたプロジェクトです。気づき・改善提案・プルリクエストなど歓迎します！


## 技術スタック

Rails 8 · Stimulus · Turbo · jQuery · Axios · ActiveStorage · RSpec · FactoryBot · Faker

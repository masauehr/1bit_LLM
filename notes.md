# 実験メモ・観察結果

## 動作確認ログ

- 標準 Ollama での Bonsai 8B 実行 → **失敗**
  - 原因: llama.cpp が `Q1_0_g128` フォーマット未対応
  - 解決策: PrismML フォーク版 llama-server を使用
- `bonsai-demo/setup.sh` 実行 → MLX エラー発生（想定内）、llama-server は **[OK]**
- `./scripts/run_llama.sh -p "こんにちは、自己紹介してください"` → **動作確認済み**
  - 日本語での応答を確認
- `./scripts/start_llama_server.sh` → **メモリ不足エラー**（コンテキスト65536トークン分で9216MB必要、空きは5460MB）
  - 解決策: `-c 8192` でコンテキスト長を制限して起動
  - `./scripts/start_llama_server.sh -c 8192` → **起動成功**
- VS Code + Continue（`provider: openai`、`apiBase: http://localhost:8080/v1`）から接続 → **応答良好**
- `test_tool_calling.py` による Tool Calling → **動作確認済み**
  - モデルが `get_weather({'city': '東京'})` を正しく呼び出し
  - ツール結果をもとに自然な日本語で最終回答を生成
  - 注意: モデルは日本語で都市名を渡すため、ダミーデータは日英両方のキーが必要

## Bonsai 8B の得意・不得意

| 操作 | 結果 | 備考 |
|------|------|------|
| コード生成・説明 | ✅ 良好 | 日本語応答も安定 |
| Tool Calling | ✅ 動作する | 都市名を日本語で渡す点に注意 |
| URL を渡して「調べて」 | ❌ 誤動作 | `requests.get(url)` のコードを返す |
| ネット参照が必要な質問 | ❌ 不可 | ローカルLLMはインターネット接続なし |
| 一般知識・固有名詞の回答 | ❌ ハルシネーション多発 | 「太陽系の惑星」→架空の惑星名を60個以上生成 |

**URL の内容を参照させたい場合**: 事前に記事本文を取得してプロンプトに貼り付ける必要がある。

**ハルシネーションの原因**: 1ビット量子化で事実知識が大幅に欠落。日本語の文法・流暢さは保たれるが、固有名詞・数値の正確さは信頼できない。**用途はコーディング支援に絞るのが現実的。**

## パフォーマンス計測

8GB MacBook（Apple Silicon）での実測値:

| モデル | パラメータ | サイズ | 速度（Prompt） | 速度（Generation） | Tool Calling |
|--------|-----------|--------|--------------|------------------|-------------|
| **Bonsai 8B（自機実測）** | 8.2B | 1.1GB | **35.3 tok/s** | **27.1 tok/s** | ✅ |
| Bonsai 8B（記事参考値） | 8.2B | 1.1GB | — | 21.1 tok/s | ✅ |
| SwiftLM Qwen 2.5 3B | 3.1B | 1.7GB | — | 27.3 tok/s | ❌ |
| Ollama Qwen 2.5 3B | 3.1B | 2.3GB | — | 23.1 tok/s | ✅ |

- Bonsai 8B は 8.2B パラメータを 1.1GB に圧縮（圧縮率 **93%**）
- 自機実測では記事参考値より高速（35.3 / 27.1 tok/s）

## 気づき・所感

- 速度では 3B モデルに劣るが、**パラメータ数と回答品質**では Bonsai 8B が優位
- **Tool Calling** の有無はエージェント用途では死活問題
  - SwiftLM は速いが Tool Calling 非対応 → エージェントには不適
- 1ビット量子化は現時点では llama.cpp 本体の対応待ちの状態
  - PrismML フォークへの依存が当面続く見込み

## 技術背景メモ

### MLX とは

Apple が開発した **Apple Silicon 専用の機械学習フレームワーク**。
M シリーズチップの Unified Memory（CPU・GPU・Neural Engine がメモリ共有）を最大活用するよう設計されている。

| 実行方法 | 特徴 |
|---------|------|
| llama.cpp (GGUF) | 汎用的、どこでも動く |
| MLX | Apple Silicon GPU をフル活用、高速だが Mac 専用 |
| Ollama | llama.cpp のラッパー、使いやすい管理ツール |

MLX はモデル実行時に Metal Shader をリアルタイムコンパイルするため、Xcode フルインストールが必要。
このプロジェクトは GGUF + llama-server 構成のため MLX は不要。

### llama-server と Ollama の関係

```
llama.cpp（コア推論エンジン）
    ├── llama-server  ← 直接使う（低レイヤー）
    └── Ollama        ← llama.cpp をラップした管理ツール
```

Ollama は llama.cpp の特定バージョンを内蔵しており、新しい量子化フォーマットへの対応は遅れる傾向がある。

```
新フォーマット登場 → llama.cpp 対応（早）→ Ollama 対応（遅）
```

今回の `Q1_0_g128` はこのギャップにより Ollama 未対応。
llama-server は Ollama より低レイヤーで、より広い GGUF フォーマットに対応できる。
ただし llama.cpp 本体が未対応のフォーマットは動かない（フォーク版が必要になる）。

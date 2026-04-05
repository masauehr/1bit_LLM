# 実験メモ・観察結果

## 動作確認ログ

- 標準 Ollama での Bonsai 8B 実行 → **失敗**
  - 原因: llama.cpp が `Q1_0_g128` フォーマット未対応
  - 解決策: PrismML フォーク版 llama-server を使用
- `bonsai-demo/setup.sh` 実行 → MLX エラー発生（想定内）、llama-server は **[OK]**
- `./scripts/run_llama.sh -p "こんにちは、自己紹介してください"` → **動作確認済み**
  - 日本語での応答を確認
  - VS Code + Continue から API 経由で接続済み

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

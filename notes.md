# 実験メモ・観察結果

## 動作確認ログ

- 標準 Ollama での Bonsai 8B 実行 → **失敗**
  - 原因: llama.cpp が `Q1_0_g128` フォーマット未対応
  - 解決策: PrismML フォーク版 llama-server を使用

## パフォーマンス計測

8GB MacBook（Apple Silicon）での比較計測結果（出典: techno-edge.net 2026/04/04）:

| モデル | パラメータ | サイズ | 速度 | Tool Calling |
|--------|-----------|--------|------|-------------|
| Bonsai 8B (PrismML) | 8.2B | 1.1GB | 21.1 tok/s | ✅ |
| SwiftLM Qwen 2.5 3B | 3.1B | 1.7GB | 27.3 tok/s | ❌ |
| Ollama Qwen 2.5 3B | 3.1B | 2.3GB | 23.1 tok/s | ✅ |

- Bonsai 8B は 8.2B パラメータを 1.1GB に圧縮（圧縮率 **93%**）

## 気づき・所感

- 速度では 3B モデルに劣るが、**パラメータ数と回答品質**では Bonsai 8B が優位
- **Tool Calling** の有無はエージェント用途では死活問題
  - SwiftLM は速いが Tool Calling 非対応 → エージェントには不適
- 1ビット量子化は現時点では llama.cpp 本体の対応待ちの状態
  - PrismML フォークへの依存が当面続く見込み

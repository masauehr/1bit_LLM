# セットアップ手順

## 動作環境

- MacBook Air (Apple Silicon)
- RAM: 8GB
- OS: macOS

## 必要なツール

- **PrismML フォーク版 llama-server**
  - 標準の Ollama / llama.cpp は `Q1_0_g128` フォーマット未対応のため、こちらが必須
  - リポジトリ: PrismML の llama.cpp フォーク

## インストール手順

1. PrismML フォーク版 llama-server をビルドまたはバイナリ取得
2. llama-server を起動し、OpenAI 互換 API として公開
   ```bash
   ./llama-server -m bonsai-8b-q1_0_g128.gguf --port 8080
   ```
3. OpenAI 互換エンドポイント（`http://localhost:8080/v1`）でアクセス

## モデルのダウンロード

- モデル名: `Bonsai 8B`（PrismML 提供）
- フォーマット: GGUF（Q1_0_g128）
- サイズ: 約 1.1GB

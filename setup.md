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

## MLX セットアップエラーについて

`bonsai-demo` の `setup.sh` を実行すると MLX のセットアップが試みられるが、環境によってはエラーが発生する。

**エラー内容:**
```
metal shader compiler がない
```

**原因:** Command Line Tools のみのインストール環境では Metal コンパイラが含まれない。

**対処法:**
- Xcode フルインストールで解決するが、**対応不要**
- このプロジェクトは `llama-server + GGUF` 構成で動作するため MLX は不要
- MLX エラーが出ても無視して問題なし

## Ollama との共存について

すでに Ollama をインストールしている環境に llama-server を追加インストールしても**問題ない**。

```
Ollama（常駐デーモン）     llama-server（手動起動）
     ↓ポート11434               ↓ポート8080
```

- インストール場所・使用ポートが別々のため競合しない
- 起動・停止も独立して管理できる

**注意: 8GB Mac でのメモリ使用**

両方同時にモデルを読み込むとメモリ不足になる可能性がある。
使うときはどちらか一方だけモデルを読み込む運用が安全。

```bash
# llama-server 使用前に Ollama のモデルを解放する場合
ollama stop
```

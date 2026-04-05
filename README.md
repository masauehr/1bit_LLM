# 1bit_LLM — MacBook Air 8GB で動かす軽量1ビットLLM

## 概要

MacBook Air (8GB RAM) 上で動作する1ビット量子化LLMの実験プロジェクト。
主に **Bonsai 8B** モデルを用いて、ローカル推論の可能性を探る。

## 対象モデル

| モデル | パラメータ | サイズ | 速度 (tok/s) | Tool Calling |
|--------|-----------|--------|-------------|-------------|
| **Bonsai 8B** (PrismML) | 8.2B | 1.1GB | 21.1 | ✅ |
| SwiftLM Qwen 2.5 3B | 3.1B | 1.7GB | 27.3 | ❌ |
| Ollama Qwen 2.5 3B | 3.1B | 2.3GB | 23.1 | ✅ |

- **Bonsai 8B** — 1ビット量子化（Q1_0_g128）による超軽量LLM。8.2Bパラメータが1.1GBに圧縮（圧縮率93%）。

## 量子化フォーマット

- 使用フォーマット: `Q1_0_g128`（1ビット量子化）
- 標準の Ollama (llama.cpp) は未対応 → **PrismML フォーク版 llama-server** が必要

## 構成ファイル

| ファイル | 内容 |
|----------|------|
| `README.md` | このファイル。プロジェクト概要 |
| `setup.md` | 環境構築手順 |
| `usage.md` | 使い方・実行例 |
| `notes.md` | 実験メモ・観察結果 |

## 推奨ユースケース

- **品質重視**: Bonsai 8B（Tool Calling 安定、回答品質が高い）
- **速度重視**: SwiftLM Qwen 2.5 3B（ただし Tool Calling 非対応）
- **エージェント用途**: Bonsai 8B または Ollama Qwen 2.5 3B（Tool Calling 必須）

## ステータス

調査・検証中

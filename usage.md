# 使い方・実行例

## 基本的な実行方法

`bonsai-demo` の起動スクリプトを使用する（`~/projects/1bit_LLM/bonsai-demo/` に配置）。

```bash
# 1回だけ推論（CLIチャット）
cd ~/projects/1bit_LLM/bonsai-demo
./scripts/run_llama.sh -p "こんにちは"

# APIサーバーとして起動（ポート8080）
./scripts/start_llama_server.sh
```

## VS Code + Continue からの使用方法

### 前提
1. `start_llama_server.sh` でサーバーを起動しておく
2. Continue 拡張機能がインストール済みであること

### Continue 設定（`~/.continue/config.yaml`）

```yaml
- name: Bonsai 8B（1ビット量子化・ローカル）
  provider: openai
  model: bonsai-8b
  apiBase: http://localhost:8080/v1
  apiKey: dummy
  contextLength: 8192
```

設定後、VS Code の Continue パネルでモデルを `Bonsai 8B` に切り替えて使用できる。

## パラメータ設定

| パラメータ | 説明 |
|-----------|------|
| `-m` | モデルファイルのパス（GGUF形式） |
| `--port` | APIポート番号（デフォルト: 8080） |

## 実行例

OpenAI 互換エンドポイントへのリクエスト例:

```python
import openai

client = openai.OpenAI(
    base_url="http://localhost:8080/v1",
    api_key="dummy"  # ローカルなので不要だが必須フィールド
)

response = client.chat.completions.create(
    model="bonsai-8b",
    messages=[{"role": "user", "content": "こんにちは"}]
)
print(response.choices[0].message.content)
```

## Tool Calling の利用

Bonsai 8B は Tool Calling に対応。エージェント用途では Bonsai 8B を推奨。
（SwiftLM Qwen 2.5 3B は Tool Calling 非対応のため注意）

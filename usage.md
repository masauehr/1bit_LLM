# 使い方・実行例

## 基本的な実行方法

PrismML フォーク版 llama-server を起動後、OpenAI 互換 API 経由でアクセスする。

```bash
# llama-server 起動
./llama-server -m bonsai-8b-q1_0_g128.gguf --port 8080
```

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

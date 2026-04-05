#!/bin/bash
# Bonsai 8B APIサーバー起動スクリプト
# コンテキスト長を8192に制限してメモリ不足を回避

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BONSAI_DIR="$SCRIPT_DIR/bonsai-demo"

echo "=== Bonsai 8B サーバー起動 (context: 8192) ==="
echo "  API: http://localhost:8080/v1"
echo "  Press Ctrl+C to stop."
echo ""

cd "$BONSAI_DIR" && ./scripts/start_llama_server.sh -c 8192

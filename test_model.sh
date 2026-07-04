#!/bin/bash
# Quick test script for Clair v5 model

set -e

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODEL_PATH="$REPO_ROOT/model/gguf/clair-v5-Q4_K_M.gguf"
LLAMA_CLI="$REPO_ROOT/llama.cpp/build/bin/llama-cli"

# Check if model exists
if [ ! -f "$MODEL_PATH" ]; then
    echo "❌ Model not found at $MODEL_PATH"
    echo "   Run: bash download_model.sh"
    exit 1
fi

# Check if llama-cli is built
if [ ! -x "$LLAMA_CLI" ]; then
    echo "❌ llama-cli not built. Building llama.cpp..."
    cd "$REPO_ROOT/llama.cpp"
    mkdir -p build && cd build
    cmake .. && cmake --build . --config Release -j$(nproc)
    cd "$REPO_ROOT"
fi

echo "✅ Model: $MODEL_PATH ($(du -h "$MODEL_PATH" | cut -f1))"
echo "✅ Runtime: $LLAMA_CLI"
echo ""
echo "Running identity test..."
echo "---"

# Run identity test
"$LLAMA_CLI" -m "$MODEL_PATH" -p "Who are you?" -n 64 --temp 0.7

echo ""
echo "---"
echo "✅ Test complete!"

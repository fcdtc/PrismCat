#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
WEB_DIR="$ROOT_DIR/web"

cleanup() {
    echo ""
    echo "Stopping all processes..."
    kill $(jobs -p) 2>/dev/null 2>&1 || true
    wait 2>/dev/null
    echo "Done."
}
trap cleanup EXIT INT TERM

# --- Backend ---
echo "==> Starting backend (Go)..."
(cd "$ROOT_DIR" && go run ./cmd/prismcat -config "$ROOT_DIR/data/config.yaml") &
BACKEND_PID=$!

# --- Frontend ---
echo "==> Installing frontend dependencies..."
(cd "$WEB_DIR" && npm ci --prefer-offline 2>/dev/null || npm install)

echo "==> Starting frontend (Vite dev server)..."
(cd "$WEB_DIR" && npm run dev) &
FRONTEND_PID=$!

echo ""
echo "========================================="
echo "  PrismCat Dev Server is running!"
echo ""
echo "  Frontend:  http://localhost:5173"
echo "  Backend:   http://localhost:8080"
echo ""
echo "  Press Ctrl+C to stop all."
echo "========================================="
echo ""

wait

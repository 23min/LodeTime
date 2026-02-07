#!/bin/bash
# build.sh - Build CLI and (optionally) runtime artifacts.

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Building LodeTime CLI"
mkdir -p "${ROOT_DIR}/bin"
if command -v go >/dev/null 2>&1; then
  (cd "${ROOT_DIR}/cmd/lodetime-cli" && go build -o "${ROOT_DIR}/bin/lode" .)
  if [ -x "${ROOT_DIR}/bin/lode" ]; then
    echo "CLI build OK:"
    echo "  binary: ${ROOT_DIR}/bin/lode"
  else
    echo "CLI build failed: ${ROOT_DIR}/bin/lode not found"
    exit 1
  fi
else
  echo "Go not found. Install Go to build the CLI."
  exit 1
fi

echo ""
echo "==> Runtime build (Elixir)"
if command -v mix >/dev/null 2>&1; then
  if [ -d "${ROOT_DIR}/deps" ]; then
    (cd "${ROOT_DIR}" && mix compile)
    echo "Runtime compile OK."
  else
    echo "Deps directory not found. Run 'mix deps.get' first, then re-run build.sh."
  fi
else
  echo "mix not found. Runtime build skipped."
fi

if [ "${BUILD_DOCKER:-0}" = "1" ]; then
  echo ""
  echo "==> Docker image build"
  if command -v docker >/dev/null 2>&1; then
    docker build -t lodetime-runtime:local "${ROOT_DIR}"
    echo "Docker image: lodetime-runtime:local"
  else
    echo "Docker not found. Skipping Docker build."
  fi
fi

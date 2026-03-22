#!/usr/bin/env sh
set -eux

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

IMGUI_TAG="${IMGUI_TAG:-v1.91.6}"
if [ ! -f imgui/imgui.h ]; then
  echo "[dist] Fetching Dear ImGui ${IMGUI_TAG}..."
  rm -rf imgui
  git clone --depth=1 --branch "${IMGUI_TAG}" https://github.com/ocornut/imgui.git imgui
fi

echo "[dist] Building PokeEdit (verbose)..."
make V=1

echo "[dist] Root after make:"
ls -la
echo "[dist] build/ after make:"
ls -la build || true

# Locate PokeEdit.nro robustly
NRO=""
if [ -f "PokeEdit.nro" ]; then
  NRO="PokeEdit.nro"
elif [ -f "build/PokeEdit.nro" ]; then
  NRO="build/PokeEdit.nro"
else
  NRO="$(find . -maxdepth 3 -name 'PokeEdit.nro' -print -quit || true)"
fi

if [ -z "${NRO}" ] || [ ! -f "${NRO}" ]; then
  echo "[dist] ERROR: PokeEdit.nro not found after make!"
  exit 1
fi

echo "[dist] Creating release bundle folder (no sdmc layout)..."
rm -rf dist
mkdir -p dist/PokeEdit

cp -f "${NRO}" dist/PokeEdit/PokeEdit.nro

echo "[dist] Bundle ready:"
find dist -maxdepth 4 -type f -print

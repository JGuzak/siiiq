#!/usr/bin/env bash
set -euo pipefail

need_cmd() {
  command -v "$1" >/dev/null 2>&1
}

run_as_root() {
  if [ "${EUID:-$(id -u)}" -eq 0 ]; then
    "$@"
  elif need_cmd sudo; then
    sudo "$@"
  else
    echo "Root privileges required for: $*"
    echo "Install sudo or run this script as root."
    exit 1
  fi
}

ensure_lua_toolchain() {
  if need_cmd lua && need_cmd luarocks; then
    return
  fi

  echo "Lua or LuaRocks not found. Installing with apt..."
  run_as_root apt-get update
  run_as_root apt-get install -y lua5.1 luarocks build-essential
}

ensure_lua_toolchain

echo "Installing Lua test dependencies..."
apt install lua-busted

echo "Lua dev environment setup complete."

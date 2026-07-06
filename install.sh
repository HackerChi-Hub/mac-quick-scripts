#!/usr/bin/env bash
# install.sh — mac-quick-scripts 一键安装
set -euo pipefail

BIN_DIR="$HOME/.local/bin"
SCRIPT_NAME="game-res"

G=$'\033[0;32m'; Y=$'\033[1;33m'; R=$'\033[0;31m'; B=$'\033[1m'; N=$'\033[0m'

printf "${B}📦 安装 mac-quick-scripts${N}\n"
printf "────────────────────────────────────────\n"

# 1. 检查 Homebrew
if ! command -v brew >/dev/null 2>&1; then
  printf "${R}✗ 未安装 Homebrew${N}\n" >&2
  printf "  请先安装: ${B}https://brew.sh${N}\n" >&2
  exit 1
fi

# 2. 检查并安装 displayplacer
if ! command -v displayplacer >/dev/null 2>&1; then
  printf "${Y}→ 安装依赖 displayplacer...${N}\n"
  brew install displayplacer
else
  printf "${G}✓ displayplacer 已安装${N}\n"
fi

# 3. 创建 bin 目录
mkdir -p "$BIN_DIR"

# 4. 复制脚本
SCRIPT_SRC="$(cd "$(dirname "$0")" && pwd)/scripts/$SCRIPT_NAME"
if [ ! -f "$SCRIPT_SRC" ]; then
  printf "${R}✗ 找不到 scripts/$SCRIPT_NAME${N}\n" >&2
  exit 1
fi

cp "$SCRIPT_SRC" "$BIN_DIR/$SCRIPT_NAME"
chmod +x "$BIN_DIR/$SCRIPT_NAME"
printf "${G}✓ 已安装 $SCRIPT_NAME → $BIN_DIR/$SCRIPT_NAME${N}\n"

# 5. 创建符号链接
ln -sf "$SCRIPT_NAME" "$BIN_DIR/game-on"
ln -sf "$SCRIPT_NAME" "$BIN_DIR/game-off"
printf "${G}✓ 已创建符号链接 game-on / game-off${N}\n"

# 6. 检查 PATH
case ":$PATH:" in
  *":$BIN_DIR:"*)
    printf "${G}✓ $BIN_DIR 已在 PATH 中${N}\n"
    ;;
  *)
    printf "${Y}⚠ $BIN_DIR 不在 PATH 中${N}\n"
    printf "  请将以下内容加入 ~/.zshrc:\n"
    printf "  ${B}export PATH=\"$BIN_DIR:\$PATH\"${N}\n"
    ;;
esac

printf "────────────────────────────────────────\n"
printf "${G}🎉 安装完成!${N} 试试: ${B}game-res${N}\n"

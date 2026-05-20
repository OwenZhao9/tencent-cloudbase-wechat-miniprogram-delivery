#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  package_delivery.sh --admin PATH --miniprogram PATH [--out DIR] [--name NAME] [--include-build]

Options:
  --admin PATH          Admin/backend project root. Defaults to current directory.
  --miniprogram PATH    Mini program root containing project.config.json. Auto-detected if omitted.
  --out DIR             Output directory. Defaults to the admin project's parent directory.
  --name NAME           Archive/staging base name. Defaults to wechat-miniprogram-delivery.
  --include-build       Include dist/ and build/ directories.
  -h, --help            Show this help.
EOF
}

ADMIN=""
MINIPROGRAM=""
OUT_DIR=""
NAME="wechat-miniprogram-delivery"
INCLUDE_BUILD=0

while [ "$#" -gt 0 ]; do
  case "$1" in
    --admin)
      ADMIN="${2:?Missing value for --admin}"
      shift 2
      ;;
    --miniprogram)
      MINIPROGRAM="${2:?Missing value for --miniprogram}"
      shift 2
      ;;
    --out)
      OUT_DIR="${2:?Missing value for --out}"
      shift 2
      ;;
    --name)
      NAME="${2:?Missing value for --name}"
      shift 2
      ;;
    --include-build)
      INCLUDE_BUILD=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

abs_path() {
  local target="$1"
  if [ -d "$target" ]; then
    (cd "$target" && pwd)
  else
    local dir
    local base
    dir="$(dirname "$target")"
    base="$(basename "$target")"
    (cd "$dir" && printf '%s/%s\n' "$(pwd)" "$base")
  fi
}

require_dir() {
  local label="$1"
  local dir="$2"
  if [ ! -d "$dir" ]; then
    echo "$label directory not found: $dir" >&2
    exit 1
  fi
}

ADMIN="${ADMIN:-$(pwd)}"
ADMIN="$(abs_path "$ADMIN")"
require_dir "Admin" "$ADMIN"

if [ -z "$MINIPROGRAM" ]; then
  if [ -f "$ADMIN/project.config.json" ]; then
    MINIPROGRAM="$ADMIN"
  elif [ -f "$ADMIN/miniprogram/project.config.json" ]; then
    MINIPROGRAM="$ADMIN/miniprogram"
  else
    PARENT="$(dirname "$ADMIN")"
    MINIPROGRAM="$(find "$PARENT" -maxdepth 3 -name project.config.json -not -path '*/node_modules/*' -print | head -n 1 | xargs dirname 2>/dev/null || true)"
  fi
fi

if [ -n "$MINIPROGRAM" ]; then
  MINIPROGRAM="$(abs_path "$MINIPROGRAM")"
  require_dir "Mini program" "$MINIPROGRAM"
  if [ ! -f "$MINIPROGRAM/project.config.json" ]; then
    echo "Mini program path does not contain project.config.json: $MINIPROGRAM" >&2
    exit 1
  fi
fi

if [ -z "$OUT_DIR" ]; then
  OUT_DIR="$(dirname "$ADMIN")"
fi
OUT_DIR="$(abs_path "$OUT_DIR")"
mkdir -p "$OUT_DIR"

TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
STAGE="$OUT_DIR/${NAME}-${TIMESTAMP}"
ZIP_PATH="$OUT_DIR/${NAME}-${TIMESTAMP}.zip"
mkdir -p "$STAGE"

RSYNC_EXCLUDES=(
  --exclude ".git"
  --exclude "node_modules"
  --exclude ".DS_Store"
  --exclude "*.log"
  --exclude "logs"
  --exclude ".cache"
  --exclude ".turbo"
  --exclude ".vite"
  --exclude ".next"
  --exclude ".nuxt"
  --exclude ".vercel"
  --exclude ".github"
  --exclude ".agent"
  --exclude ".codex"
  --exclude ".agents"
  --exclude ".augment-guidelines"
  --exclude ".claude"
  --exclude ".clinerules"
  --exclude ".codebuddy"
  --exclude ".comate"
  --exclude ".cursor"
  --exclude ".gemini"
  --exclude ".iflow"
  --exclude ".kiro"
  --exclude ".lingma"
  --exclude ".playwright-mcp"
  --exclude ".qoder"
  --exclude ".qwen"
  --exclude ".roo"
  --exclude ".rules"
  --exclude ".trae"
  --exclude ".vscode"
  --exclude ".windsurf"
  --exclude ".mcp.json"
  --exclude ".opencode.json"
  --exclude "AGENTS.md"
  --exclude "AI 提示词.md"
  --exclude "CLAUDE.md"
  --exclude "CODEBUDDY.md"
  --exclude "IFLOW.md"
  --exclude "codebuddy-plugin"
  --exclude ".env"
  --exclude ".env.local"
  --exclude ".env.development.local"
  --exclude ".env.production.local"
  --exclude ".env.test.local"
  --exclude "project.private.config.json"
  --exclude "cloudbaserc.local.json"
  --exclude "*.zip"
)

if [ "$INCLUDE_BUILD" -eq 0 ]; then
  RSYNC_EXCLUDES+=(--exclude "dist" --exclude "build")
fi

copy_project() {
  local src="$1"
  local dest="$2"
  mkdir -p "$dest"
  rsync -a "${RSYNC_EXCLUDES[@]}" "$src"/ "$dest"/

  if [ -f "$src/.env" ] && [ ! -f "$dest/.env.example" ]; then
    awk '
      /^[[:space:]]*#/ { print; next }
      /^[[:space:]]*$/ { print; next }
      index($0, "=") > 0 {
        key = substr($0, 1, index($0, "=") - 1)
        print key "="
        next
      }
      { print }
    ' "$src/.env" > "$dest/.env.example"
  fi
}

copy_project "$ADMIN" "$STAGE/admin"

if [ -n "$MINIPROGRAM" ]; then
  copy_project "$MINIPROGRAM" "$STAGE/miniprogram"
else
  echo "Warning: no mini program root detected; packaged admin only." >&2
fi

(
  cd "$OUT_DIR"
  zip -qry "$ZIP_PATH" "$(basename "$STAGE")"
)

unzip -tq "$ZIP_PATH" >/dev/null

SIZE="$(du -h "$ZIP_PATH" | awk '{print $1}')"
echo "Created: $ZIP_PATH"
echo "Size: $SIZE"
echo "Staging: $STAGE"

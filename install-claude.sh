#!/usr/bin/env bash
set -euo pipefail

# ============================================================================
# rust-skills Installer for Claude Code
#
# This script installs the Rust skills from this repository into the global
# Claude Code skills directory (`~/.claude/skills`).
# It is idempotent and can be run multiple times safely.
# ============================================================================

# --- Configuration ---
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_SRC_DIR="$REPO_ROOT/skills"
CLAUDE_SKILLS_DEST_DIR="$HOME/.claude/skills"

# --- Logging ---
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly RED='\033[0;31m'
readonly NC='\033[0m'

log_info() {
    echo -e "${GREEN}[INFO]${NC} $*"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $*" >&2
}

# --- Core Functions ---

ensure_dir_exists() {
    local dir_path="$1"
    if [[ ! -d "$dir_path" ]]; then
        log_info "Target directory not found. Creating '${dir_path}'..."
        mkdir -p "$dir_path"
    fi
}

install_skill_dir() {
    local src_dir="$1"
    local dest_dir="$2"
    local skill_name
    skill_name="$(basename "$src_dir")"
    local target_skill_path="${dest_dir}/${skill_name}"
    log_info "Syncing skill '${skill_name}'..."
    rsync -av --checksum "$src_dir/" "$target_skill_path/"
}

# --- Main Execution ---

main() {
    log_info "Starting rust-skills installation for Claude Code..."

    if [[ ! -d "$SKILLS_SRC_DIR" ]]; then
        log_error "Source skills directory not found at '${SKILLS_SRC_DIR}'."
        log_error "Please run this script from the root of the 'rust-skills' repository."
        exit 1
    fi

    ensure_dir_exists "$CLAUDE_SKILLS_DEST_DIR"

    for skill_path in "$SKILLS_SRC_DIR"/*; do
        if [[ -d "$skill_path" ]]; then
            install_skill_dir "$skill_path" "$CLAUDE_SKILLS_DEST_DIR"
        fi
    done

    log_info "✅ Successfully installed/updated Rust skills for Claude Code."
    log_info "Skills are located in: ${CLAUDE_SKILLS_DEST_DIR}"
}

main "$@"

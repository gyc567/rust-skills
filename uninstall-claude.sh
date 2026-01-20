#!/usr/bin/env bash
set -euo pipefail

# ============================================================================
# rust-skills Uninstaller for Claude Code
# ============================================================================

# --- Configuration ---
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_SRC_DIR="$REPO_ROOT/skills"
CLAUDE_SKILLS_DEST_DIR="$HOME/.claude/skills"

# --- Logging ---
readonly GREEN='\033[0;32m'
readonly NC='\033[0m'

log_info() {
    echo -e "${GREEN}[INFO]${NC} $*"
}

# --- Main Execution ---
main() {
    log_info "Starting rust-skills uninstallation for Claude Code..."

    if [[ ! -d "$CLAUDE_SKILLS_DEST_DIR" ]]; then
        log_info "Target directory '${CLAUDE_SKILLS_DEST_DIR}' does not exist. Nothing to do."
        exit 0
    fi

    for skill_path in "$SKILLS_SRC_DIR"/*; do
        if [[ -d "$skill_path" ]]; then
            skill_name="$(basename "$skill_path")"
            target_skill_path="${CLAUDE_SKILLS_DEST_DIR}/${skill_name}"
            if [[ -d "$target_skill_path" ]]; then
                log_info "Removing skill '${skill_name}'..."
                rm -rf "$target_skill_path"
            fi
        fi
    done

    log_info "✅ Uninstallation complete."
}

main "$@"

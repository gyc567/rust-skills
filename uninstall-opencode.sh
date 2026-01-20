#!/usr/bin/env bash
set -euo pipefail

# ============================================================================
# rust-skills Uninstaller for OpenCode
#
# This script removes the Rust skills installed by 'install-opencode.sh'
# from the global OpenCode skills directory.
# ============================================================================

# --- Configuration ---
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_SRC_DIR="$REPO_ROOT/skills"
OPENCODE_SKILLS_DEST_DIR="$HOME/.config/opencode/skills"

# --- Logging ---
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly NC='\033[0m'

log_info() {
    echo -e "${GREEN}[INFO]${NC} $*"
}

# --- Main Execution ---
main() {
    log_info "Starting rust-skills uninstallation for OpenCode..."

    if [[ ! -d "$OPENCODE_SKILLS_DEST_DIR" ]]; then
        log_info "Target directory '${OPENCODE_SKILLS_DEST_DIR}' does not exist. Nothing to do."
        exit 0
    fi

    for skill_path in "$SKILLS_SRC_DIR"/*; do
        if [[ -d "$skill_path" ]]; then
            skill_name="$(basename "$skill_path")"
            target_skill_path="${OPENCODE_SKILLS_DEST_DIR}/${skill_name}"
            if [[ -d "$target_skill_path" ]]; then
                log_info "Removing skill '${skill_name}'..."
                rm -rf "$target_skill_path"
            fi
        fi
    done

    log_info "✅ Uninstallation complete."
}

main "$@"

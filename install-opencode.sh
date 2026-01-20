#!/usr/bin/env bash
set -euo pipefail

# ============================================================================
# rust-skills Installer for OpenCode
#
# This script installs the Rust skills from this repository into the global
# OpenCode skills directory (`~/.config/opencode/skills`).
# It is idempotent and can be run multiple times safely.
# ============================================================================

# --- Configuration ---
# Determine the absolute path of the repository's root directory.
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Source directory containing the skills.
SKILLS_SRC_DIR="$REPO_ROOT/skills"
# Target directory for OpenCode global skills.
OPENCODE_SKILLS_DEST_DIR="$HOME/.config/opencode/skills"

# --- Logging ---
# Colored output for better readability.
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly RED='\033[0;31m'
readonly NC='\033[0m' # No Color

log_info() {
    echo -e "${GREEN}[INFO]${NC} $*"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $*" >&2
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $*" >&2
}

# --- Core Functions ---

# Function to ensure a directory exists. Creates it if it doesn't.
# This makes the script idempotent.
ensure_dir_exists() {
    local dir_path="$1"
    if [[ ! -d "$dir_path" ]]; then
        log_info "Target directory not found. Creating '${dir_path}'..."
        mkdir -p "$dir_path"
    fi
}

# Function to install a single skill (which is a directory of files).
# It uses rsync for efficient and safe synchronization.
install_skill_dir() {
    local src_dir="$1"
    local dest_dir="$2"
    local skill_name

    skill_name="$(basename "$src_dir")"
    local target_skill_path="${dest_dir}/${skill_name}"

    log_info "Syncing skill '${skill_name}'..."
    # Use rsync to copy the directory.
    # -a: archive mode (preserves permissions, etc.)
    # -v: verbose
    # --checksum: use checksums to decide if files changed, not just mod-time and size.
    rsync -av --checksum "$src_dir/" "$target_skill_path/"
}


# --- Main Execution ---

main() {
    log_info "Starting rust-skills installation for OpenCode..."

    # 1. Validate that the source skills directory exists.
    if [[ ! -d "$SKILLS_SRC_DIR" ]]; then
        log_error "Source skills directory not found at '${SKILLS_SRC_DIR}'."
        log_error "Please run this script from the root of the 'rust-skills' repository."
        exit 1
    fi

    # 2. Ensure the target directory exists.
    ensure_dir_exists "$OPENCODE_SKILLS_DEST_DIR"

    # 3. Iterate over each skill directory in the source and install it.
    for skill_path in "$SKILLS_SRC_DIR"/*; do
        if [[ -d "$skill_path" ]]; then
            install_skill_dir "$skill_path" "$OPENCODE_SKILLS_DEST_DIR"
        fi
    done

    log_info "✅ Successfully installed/updated Rust skills for OpenCode."
    log_info "Skills are located in: ${OPENCODE_SKILLS_DEST_DIR}"
}

# Execute the main function with all passed arguments.
main "$@"

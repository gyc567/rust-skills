#!/usr/bin/env bash
set -euo pipefail

# ============================================================================
# rust-skills Remote Installer
#
# This script is designed to be run via `curl | bash`. It safely clones the
# rust-skills repository into a temporary directory and runs the appropriate
# local installer.
# ============================================================================

# --- Configuration ---
readonly REPO_URL="https://github.com/gyc567/rust-skills.git"
readonly REPO_NAME="rust-skills"

# --- Logging and Colors ---
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m'

log_info() {
    echo -e "${BLUE}[INFO]${NC} $*"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $*"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $*" >&2
}

# --- Core Functions ---

# Ask for user confirmation before proceeding.
confirm() {
    # `-n 1` reads a single character
    # `-r` prevents backslash from being interpreted
    # `-p` displays a prompt
    read -n 1 -r -p "Do you want to continue? (y/N) " response
    echo
    if [[ "$response" =~ ^[Yy]$ ]]; then
        return 0 # Success
    else
        return 1 # Failure
    fi
}

# Cleanup function that will be called on script exit.
cleanup() {
    exit_code=$?
    if [[ -n "${TMP_DIR-}" && -d "${TMP_DIR}" ]]; then
        log_info "Cleaning up temporary directory..."
        rm -rf "${TMP_DIR}"
    fi
    # Preserve the exit code
    exit ${exit_code}
}

# --- Main Execution ---
main() {
    # Set up a trap to call the cleanup function on EXIT, interrupt, or termination.
    trap cleanup EXIT INT TERM

    log_info "Welcome to the rust-skills installer."
    log_warn "This script will clone the repository and install skills into your user config."
    
    if ! confirm; then
        log_warn "Installation cancelled by user."
        exit 1
    fi

    # Create a temporary directory for the clone.
    # `mktemp -d` is the standard, secure way to do this.
    TMP_DIR=$(mktemp -d)
    log_info "Created temporary directory at: ${TMP_DIR}"

    log_info "Cloning repository from ${REPO_URL}..."
    git clone --depth 1 "${REPO_URL}" "${TMP_DIR}/${REPO_NAME}"
    
    cd "${TMP_DIR}/${REPO_NAME}"

    log_info "Please choose the target environment to install for:"
    # PS3 is the prompt for the `select` command.
    PS3="Enter a number (1-3): "
    select target in "opencode" "claude" "both"; do
        case $target in
            opencode)
                log_info "Installing for OpenCode..."
                ./install-opencode.sh
                break
                ;;
            claude)
                log_info "Installing for Claude Code..."
                ./install-claude.sh
                break
                ;;
            both)
                log_info "Installing for both OpenCode and Claude Code..."
                ./install-opencode.sh
                ./install-claude.sh
                break
                ;;
            *)
                log_warn "Invalid option. Please try again."
                ;;
        esac
    done

    log_success "Installation complete!"
    log_info "The installer will now clean up and exit."
}

# Execute the main function.
main

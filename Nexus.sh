#!/usr/bin/env bash

set -euo pipefail

# Configuration
NEXUS_HOME="${HOME}/.nexus"
REPO_URL="https://github.com/nexus-xyz/network-api"
REPO_PATH="${NEXUS_HOME}/network-api"
TERMS_URL="https://nexus.xyz/terms-of-use"
ORCHESTRATOR_URL="beta.orchestrator.nexus.xyz"

# Formatting constants
BOLD='\033[1m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
NC='\033[0m' # No Color

# System requirements
REQUIRED_PKGS=("build-essential" "pkg-config" "libssl-dev" "git" "protobuf-compiler")

# Initialize logging
LOG_FILE="${NEXUS_HOME}/installation.log"
exec > >(tee -a "${LOG_FILE}") 2>&1

# Display formatted messages
info() { printf "${BOLD}${BLUE}[INFO]${NC} %s\n" "$1"; }
success() { printf "${BOLD}${GREEN}[SUCCESS]${NC} %s\n" "$1"; }
warning() { printf "${BOLD}${YELLOW}[WARNING]${NC} %s\n" "$1"; }

# Display Nexus logo
fetch_logo() {
    info "Fetching Nexus logo..."
    curl -sSf https://raw.githubusercontent.com/arun993/nexus_prover/main/logo.sh | bash
    sleep 3
}

# System setup and package installation
system_setup() {
    info "Starting system update and upgrade..."
    sudo apt-get update && sudo apt-get -y upgrade
    
    info "Installing required packages: ${REQUIRED_PKGS[*]}"
    sudo apt-get -y install "${REQUIRED_PKGS[@]}"
}

# Install Rust toolchain
install_rust() {
    info "Installing Rust toolchain..."
    if ! command -v rustc &> /dev/null; then
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        source "${HOME}/.cargo/env"
        success "Rust installed successfully"
    else
        warning "Rust already installed. Skipping installation."
    fi
}

# Verify directory structure
create_nexus_dir() {
    if [[ ! -d "${NEXUS_HOME}" ]]; then
        mkdir -p "${NEXUS_HOME}"
        success "Created Nexus directory: ${NEXUS_HOME}"
    else
        warning "Directory already exists: ${NEXUS_HOME}"
    fi
}

# User agreement verification
check_terms_agreement() {
    if [[ -z "${NONINTERACTIVE:-}" && ! -f "${NEXUS_HOME}/prover-id" ]]; then
        info "You must agree to the Nexus Beta Terms of Use to continue."
        printf "${BOLD}Terms of Use: ${TERMS_URL}${NC}\n"
        
        while true; do
            read -rp "Do you agree to the terms? (Y/n) " yn
            case "${yn}" in
                [Yy]*|"") break;;
                [Nn]*) warning "Terms declined. Exiting..."; exit 1;;
                *) warning "Please answer (Y)es or (N)o";;
            esac
        done
    fi
}

# Prover ID management
setup_prover_id() {
    local prover_id
    if [[ -z "${NONINTERACTIVE:-}" ]]; then
        info "Prover ID setup instructions:"
        printf "${BOLD}1. Visit ${GREEN}https://beta.nexus.xyz${NC}\n"
        printf "2. Copy your 28-character ${YELLOW}prover id${NC} from the bottom left\n"
        printf "3. Enter it below\n\n${NC}"
        
        while true; do
            read -rp "Enter Prover ID (28 characters) or press Enter to skip: " prover_id
            if [[ -z "${prover_id}" ]]; then
                warning "Prover ID entry skipped. Some features may be unavailable."
                return
            elif [[ "${#prover_id}" -eq 28 ]]; then
                echo "${prover_id}" > "${NEXUS_HOME}/prover-id"
                success "Prover ID saved to ${NEXUS_HOME}/prover-id"
                break
            else
                warning "Invalid Prover ID length (${#prover_id}/28 characters)"
            fi
        done
    fi
}

# Repository management
manage_repository() {
    info "Managing Nexus repository..."
    if [[ -d "${REPO_PATH}" ]]; then
        warning "Repository exists. Updating..."
        (cd "${REPO_PATH}" && git stash save "Script update $(date)" && git pull --ff-only)
    else
        info "Cloning repository..."
        git clone "${REPO_URL}" "${REPO_PATH}"
    fi
    
    info "Checking out latest release..."
    (cd "${REPO_PATH}" && \
     git fetch --tags && \
     git checkout "$(git describe --tags --abbrev=0)")
}

# Main execution
main() {
    fetch_logo
    system_setup
    install_rust
    create_nexus_dir
    check_terms_agreement
    setup_prover_id
    manage_repository
    
    info "Starting prover service..."
    (cd "${REPO_PATH}/clients/cli" && \
     cargo run --release --bin prover -- "${ORCHESTRATOR_URL}")
}

main "$@"

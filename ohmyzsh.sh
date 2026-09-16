#!/usr/bin/env bash
# ── Oh My Zsh Installer ─────────────────────────────────
#
# Clones Oh My Zsh and optionally sets zsh as the login shell.
# An existing ~/.zshrc is never read, written, moved or replaced.
#
# Usage:
#   bash install.sh
#   bash install.sh --unattended
#   bash install.sh --skip-chsh
#
# Environment:
#   ZSH     - path to the Oh My Zsh folder (default: $HOME/.oh-my-zsh)
#   REMOTE  - git remote to clone from (default: gitee mirror)
#   BRANCH  - branch to check out (default: master)
#   CHSH    - 'no' leaves the login shell unchanged
#   RUNZSH  - 'no' does not start zsh when the installer finishes

set -euo pipefail

# ── Colors ──────────────────────────────────────────────
CRED='\033[0;31m'
CGRN='\033[0;32m'
CYLW='\033[0;33m'
CBLD='\033[1m'
CDEF='\033[0m'

# ── Defaults ────────────────────────────────────────────
USER="${USER:-$(id -u -n)}"
HOME="${HOME:-$(getent passwd "$USER" 2>/dev/null | cut -d: -f6)}"
HOME="${HOME:-$(eval echo "~$USER")}"

custom_zsh="${ZSH:+yes}"
ZSH="${ZSH:-$HOME/.oh-my-zsh}"
REMOTE="${REMOTE:-https://gitee.com/caiguang_cc/ohmyzsh.git}"
BRANCH="${BRANCH:-master}"
CHSH="${CHSH:-yes}"
RUNZSH="${RUNZSH:-yes}"

# ── Helpers ─────────────────────────────────────────────
command_exists() {
    command -v "$1" &>/dev/null
}

user_can_sudo() {
    command_exists sudo || return 1
    ! LANG= sudo -n -v 2>&1 | grep -q "may not run sudo"
}

# ── Clone Oh My Zsh ─────────────────────────────────────
setup_ohmyzsh() {
    echo -e "${CGRN}>> Cloning Oh My Zsh...${CDEF}"
    echo "  ───────────────────────────────────────────────────"

    if ! command_exists git; then
        echo -e "${CRED}>> git is not installed.${CDEF}"
        exit 1
    fi

    # Keep the cloned repository from having insecure permissions, otherwise
    # compinit fails with "command not found: compdef" for umasks like 002.
    umask g-w,o-w

    if ! git init --quiet "$ZSH"; then
        echo -e "${CRED}>> Could not initialise $ZSH.${CDEF}"
        exit 1
    fi

    git -C "$ZSH" config core.eol lf
    git -C "$ZSH" config core.autocrlf false
    git -C "$ZSH" config fsck.zeroPaddedFilemode ignore
    git -C "$ZSH" config fetch.fsck.zeroPaddedFilemode ignore
    git -C "$ZSH" config receive.fsck.zeroPaddedFilemode ignore
    git -C "$ZSH" config oh-my-zsh.remote origin
    git -C "$ZSH" config oh-my-zsh.branch "$BRANCH"
    git -C "$ZSH" remote add origin "$REMOTE"

    echo -e "${CYLW}  fetching ${BRANCH} from ${REMOTE}${CDEF}"

    if ! git -C "$ZSH" fetch --depth=1 origin \
        || ! git -C "$ZSH" checkout -b "$BRANCH" "origin/$BRANCH"; then
        rm -rf "$ZSH"
        echo -e "${CRED}>> Failed to clone oh-my-zsh.${CDEF}"
        exit 1
    fi

    echo -e "${CGRN}>> Oh My Zsh cloned to ${ZSH}${CDEF}"
    echo ""
}

# ── Default Shell ───────────────────────────────────────
setup_shell() {
    # Skip if the user asked for it, or if stdin is not interactive
    if [[ "$CHSH" == "no" ]]; then
        return
    fi

    # Nothing to do when zsh already is the login shell
    if [[ "$(basename -- "${SHELL:-}")" == "zsh" ]]; then
        return
    fi

    if ! command_exists chsh; then
        echo -e "${CYLW}>> chsh not found, change your default shell manually.${CDEF}"
        return
    fi

    echo -e "${CBLD}${CYLW}>> Change your default shell to zsh?${CDEF}"
    echo "  ───────────────────────────────────────────────────"
    read -rp "  [Y/n] > " opt || opt=""

    case "$opt" in
        y*|Y*|"") ;;
        n*|N*) echo -e "${CYLW}>> Shell change skipped.${CDEF}"; return ;;
        *) echo -e "${CYLW}>> Invalid choice, shell change skipped.${CDEF}"; return ;;
    esac

    echo ""
    echo -e "${CGRN}>> Changing your default shell to zsh...${CDEF}"
    echo "  ───────────────────────────────────────────────────"

    # ── Locate the zsh binary ───────────────────────────
    local zsh_bin="zsh"

    # Termux ships zsh from its own prefix, no /etc/shells lookup needed
    case "${PREFIX:-}" in
        *com.termux*) ;;
        *)
            local shells_file
            if [[ -f /etc/shells ]]; then
                shells_file=/etc/shells
            elif [[ -f /usr/share/defaults/etc/shells ]]; then
                shells_file=/usr/share/defaults/etc/shells
            else
                echo -e "${CRED}>> Could not find /etc/shells, change your shell manually.${CDEF}"
                return
            fi

            # Prefer the zsh that comes first on $PATH, but only if it is
            # actually listed as a valid login shell
            if ! zsh_bin="$(command -v zsh)" || ! grep -qx "$zsh_bin" "$shells_file"; then
                zsh_bin="$(grep '^/.*/zsh$' "$shells_file" | tail -n 1)"
                if [[ ! -f "$zsh_bin" ]]; then
                    echo -e "${CRED}>> No zsh binary found in ${shells_file}.${CDEF}"
                    echo -e "${CRED}>> Change your default shell manually.${CDEF}"
                    return
                fi
            fi
            ;;
    esac

    # ── Back up the current shell ───────────────────────
    if [[ -n "${SHELL:-}" ]]; then
        echo "$SHELL" > ~/.shell.pre-oh-my-zsh
    else
        grep "^$USER:" /etc/passwd | awk -F: '{print $7}' > ~/.shell.pre-oh-my-zsh
    fi

    # ── Apply the change ────────────────────────────────
    # sudo without a password prompt where possible, plain chsh otherwise
    local chsh_cmd=(chsh -s "$zsh_bin" "$USER")
    if user_can_sudo; then
        chsh_cmd=(sudo -k chsh -s "$zsh_bin" "$USER")
    fi

    if "${chsh_cmd[@]}"; then
        export SHELL="$zsh_bin"
        echo -e "${CGRN}>> Shell changed to ${zsh_bin}${CDEF}"
    else
        echo -e "${CRED}>> chsh failed, change your default shell manually.${CDEF}"
    fi

    echo ""
}

# ── Main ────────────────────────────────────────────────
main() {
    # ── Arguments ───────────────────────────────────────
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --unattended) RUNZSH=no; CHSH=no ;;
            --skip-chsh)  CHSH=no ;;
            *) echo -e "${CRED}>> Unknown option: $1${CDEF}"; exit 1 ;;
        esac
        shift
    done

    # Run unattended when stdin is not a terminal
    if [[ ! -t 0 ]]; then
        RUNZSH=no
        CHSH=no
    fi

    # ── Checks ──────────────────────────────────────────
    if ! command_exists zsh; then
        echo -e "${CRED}>> Zsh is not installed, install it first.${CDEF}"
        exit 1
    fi

    if [[ -d "$ZSH" ]]; then
        echo -e "${CYLW}>> ${ZSH} already exists.${CDEF}"
        echo "  ───────────────────────────────────────────────────"

        if [[ -n "$custom_zsh" ]]; then
            echo -e "  ${CYLW}1.${CDEF} Unset ZSH when calling the installer:"
            echo -e "     ${CBLD}ZSH= bash install.sh${CDEF}"
            echo -e "  ${CYLW}2.${CDEF} Install to a folder that does not exist yet:"
            echo -e "     ${CBLD}ZSH=/path/to/new/ohmyzsh bash install.sh${CDEF}"
            echo -e "  ${CYLW}3.${CDEF} Remove it if it holds nothing important:"
            echo -e "     ${CBLD}rm -rf $ZSH${CDEF}"
        else
            echo -e "  Remove it if you want to reinstall."
        fi

        echo ""
        exit 1
    fi

    # ── Install ─────────────────────────────────────────
    setup_ohmyzsh
    setup_shell

    echo -e "${CGRN}>> Oh My Zsh is now installed!${CDEF}"
    echo "  ───────────────────────────────────────────────────"
    echo -e "  ${CYLW}~/.zshrc${CDEF} was left untouched - this script never writes to it."
    echo -e "  Templates for plugins, themes and options live in:"
    echo -e "  ${ZSH}/templates/zshrc.zsh-template"
    echo ""

    if [[ "$RUNZSH" == "no" ]]; then
        echo -e "${CYLW}>> Run zsh to try it out.${CDEF}"
        exit 0
    fi

    exec zsh -l
}

main "$@"

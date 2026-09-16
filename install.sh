#!/usr/bin/env bash
# ╔═══════════════════════════════════════════════════════╗
# ║           dotfile-niri Installer v1.0                 ║
# ║           Niri Desktop Dotfiles Setup                 ║
# ╚═══════════════════════════════════════════════════════╝

set -euo pipefail

# ── Colors ──────────────────────────────────────────────
CRED='\033[0;31m'
CGRN='\033[0;32m'
CYLW='\033[0;33m'
CBLE='\033[0;34m'
CBLD='\033[1m'
CDEF='\033[0m'

# ── Paths ───────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"

# ── Defaults ────────────────────────────────────────────
SHELL_CHOICE="fish"      # fish | zsh
TERM_CHOICE="ghostty"    # ghostty | kitty
DO_PKGS=1
DO_FILES=1
DO_SYSTEM=0
FORCE=0
UNATTENDED=0
AUR_HELPER=""

# ── Helpers ─────────────────────────────────────────────
info()    { echo -e "  ${CBLE}>>${CDEF} $*"; }
ok()      { echo -e "  ${CGRN}>>${CDEF} $*"; }
warn()    { echo -e "  ${CYLW}>> 警告:${CDEF} $*"; }
err()     { echo -e "  ${CRED}>> 错误:${CDEF} $*" >&2; }
die()     { err "$*"; exit 1; }
separator() { echo "  ───────────────────────────────────────────────────"; }

command_exists() { command -v "$1" &>/dev/null; }

confirm() {
    # confirm <提示> — unattended 模式一律跳过
    [[ "$UNATTENDED" == "1" ]] && return 1
    read -r -p "  $1 [y/N] " reply
    [[ "$reply" =~ ^[Yy]$ ]]
}

# ── Banner ──────────────────────────────────────────────
show_banner() {
    echo -e "${CBLD}${CYLW}"
    echo "╔═══════════════════════════════════════════════════════╗"
    echo "║           dotfile-niri Installer v1.0                 ║"
    echo "║           Niri Desktop Dotfiles Setup                 ║"
    echo "╚═══════════════════════════════════════════════════════╝"
    echo -e "${CDEF}"
}

# ── Choose Shell & Terminal ─────────────────────────────
choose_options() {
    echo -e "  ${CBLD}Choose Shell:${CDEF}"
    separator
    echo -e "  ${CGRN}1)${CDEF}  fish    (default)"
    echo -e "  ${CGRN}2)${CDEF}  zsh     (配合 ohmyzsh.sh 使用)"
    separator
    if [[ "$UNATTENDED" == "1" ]]; then
        echo -e "  ${CYLW}unattended, 使用默认: fish${CDEF}"
    else
        read -rp "  Select > " choice
        case "$choice" in
            ""|1) SHELL_CHOICE="fish" ;;
            2)    SHELL_CHOICE="zsh" ;;
            *)    warn "无效选项, 使用默认: fish" ;;
        esac
    fi
    ok "Shell 配置: $SHELL_CHOICE"

    echo ""
    echo -e "  ${CBLD}Choose Terminal Emulator:${CDEF}"
    separator
    echo -e "  ${CGRN}1)${CDEF}  ghostty  (default)"
    echo -e "  ${CGRN}2)${CDEF}  kitty"
    separator
    if [[ "$UNATTENDED" == "1" ]]; then
        echo -e "  ${CYLW}unattended, 使用默认: ghostty${CDEF}"
    else
        read -rp "  Select > " choice
        case "$choice" in
            ""|1) TERM_CHOICE="ghostty" ;;
            2)    TERM_CHOICE="kitty" ;;
            *)    warn "无效选项, 使用默认: ghostty" ;;
        esac
    fi
    ok "终端模拟器: $TERM_CHOICE"
    separator
    echo ""
}

# ── Args ────────────────────────────────────────────────
show_help() {
    cat <<'EOF'
用法:
  bash install.sh                 # 交互式: 选择 shell/终端 + 备份旧配置 + 部署 + 可选装依赖
  bash install.sh --no-pkg        # 只部署配置文件, 不安装软件包
  bash install.sh --pkg-only      # 只安装软件包, 不动配置
  bash install.sh --system        # 额外部署 /etc 下的系统配置 (keyd)
  bash install.sh --force         # 覆盖已有文件时不做备份
  bash install.sh --unattended    # 无人值守 (shell=fish, 终端=ghostty, 不询问)

说明:
  - Games/ 不会部署 (按需求跳过)
  - .local/share/nvim (lazy.nvim 插件缓存) 不复制, 由 lazy.nvim 自动同步
  - 已存在的目标文件会备份到 ~/.dotfiles-backup-<时间戳>/
  - fish/zsh 和 ghostty/kitty 二选一, 未被选中的配置不会部署
EOF
}

for arg in "$@"; do
    case "$arg" in
        --no-pkg)     DO_PKGS=0 ;;
        --pkg-only)   DO_PKGS=1; DO_FILES=0 ;;
        --system)     DO_SYSTEM=1 ;;
        --force)      FORCE=1 ;;
        --unattended) UNATTENDED=1 ;;
        -h|--help)
            show_help
            exit 0 ;;
        *) die "未知参数: $arg" ;;
    esac
done

# ── Preflight ───────────────────────────────────────────
preflight() {
    echo -e "${CBLD}>> Preflight${CDEF}"
    separator

    [[ -d "$SCRIPT_DIR/.config" ]] || die "请在仓库内运行: $SCRIPT_DIR 缺少 .config/"
    [[ -f /etc/os-release ]] && grep -qi arch /etc/os-release \
        || warn "非 Arch 系发行版, 包安装步骤可能失败 (配置文件部分不受影响)"

    if [[ $DO_PKGS -eq 1 ]]; then
        if command_exists paru; then
            AUR_HELPER="paru"
        elif command_exists yay; then
            AUR_HELPER="yay"
        elif command_exists pacman; then
            AUR_HELPER="pacman"
            warn "未找到 paru/yay, 只装官方仓库包; AUR 包需自行安装"
        else
            warn "未找到 pacman, 跳过软件包安装"
            DO_PKGS=0
        fi
    fi

    echo ""
}

# ── Backup ──────────────────────────────────────────────
backup_target() {
    local target="$1"
    [[ -e "$target" || -L "$target" ]] || return 0
    if [[ $FORCE -eq 1 ]]; then
        warn "覆盖 ${target/#$HOME/~} (未备份)"
        rm -rf "$target"
        return 0
    fi
    mkdir -p "$BACKUP_DIR"
    local rel="${target#"$HOME"/}"
    local dest="$BACKUP_DIR/${rel//\//_}"
    mv "$target" "$dest"
    info "已备份: ~/$rel -> ${BACKUP_DIR#"$HOME"/}/${dest##*/}"
}

# ── Deploy Dotfiles ─────────────────────────────────────
install_dotfiles() {
    echo -e "${CBLD}>> Deploying dotfiles${CDEF}"
    separator
    local copied=0
    local item base target

    # ~/.config/* — 按选择跳过未采用的 shell / 终端配置
    mkdir -p "$HOME/.config"
    for item in "$SCRIPT_DIR"/.config/*; do
        base="$(basename "$item")"
        case "$base" in
            fish)    [[ "$SHELL_CHOICE" == "fish" ]] || continue ;;
            ghostty) [[ "$TERM_CHOICE" == "ghostty" ]] || continue ;;
            kitty)   [[ "$TERM_CHOICE" == "kitty" ]] || continue ;;
        esac
        target="$HOME/.config/$base"
        [[ -e "$target" ]] && backup_target "$target"
        cp -a "$item" "$target"
        copied=$((copied + 1))
        ok "~/.config/$base"
    done

    # 家目录 dotfiles — fish 只拿 .vimrc/.tmux.conf/.gtkrc-2.0, zsh 额外拿 .zshrc/.zprofile
    for item in .vimrc .tmux.conf .gtkrc-2.0 .zshrc .zprofile; do
        case "$item" in
            .zshrc|.zprofile) [[ "$SHELL_CHOICE" == "zsh" ]] || continue ;;
        esac
        [[ -e "$SCRIPT_DIR/$item" ]] || continue
        target="$HOME/$item"
        [[ -e "$target" ]] && backup_target "$target"
        cp -a "$SCRIPT_DIR/$item" "$target"
        copied=$((copied + 1))
        ok "~/$item"
    done

    # .local/share: 图标主题 + GTK 主题; nvim/ 是 lazy.nvim 插件缓存, 不复制
    mkdir -p "$HOME/.local/share"
    for sub in themes icons; do
        [[ -d "$SCRIPT_DIR/.local/share/$sub" ]] || continue
        target="$HOME/.local/share/$sub"
        [[ -e "$target" ]] && backup_target "$target"
        cp -a "$SCRIPT_DIR/.local/share/$sub" "$target"
        copied=$((copied + 1))
        ok "~/.local/share/$sub"
    done

    separator
    echo -e "  ${CGRN}>> Dotfiles deployed ($copied items)${CDEF}"
    [[ -d "$BACKUP_DIR" ]] && info "旧配置备份在: ${CBLE}$BACKUP_DIR${CDEF}, 确认无误后可删除" \
        || info "没有需要备份的旧配置"
    echo ""
}

# ── Packages ────────────────────────────────────────────
install_packages() {
    echo -e "${CBLD}>> Installing packages${CDEF}"
    separator

    if [[ $DO_PKGS -eq 0 ]]; then
        info "已指定 --no-pkg, 跳过"
        echo ""
        return 0
    fi

    # ── Pacman packages ─────────────────────────────────
    local pacman_pkgs=(
        # ── Desktop ─────────────────────────────────────
        niri
        $TERM_CHOICE
        xdg-desktop-portal-gtk xdg-desktop-portal-gnome polkit-gnome

        # ── Input Method ────────────────────────────────
        fcitx5 fcitx5-gtk fcitx5-qt fcitx5-chinese-addons fcitx5-configtool

        # ── Tools ───────────────────────────────────────
        neovim tmux mpv cava btop mako fuzzel swaylock starship
        yazi eza htop bat fastfetch waypaper satty mangohud

        # ── System Config ───────────────────────────────
        keyd

        # ── Fonts ───────────────────────────────────────
        ttf-jetbrains-mono-nerd
    )

    # ── AUR packages ────────────────────────────────────
    local aur_pkgs=(
        eww matugen clipse clipse-gui go-musicfox hexecute sesheta
    )

    if [[ "$AUR_HELPER" == "pacman" ]]; then
        info "使用 pacman 安装官方仓库包..."
        separator
        sudo pacman -S --needed --noconfirm "${pacman_pkgs[@]}" \
            || warn "部分包安装失败, 请检查"
        echo ""
        return 0
    fi

    info "使用 $AUR_HELPER 安装 (${#pacman_pkgs[@]} 官方仓库 + ${#aur_pkgs[@]} AUR)..."
    separator
    "$AUR_HELPER" -S --needed --noconfirm "${pacman_pkgs[@]}" \
        || warn "官方仓库包部分安装失败, 请检查"
    "$AUR_HELPER" -S --needed --noconfirm "${aur_pkgs[@]}" \
        || warn "AUR 包部分安装失败 (可手动确认: ${aur_pkgs[*]})"

    separator
    echo -e "  ${CGRN}>> Packages installed${CDEF}"
    echo ""
}

# ── System Config (/etc) ────────────────────────────────
install_system() {
    echo -e "${CBLD}>> System config (/etc)${CDEF}"
    separator

    if [[ $DO_SYSTEM -eq 0 ]]; then
        info "未指定 --system, 跳过 /etc 配置"
        info "  如需键盘映射 (keyd):    sudo cp $SCRIPT_DIR/etc/keyd/default.conf /etc/keyd/"
        info "  pacman.conf 请自行核对后手动合并, 脚本不会直接覆盖"
        echo ""
        return 0
    fi

    # ── keyd ────────────────────────────────────────────
    if confirm "部署 keyd 键盘映射到 /etc/keyd/ 并启用服务?"; then
        sudo mkdir -p /etc/keyd
        [[ -f /etc/keyd/default.conf ]] && sudo cp /etc/keyd/default.conf /etc/keyd/default.conf.bak-dotfiles
        sudo cp "$SCRIPT_DIR/etc/keyd/default.conf" /etc/keyd/default.conf
        sudo systemctl enable --now keyd.service
        ok "keyd 已部署并启用"
    fi

    # ── pacman.conf ─────────────────────────────────────
    if confirm "将仓库的 pacman.conf 部署到 /etc (原文件备份为 pacman.conf.bak-dotfiles)?"; then
        sudo cp /etc/pacman.conf /etc/pacman.conf.bak-dotfiles
        sudo cp "$SCRIPT_DIR/etc/pacman.conf" /etc/pacman.conf
        ok "pacman.conf 已部署 (原文件: /etc/pacman.conf.bak-dotfiles)"
        warn "请确认镜像源/仓库列表符合你的网络环境"
    fi
    echo ""
}

# ── Post Install ────────────────────────────────────────
post_install() {
    echo -e "${CBLD}>> Post install${CDEF}"
    separator

    # ── Login shell ─────────────────────────────────────
    if [[ $DO_FILES -eq 1 ]] && command_exists "$SHELL_CHOICE" \
        && [[ "$(getent passwd "$USER" | cut -d: -f7)" != "$(command -v "$SHELL_CHOICE")" ]] \
        && confirm "将 $SHELL_CHOICE 设为登录 shell (chsh)?"; then
        chsh -s "$(command -v "$SHELL_CHOICE")" "$USER" \
            && ok "登录 shell 已切换为 $SHELL_CHOICE" \
            || warn "chsh 失败, 请手动执行: chsh -s \$(command -v $SHELL_CHOICE)"
    fi

    # ── systemd user daemon ─────────────────────────────
    if [[ $DO_FILES -eq 1 ]]; then
        systemctl --user daemon-reload 2>/dev/null && ok "systemd --user daemon-reload 完成"
    fi

    # ── Oh My Zsh (仅 zsh) ──────────────────────────────
    if [[ $DO_FILES -eq 1 && "$SHELL_CHOICE" == "zsh" ]] && [[ -x "$SCRIPT_DIR/ohmyzsh.sh" ]] \
        && confirm "现在运行 ohmyzsh.sh 安装 Oh My Zsh?"; then
        bash "$SCRIPT_DIR/ohmyzsh.sh" || warn "Oh My Zsh 安装未完成, 可稍后手动运行"
    fi

    # ── nvim plugins ────────────────────────────────────
    if [[ $DO_FILES -eq 1 ]] && command_exists nvim && confirm "现在同步 nvim 插件 (lazy.nvim)?"; then
        nvim --headless "+Lazy! sync" +qa 2>/dev/null \
            && ok "nvim 插件同步完成" \
            || warn "nvim 插件同步未完成, 可稍后打开 nvim 手动 :Lazy sync"
    fi

    echo ""
    echo -e "${CGRN}>> Setup complete!${CDEF}"
    separator
    echo -e "  ${CYLW}1.${CDEF} 注销并重新登录 niri (或重启), 使 niri/eww/fcitx5 等配置生效"
    echo ""
    echo -e "  ${CYLW}2.${CDEF} niri 绑定里有硬编码的另一个终端, 按需修改:"
    echo -e "     Mod+Q -> spawn ghostty  (binds.kdl:3)"
    echo -e "     Mod+V -> spawn kitty -e clipse gui  (binds.kdl:7)"
    echo ""
    echo -e "  ${CYLW}3.${CDEF} Games/ (VRChat 配置) 按需求未部署"
}

# ── Main ────────────────────────────────────────────────
main() {
    show_banner
    choose_options
    preflight
    [[ $DO_FILES -eq 1 ]] && install_dotfiles
    install_packages
    install_system
    post_install
}

main "$@"

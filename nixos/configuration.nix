{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/steam.nix
  ];
  # ── Bootloader ──────────────────────────────────────────────
#  boot.loader.systemd-boot.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
    # Bootloader.
  boot.loader = {
    grub = {
      enable = true;
      device = "nodev"; # "nodev" is used for UEFI
      efiSupport = true;
      gfxmodeEfi = "1366x768";
      #font = "${pkgs.nerd-fonts.noto}/share/fonts/truetype/NerdFonts/Noto/NotoSansMNerdFont-Bold.ttf";
      fontSize = 26;
      splashImage = "/etc/nixos/孤独摇滚-波奇酱.png";
      useOSProber = true;
      devices = [ "nodev" ];
    };
    efi.canTouchEfiVariables = true;
  };

  # Use latest kernel.
#  boot.kernelPackages = pkgs.linuxPackages_zen;

  #For NVIDIA
  #boot.initrd.kernelModules = [ 
  #  "nvidia"
  #  "nvidia_modeset"
  #];

  boot.kernel.sysctl = {
    "kernel.unprivileged_userns_clone" = 1;
  };

  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
    "riscv64-linux"
  ];

  boot.kernelParams = [ 
    "acpi_backlight=native"
  ];

  # ── Nix ─────────────────────────────────────────────────────
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # ── 网络 ────────────────────────────────────────────────────
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

# ── 时区 ────────────────────────────────────────────────────
  time.timeZone = "Asia/Shanghai";
 # i18n.defaultLocale = "en_US.UTF-8";
 # i18n.extraLocaleSettings = {
 #   LC_TIME = "en_US.UTF-8";
 #   LC_CTYPE = "zh_CN.UTF-8";
 # };

  # ── 用户 ────────────────────────────────────────────────────
  users.users.ash = {
    isNormalUser = true;
    description = "Ash";
    home = "/home/ash";
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "networkmanager" "audio" "input" "video" "docker" "kvm" "libvirtd" "vmware" ];
  };
  security.sudo.wheelNeedsPassword = true;
  programs.zsh.enable = true;
  virtualisation.vmware.host.enable = true;

  # ── 驱动 ────────────────────────────────────────────────────
  # Intel HD Graphics 520 (Skylake) + NVIDIA GeForce 940MX (Maxwell)
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver
      libvdpau-va-gl
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      intel-media-driver
    ];
  };

  # CPU 微码更新
  hardware.cpu.intel.updateMicrocode = true;

  # NVIDIA GeForce 940MX（Maxwell 架构 → 必须 closed-source 内核模块）
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = false;                      # Maxwell 不支持 open 内核模块！[span_3](end_span)
    nvidiaSettings = true;

    # ！！！核心修改：锁定 Maxwell 架构支持的 580.xx Legacy 驱动驱动包！！！
    package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
  };

  # 必须指定视频驱动
  services.xserver.videoDrivers = [ "nvidia" ];

  # 注：boot.[span_4](start_span)blacklistedKernelModules = [ "nouveau" ]; 
  # 这一行在 NixOS 里可以安全地删掉或注释掉，因为上面的 videoDrivers 会自动帮你拉黑 nouveau。[span_4](end_span)

  hardware.nvidia.prime = {
    sync.enable = false;
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };
    intelBusId  = "PCI:0:2:0";
    nvidiaBusId = "PCI:2:0:0";
  };



  # ── 声音 ────────────────────────────────────────────────────
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # ── 蓝牙 ────────────────────────────────────────────────────
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # ── SSH ─────────────────────────────────────────────────────
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "prohibit-password";
      PasswordAuthentication = true;
    };
  };

  # ── 服务 ────────────────────────────────────────────────────
  services.flatpak.enable = true;
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;
  services.udisks2.enable = true;
  virtualisation.docker.enable = true;
  programs.nix-ld.enable = true;

  # ── Wayland / Niri ──────────────────────────────────────────
  programs.niri.enable = true;
  programs.xwayland.enable = true;

  # ── 输入法 fcitx5 ───────────────────────────────────────────
  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5.addons = with pkgs; [
      fcitx5-rime
      qt6Packages.fcitx5-configtool
      qt6Packages.fcitx5-chinese-addons
    ];
    fcitx5.waylandFrontend = true;
    fcitx5.settings.inputMethod = {
      GroupOrder."0" = "Default";
      "Groups/0" = {
        Name = "Default";
        "Default Layout" = "us";
        DefaultIM = "keyboard-us";
      };
      "Groups/0/Items/0".Name = "keyboard-us";
      "Groups/0/Items/1".Name = "rime";
    };
    fcitx5.settings = {
      globalOptions = {
        "Hotkey/TriggerKeys" = { "0" = "Super+space"; };
      };
      addons.classicui.globalSection.Theme = "catppuccin-mocha-mauve";
    };
  };

  # ── 字体 ────────────────────────────────────────────────────
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      maple-mono.NF-CN
      maple-mono.NF
      maple-mono.NF-unhinted
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji-blob-bin
      dejavu_fonts
      liberation_ttf
      font-awesome
      gnome-themes-extra
      nerd-fonts.noto
      nerd-fonts.symbols-only
      nerd-fonts.jetbrains-mono
    ];
    fontconfig = {
      defaultFonts = {
        serif = [ "Noto Serif CJK SC" ];
        sansSerif = [ "Noto Sans CJK SC" ];
        monospace = [ "MapleMono NF CN" "JetBrainsMono Nerd Font" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };

  # ── 软件包 ──────────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    inputs.niri.packages.${pkgs.system}.niri
    os-prober
    # System工具
    git vim curl wget rsync gparted 
    uv
    _7zip-zstd
    unzip
    brightnessctl
    pciutils
    pulseaudio
    ffmpeg
    libva
    libva-utils
    power-profiles-daemon
    bluez
    clinfo
    cachix
    desktop-file-utils
    wlr-randr
    nvtopPackages.nvidia

    # Wayland 工具
    swayidle
    swaylock-effects
    sway-audio-idle-inhibit
    waybar
    wlogout
    waypaper
    fuzzel
    mako
    awww
    grim
    slurp
    wl-clipboard
    xwayland-satellite

    # 终端 / 文件
    kitty
    yazi
    (pkgs.btop.override { cudaSupport = true; })
    fastfetch
    ripgrep
    fzf
    tree
    zoxide
    jq
    tree
    
    #字体
      # Maple Mono
    maple-mono.NF 
    # 其他字体
    noto-fonts-cjk-sans
    dejavu_fonts
    liberation_ttf
    nerd-fonts.noto
    # font-icons
    maple-mono.NF
    # Maple Mono NF (Ligature unhinted)
    maple-mono.NF-unhinted
    gnome-themes-extra          # adwaita-fonts
    noto-fonts-cjk-sans         # noto-fonts-cjk
    dejavu_fonts                # ttf-dejavu
    liberation_ttf              # ttf-liberation
    nerd-fonts.symbols-only     # ttf-nerd-fonts-symbols
    noto-fonts-emoji-blob-bin            # noto-fonts-emoji
    font-awesome                # ttf-font-awesome
    nerd-fonts.jetbrains-mono
    # 编辑器
    neovim
    vscode

    # 媒体
    cava
    go-musicfox
    playerctl

    # 主题
    catppuccin-gtk
    catppuccin-fcitx5
    papirus-icon-theme
    nwg-look

    # 网络
    clash-verge-rev

    # 开发
    python3
    docker-compose

    # 应用
    google-chrome
    firefox
    qq
    localsend
    # wechat
    wemeet
    wpsoffice-cn
  ];

  # ── 编辑器 ─────────────────────────────────────────────────
    programs.vscode.package = pkgs.vscode.fhsWithPackages (ps: with ps; [ rustup zlib openssl.dev pkg-config ]);

  # ── 环境变量 ─────────────────────────────────────────────────
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
    # PRIME Offload 模式下显示器由 Intel 核显驱动，GBM 应使用 mesa 默认后端
    # GBM_BACKEND = "nvidia-drm";  # ❌ 错误：这是给独显直连用的，不是 PRIME Offload
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    TERMINAL = "kitty";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
    XDG_DATA_DIRS = [
      "/run/current-system/sw/share"
      "$HOME/.nix-profile/share"
    ];
  };

  environment.pathsToLink = [ "/share/applications" ];

  system.stateVersion = "25.11";
}

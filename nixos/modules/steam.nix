{ config, lib, pkgs, ... }:

{
  # ── Steam 安装 ──────────────────────────────────────────────
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = false;
    localNetworkGameTransfers.openFirewall = true;
    extest.enable = true;
    extraPackages = with pkgs; [
      # 一些游戏需要的额外库
      gamemode
      mangohud
    ];
  };

  hardware.steam-hardware.enable = true;

  # ── 创建 Steam 用独显启动的快捷方式 ──────────────────────────
  # 这会生成一个 ~/Desktop/steam-nvidia.desktop
  # 双击即可用 NVIDIA GPU 启动 Steam
  environment.systemPackages = let
    steam-nvidia = pkgs.writeShellScriptBin "steam-nvidia" ''
      export __NV_PRIME_RENDER_OFFLOAD=1
      export __GLX_VENDOR_LIBRARY_NAME=nvidia
      export __VK_LAYER_NV_optimus=NVIDIA_only
      export VK_DRIVER_FILES=/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json
      exec ${pkgs.steam}/bin/steam "$@"
    '';
  in [
    steam-nvidia
  ];
}
{ pkgs, inputs, ... }: {
  home.username = "ash";
  home.homeDirectory = "/home/ash";
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    kitty
    fuzzel
    waybar
    wemeet
  ];

  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      saoudrizwan.claude-dev
    ];
  };

  programs.zsh.enable = true;
  programs.zoxide.enable = true;
}

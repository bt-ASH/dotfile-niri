<h1 align="center">
  Niri Dotfiles
</h1>

<p align="center">
   <a href="#features">Features</a> • 
   <a href="#gallery">Gallery</a> • 
   <a href="#dependencies">Dependencies</a> • 
   <a href="#ui--icon-themes">UI & Icons</a> • 
   <a href="#installation">Installation</a> • 
   <a href="#keybinds">Keybinds</a>
</p>

## Features

- Niri wayland compositor with custom scripts
- Waybar status bar with Win11-like layout
- Matugen dynamic color scheme generation
- Fcitx5 input method
- Kitty terminal
- Neovim with full plugin setup
- Tmux configuration
- Fish, Bash, Zsh shell configs
- MPV with custom scripts
- Cava audio visualizer
- Btop system monitor
- Mako notifications
- Fuzzel app launcher
- GTK theme integration
- Automatic wallpaper-following theme switching (see [Scripts-chan](https://github.com/bt-ASH/Scripts-chan#))

## Dependencies

| Name | Used For | Link |
| --- | --- | --- |
| `niri` | Wayland compositor | [niri](https://github.com/YaLTeR/niri) |
| `waybar` | Status bar | [waybar](https://github.com/Alexays/Waybar) |
| `kitty` | Terminal emulator | [kitty](https://github.com/kovidgoyal/kitty) |
| `fcitx5` | Input method | [fcitx5](https://fcitx-im.org/) |
| `nvim` | Text editor | [neovim](https://github.com/neovim/neovim) |
| `tmux` | Terminal multiplexer | [tmux](https://github.com/tmux/tmux) |
| `mpv` | Media player | [mpv](https://mpv.io/) |
| `cava` | Audio visualizer | [cava](https://github.com/karlstav/cava) |
| `btop` | System monitor | [btop](https://github.com/aristocratos/btop) |
| `mako` | Notification daemon | [mako](https://github.com/emersion/mako) |
| `fuzzel` | App launcher | [fuzzel](https://codeberg.org/dnkl/fuzzel) |
| `matugen` | Material You colors | [matugen](https://github.com/InioX/matugen) |
| `swaylock` | Screen locker | [swaylock](https://github.com/swaywm/swaylock) |
| `starship` | Shell prompt | [starship](https://github.com/starship/starship) |
| `yazi` | File manager | [yazi](https://github.com/sxyazi/yazi) |

## UI & Icon Themes

| Name | Used For | Link |
| --- | --- | --- |
| `Adwaita-Matugen-A` | Icon theme | Custom Matugen-generated |
| `JetBrains Mono Nerd Font` | UI font | [JetBrainsMono-NF](https://github.com/ryanoasis/nerd-fonts) |

## Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/bt-ASH/dotfile-niri.git ~/dotfile-niri
   ```

2. **Copy configs**
   ```bash
   cp -r ~/dotfile-niri/.config/* ~/.config/
   cp ~/dotfile-niri/.bashrc ~/.bashrc
   cp ~/dotfile-niri/.bash_profile ~/.bash_profile
   cp ~/dotfile-niri/.zshrc ~/.zshrc
   cp ~/dotfile-niri/.vimrc ~/.vimrc
   ```

3. **Install dependencies**
   - Install the packages listed in the Dependencies table above using your package manager.

4. **Restart Niri**
   - Log out and log back in, or restart Niri to apply changes.

## Keybinds

| Action | Shortcut |
| --- | --- |
| Terminal | `Super + Enter` |
| Close window | `Super + Q` |
| Toggle floating | `Super + Space` |
| Launcher | `Super + D` |
| Lock screen | `Super + Escape` |

## Notes

- Configured for Arch Linux with Niri wayland compositor
- Color schemes are dynamically generated using Matugen
- Custom scripts are located in `~/.config/niri/scripts/`
- Waybar has two variants: default and Win11-like layout

## License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](LICENSE) file for details.

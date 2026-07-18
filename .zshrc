# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
#if [ -z "$TMUX" ]; then
#  tmux attach -t mysession || tmux new-session    # Set name of the theme to load --- if set to "random", it will
#fi
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="random"
# ZSH_THEME="ys"
 # ZSH_THEME="af-magic"
# ZSH_THEME="jonathan"
#  ZSH_THEME="amuse"
 ZSH_THEME="aussiegeek"
# ZSH_THEME="bureau"
# ZSH_THEME="simonoff"
#
# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added in $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
	zsh-autosuggestions
	zsh-syntax-highlighting
	#incr
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"
export EDITOR=nvim
# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#
alias y="yazi"
#alias vim="nvim"
alias v="nvim"
alias vi="nvim"
#alias mpv="mpv --hwdec=vaapi"
alias fox="firefox & disown"
alias icat="kitten kitty icat"
alias rsyncs="rsync -av --progress"
alias not='notify-send "Download Error!"'
#alias fastfetch=\ fastfetch\ --logo\ Blackarch
alias nix_up='git add . && git commit -m "init"'
alias ff="fastfetch --config ~/.config/fastfetch/config-linux-anime.jsonc"
#alias wps="env GTK_IM_MODULE=fcitx QT_IM_MODULE=fcitx XMODIFIERS=@im=fcitx wps & disown"
alias wechat="env GTK_IM_MODULE=fcitx QT_IM_MODULE=fcitx XMODIFIERS=@im=fcitx wechat & disown"
alias nix_py11="nix-shell -p '(import (fetchTarball \
  \"https://github.com/NixOS/nixpkgs/archive/nixos-23.11.tar.gz\"\
  ) {}).python311.override { version = \"3.11.9\"; }'"

#zsh-autosuggestion颜色为白色的问题解决
export TERM=xterm-256color

# 设置wikiman分页器为nvim
#export PAGER="nvim -R"
#export MANPAGER="nvim -R"

export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,spinner:#F5E0DC,hl:#F38BA8 \
--color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC \
--color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 \
--color=selected-bg:#45475A \
--color=border:#6C7086,label:#CDD6F4"
# Created by `pipx` on 2025-12-24 13:05:28
export PATH="$PATH:/home/ash/.local/bin"
# flatpak环境
export XDG_DATA_DIRS="/usr/local/share:/usr/share:/var/lib/flatpak/exports/share:/home/ash/.local/share/flatpak/exports/share"

rand_off(){
  wlr-randr --output eDP-1 --off
  echo "eDP-1 display off"
}
rand_on(){
  wlr-randr --output eDP-1 --on
  echo "eDP-1 display on"
}



vid(){
  wf-recorder -g "$(slurp -d)" -f ~/Videos/$(date +%Y-%m-%d_%H-%M-%S).mp4 \
  --codec=libx264rgb \
  --audio=$(pactl get-default-sink).monitor
}
vid_full(){
  wf-recorder -g "$(swaymsg -t get_outputs | jq -r ".[] | select(.focused) | .rect | \"\(.x),\(.y) \(.width)x\(.height)\"")" -f ~/Videos/$(date +%Y-%m-%d_%H-%M-%S).mp4 --codec=libx264rgb --audio=$(pactl get-default-sink).monitor
}

# 8 9 11 13 14 15 16 19 22 23 27 28
fs(){
  echo "8 9 11 13 14 15 16 19 22 23 27 28"
  read FFS
  fastfetch -c examples/$FFS.jsonc  -l none
}

if [[ $(tty) == '/dev/tty1' ]];then
  niri-session
  pyenv shell system
fi

[[ -s /usr/share/autojump/autojump.zsh ]] && source /usr/share/autojump/autojump.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
#eval pyenv shell system
# >>> miyu zsh hook >>>
[ -r "/home/ash/.config/miyu/shell/zsh-hook.zsh" ] && source "/home/ash/.config/miyu/shell/zsh-hook.zsh"
# <<< miyu zsh hook <<<

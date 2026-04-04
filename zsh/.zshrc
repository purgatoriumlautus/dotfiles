# Minimal zsh config - no frameworks

# -----------------
# History
# -----------------
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS      # no duplicate entries
setopt HIST_IGNORE_SPACE     # ignore commands starting with space
setopt SHARE_HISTORY         # share history between sessions
setopt APPEND_HISTORY        # append instead of overwrite

# -----------------
# Completion
# -----------------
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'  # case-insensitive
zstyle ':completion:*' menu select                    # menu selection
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS} # colored completions

# -----------------
# Correction
# -----------------
setopt CORRECT           # command correction
setopt CORRECT_ALL       # argument correction
SPROMPT='zsh: correct %F{red}%R%f to %F{green}%r%f? [y/n/a/e] '

# -----------------
# Misc options
# -----------------
setopt AUTO_CD              # cd by typing directory name
setopt NO_BEEP              # no beep
setopt INTERACTIVE_COMMENTS # allow comments in interactive shell

# -----------------
# Colors
# -----------------
autoload -Uz colors && colors

# -----------------
# Git info for prompt
# -----------------
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats ' %F{green}(%b)%f'
zstyle ':vcs_info:git:*' actionformats ' %F{yellow}(%b|%a)%f'
setopt PROMPT_SUBST

# -----------------
# Prompt
# -----------------
# [I/N] user@hostname ~/path (branch)
# >
# Device-specific: change hostname display per machine
PROMPT='${vim_mode} %F{white}%n%f@%F{cyan}セレスチャル%f %F{white}%~%f${vcs_info_msg_0_}
%F{green}>%f '

# -----------------
# Editor
# -----------------
export EDITOR='nvim'

# -----------------
# PATH
# -----------------
export PATH=$HOME/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl

# -----------------
# Aliases
# -----------------
alias ff="fastfetch"
alias vim="nvim"
alias ls="ls --color=auto"
alias ll="ls -la"
# alias kali="virsh start kali 2>/dev/null && virt-viewer --attach kali & 2>/dev/null || virt-viewer --attach kali &"
# alias kalis="virsh shutdown kali"
alias cd="z"


# Git aliases
alias g="git"
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gl="git pull"
alias gd="git diff"
alias gco="git checkout"
alias gb="git branch"
alias glog="git log --oneline --graph"

# -----------------
# NVM (Node Version Manager)
# -----------------
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# -----------------
# Vi mode
# -----------------
bindkey -v                           # vi mode
export KEYTIMEOUT=1                  # reduce ESC delay (10ms)

# Mode indicator for prompt
vim_ins_mode="%F{green}I%f"
vim_cmd_mode="%F{yellow}N%f"
vim_mode=$vim_ins_mode

zle-keymap-select() {
  vim_mode="${${KEYMAP/vicmd/${vim_cmd_mode}}/(main|viins)/${vim_ins_mode}}"
  zle reset-prompt
}
zle-line-init() {
  vim_mode=$vim_ins_mode
}
zle -N zle-keymap-select
zle -N zle-line-init

# Keep useful keybinds in insert mode
bindkey '^A' beginning-of-line       # Ctrl+A - start of line
bindkey '^E' end-of-line             # Ctrl+E - end of line
bindkey '^U' kill-whole-line         # Ctrl+U - delete entire line
bindkey '^K' kill-line               # Ctrl+K - delete to end
bindkey '^W' backward-kill-word      # Ctrl+W - delete word backward
bindkey '^Y' yank                    # Ctrl+Y - paste killed text
bindkey '^P' up-line-or-history      # Ctrl+P - previous history
bindkey '^N' down-line-or-history    # Ctrl+N - next history

# Visual mode (v in normal mode)
bindkey -M vicmd 'v' visual-mode
bindkey -M vicmd 'V' visual-line-mode

# Clipboard integration (normal mode, Wayland via wl-copy/wl-paste)
vi-yank-clip() { zle vi-yank; print -n "$CUTBUFFER" | wl-copy; }
vi-delete-clip() { zle vi-delete; print -n "$CUTBUFFER" | wl-copy; }
vi-paste-clip() { CUTBUFFER=$(wl-paste); zle vi-put-after; }
zle -N vi-yank-clip
zle -N vi-delete-clip
zle -N vi-paste-clip
bindkey -M vicmd 'Y' vi-yank-clip    # Y - yank to system clipboard
bindkey -M vicmd 'D' vi-delete-clip  # D - delete to system clipboard
bindkey -M vicmd 'P' vi-paste-clip   # P - paste from system clipboard

# -----------------
# FZF (fuzzy finder)
# -----------------
export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git . /'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --exclude .git . /'
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh
bindkey -r '\ec'
bindkey '^G' fzf-cd-widget


# bun completions
[ -s "/home/admni/.bun/_bun" ] && source "/home/admni/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Qemu
export LIBVIRT_DEFAULT_URI="qemu:///system"

# -----------------
# zoxide (z replacement) — must be last
# -----------------
eval "$(zoxide init zsh)"

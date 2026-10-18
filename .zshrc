# =======================================================
# 1. KHAI BÁO BIẾN MÔI TRƯỜNG CƠ BẢN
# =======================================================
export ZSH="$HOME/.oh-my-zsh"

# =======================================================
# 4. OH-MY-ZSH & PLUGINS
# =======================================================
plugins=(
    git
    sudo
    copypath
    extract
    zsh-autosuggestions
    zsh-syntax-highlighting
)
source $ZSH/oh-my-zsh.sh

# =======================================================
# 5. CÔNG CỤ TƯƠNG TÁC (FZF & THEME)
# =======================================================
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

alias f='fzf'
alias fp='fzf --preview="bat --color=always {}"'
alias fv='nvim $(fzf -m --preview="bat --color=always {}")'

# Khởi tạo Oh-My-Posh
eval "$(oh-my-posh init zsh --config ~/projects/dotfiles/ohmyposh-themes/atomicBit.omp.json)"

# Pokemon Logo + System Info
if command -v pokemon-colorscripts > /dev/null; then
    pokemon-colorscripts --no-title -s -r | fastfetch -c $HOME/.config/fastfetch/config-pokemon.jsonc --logo-type file-raw --logo-height 10 --logo-width 5 --logo -
fi

# =======================================================
# 6. ALIASES (LỆNH TẮT TỰ KÍCH HOẠT BẰNG TAY)
# =======================================================
# --- Quản lý hệ thống ---
alias ss='source ~/.zshrc'
alias cls='clear'
alias ht='htop'
alias nv='nvim'
alias tm='tmux'
alias tmrb='tm attach -t robocar'
alias tmrs='tm attach -t rust'

# --- LSD ---
alias ls='lsd'
alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'


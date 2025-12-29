# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# ====== SẮP XẾP VÀ KHAI BÁO BIẾN MÔI TRƯỜNG PATH ======
# Đảm bảo các đường dẫn quan trọng được khai báo trước khi Zsh khởi động

# Thêm ~/.local/bin vào PATH (thường dùng cho các binary của pip/người dùng và pipx)
export PATH="$HOME/.local/bin:$PATH"
export PATH=$PATH:/snap/bin

# Thêm đường dẫn Neovim đã cài đặt qua TAR.GZ
#export PATH="$PATH:/opt/nvim-linux-x86_64/bin"

# =======================================================
export ZSH="$HOME/.oh-my-zsh"

# BÌNH LUẬN (COMMENT) DÒNG NÀY ĐỂ SỬ DỤNG OH MY POSH THAY THẾ
# ZSH_THEME="agnosterzak" 

plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# ====== KHỞI ĐỘNG VÀ HIỂN THỊ TERMINAL ======

# Display Pokemon-colorscripts
# Project page: https://gitlab.com/phoneybadger/pokemon-colorscripts#on-other-distros-and-macos
#pokemon-colorscripts --no-title -s -r #without fastfetch
pokemon-colorscripts --no-title -s -r | fastfetch -c $HOME/.config/fastfetch/config-pokemon.jsonc --logo-type file-raw --logo-height 10 --logo-width 5 --logo -

# fastfetch. Will be disabled if above colorscript was chosen to install
#fastfetch -c $HOME/.config/fastfetch/config-compact.jsonc

# ====== ALIASES CƠ BẢN VÀ LSD ======
# Vim
alias vim='nvim'
# Set-up icons for files/directories in terminal using lsd
alias ls='lsd'
alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'

# fzf
source <(fzf --zsh)
alias f=fzf
# preview with bat
alias fp='fzf --preview="bat --color=always {}"'
# open neovim with select file by tab
alias fv='nvim $(fzf -m --preview="bat --color=always {}")'

# Alias thêm:
alias update='sudo apt update && sudo apt upgrade -y'
alias ht='htop'
alias ss='source ~/.zshrc'

# Tmux
alias tm='tmux'

# Lazydocker
alias lzd='lazydocker'

# Lazygit
alias lzg='lazygit'
# ====== ALIASES CHO PHÁT TRIỂN & GIT ======

# Git status
alias gs='git status'
# Git init
alias gi='git init'
alias ga='git add'
# Git commit
alias gcm='git commit -m'
# Git push
alias gp='git push'
# Git pull
alias gpl='git pull'

# ====== ALIASES CHO ESP-IDF (QUAN TRỌNG) ======

# Thiết lập môi trường IDF
# Lệnh này sẽ kích hoạt môi trường Python ảo và thiết lập các biến $PATH.
alias idfinit='. ~/esp/esp-idf/export.sh'
# Xây dựng dự án
alias idfbuild='idf.py build'
# Flash chương trình
alias idfflash='idf.py flash'
# Theo dõi Serial Monitor
alias idfmonitor='idf.py monitor'
# i3
alias rlook='regolith-look set'
alias rrefresh='regolith-look refresh'
# ====== KHỞI TẠO OH MY POSH VỚI THEME EASY TERM ======
eval "$(oh-my-posh init zsh --config ~/.poshthemes/easy-term.omp.json)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
# MATLAB + NVIDIA (RTX 3050) on Regolith
export __GLX_VENDOR_LIBRARY_NAME=nvidia
export __NV_PRIME_RENDER_OFFLOAD=1
export __VK_LAYER_NV_optimus=NVIDIA_only
export PATH="$HOME/bin:$PATH"

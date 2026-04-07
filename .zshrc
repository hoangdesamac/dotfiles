# =======================================================
# 1. KHAI BÁO BIẾN MÔI TRƯỜNG CƠ BẢN
# =======================================================
export ZSH="$HOME/.oh-my-zsh"
export FILE_MANAGER=thunar
export ANDROID_HOME="$HOME/Android/Sdk"

# Cấu hình đồ họa NVIDIA (LOQ 15IAX9 chạy Prime rất mượt)
export __GLX_VENDOR_LIBRARY_NAME=nvidia
export __NV_PRIME_RENDER_OFFLOAD=1
export __VK_LAYER_NV_optimus=NVIDIA_only

# Fix lỗi hiển thị cho một số ứng dụng Java/Matlab trên i3
export _JAVA_AWT_WM_NONREPARENTING=1 

# =======================================================
# 2. CẤU HÌNH NVM (Node Version Manager)
# =======================================================
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# =======================================================
# 3. THIẾT LẬP PATH (Ưu tiên các tool tự cài)
# =======================================================
# Đường dẫn ESP-Clang cho ESP-IDF (Fix lỗi LSP trong Neovim)
export PATH="$HOME/.espressif/tools/esp-clang/bin:$PATH"

# Thêm đường dẫn Mason cho Neovim (để không bị lỗi DAP/LSP)
export PATH="$HOME/.local/share/nvim/mason/bin:$PATH"
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"
export PATH="/opt/nvim-linux-x86_64/bin:/snap/bin:$PATH"

# Android Paths
export PATH="$PATH:$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools"
export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/build-tools"

# =======================================================
# 4. OH-MY-ZSH & PLUGINS
# =======================================================
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    extract # Plugin giải nén cực nhanh bằng lệnh 'extract'
    sudo    # Nhấn ESC 2 lần để thêm 'sudo' vào lệnh vừa gõ
)
source $ZSH/oh-my-zsh.sh

# =======================================================
# 5. CÔNG CỤ TƯƠNG TÁC (FZF & THEME)
# =======================================================
# Khởi tạo FZF (Chỉ gọi 1 lần duy nhất)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Alias cho FZF (Dùng bat để preview code cực đẹp)
alias f='fzf'
alias fp='fzf --preview="bat --color=always {}"'
alias fv='nvim $(fzf -m --preview="bat --color=always {}")'

# Khởi tạo Oh-My-Posh (Đặt trước Pokemon để tránh lag)
eval "$(oh-my-posh init zsh --config ~/.poshthemes/atomicBit.omp.json)"

# Pokemon Logo + System Info
if command -v pokemon-colorscripts > /dev/null; then
    pokemon-colorscripts --no-title -s -r | fastfetch -c $HOME/.config/fastfetch/config-pokemon.jsonc --logo-type file-raw --logo-height 10 --logo-width 5 --logo -
fi

# =======================================================
# 6. ALIASES (LỆNH TẮT)
# =======================================================
# --- Quản lý hệ thống ---
alias update='sudo apt update && sudo apt upgrade -y'
alias ss='source ~/.zshrc'
alias cls='clear'
alias ht='htop'
alias nv='nvim'

# --- LSD (ls đẹp hơn) ---
alias ls='lsd'
alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'

# =======================================================
# 7. SDKMAN & CONDA (PHẢI Ở CUỐI CÙNG)
# =======================================================
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"

# >>> conda initialize >>>
if [ -f "$HOME/miniconda/bin/conda" ]; then
    eval "$($HOME/miniconda/bin/conda shell.zsh hook)"
fi
# <<< conda initialize <<<

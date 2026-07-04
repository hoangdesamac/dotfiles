# =======================================================
# 1. KHAI BÁO BIẾN MÔI TRƯỜNG CƠ BẢN
# =======================================================
export ZSH="$HOME/.oh-my-zsh"
export FILE_MANAGER=thunar

# CHUẨN HÓA ANDROID HOME
export ANDROID_HOME="$HOME/Android/Sdk"
export XDG_DATA_DIRS="/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share:$XDG_DATA_DIRS"
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
export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin"
export PATH="$PATH:$ANDROID_HOME/platform-tools"
export PATH="$PATH:$ANDROID_HOME/emulator"

# Thêm sẵn đường dẫn Cargo/Rust & PlatformIO vào PATH thay vì source cả môi trường
export PATH="$HOME/.cargo/bin:$HOME/.platformio/penv/bin:$PATH"

# =======================================================
# 4. OH-MY-ZSH & PLUGINS
# =======================================================
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    extract 
    sudo    
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
eval "$(oh-my-posh init zsh --config ~/.poshthemes/atomicBit.omp.json)"

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

# --- Kích hoạt môi trường bằng tay ---
alias get_idf='. $HOME/.espressif/v5.5.3/esp-idf/export.sh'
alias espidf='source ~/.espressif/v5.5.3/esp-idf/export.sh'
alias esp_master='. /home/hoangdesamac/esp/esp-idf-master/export.sh' # Bản 6.2 lúc nãy của bạn

# Lệnh bật Conda bằng tay khi nào cần mới dùng
alias start_conda='source /home/hoangdesamac/miniconda3/etc/profile.d/conda.sh'

# =======================================================
# 7. SDKMAN (PHẢI Ở CUỐI CÙNG)
# =======================================================
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"
# direnv
eval "$(direnv hook zsh)"

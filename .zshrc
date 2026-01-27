# =======================================================
# 1. KHAI BÁO BIẾN MÔI TRƯỜNG CƠ BẢN (ENV VARS)
# =======================================================
export ZSH="$HOME/.oh-my-zsh"
export FILE_MANAGER=thunar
export ANDROID_HOME="$HOME/Android/Sdk"

# Cấu hình đồ họa cho NVIDIA/Matlab
export __GLX_VENDOR_LIBRARY_NAME=nvidia
export __NV_PRIME_RENDER_OFFLOAD=1
export __VK_LAYER_NV_optimus=NVIDIA_only

# =======================================================
# 2. CẤU HÌNH NVM (QUAN TRỌNG: PHẢI NẰM TRƯỚC PATH)
# =======================================================
# Nạp NVM trước để nó tự động chèn Node path lên đầu
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# =======================================================
# 3. THIẾT LẬP PATH (GỘP CHUNG ĐỂ TRÁNH XUNG ĐỘT)
# =======================================================
# Thứ tự ưu tiên: Local bin > Home bin > System > Custom apps > Android
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"
export PATH="$PATH:/opt/nvim-linux-x86_64/bin:/snap/bin"

# Thêm Android Paths
export PATH="$PATH:$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools"
export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/build-tools"

# =======================================================
# 4. OH-MY-ZSH & PLUGINS
# =======================================================
# ZSH_THEME="agnosterzak" # Đã tắt để dùng Oh-My-Posh
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
)
source $ZSH/oh-my-zsh.sh

# =======================================================
# 5. CÔNG CỤ TƯƠNG TÁC (FZF, DISPLAY)
# =======================================================
# FZF Configuration
source <(fzf --zsh)
alias f=fzf
alias fp='fzf --preview="bat --color=always {}"'
alias fv='nvim $(fzf -m --preview="bat --color=always {}")'

# Hiển thị Logo Pokemon + Fastfetch khi mở terminal
pokemon-colorscripts --no-title -s -r | fastfetch -c $HOME/.config/fastfetch/config-pokemon.jsonc --logo-type file-raw --logo-height 10 --logo-width 5 --logo -

# Khởi tạo Oh-My-Posh Theme
eval "$(oh-my-posh init zsh --config ~/.poshthemes/emodipt-extend.omp.json)"

# =======================================================
# 6. ALIASES (ĐỊNH DANH LỆNH TẮT)
# =======================================================
# --- System & File Management ---
alias update='sudo apt update && sudo apt upgrade -y'
alias ss='source ~/.zshrc'
alias cls='clear'
alias ht='htop'
alias rr='ranger'
alias ls='lsd'
alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'

# --- Editors ---
alias vim='nvim'
alias nv='nvim'

# --- Git ---
alias gs='git status'
alias gi='git init'
alias ga='git add'
alias gcm='git commit -m'
alias gp='git push'
alias gpl='git pull'
alias lzg='lazygit'

# --- Tmux & Docker ---
alias tm='tmux'
alias tmc='tm attach-session -t c-5'
alias tmd='tm attach-session -t d-5'
alias tmk='tm attach-session -t kot-4'
alias lzd='lazydocker'

# --- ESP-IDF (Embedded) ---
alias idfinit='. ~/esp-idf/export.sh'
alias idfbuild='idf.py build'
alias idfflash='idf.py flash'
alias idfmonitor='idf.py monitor'

# --- Android Development ---
alias adbd='adb devices'
alias adbl='adb logcat'
alias avdlist='emulator -list-avds'
alias avdrun='emulator -avd'

# --- Virtualization Switch (KVM vs VirtualBox) ---
alias to-android="sudo modprobe -r vboxnetadp vboxnetflt vboxdrv && sudo modprobe kvm_intel && echo '🟢 Ready for Android Emulator!'"
alias to-vbox="sudo modprobe -r kvm_intel kvm && sudo modprobe vboxdrv && echo '🔵 Ready for VirtualBox!'"

# --- Regolith / i3 ---
alias rlook='regolith-look set'
alias rrefresh='regolith-look refresh'

# =======================================================
# 7. SDKMAN (PHẢI NẰM CUỐI CÙNG)
# =======================================================
export SDKMAN_DIR="/home/hoangdesamac/.sdkman"
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"

#!/bin/bash

# Chuyển vào đúng thư mục chứa backup
cd "$(dirname "$0")"

echo "--- 1. Dọn dẹp cấu hình cũ gây xung đột ---"
sudo rm -f /etc/apt/sources.list.d/qgis.*
sudo rm -f /etc/apt/sources.list.d/github-cli.list
sudo rm -f /etc/apt/sources.list.d/vscode.list

echo "--- 2. Khôi phục chìa khóa xác thực (Keyrings) ---"
sudo mkdir -p /usr/share/keyrings

# Brave Browser Key
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg

# VS Code Key
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /usr/share/keyrings/vscode.gpg >/dev/null

# GitHub CLI Key
sudo curl -fsSLo /usr/share/keyrings/githubcli-archive-keyring.gpg https://cli.github.com/packages/githubcli-archive-keyring.gpg

# QGIS Key
sudo wget -qO- https://qgis.org/downloads/qgis-2022.gpg.key | sudo gpg --dearmor --yes -o /usr/share/keyrings/qgis-archive-keyring.gpg

echo "--- 3. Khôi phục danh sách kho phần mềm (Sources) ---"
# VS Code
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/vscode.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list

# GitHub CLI
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list

# QGIS
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/qgis-archive-keyring.gpg] https://qgis.org/debian noble main" | sudo tee /etc/apt/sources.list.d/qgis.list

# Khôi phục các PPA khác từ backup (nếu có)
if [ -d "sources.list.d" ]; then
  sudo cp -n sources.list.d/* /etc/apt/sources.list.d/ 2>/dev/null || true
fi

echo "--- 4. Cập nhật hệ thống ---"
sudo apt update

echo "--- 5. Cài đặt lại các ứng dụng từ package_list.txt ---"
if [ -f "package_list.txt" ]; then
  # Lọc bỏ tiêu đề và các thông số thừa, chỉ giữ lại tên gói
  grep -v "Listing" package_list.txt | awk -F'/' '{print $1}' | xargs sudo apt install -y
else
  echo "Không tìm thấy package_list.txt, cài các app cơ bản..."
  sudo apt install code brave-browser gh qgis kitty nvim fastfetch -y
fi

echo "--- HOÀN THÀNH! ---"

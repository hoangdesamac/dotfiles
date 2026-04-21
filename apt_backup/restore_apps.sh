#!/bin/bash

# 1. Định nghĩa màu sắc cho dễ nhìn
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}>>> Đang dọn dẹp các cấu hình cũ bị lỗi...${NC}"
sudo rm -f /etc/apt/sources.list.d/qgis.*
sudo rm -f /etc/apt/sources.list.d/github-cli.list
sudo rm -f /etc/apt/sources.list.d/vscode.list
sudo rm -f /etc/apt/sources.list.d/brave-browser*.list

echo -e "${BLUE}>>> Đang cài đặt công cụ hỗ trợ (curl, gpg, wget)...${NC}"
sudo apt update && sudo apt install -y curl gpg wget

echo -e "${BLUE}>>> Đang tải Keyrings mới nhất từ trang chủ các hãng...${NC}"
sudo mkdir -p /usr/share/keyrings

# Brave Browser
curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg

# VS Code
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /usr/share/keyrings/vscode.gpg >/dev/null

# GitHub CLI
curl -fsSLo /usr/share/keyrings/githubcli-archive-keyring.gpg https://cli.github.com/packages/githubcli-archive-keyring.gpg

# QGIS (Dùng keyserver trực tiếp)
sudo gpg --no-default-keyring --keyring /usr/share/keyrings/qgis-archive-keyring.gpg --keyserver keyserver.ubuntu.com --recv-keys D155B8E6A419C5BE

echo -e "${BLUE}>>> Đang thiết lập danh sách Repository mới...${NC}"
# Thêm VS Code
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/vscode.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list

# Thêm Brave
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list

# Thêm GitHub CLI
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list

# Thêm QGIS (Bản Noble cho 24.04)
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/qgis-archive-keyring.gpg] https://qgis.org/debian noble main" | sudo tee /etc/apt/sources.list.d/qgis.list

echo -e "${GREEN}>>> Đang cập nhật hệ thống với cấu hình mới...${NC}"
sudo apt update

echo -e "${GREEN}>>> Đang tiến hành cài đặt ứng dụng...${NC}"
# Ưu tiên cài các app chính trước để đảm bảo có đồ dùng ngay
sudo apt install -y code brave-browser gh qgis kitty nvim fastfetch

# Sau đó mới quét file package_list.txt để cài các app phụ còn thiếu
if [ -f "package_list.txt" ]; then
  echo -e "${BLUE}>>> Đang cài nốt các gói từ package_list.txt...${NC}"
  grep -v "Listing" package_list.txt | awk -F'/' '{print $1}' | xargs sudo apt install -y
fi

echo -e "${GREEN}====================================${NC}"
echo -e "${GREEN}   XONG RỒI! MÁY ĐÃ CẬP NHẬT MỚI   ${NC}"
echo -e "${GREEN}====================================${NC}"

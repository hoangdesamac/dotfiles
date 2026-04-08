#!/bin/bash

# Đường dẫn thư mục lưu trữ
BACKUP_DIR="$HOME/projects/dotfiles/apt_backup"
mkdir -p "$BACKUP_DIR"

echo "🚀 Đang bắt đầu sao lưu cấu hình APT vào $BACKUP_DIR..."

# 1. Sao lưu danh sách các gói đã cài (Chỉ tên gói cho gọn)
apt list --installed | awk -F/ '{print $1}' > "$BACKUP_DIR/package_list.txt"

# 2. Sao lưu các tệp nguồn (sources.list và sources.list.d)
# Sử dụng rsync để copy thư mục cho sạch sẽ
rsync -av --delete /etc/apt/sources.list "$BACKUP_DIR/"
rsync -av --delete /etc/apt/sources.list.d/ "$BACKUP_DIR/sources.list.d/"

# 3. Sao lưu các khóa GPG (Cực kỳ quan trọng để không bị lỗi NO_PUBKEY)
rsync -av --delete /etc/apt/keyrings/ "$BACKUP_DIR/keyrings/"

# 4. Lưu lại danh sách các PPA đang dùng
grep -r --include="*.list" "^deb" /etc/apt/sources.list.d/ > "$BACKUP_DIR/ppa_summary.txt"

echo "✅ Đã sao lưu xong!"
echo "📂 Cấu trúc hiện tại của $BACKUP_DIR:"
ls -R "$BACKUP_DIR"

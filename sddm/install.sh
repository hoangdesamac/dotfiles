#!/bin/bash
# Chạy với quyền sudo: sudo ./install.sh

echo "Đang cài đặt SDDM theme..."
sudo cp -r themes/simple-sddm /usr/share/sddm/themes/
sudo cp sddm.conf /etc/sddm.conf

# Nếu có file trong conf.d
if [ -d "conf.d" ]; then
  sudo cp -r conf.d/* /etc/sddm.conf.d/
fi

echo "Hoàn tất! Hãy thử Logout để kiểm tra giao diện mới."

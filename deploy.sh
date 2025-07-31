#!/bin/bash

# 部署脚本
echo "开始部署 Project Sleepy..."

# 检查参数
if [ $# -eq 0 ]; then
    echo "使用方法: ./deploy.sh <服务器IP> [用户名] [端口]"
    echo "示例: ./deploy.sh 192.168.1.100 root 22"
    exit 1
fi

SERVER_IP=$1
USERNAME=${2:-root}
PORT=${3:-22}

echo "部署到服务器: $SERVER_IP"
echo "用户名: $USERNAME"
echo "端口: $PORT"

# 创建临时目录
TEMP_DIR=$(mktemp -d)
echo "创建临时目录: $TEMP_DIR"

# 复制项目文件到临时目录
cp -r project-sleepy/ "$TEMP_DIR/"
cp -r sleepy-helper/ "$TEMP_DIR/"

# 上传到服务器
echo "上传文件到服务器..."
scp -P $PORT -r "$TEMP_DIR"/* "$USERNAME@$SERVER_IP:/var/www/html/"

# 设置权限
echo "设置文件权限..."
ssh -p $PORT "$USERNAME@$SERVER_IP" "chown -R www-data:www-data /var/www/html && chmod -R 755 /var/www/html"

# 重启Web服务
echo "重启Web服务..."
ssh -p $PORT "$USERNAME@$SERVER_IP" "systemctl reload apache2"

# 清理临时目录
rm -rf "$TEMP_DIR"

echo "部署完成!"
echo "请确保在服务器上配置好 config.php 文件" 
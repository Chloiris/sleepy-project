#!/bin/bash

# 服务器部署脚本
echo "开始部署 Project Sleepy 到服务器..."

# 1. 更新系统
echo "更新系统包..."
sudo apt update && sudo apt upgrade -y

# 2. 安装必要软件
echo "安装必要软件..."
sudo apt install -y nginx php8.1-fpm php8.1-curl php8.1-json git certbot python3-certbot-nginx

# 3. 创建网站目录
echo "创建网站目录..."
sudo mkdir -p /var/www/html
cd /var/www/html

# 4. 清理旧文件
echo "清理旧文件..."
sudo rm -rf .* * 2>/dev/null || true

# 5. 克隆项目
echo "克隆项目..."
sudo git clone https://github.com/Chloiris/sleepy-project.git project-sleepy

# 6. 设置权限
echo "设置文件权限..."
sudo chown -R www-data:www-data /var/www/html/project-sleepy
sudo chmod -R 755 /var/www/html/project-sleepy

# 7. 配置Nginx
echo "配置Nginx..."
sudo tee /etc/nginx/sites-available/default > /dev/null <<EOF
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /var/www/html/project-sleepy;
    index index.php index.html index.htm;

    server_name _;

    location / {
        try_files \$uri \$uri/ =404;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.1-fpm.sock;
    }
}
EOF

# 8. 启用站点
echo "启用Nginx站点..."
sudo rm -f /etc/nginx/sites-enabled/*
sudo ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/

# 9. 测试Nginx配置
echo "测试Nginx配置..."
sudo nginx -t

# 10. 重启服务
echo "重启服务..."
sudo systemctl restart nginx
sudo systemctl restart php8.1-fpm

# 11. 配置SSL证书（如果有域名）
if [ ! -z "$1" ]; then
    echo "配置SSL证书..."
    sudo certbot --nginx -d $1 --non-interactive --agree-tos --email admin@example.com
fi

echo "部署完成！"
echo "网站地址: http://$(curl -s ifconfig.me)"
if [ ! -z "$1" ]; then
    echo "HTTPS地址: https://$1"
fi 
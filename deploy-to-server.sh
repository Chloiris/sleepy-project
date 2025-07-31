#!/bin/bash

echo "=== Project Sleepy 云服务器部署脚本 ==="
echo ""

# 获取服务器 IP
SERVER_IP=$(curl -s ifconfig.me)
echo "检测到服务器 IP: $SERVER_IP"
echo ""

# 更新系统
echo "更新系统包..."
sudo apt update && sudo apt upgrade -y

# 安装必要的软件
echo "安装必要的软件..."
sudo apt install -y python3 python3-pip python3-venv git curl wget nginx php-fpm php-curl php-json docker.io docker-compose

# 启动 Docker 服务
echo "启动 Docker 服务..."
sudo systemctl start docker
sudo systemctl enable docker

# 创建项目目录
echo "创建项目目录..."
mkdir -p ~/sleepy-project
cd ~/sleepy-project

# 下载项目文件（假设你已经上传到 GitHub）
echo "下载项目文件..."
# 如果你有 GitHub 仓库，取消下面的注释并修改 URL
# git clone https://github.com/你的用户名/你的仓库.git .

# 或者手动上传文件到服务器
echo "请手动上传项目文件到 ~/sleepy-project 目录"
echo "或者使用 scp 命令上传："
echo "scp -r project-sleepy/* user@$SERVER_IP:~/sleepy-project/"
echo "scp -r sleepy-helper user@$SERVER_IP:~/sleepy-project/"
echo ""

# 创建 Home Assistant 配置
echo "创建 Home Assistant 配置..."
mkdir -p ~/homeassistant
cd ~/homeassistant

cat > configuration.yaml << 'EOF'
# Home Assistant 基础配置
default_config:

# 启用 API
api:

# 启用前端
frontend:

# 启用历史记录
recorder:

# 启用自动化
automation:

# 启用脚本
script:

# 启用场景
scene:

# 启用输入帮助器
input_boolean:
  awake:
    name: "醒着状态"
    icon: mdi:eye
  private_mode:
    name: "隐私模式"
    icon: mdi:eye-off

input_text:
  my_windows:
    name: "当前窗口"
    icon: mdi:monitor
    max: 255
  message:
    name: "消息"
    icon: mdi:message-text
    max: 255

input_datetime:
  message_timer:
    name: "消息过期时间"
    has_date: true
    has_time: true

input_button:
  message_expire:
    name: "手动过期消息"
    icon: mdi:delete
EOF

# 创建 docker-compose.yml
cat > docker-compose.yml << 'EOF'
version: '3'
services:
  homeassistant:
    container_name: homeassistant
    image: "ghcr.io/home-assistant/home-assistant:stable"
    volumes:
      - ./configuration.yaml:/config/configuration.yaml:ro
      - ./config:/config
    restart: unless-stopped
    privileged: true
    network_mode: host
EOF

# 启动 Home Assistant
echo "启动 Home Assistant..."
docker-compose up -d

# 等待 Home Assistant 启动
echo "等待 Home Assistant 启动..."
sleep 30

# 部署网页
echo "部署网页..."
sudo mkdir -p /var/www/sleepy
sudo chown -R $USER:$USER /var/www/sleepy

# 复制项目文件
if [ -d "~/sleepy-project/project-sleepy" ]; then
    cp -r ~/sleepy-project/project-sleepy/* /var/www/sleepy/
else
    echo "请确保项目文件已上传到 ~/sleepy-project/project-sleepy/"
    exit 1
fi

# 设置权限
sudo chown -R www-data:www-data /var/www/sleepy
sudo chmod 755 /var/www/sleepy

# 创建 Nginx 配置
echo "配置 Nginx..."
sudo tee /etc/nginx/sites-available/sleepy << EOF
server {
    listen 80;
    server_name $SERVER_IP;
    root /var/www/sleepy;
    index index.html;

    location / {
        try_files \$uri \$uri/ =404;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.1-fpm.sock;
    }

    location ~ /\.ht {
        deny all;
    }
}
EOF

# 启用网站
sudo ln -sf /etc/nginx/sites-available/sleepy /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default

# 测试 Nginx 配置
sudo nginx -t

# 重启 Nginx
sudo systemctl restart nginx

# 安装 Python 依赖
echo "安装 Python 依赖..."
cd ~/sleepy-project/sleepy-helper/app-reporter/windows
pip3 install requests pygetwindow urllib3

# 创建配置文件模板
echo "创建配置文件..."
cat > config-template.py << 'EOF'
# config-template.py
# 复制此文件为 config.py 并修改以下配置

# 修改为你的服务器 IP 地址
HASS_URL = "http://SERVER_IP:8123/api/states/input_text.my_windows"
# 在 Home Assistant 控制台左下角用户面板底部生成长期访问令牌
HASS_TOKEN = "your_long_lived_access_token_here"
# 更新间隔（秒）
UPDATE_INTERVAL = 10
# 如果使用自签名证书，设置为 True
IGNORE_SSL_ERRORS = False
ATTRIBUTES = {
    "editable": "true",
    "min": 0,
    "max": 255,
    "pattern": "null",
    "mode": "text",
    "icon": "mdi:monitor",
    "friendly_name": "我的 Windows 设备",
}
EOF

# 替换 SERVER_IP
sed -i "s/SERVER_IP/$SERVER_IP/g" config-template.py

echo ""
echo "=== 部署完成 ==="
echo ""
echo "服务器信息："
echo "- 服务器 IP: $SERVER_IP"
echo "- Home Assistant: http://$SERVER_IP:8123"
echo "- 网页: http://$SERVER_IP"
echo ""
echo "下一步："
echo "1. 访问 http://$SERVER_IP:8123 完成 Home Assistant 初始设置"
echo "2. 在 Home Assistant 中创建长期访问令牌"
echo "3. 编辑 ~/sleepy-project/sleepy-helper/app-reporter/windows/config.py"
echo "4. 在本地电脑上运行 sleepy-helper 脚本"
echo ""
echo "本地配置："
echo "- 复制 config-template.py 为 config.py"
echo "- 填入你的长期访问令牌"
echo "- 运行: python sleepy-helper-windows.py" 
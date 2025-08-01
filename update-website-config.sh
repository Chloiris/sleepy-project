#!/bin/bash

echo "=== 更新网站配置文件 ==="

# 获取服务器IP
SERVER_IP=$(curl -s ifconfig.me)
echo "服务器IP: $SERVER_IP"

# 检查Home Assistant是否运行
if docker ps | grep -q homeassistant; then
    echo "✓ Home Assistant 正在运行"
else
    echo "❌ Home Assistant 未运行，请先启动Home Assistant"
    exit 1
fi

# 创建配置文件
echo "创建网站配置文件..."
sudo tee /var/www/html/sleepy-project/project-sleepy/states/config.php > /dev/null <<EOF
<?php
// Project Sleepy 配置文件
// 自动生成于 $(date)

// Home Assistant REST API 接入点
\$endpoint = "http://$SERVER_IP:8123/api";

// Home Assistant 域名 (需包含协议)
\$host = "http://$SERVER_IP:8123";

// 长期访问令牌 (需要在Home Assistant中生成)
\$token = "YOUR_LONG_LIVED_ACCESS_TOKEN_HERE";

// 缓存文件路径
\$cacheFile = __DIR__ . '/cache.json';

// 缓存过期时间 (秒)
\$cacheTTL = 30;

// 调试模式
\$debug = false;

// 允许的域名（CORS）
\$allowedOrigins = [
    "https://sleepy.chlogonia.top",
    "http://$SERVER_IP",
    "http://localhost"
];
?>
EOF

echo "✓ 配置文件已创建: /var/www/html/sleepy-project/project-sleepy/states/config.php"
echo ""
echo "下一步操作："
echo "1. 访问 http://$SERVER_IP:8123 完成Home Assistant初始设置"
echo "2. 在Home Assistant控制台左下角用户面板底部生成长期访问令牌"
echo "3. 编辑配置文件，将 YOUR_LONG_LIVED_ACCESS_TOKEN_HERE 替换为实际令牌"
echo "4. 重启网站服务: sudo systemctl restart nginx"
echo ""
echo "生成长期访问令牌的步骤："
echo "1. 登录Home Assistant"
echo "2. 点击左下角用户名"
echo "3. 滚动到底部，点击'长期访问令牌'"
echo "4. 点击'创建令牌'"
echo "5. 输入名称（如：Project Sleepy）"
echo "6. 复制生成的令牌"
echo "7. 更新配置文件中的\$token变量" 
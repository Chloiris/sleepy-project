#!/bin/bash

echo "=== 服务器状态检查 ==="

# 1. 检查系统状态
echo "1. 系统状态："
echo "   CPU使用率: $(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)%"
echo "   内存使用率: $(free | grep Mem | awk '{printf("%.1f", $3/$2 * 100.0)}')%"
echo "   磁盘使用率: $(df / | tail -1 | awk '{print $5}')"

# 2. 检查服务状态
echo ""
echo "2. 服务状态："
echo "   Nginx: $(systemctl is-active nginx)"
echo "   PHP-FPM: $(systemctl is-active php8.1-fpm)"
echo "   Docker: $(systemctl is-active docker)"

# 3. 检查端口状态
echo ""
echo "3. 端口状态："
echo "   80端口: $(ss -tlnp | grep :80 | wc -l) 个监听"
echo "   443端口: $(ss -tlnp | grep :443 | wc -l) 个监听"

# 4. 检查网站文件
echo ""
echo "4. 网站文件："
if [ -f "/var/www/html/project-sleepy/index.html" ]; then
    echo "   index.html: 存在"
    echo "   文件大小: $(ls -lh /var/www/html/project-sleepy/index.html | awk '{print $5}')"
else
    echo "   index.html: 不存在"
fi

# 5. 检查Nginx配置
echo ""
echo "5. Nginx配置："
if nginx -t 2>/dev/null; then
    echo "   配置语法: 正确"
else
    echo "   配置语法: 错误"
fi

# 6. 检查SSL证书
echo ""
echo "6. SSL证书："
if [ -f "/etc/letsencrypt/live/sleepy.chlogonia.top/fullchain.pem" ]; then
    echo "   SSL证书: 存在"
    echo "   过期时间: $(openssl x509 -in /etc/letsencrypt/live/sleepy.chlogonia.top/fullchain.pem -noout -enddate | cut -d= -f2)"
else
    echo "   SSL证书: 不存在"
fi

# 7. 测试网站访问
echo ""
echo "7. 网站访问测试："
echo "   HTTP响应: $(curl -s -o /dev/null -w "%{http_code}" http://localhost)"
echo "   HTTPS响应: $(curl -s -o /dev/null -w "%{http_code}" https://sleepy.chlogonia.top)"

# 8. 检查Docker容器
echo ""
echo "8. Docker容器："
if command -v docker &> /dev/null; then
    echo "   Docker已安装"
    echo "   运行中的容器: $(docker ps -q | wc -l) 个"
    echo "   所有容器: $(docker ps -a -q | wc -l) 个"
else
    echo "   Docker未安装"
fi

echo ""
echo "检查完成！" 
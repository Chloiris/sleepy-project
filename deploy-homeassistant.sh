#!/bin/bash

echo "=== Home Assistant 部署脚本 ==="
echo "开始部署 Home Assistant 和 ESPHome..."

# 1. 创建目录结构
echo "1. 创建目录结构..."
mkdir -p ~/homeassistant/{config,esphome,database,backups}
cd ~/homeassistant

# 2. 复制配置文件
echo "2. 复制配置文件..."
if [ -f "../homeassistant/configuration.yaml" ]; then
    cp ../homeassistant/configuration.yaml config/
    echo "   ✓ 配置文件已复制"
else
    echo "   ⚠ 配置文件不存在，将使用默认配置"
fi

# 3. 复制ESPHome配置
echo "3. 复制ESPHome配置..."
if [ -d "../sleepy-helper/esphome" ]; then
    cp -r ../sleepy-helper/esphome/* esphome/
    echo "   ✓ ESPHome配置已复制"
else
    echo "   ⚠ ESPHome配置不存在"
fi

# 4. 复制Docker Compose文件
echo "4. 复制Docker Compose文件..."
if [ -f "../homeassistant/docker-compose.yml" ]; then
    cp ../homeassistant/docker-compose.yml .
    echo "   ✓ Docker Compose文件已复制"
else
    echo "   ⚠ Docker Compose文件不存在"
fi

# 5. 设置权限
echo "5. 设置文件权限..."
sudo chown -R $USER:$USER ~/homeassistant
chmod -R 755 ~/homeassistant

# 6. 启动服务
echo "6. 启动Home Assistant服务..."
docker-compose up -d

# 7. 等待服务启动
echo "7. 等待服务启动..."
echo "   请等待30秒让服务完全启动..."
sleep 30

# 8. 检查服务状态
echo "8. 检查服务状态..."
docker-compose ps

# 9. 显示访问信息
echo ""
echo "=== 部署完成 ==="
echo ""
echo "访问地址："
echo "  Home Assistant: http://$(curl -s ifconfig.me):8123"
echo "  ESPHome: http://$(curl -s ifconfig.me):6052"
echo ""
echo "下一步操作："
echo "1. 访问 Home Assistant 完成初始设置"
echo "2. 创建长期访问令牌（在用户面板底部）"
echo "3. 配置ESP32设备"
echo "4. 更新网站配置文件"
echo ""
echo "常用命令："
echo "  查看日志: docker-compose logs -f homeassistant"
echo "  重启服务: docker-compose restart"
echo "  停止服务: docker-compose down"
echo "  更新服务: docker-compose pull && docker-compose up -d" 
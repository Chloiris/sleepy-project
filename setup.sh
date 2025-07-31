#!/bin/bash

echo "=== Project Sleepy + Sleepy Helper 快速设置 ==="
echo ""

# 检查 Python 依赖
echo "检查 Python 依赖..."
pip install requests pygetwindow urllib3

# 创建配置文件
echo ""
echo "创建配置文件..."

# Windows 配置
if [ ! -f "sleepy-helper/app-reporter/windows/config.py" ]; then
    cp sleepy-helper/app-reporter/windows/config-template.py sleepy-helper/app-reporter/windows/config.py
    echo "✅ 已创建 Windows 配置文件: sleepy-helper/app-reporter/windows/config.py"
    echo "   请编辑此文件并填入你的 Home Assistant 信息"
else
    echo "⚠️  Windows 配置文件已存在"
fi

# macOS 配置
if [ ! -f "sleepy-helper/app-reporter/macos/config.py" ]; then
    cp sleepy-helper/app-reporter/macos/config-example.py sleepy-helper/app-reporter/macos/config.py
    echo "✅ 已创建 macOS 配置文件: sleepy-helper/app-reporter/macos/config.py"
    echo "   请编辑此文件并填入你的 Home Assistant 信息"
else
    echo "⚠️  macOS 配置文件已存在"
fi

# PHP 配置
if [ ! -f "project-sleepy/states/config.php" ]; then
    cp project-sleepy/states/config-template.php project-sleepy/states/config.php
    echo "✅ 已创建 PHP 配置文件: project-sleepy/states/config.php"
    echo "   请编辑此文件并填入你的 Home Assistant 信息"
else
    echo "⚠️  PHP 配置文件已存在"
fi

echo ""
echo "=== 设置完成 ==="
echo ""
echo "下一步："
echo "1. 编辑配置文件，填入你的 Home Assistant 地址和令牌"
echo "2. 在 Home Assistant 中创建必要的 Helpers"
echo "3. 上传到服务器并启动服务"
echo ""
echo "详细说明请查看 DEPLOYMENT.md" 
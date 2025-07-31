# 快速部署指南

## 步骤 1：上传项目到服务器

### 方法一：使用 scp 命令
```bash
# 在你的本地电脑上运行
scp -r project-sleepy/* root@你的服务器IP:/tmp/
scp -r sleepy-helper root@你的服务器IP:/tmp/
```

### 方法二：使用 Git
```bash
# 在服务器上运行
cd ~
git clone https://github.com/你的用户名/你的仓库.git sleepy-project
```

## 步骤 2：在服务器上运行部署脚本

```bash
# 连接到服务器
ssh root@你的服务器IP

# 上传部署脚本
# 将 deploy-to-server.sh 上传到服务器

# 运行部署脚本
chmod +x deploy-to-server.sh
./deploy-to-server.sh
```

## 步骤 3：配置 Home Assistant

1. 访问 `http://你的服务器IP:8123`
2. 完成初始设置
3. 创建长期访问令牌

## 步骤 4：配置本地脚本

1. 编辑 `sleepy-helper/app-reporter/windows/config.py`
2. 填入服务器 IP 和访问令牌
3. 在本地电脑上运行脚本

## 步骤 5：测试功能

- 访问网页：`http://你的服务器IP`
- 测试窗口检测功能

## 故障排除

### 如果网页无法访问：
```bash
# 检查 Nginx 状态
sudo systemctl status nginx

# 检查 PHP 状态
sudo systemctl status php8.1-fpm

# 查看错误日志
sudo tail -f /var/log/nginx/error.log
```

### 如果 Home Assistant 无法访问：
```bash
# 检查 Docker 容器
docker ps

# 查看容器日志
docker logs homeassistant

# 重启容器
docker-compose restart
```

### 如果窗口检测不工作：
```bash
# 检查 Python 依赖
pip3 list | grep -E "(requests|pygetwindow|urllib3)"

# 测试网络连接
curl -X GET "http://你的服务器IP:8123/api/"
``` 
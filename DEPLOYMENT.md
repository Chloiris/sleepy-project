# Project Sleepy + Sleepy Helper 部署指南

## 项目概述

- **project-sleepy**: 前端网页，显示设备状态和消息
- **sleepy-helper**: Windows 设备端脚本，采集并上报设备信息

## 部署步骤

### 1. 在 Home Assistant 中创建必要的 Helpers

#### 必需的 Helpers：
- `input_text.my_windows` (Text Helper) - 存储当前窗口信息
- `input_text.message` (Text Helper) - 存储自定义消息
- `input_boolean.private_mode` (Boolean Helper) - 隐私模式开关
- `input_boolean.awake` (Boolean Helper) - 醒着状态
- `input_datetime.message_timer` (DateTime Helper) - 消息过期时间
- `input_button.message_expire` (Button Helper) - 手动过期消息

### 2. 获取 Home Assistant 长期访问令牌

1. 进入 Home Assistant 控制台
2. 点击左下角的用户面板
3. 滚动到底部，点击"长期访问令牌"
4. 创建新令牌并复制

### 3. 配置 sleepy-helper

#### Windows 版本：
1. 编辑 `sleepy-helper/app-reporter/windows/config.py`
2. 修改以下配置：
   ```python
   HASS_URL = "http://你的服务器IP:8123/api/states/input_text.my_windows"
   HASS_TOKEN = "your_long_lived_access_token"
   ```

#### 安装依赖：
```bash
pip install requests pygetwindow urllib3
```

#### 运行脚本：
```bash
# Windows
python sleepy-helper-windows.py
```

### 4. 配置 project-sleepy

1. 编辑 `project-sleepy/states/config.php`
2. 修改以下配置：
   ```php
   $endpoint = 'http://你的服务器IP:8123/api';
   $host = 'http://你的服务器IP:8123';
   $token = 'your_long_lived_access_token';
   ```

### 5. 服务器部署

#### 上传到服务器：
```bash
# 上传 project-sleepy 到网站根目录
scp -r project-sleepy/* user@server:/var/www/html/

# 上传 sleepy-helper 到服务器
scp -r sleepy-helper user@server:/home/user/
```

#### 设置权限：
```bash
chmod 755 /var/www/html/
chmod 644 /var/www/html/states/config.php
```

#### 启动设备端脚本：
```bash
# 在服务器上后台运行
nohup python3 /home/user/sleepy-helper/app-reporter/windows/sleepy-helper-windows.py &
```

### 6. 访问网页

部署完成后，访问：
```
http://你的服务器IP/
```

## 自动化配置

### 消息过期自动化：
```yaml
automation:
  - alias: "消息过期"
    trigger:
      platform: time
      at: !input_datetime.message_timer
    action:
      - service: input_text.set_value
        target:
          entity_id: input_text.message
        data:
          value: "EXPIRED"
```

### 按钮触发过期：
```yaml
automation:
  - alias: "手动过期消息"
    trigger:
      platform: state
      entity_id: input_button.message_expire
    action:
      - service: input_text.set_value
        target:
          entity_id: input_text.message
        data:
          value: "EXPIRED"
```

## 故障排除

1. **网页无法访问**：检查 PHP 配置和文件权限
2. **数据不更新**：检查 Home Assistant 令牌和网络连接
3. **窗口检测失败**：检查 Python 依赖是否正确安装

## 安全注意事项

1. 不要在代码中硬编码访问令牌
2. 使用 HTTPS 连接
3. 定期更新访问令牌
4. 限制服务器访问权限 
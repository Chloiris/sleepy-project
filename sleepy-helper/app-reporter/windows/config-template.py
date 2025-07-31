# config-template.py
# 复制此文件为 config.py 并修改以下配置

# 修改为你的 Home Assistant 地址
HASS_URL = "https://your-home-assistant.example.com/api/states/input_text.my_windows"
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
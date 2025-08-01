# ESP32 设备配置指南

## 硬件需求

### 必需组件
- ESP32开发板
- SSD1306 OLED显示屏 (128x64)
- AHT10温湿度传感器
- BMP280气压传感器
- 4个按钮
- 光敏电阻
- 面包板和连接线

### 可选组件
- 3D打印外壳
- 电源适配器
- 散热风扇

## 接线图

```
ESP32 引脚连接：

显示屏 (I2C):
- SDA -> GPIO21
- SCL -> GPIO22
- VCC -> 3.3V
- GND -> GND

传感器 (I2C):
- SDA -> GPIO33
- SCL -> GPIO32
- VCC -> 3.3V
- GND -> GND

按钮:
- 按钮1 -> GPIO16 (醒着状态切换)
- 按钮2 -> GPIO17 (隐私模式切换)
- 按钮3 -> GPIO18 (显示控制)
- 按钮4 -> GPIO19 (消息过期)

LED指示灯:
- GPIO2 -> LED (连接状态指示)

光敏电阻:
- GPIO27 -> 光敏电阻 (环境光检测)
```

## 软件配置

### 1. 安装ESPHome

1. 在Home Assistant中安装ESPHome插件
2. 或者使用Docker运行ESPHome

### 2. 配置设备

1. 在ESPHome中创建新设备
2. 选择ESP32开发板
3. 上传配置文件

### 3. 修改配置文件

编辑 `sleepy-helper-master.yaml` 文件：

```yaml
# 修改WiFi配置
wifi:
  ssid: "你的WiFi名称"
  password: "你的WiFi密码"

# 修改Home Assistant API密钥
api:
  encryption:
    key: "你的API密钥"

# 修改OTA密码
ota:
  - platform: esphome
    password: "你的OTA密码"

# 修改网站URL
http_request:
  - url: https://sleepy.chlogonia.top/states/statistics/
```

### 4. 编译和上传

1. 在ESPHome中点击"编译"
2. 编译成功后点击"上传"
3. 等待设备重启

## 功能说明

### 按钮功能
- **按钮1**: 切换醒着/睡觉状态
- **按钮2**: 切换隐私模式
- **按钮3**: 临时点亮显示屏
- **按钮4**: 双击过期消息

### 显示屏信息
- 连接状态
- 当前状态（醒着/睡觉）
- 隐私模式状态
- 网站访问统计
- 消息状态

### 传感器数据
- 室内温度
- 室内湿度
- 室内气压

## 故障排除

### 常见问题

1. **设备无法连接WiFi**
   - 检查WiFi名称和密码
   - 确保WiFi信号强度足够

2. **显示屏不显示**
   - 检查I2C连接
   - 确认显示屏地址 (0x3C)
   - 检查电源连接

3. **传感器数据异常**
   - 检查I2C连接
   - 确认传感器地址
   - 检查电源电压

4. **按钮无响应**
   - 检查按钮连接
   - 确认GPIO引脚配置
   - 检查上拉电阻

### 调试方法

1. **查看日志**
   ```bash
   docker-compose logs -f esphome
   ```

2. **串口调试**
   - 连接USB到电脑
   - 使用串口工具查看输出

3. **网络调试**
   - 检查设备IP地址
   - 测试网络连接

## 高级配置

### 自定义显示内容

修改 `lambda` 部分来自定义显示内容：

```yaml
lambda: |-
  it.printf(64, 16, id(Bold), TextAlign::CENTER, "自定义文本");
```

### 添加新传感器

在 `sensor:` 部分添加新传感器：

```yaml
sensor:
  - platform: your_sensor
    name: "传感器名称"
    # 其他配置
```

### 自定义自动化

在Home Assistant中添加自动化：

```yaml
automation:
  - alias: "自定义自动化"
    trigger:
      platform: state
      entity_id: input_boolean.awake
    action:
      - service: notify.mobile_app
        data:
          message: "状态已改变"
```

## 维护

### 定期更新
- 定期更新ESPHome固件
- 检查传感器校准
- 清洁设备外壳

### 备份配置
- 备份ESPHome配置文件
- 备份Home Assistant配置
- 定期备份数据库

### 监控状态
- 监控设备连接状态
- 检查传感器数据准确性
- 监控网络连接稳定性 
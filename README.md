# Project Sleepy + Sleepy Helper

一个基于 Home Assistant 的智能家居状态分享系统，让朋友知道你的当前状态（醒着/睡着）。

## 🚀 快速开始

### 1. 克隆项目
```bash
git clone https://github.com/你的用户名/project-sleepy.git
cd project-sleepy
```

### 2. 配置 Home Assistant
1. 复制配置文件模板：
   ```bash
   cp project-sleepy/states/config-template.php project-sleepy/states/config.php
   ```
2. 编辑 `project-sleepy/states/config.php`，填入你的 Home Assistant 信息

### 3. 部署到服务器
选择以下任一方式：

#### 方式一：使用部署脚本
```bash
./deploy.sh 你的服务器IP 用户名 端口
```

#### 方式二：使用 Docker
```bash
docker-compose up -d
```

#### 方式三：GitHub Actions 自动部署
1. 在 GitHub 仓库设置中添加 Secrets
2. 推送代码到 main 分支即可自动部署

## 📁 项目结构

```
├── project-sleepy/          # 主项目（Web界面）
│   ├── index.html          # 主页面
│   ├── assets/             # 静态资源
│   └── states/             # PHP后端
├── sleepy-helper/          # 扩展工具
│   ├── app-reporter/       # 前台程序报告器
│   ├── esphome/           # ESP32硬件配置
│   └── shortcuts/         # iOS快捷指令
├── .github/workflows/     # GitHub Actions
├── Dockerfile             # Docker配置
└── docker-compose.yml     # Docker Compose
```

## 🔧 配置说明

### Home Assistant 配置
- 需要创建以下 Helper：
  - `input_boolean.private_mode` (隐私模式开关)
  - `input_text.mars_state` (状态显示)
  - `input_text.message` (自定义消息)
  - `input_datetime.message_timer` (消息过期时间)

### 服务器要求
- PHP 7.4+
- Apache/Nginx
- 支持 cURL 扩展

## 📖 详细文档

- [Project Sleepy 详细说明](./project-sleepy/README.md)
- [Sleepy Helper 使用指南](./sleepy-helper/README.md)
- [部署指南](./DEPLOYMENT.md)
- [快速部署](./QUICK-DEPLOY.md)

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

## �� 许可证

MIT License 
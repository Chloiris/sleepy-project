# GitHub 上传步骤指南

## 步骤1: 创建GitHub仓库

1. 访问 [GitHub.com](https://github.com) 并登录
2. 点击右上角 `+` 号 → `New repository`
3. 填写仓库信息：
   - **Repository name**: `project-sleepy`
   - **Description**: `基于 Home Assistant 的智能家居状态分享系统`
   - **Visibility**: 选择 Public 或 Private
   - **不要勾选** "Add a README file"（我们已经有了）
4. 点击 `Create repository`

## 步骤2: 连接本地仓库

在PowerShell中执行以下命令（替换 `Chloiris` 为你的GitHub用户名）：

```bash
git remote add origin https://github.com/Chloiris/project-sleepy.git
git branch -M main
git push -u origin main
```

## 步骤3: 身份验证

### 方式一: 浏览器登录（推荐）
- 执行 `git push` 时会自动打开浏览器
- 在浏览器中登录你的GitHub账号
- 授权访问

### 方式二: 个人访问令牌
如果浏览器登录不工作，需要创建个人访问令牌：

1. 在GitHub页面点击右上角头像 → `Settings`
2. 左侧菜单选择 `Developer settings` → `Personal access tokens` → `Tokens (classic)`
3. 点击 `Generate new token` → `Generate new token (classic)`
4. 填写信息：
   - **Note**: `Project Sleepy Deploy`
   - **Expiration**: 选择合适的时间
   - **Scopes**: 勾选 `repo` 和 `workflow`
5. 点击 `Generate token`
6. **复制生成的令牌**（只显示一次！）
7. 在PowerShell中使用令牌作为密码

## 步骤4: 验证上传成功

1. 刷新你的GitHub仓库页面
2. 应该能看到所有文件都已上传
3. 检查 `.github/workflows/deploy.yml` 文件是否存在

## 步骤5: 设置GitHub Secrets（用于自动部署）

1. 在仓库页面点击 `Settings` → `Secrets and variables` → `Actions`
2. 点击 `New repository secret`
3. 添加以下Secrets：

| Secret名称 | 值 | 说明 |
|-----------|----|----|
| `HOST` | `你的服务器IP` | 服务器IP地址 |
| `USERNAME` | `root` | 服务器用户名 |
| `SSH_KEY` | SSH私钥内容 | 见下方SSH密钥生成 |
| `PORT` | `22` | SSH端口 |

## 生成SSH密钥（用于自动部署）

在PowerShell中执行：

```bash
# 生成SSH密钥
ssh-keygen -t rsa -b 4096 -C "你的邮箱@example.com"

# 查看公钥（添加到服务器）
cat ~/.ssh/id_rsa.pub

# 查看私钥（用于GitHub Secrets）
cat ~/.ssh/id_rsa
```

## 常见问题

### Q: 推送时提示权限错误
A: 确保已正确登录GitHub或使用个人访问令牌

### Q: 找不到 .ssh 目录
A: 在Windows中，SSH密钥通常存储在 `C:\Users\你的用户名\.ssh\`

### Q: 如何查看已上传的文件
A: 在GitHub仓库页面可以看到所有文件

## 完成后的下一步

1. 设置GitHub Secrets
2. 配置服务器
3. 测试自动部署

---

**注意**: 所有敏感配置文件（如 `config.php`）都不会被上传，这是正确的安全做法。 
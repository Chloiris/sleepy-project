<?php
// 配置文件模板
// 复制此文件为 config.php 并填入你的实际配置

// Home Assistant REST API 接入点
$endpoint = "https://your-home.example.net/api";

// Home Assistant 域名 (需包含协议)
$host = "https://your-home.example.net";

// 长期访问令牌 (在HA控制台左下角用户面板底部生成)
$token = "your_long_lived_access_token_here";

// 缓存文件路径
$cacheFile = __DIR__ . '/cache.json';

// 缓存过期时间 (秒)
$cacheTTL = 30;
?> 
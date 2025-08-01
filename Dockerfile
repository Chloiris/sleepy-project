FROM php:8.1-apache

# 安装系统依赖
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    pkg-config \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# 安装必要的PHP扩展
RUN docker-php-ext-install curl json

# 设置工作目录
WORKDIR /var/www/html

# 复制项目文件
COPY project-sleepy/ .

# 设置权限
RUN chown -R www-data:www-data /var/www/html
RUN chmod -R 755 /var/www/html

# 启用Apache重写模块
RUN a2enmod rewrite

# 配置Apache
COPY apache-config.conf /etc/apache2/sites-available/000-default.conf

# 暴露端口
EXPOSE 80

# 启动Apache
CMD ["apache2-foreground"] 
#!/bin/bash

source config.sh

echo "Database Host:$DB_HOST"
echo "Database Port: $DB_PORT"
echo "Database User: $DB_USER"
echo "Database Password: $DB_PASS"

echo "App Debug Mode: $APP_DEBUG"
echo "App Log Level: $APP_LOG_LEVEL"

if [ "$APP_DEBUG" = "true" ]; then
     echo "Debug mode is enabled."
else
     echo "Debug mode is disabled."
fi

chmod +x sh.sh

REPO_URL="https://github.com/GXUCPC/Gxucpc-system"
git clone $REPO_URL
.git tmp
mv tmp/.git ./
rmdir tmp
git reset --hard HEAD

echo "欢迎使用分支管理脚本"
echo "请输入以下命令来执行操作："
echo " 1: 创建并切换到新分支"
echo " 2: 切换到现有分支"
echo " 3: 列出所有分支"
echo " 4: 删除分支"
echo " 5: 退出"

read -p "请选择一个操作（1-5）: " option

case $option in
  1)
    read -p "请输入新分支的名称: " new_branch
    git checkout -b $new_branch
    ;;
  2)
    read -p "请输入要切换的分支名称: " branch_name
    if git rev-parse --verify $branch_name >/dev/null 2>&1; then
        git checkout $branch_name
    else
        echo "分支 $branch_name 不存在。"
    fi
    ;;
  3)
    git branch
    ;;
  4)
    read -p "请输入要删除的分支名称: " branch_name
    git branch -d $branch_name
    ;;
  5)
    echo "退出脚本。"
    exit 0
    ;;
  *)
    echo "无效的选项，请重新运行脚本。"
    exit 1
    ;;
esac


git clone https://github.com/GXUCPC/Gxucpc-system
cd repository

if [ -f "package.json" ]; then
    echo "检测到Node.js项目，正在安装npm依赖..."
    npm install
elif [ -f "requirements.txt" ]; then
    echo "检测到Python项目，正在安装pip依赖..."
    pip install -r requirements.txt
elif [ -f "Gemfile" ]; then
    echo "检测到Ruby项目，正在安装bundler依赖..."
    bundle install
elif [ -f "composer.json" ]; then
    echo "检测到PHP项目，正在安装Composer依赖..."
    composer install
else
    echo "未检测到支持的项目类型。"
fi
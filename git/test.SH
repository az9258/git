#!/bin/bash

chmod +x test.SH

REPO_URL="https://github.com/GXUCPC/Gxucpc-system"

if [ -d "Gxucpc-system" ]; then
    git pull
else
    git clone $REPO_URL
    echo "仓库 '$REPO_URL' 已克隆"
fi

git clone $REPO_URL
git pull
cd Gxucpc-system
Branch="GreeN"
git checkout $Branch
git status
git config --global color.ui auto
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

git clone $REPO_URL
git pull
cd Gxucpc-system
git checkout $Branch
mvn package -DskipTests=true
nohup java -jar  Gxucpc-system\target\Gxucpc-system-0.0.1-SNAPSHOT.jar  >> mylog.log &
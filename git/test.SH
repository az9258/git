#!/bin/bash

chmod +x test.SH

REPO_URL="https://github.com/GXUCPC/Gxucpc-system"

if [ -d "Gxucpc-system" ]; then
    git pull
else
    git clone $REPO_URL
    echo "仓库 '$REPO_URL' 已克隆"
fi

cd Gxucpc-system
Branch="GreeN"
git checkout $Branch
git status
mvn package -DskipTests=true
nohup java -jar  Gxucpc-system\target\Gxucpc-system-0.0.1-SNAPSHOT.jar  >> mylog.log &
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

REPO_URL="git@gitee.com:az9258/first.git"
git clone $REPO_URL

./sh.sh
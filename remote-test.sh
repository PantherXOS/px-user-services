#!/usr/bin/env sh

TARGET_PATH="/home/panther/projects/px-user-services"
SERVER_ADDRESS="panther@127.0.0.1"

ssh ${SERVER_ADDRESS} -p 2222 "mkdir -p ${TARGET_PATH}"


nodemon --exec "rsync -av -e 'ssh -p 2222' --exclude '.git' '.' \"$SERVER_ADDRESS:$TARGET_PATH/\"" -e scm,sh,desktop

#!/bin/sh

services=(
    cron
    px-accounts-service
    px-events-service
    px-secret-service
    px-settings-service
)

getpid() {
    pids=$(ps x | grep -v grep | grep "$1" | awk '{print $1}')
    echo $pids
}

killapp() {
    unset pids
    pids=$(getpid "$1")
    if [ "$pids" ]; then
        for pid in ${pids[@]}; do
            echo "killing $1: $pid"
            kill -9 $pid;
        done;
    fi
}

# Cleanup previous shepherd instance
killapp "shepherd"
socketpath="/run/user/${UID}/shepherd/socket";
if [ -a "${socketpath}" ]; then
    rm "${socketpath}";
fi

# Kill user's running services
for service in ${services[@]}; do
    killapp "$service";
done

# Fix cron jobs base directory
mkdir -p "$HOME/.config/cron"

#start shepherd
shepherd -c /etc/px/user-services.scm
# shepherd -c /home/panther/projects/px-user-services/etc/px/user-services.scm

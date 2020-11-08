#!/bin/sh

# get PID for provided application
getpid() {
    pids=$(ps x | grep -v grep | grep "$1" | awk '{print $1}')
    echo $pids
}

# kill child processes for provided PID
getchilds() {
    pids=$(ps x -f | grep "$1" | grep -v "grep" | awk '{print $2}' | grep -v "$1")
    echo $pids
}

# kill application by it's name
killapp() {
    unset pids
    pids=$(getpid "$1")
    if [ "$pids" ]; then
        for pid in ${pids[@]}; do
            echo "kill $1: $pid"
            kill -9 $pid;
        done;
    fi
}

# kill application and all of it's child processes
killtree() {
    parent_ids=$(getpid "$1")
    if [ "$parent_ids" ]; then
        for parent_id in ${parent_ids[@]}; do
            child_ids=$(getchilds $parent_id)
            if [ "$child_ids" ]; then
                for child_id in ${child_ids[@]}; do
                    echo " kill $child_id"
                    kill $child_id
                    if [ $? -ne 0 ]; then
                        kill -9 $child_id
                    fi
                done
            fi
            echo "kill -> $parent_id"
            kill -9 "$parent_id"
        done
    fi
}

# start shepherd as user-service
start() {
    killtree "shepherd"
    socket_path="/run/user/$UID/shepherd/socket"
    if [ -a ${socket_path} ]; then
        rm ${socket_path}
    fi

    profile_path="etc/px/services/init.scm"
    user_profile_path="$HOME/.guix-profile/$profile_path"
    system_profile_path="/run/current-system/profile/$profile_path"
    if [ -f "$user_profile_path" ]; then
        shepherd -c "$user_profile_path"
    elif [ -f "$system_profile_path" ]; then
        shepherd -c "$system_profile_path"
    fi
}

start

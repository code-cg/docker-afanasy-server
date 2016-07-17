#!/bin/bash

if [ "$1" = 'afserver' ]; then
    if [ "$2" = 'reset_all' ]; then
        echo "$2 mentioned"
        afcmd db_reset_all
    fi
    exec afserver "$@"
fi

exec "$@"

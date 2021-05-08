#!/usr/bin/bash

# https://github.com/microsoft/vscode-dev-containers/blob/e646d525e1e5ca5d872977905eb23424e36dd558/script-library/docs/desktop-lite.md
prefix=""
if [[ $(id -u) -ne 0 ]]; then
    prefix="sudo"
fi

if [[ -d "/usr/local/novnc" ]] && [[ $(ps -Af | grep /usr/local/novnc/noVNC*/utils/launch.sh | grep -v grep) == '' ]]; then
    $prefix bash -c "
        while :; do
            $prefix /usr/local/novnc/noVNC*/utils/launch.sh --listen ${NOVNC_PORT:-6080} --vnc localhost:${VNC_PORT:-5900};
        done 2>&1" > /dev/null &
fi

exec "$@"

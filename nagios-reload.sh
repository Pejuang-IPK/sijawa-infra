#!/usr/bin/env bash

# Script untuk reload Nagios ketika ada perubahan file config
# Gunakan: ./nagios-reload.sh

NAGIOS_CONTAINER="nagios_sijawa"
NAGIOS_CONFIG_PATH="/opt/nagios/etc"
WATCH_PATHS=("./nagios/nagios.cfg" "./nagios/commands.cfg" "./nagios/contacts.cfg" "./nagios/templates.cfg" "./nagios/servers/")

echo "Monitoring Nagios configuration files for changes..."
echo "Press Ctrl+C to stop"
echo ""

# Fungsi untuk reload Nagios
reload_nagios() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] Detecting configuration changes, reloading Nagios..."
    docker exec $NAGIOS_CONTAINER /opt/nagios/bin/nagios -v $NAGIOS_CONFIG_PATH/nagios.cfg
    if [ $? -eq 0 ]; then
        docker exec $NAGIOS_CONTAINER /usr/sbin/service nagios reload
        echo "[$(date +'%Y-%m-%d %H:%M:%S')] ✓ Nagios reloaded successfully!"
    else
        echo "[$(date +'%Y-%m-%d %H:%M:%S')] ✗ Configuration error detected. Fix and save again."
    fi
    echo ""
}

# Gunakan inotifywait jika tersedia
if command -v inotifywait &> /dev/null; then
    while true; do
        inotifywait -r -e modify,create,delete "${WATCH_PATHS[@]}" && reload_nagios
    done
else
    # Fallback: menggunakan stat untuk cek perubahan file (lebih lambat)
    echo "Warning: inotify-tools not found. Using slower polling method."
    echo "Install inotify-tools for better performance: sudo apt install inotify-tools"
    echo ""
    
    declare -A last_mod
    
    while true; do
        changed=0
        for path in "${WATCH_PATHS[@]}"; do
            if [ -e "$path" ]; then
                current_mod=$(stat -c %Y "$path" 2>/dev/null)
                if [ "${last_mod[$path]}" != "$current_mod" ]; then
                    last_mod[$path]=$current_mod
                    changed=1
                fi
            fi
        done
        
        if [ $changed -eq 1 ]; then
            reload_nagios
        fi
        
        sleep 2
    done
fi

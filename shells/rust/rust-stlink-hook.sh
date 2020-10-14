dev="$(lsusb | awk '/ST-LINK/ { gsub(":", ""); print $2 "/" $4; exit }')"
if [[ -n "$dev" ]]; then
    local path="/dev/bus/usb/$dev"
    if [[ ! -w "$path" ]]; then
        echo "ST-LINK found at $path, but no write permission granted"
        echo -n "run \`sudo chmod $USER $path\`? [y/N] "

        read -n 1 choice
        echo
        if [[ "$choice" = "y" ]]; then
            sudo chown "$USER" "$path"
        fi
    fi
else
    echo "warning: no ST-LINK found"
fi

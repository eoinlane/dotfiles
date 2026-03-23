#!/bin/sh
# Fetch Bing's daily wallpaper and set it as XFCE desktop background

WALLPAPER_DIR="$HOME/Pictures/wallpapers/bing"
mkdir -p "$WALLPAPER_DIR"

# Fetch today's image metadata from Bing
JSON=$(curl -s "https://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1&mkt=en-US")
if [ -z "$JSON" ]; then
    echo "Failed to fetch Bing wallpaper metadata" >&2
    exit 1
fi

# Extract the URL base
URLBASE=$(echo "$JSON" | sed -n 's/.*"urlbase":"\([^"]*\)".*/\1/p')
if [ -z "$URLBASE" ]; then
    echo "Failed to parse image URL" >&2
    exit 1
fi

# Download UHD version
TODAY=$(date +%Y-%m-%d)
FILENAME="${WALLPAPER_DIR}/bing-${TODAY}.jpg"
IMAGE_URL="https://www.bing.com${URLBASE}_UHD.jpg"

if [ ! -f "$FILENAME" ]; then
    curl -sL -o "$FILENAME" "$IMAGE_URL"
    if [ ! -s "$FILENAME" ]; then
        echo "Failed to download wallpaper" >&2
        rm -f "$FILENAME"
        exit 1
    fi
fi

# Update XFCE desktop config XML
CONFIG="$HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml"
if [ -f "$CONFIG" ]; then
    sed -i '' "s|value=\"/home/eoin/Pictures/wallpapers/[^\"]*\"|value=\"${FILENAME}\"|g" "$CONFIG"
fi

# Try to notify xfdesktop to reload (if session is active)
if [ -n "$DISPLAY" ]; then
    xfdesktop --quit 2>/dev/null
    sleep 1
    xfdesktop &
fi

# Clean up wallpapers older than 7 days
find "$WALLPAPER_DIR" -name "bing-*.jpg" -mtime +7 -delete 2>/dev/null

echo "Bing wallpaper set: $FILENAME"

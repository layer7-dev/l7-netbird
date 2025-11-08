#!/bin/bash
set -e

echo "🎨 l7 zero trust - Icon Generator"
echo "=================================="

# Farben für Output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Quell-Assets (relativ zum Script-Verzeichnis: branding/scripts/)
BLACK_ICON="../../l7-assets/layer7_managed_it_icon.png"
WHITE_ICON="../../l7-assets/layer7_managed_it_icon_white.png"
BLACK_LOGO="../../l7-assets/layer7_managed_it_black.png"
WHITE_LOGO="../../l7-assets/layer7_managed_it_white_retina.png"
OUTPUT_DIR="../../client/ui/assets"

# Prüfe ob ImageMagick installiert ist
if ! command -v convert &> /dev/null; then
    echo "❌ Error: ImageMagick is not installed."
    echo "   Please install it: sudo apt-get install imagemagick (Linux)"
    echo "                      brew install imagemagick (macOS)"
    exit 1
fi

# Prüfe ob Quell-Assets existieren
if [ ! -f "$BLACK_ICON" ]; then
    echo "❌ Error: Black icon not found at $BLACK_ICON"
    exit 1
fi

if [ ! -f "$WHITE_ICON" ]; then
    echo "❌ Error: White icon not found at $WHITE_ICON"
    exit 1
fi

echo -e "${BLUE}📦 Creating output directory...${NC}"
mkdir -p "$OUTPUT_DIR"
mkdir -p "../../branding/assets/generated"

# Funktion: Icon mit Statusindikator erstellen
create_status_icon() {
    local base_icon=$1
    local status=$2
    local output_name=$3
    local theme_suffix=$4  # "" oder "-dark"
    local size=${5:-128}
    
    local output_file="$OUTPUT_DIR/${output_name}${theme_suffix}.png"
    
    # Basis-Icon erstellen
    convert "$base_icon" -resize ${size}x${size} "$output_file"
    
    # Status-Indikator hinzufügen (kleiner farbiger Punkt)
    case $status in
        "connected")
            # Grüner Punkt (layer7 grün)
            convert "$output_file" \
                -fill "#a0cf4f" \
                -draw "circle $((size-15)),$((size-15)) $((size-15)),$((size-25))" \
                "$output_file"
            ;;
        "disconnected")
            # Grauer/Schwarzer Punkt
            convert "$output_file" \
                -fill "#666666" \
                -draw "circle $((size-15)),$((size-15)) $((size-15)),$((size-25))" \
                "$output_file"
            ;;
        "connecting")
            # Orange Punkt (Warnung/In Progress)
            convert "$output_file" \
                -fill "#ff8c00" \
                -draw "circle $((size-15)),$((size-15)) $((size-15)),$((size-25))" \
                "$output_file"
            ;;
        "error")
            # Roter Punkt
            convert "$output_file" \
                -fill "#ff0000" \
                -draw "circle $((size-15)),$((size-15)) $((size-15)),$((size-25))" \
                "$output_file"
            ;;
        "update")
            # Blauer Punkt (Update verfügbar)
            convert "$output_file" \
                -fill "#0066cc" \
                -draw "circle $((size-15)),$((size-15)) $((size-15)),$((size-25))" \
                "$output_file"
            ;;
    esac
    
    echo -e "${GREEN}  ✓${NC} Created: ${output_name}${theme_suffix}.png"
}

# Basis-Icons kopieren (ohne Status-Indikator)
echo -e "\n${BLUE}📋 Creating base icons...${NC}"
convert "$BLACK_ICON" -resize 128x128 "$OUTPUT_DIR/netbird.png"
convert "$BLACK_ICON" -resize 256x256 "$OUTPUT_DIR/l7-icon.png"
convert "$BLACK_LOGO" -resize 512x512 "../../docs/media/logo.png"
convert "$BLACK_LOGO" -resize 256x256 "../../docs/media/logo-full.png"
echo -e "${GREEN}  ✓${NC} Base icons created"

# Dot Icons für Menü
echo -e "\n${BLUE}🔵 Creating menu dot icons...${NC}"
convert "$BLACK_ICON" -resize 16x16 "$OUTPUT_DIR/connected.png"
convert "$BLACK_ICON" -resize 16x16 -colorize 50,50,50 "$OUTPUT_DIR/disconnected.png"
echo -e "${GREEN}  ✓${NC} Menu dots created"

# Light Mode Icons (Schwarz) generieren
echo -e "\n${BLUE}☀️  Generating Light Mode icons (black base)...${NC}"
create_status_icon "$BLACK_ICON" "connected" "netbird-systemtray-connected" ""
create_status_icon "$BLACK_ICON" "disconnected" "netbird-systemtray-disconnected" ""
create_status_icon "$BLACK_ICON" "connecting" "netbird-systemtray-connecting" ""
create_status_icon "$BLACK_ICON" "error" "netbird-systemtray-error" ""
create_status_icon "$BLACK_ICON" "update" "netbird-systemtray-update-connected" ""
create_status_icon "$BLACK_ICON" "update" "netbird-systemtray-update-disconnected" ""

# Dark Mode Icons (Weiß) generieren
echo -e "\n${BLUE}🌙 Generating Dark Mode icons (white base)...${NC}"
create_status_icon "$WHITE_ICON" "connected" "netbird-systemtray-connected" "-dark"
create_status_icon "$WHITE_ICON" "disconnected" "netbird-systemtray-disconnected" "-dark"
create_status_icon "$WHITE_ICON" "connecting" "netbird-systemtray-connecting" "-dark"
create_status_icon "$WHITE_ICON" "error" "netbird-systemtray-error" "-dark"
create_status_icon "$WHITE_ICON" "update" "netbird-systemtray-update-connected" "-dark"
create_status_icon "$WHITE_ICON" "update" "netbird-systemtray-update-disconnected" "-dark"

# macOS Template-Icons (nutzen schwarze Version für Template-Mode)
echo -e "\n${BLUE}🍎 Generating macOS template icons...${NC}"
create_status_icon "$BLACK_ICON" "connected" "netbird-systemtray-connected" "-macos"
create_status_icon "$BLACK_ICON" "disconnected" "netbird-systemtray-disconnected" "-macos"
create_status_icon "$BLACK_ICON" "connecting" "netbird-systemtray-connecting" "-macos"
create_status_icon "$BLACK_ICON" "error" "netbird-systemtray-error" "-macos"
create_status_icon "$WHITE_ICON" "update" "netbird-systemtray-update-connected" "-macos"
create_status_icon "$WHITE_ICON" "update" "netbird-systemtray-update-disconnected" "-macos"

# Windows .ico Dateien erstellen (mehrere Größen kombiniert)
echo -e "\n${BLUE}🪟 Generating Windows .ico files...${NC}"
if command -v icotool &> /dev/null; then
    for size in 16 32 48 64 128 256; do
        convert "$BLACK_ICON" -resize ${size}x${size} "/tmp/l7-icon-${size}.png"
    done
    icotool -c -o "$OUTPUT_DIR/netbird.ico" /tmp/l7-icon-*.png
    rm /tmp/l7-icon-*.png
    echo -e "${GREEN}  ✓${NC} Windows .ico created"
else
    echo -e "  ⚠️  icotool not found, skipping .ico creation"
    echo "     Install with: sudo apt-get install icoutils"
fi

# Summary
echo -e "\n${GREEN}✅ l7 zero trust icon generation complete!${NC}"
echo ""
echo "Generated icons:"
echo "  • Light Mode: Black icons with status indicators"
echo "  • Dark Mode: White icons with status indicators"
echo "  • macOS: Template-compatible icons"
echo "  • Windows: Multi-resolution .ico file"
echo ""
echo "Location: $OUTPUT_DIR"
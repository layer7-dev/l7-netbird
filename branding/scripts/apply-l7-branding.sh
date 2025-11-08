#!/bin/bash
set -e

echo "🎨 Applying l7 zero trust Branding"
echo "===================================="

# Farben für Output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Arbeitsverzeichnis (Projekt-Root)
PROJECT_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$PROJECT_ROOT"

echo -e "${BLUE}📍 Working directory: $PROJECT_ROOT${NC}"

# 1. Icons generieren
echo -e "\n${BLUE}🎨 Step 1: Generating l7 icons...${NC}"
if [ -f "branding/scripts/generate-l7-icons.sh" ]; then
    chmod +x branding/scripts/generate-l7-icons.sh
    bash branding/scripts/generate-l7-icons.sh
else
    echo -e "${YELLOW}⚠️  Icon generator script not found, skipping...${NC}"
fi

# 2. Code-Anpassungen
echo -e "\n${BLUE}✏️  Step 2: Updating code references...${NC}"

# App-ID ändern
echo -e "  • Updating App ID..."
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS (BSD sed)
    sed -i '' 's/app\.NewWithID("NetBird")/app.NewWithID("l7zerotrust")/g' client/ui/client_ui.go
    sed -i '' 's/NetBird/l7 zero trust/g' client/ui/client_ui.go
else
    # Linux (GNU sed)
    sed -i 's/app\.NewWithID("NetBird")/app.NewWithID("l7zerotrust")/g' client/ui/client_ui.go
    sed -i 's/NetBird/l7 zero trust/g' client/ui/client_ui.go
fi
echo -e "${GREEN}    ✓${NC} App ID updated to 'l7zerotrust'"

# GoReleaser Konfiguration
echo -e "  • Updating GoReleaser config..."
if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' 's/project_name: netbird-ui/project_name: l7-zerotrust-ui/g' .goreleaser_ui.yaml
    sed -i '' 's/netbird-ui/l7-zerotrust-ui/g' .goreleaser_ui.yaml
    sed -i '' 's/Netbird/l7 zero trust/g' .goreleaser_ui.yaml
else
    sed -i 's/project_name: netbird-ui/project_name: l7-zerotrust-ui/g' .goreleaser_ui.yaml
    sed -i 's/netbird-ui/l7-zerotrust-ui/g' .goreleaser_ui.yaml
    sed -i 's/Netbird/l7 zero trust/g' .goreleaser_ui.yaml
fi
echo -e "${GREEN}    ✓${NC} GoReleaser config updated"

# Update-Kanal ändern
echo -e "  • Updating update channel..."
if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' 's/version\.NewUpdate("nb\/client-ui")/version.NewUpdate("l7\/zerotrust-ui")/g' client/ui/client_ui.go
else
    sed -i 's/version\.NewUpdate("nb\/client-ui")/version.NewUpdate("l7\/zerotrust-ui")/g' client/ui/client_ui.go
fi
echo -e "${GREEN}    ✓${NC} Update channel set to 'l7/zerotrust-ui'"

# 3. Maintainer-Informationen
echo -e "\n${BLUE}📝 Step 3: Updating maintainer information...${NC}"
if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' 's/Netbird <dev@netbird.io>/layer7 managed it <dev@layer7.de>/g' .goreleaser_ui.yaml
    sed -i '' 's/netbird.io/layer7.de/g' .goreleaser_ui.yaml
else
    sed -i 's/Netbird <dev@netbird.io>/layer7 managed it <dev@layer7.de>/g' .goreleaser_ui.yaml
    sed -i 's/netbird.io/layer7.de/g' .goreleaser_ui.yaml
fi
echo -e "${GREEN}  ✓${NC} Maintainer info updated"

# 4. Desktop-Dateien aktualisieren (Linux)
echo -e "\n${BLUE}🐧 Step 4: Updating Linux desktop files...${NC}"
if [ -f "client/ui/build/netbird.desktop" ]; then
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' 's/Name=NetBird/Name=l7 zero trust/g' client/ui/build/netbird.desktop
        sed -i '' 's/Comment=NetBird/Comment=l7 zero trust/g' client/ui/build/netbird.desktop
    else
        sed -i 's/Name=NetBird/Name=l7 zero trust/g' client/ui/build/netbird.desktop
        sed -i 's/Comment=NetBird/Comment=l7 zero trust/g' client/ui/build/netbird.desktop
    fi
    echo -e "${GREEN}  ✓${NC} Desktop file updated"
else
    echo -e "${YELLOW}  ⚠️  Desktop file not found${NC}"
fi

# 5. Version info (Windows)
echo -e "\n${BLUE}🪟 Step 5: Updating Windows version info...${NC}"
if [ -f "versioninfo.json" ]; then
    # JSON erfordert spezielle Behandlung, verwenden wir jq wenn verfügbar
    if command -v jq &> /dev/null; then
        jq '.StringFileInfo.ProductName = "l7 zero trust" | 
            .StringFileInfo.CompanyName = "layer7 managed it" |
            .StringFileInfo.LegalCopyright = "© 2025 layer7 managed it"' \
            versioninfo.json > versioninfo.json.tmp
        mv versioninfo.json.tmp versioninfo.json
        echo -e "${GREEN}  ✓${NC} Version info updated (using jq)"
    else
        echo -e "${YELLOW}  ⚠️  jq not found, skipping JSON update${NC}"
        echo -e "     Install jq for automatic version info updates"
    fi
else
    echo -e "${YELLOW}  ⚠️  versioninfo.json not found${NC}"
fi

# 6. Branding-Validierung
echo -e "\n${BLUE}🔍 Step 6: Validating branding changes...${NC}"
errors=0

# Prüfe ob Icons existieren
if [ ! -f "client/ui/assets/netbird.png" ]; then
    echo -e "${YELLOW}  ⚠️  Warning: Main icon not found${NC}"
    ((errors++))
fi

# Prüfe ob App-ID geändert wurde
if grep -q 'app.NewWithID("NetBird")' client/ui/client_ui.go; then
    echo -e "${YELLOW}  ⚠️  Warning: Old App ID still present${NC}"
    ((errors++))
fi

if [ $errors -eq 0 ]; then
    echo -e "${GREEN}  ✓${NC} All validation checks passed"
else
    echo -e "${YELLOW}  ⚠️  $errors warning(s) found${NC}"
fi

# Summary
echo -e "\n${GREEN}✅ l7 zero trust branding applied successfully!${NC}"
echo ""
echo "Changes made:"
echo "  • App ID: l7zerotrust"
echo "  • Product Name: l7 zero trust"
echo "  • Update Channel: l7/zerotrust-ui"
echo "  • Maintainer: layer7 managed it"
echo "  • Icons: Generated in client/ui/assets/"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo "  1. Review changes: git status"
echo "  2. Test build: cd client/ui && go build"
echo "  3. Commit changes: git add -A && git commit -m 'Apply l7 branding'"
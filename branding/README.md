# l7 zero trust - Custom Netbird Branding

Dies ist die vollständige Dokumentation für das l7 zero trust Custom Branding basierend auf Netbird.

## 📋 Übersicht

Dieses Projekt enthält alle notwendigen Scripts und Konfigurationen, um Netbird mit layer7 Branding zu versehen und automatisch mit der neuesten Netbird-Version synchron zu halten.

### Branding-Spezifikationen

- **Produktname**: l7 zero trust (immer kleingeschrieben)
- **Firma**: layer7 managed it (immer kleingeschrieben)
- **Primärfarbe**: #a0cf4f (layer7 grün)
- **App-ID**: l7zerotrust
- **Update-Kanal**: l7/zerotrust-ui

### Theme-Aware Icons

- **Light Mode**: Schwarze Icons (`layer7_managed_it_icon.png`)
- **Dark Mode**: Weiße Icons (`layer7_managed_it_icon_white.png`)
- **Web-GUI**: Weißes Logo (`layer7_managed_it_white_retina.png`)

## 🚀 Schnellstart

### Voraussetzungen

**Erforderlich:**
- Git
- Go 1.23+
- ImageMagick (`convert` command)
- Bash shell

**Optional (für vollständige Funktionalität):**
- `icoutils` (für Windows .ico Dateien)
- `jq` (für JSON-Verarbeitung)

**Installation der Abhängigkeiten:**

```bash
# Ubuntu/Debian
sudo apt-get install imagemagick icoutils jq

# macOS
brew install imagemagick jq

# Windows (mit Chocolatey)
choco install imagemagick jq
```

### Branding anwenden

```bash
# 1. In Projekt-Root wechseln
cd /path/to/l7-netbird-1

# 2. Branding-Script ausführbar machen
chmod +x branding/scripts/apply-l7-branding.sh
chmod +x branding/scripts/generate-l7-icons.sh

# 3. Branding anwenden
./branding/scripts/apply-l7-branding.sh
```

Dies führt automatisch aus:
- ✅ Icon-Generierung (schwarz/weiß)
- ✅ Code-Anpassungen (App-ID, Namen, etc.)
- ✅ GoReleaser-Konfiguration
- ✅ Maintainer-Informationen
- ✅ Update-Kanal

### Build erstellen

```bash
# UI lokal bauen
cd client/ui
go build -o l7-zerotrust-ui

# Mit GoReleaser (alle Plattformen)
goreleaser release --config .goreleaser_ui.yaml --snapshot --clean
```

## 📁 Verzeichnisstruktur

```
branding/
├── README.md                      # Diese Datei
├── l7-branding-config.yaml       # Branding-Konfiguration
├── assets/                        # Generierte Assets
│   └── generated/                # Icon-Varianten
└── scripts/
    ├── apply-l7-branding.sh      # Haupt-Branding-Script
    └── generate-l7-icons.sh      # Icon-Generator

l7-assets/                         # Quell-Assets
├── layer7_managed_it_black.png
├── layer7_managed_it_icon.png
├── layer7_managed_it_icon_white.png
└── layer7_managed_it_white_retina.png

.github/workflows/
├── l7-sync-upstream.yml          # Wöchentliche Upstream-Sync
└── l7-build-ui.yml               # Multi-Platform Builds
```

## 🔄 Automatische Updates

### Upstream Synchronisation

Das System synchronisiert automatisch jeden **Montag um 1:00 Uhr UTC** mit dem offiziellen Netbird-Repository.

**Workflow:**
1. Änderungen von `netbirdio/netbird` holen
2. Upstream-Branch mergen
3. l7 Branding automatisch anwenden
4. Änderungen committen und pushen

**Manueller Sync:**
```bash
# Via GitHub Actions UI
# Oder lokal:
git fetch upstream
git merge upstream/main
./branding/scripts/apply-l7-branding.sh
git add -A
git commit -m "🎨 Sync with upstream and apply l7 branding"
git push
```

### Konflikt-Behandlung

Bei Merge-Konflikten:
1. GitHub erstellt automatisch ein Issue
2. Manuelle Auflösung erforderlich:
   ```bash
   git fetch upstream
   git merge upstream/main
   # Konflikte auflösen
   ./branding/scripts/apply-l7-branding.sh
   git add -A
   git commit -m "Resolve merge conflicts and apply branding"
   git push
   ```

## 🏗️ Build-Pipeline

### GitHub Actions Workflows

**1. Upstream Sync (`.github/workflows/l7-sync-upstream.yml`)**
- Trigger: Wöchentlich (Montag 1:00 UTC) oder manuell
- Funktion: Netbird-Updates holen und Branding anwenden

**2. UI Build (`.github/workflows/l7-build-ui.yml`)**
- Trigger: Push, PR, Release, oder manuell
- Plattformen: Linux, Windows, macOS
- Output: l7-zerotrust-ui Binaries

### Lokale Builds

**Entwicklungs-Build:**
```bash
cd client/ui
go build -o l7-zerotrust-ui
```

**Release-Build (alle Plattformen):**
```bash
goreleaser release --config .goreleaser_ui.yaml --snapshot --clean
```

**Spezifische Plattform:**
```bash
# Linux
GOOS=linux GOARCH=amd64 go build -o l7-zerotrust-ui

# Windows
GOOS=windows GOARCH=amd64 go build -o l7-zerotrust-ui.exe

# macOS
GOOS=darwin GOARCH=arm64 go build -o l7-zerotrust-ui
```

## 🎨 Icon-Generierung

### Icons manuell generieren

```bash
cd branding/scripts
./generate-l7-icons.sh
```

### Generierte Icons

Das Script erstellt folgende Icon-Varianten:

**Light Mode (Schwarz):**
- `netbird-systemtray-connected.png`
- `netbird-systemtray-disconnected.png`
- `netbird-systemtray-connecting.png`
- `netbird-systemtray-error.png`
- `netbird-systemtray-update-*.png`

**Dark Mode (Weiß):**
- `netbird-systemtray-*-dark.png`

**macOS Template:**
- `netbird-systemtray-*-macos.png`

**Basis-Icons:**
- `netbird.png` - Haupt-Icon
- `netbird.ico` - Windows Icon
- `connected.png` / `disconnected.png` - Menü-Dots

## 🔧 Konfiguration

### Branding-Parameter anpassen

Bearbeiten Sie [`l7-branding-config.yaml`](l7-branding-config.yaml):

```yaml
branding:
  product_name: "l7 zero trust"
  company_name: "layer7 managed it"
  app_id: "l7zerotrust"

colors:
  primary: "#a0cf4f"

update_server:
  url: "https://updates.layer7.de"
  channel: "l7/zerotrust-ui"
```

### Code-Anpassungen

**Wichtige Dateien:**
- `client/ui/client_ui.go` - App-ID, Produktname
- `.goreleaser_ui.yaml` - Build-Konfiguration
- `versioninfo.json` - Windows Metadaten

## 🌐 Web-Dashboard Branding

### Dashboard-Repository

```bash
# Dashboard-Fork erstellen
git clone https://github.com/netbirdio/dashboard.git l7-dashboard
cd l7-dashboard

# Branding anwenden
# 1. Logo ersetzen
cp ../l7-assets/layer7_managed_it_white_retina.png public/logo.png
cp ../l7-assets/layer7_managed_it_icon_white.png public/favicon.png

# 2. CSS-Variablen (in src/styles/variables.css)
:root {
  --primary-color: #a0cf4f;
  --primary-hover: #8fb644;
}

# 3. Alle "Netbird" → "l7 zero trust" ersetzen
find src -type f -exec sed -i 's/NetBird/l7 zero trust/g' {} +
```

## 📦 Distribution

### Package-Formate

**Linux:**
- `.deb` (Debian/Ubuntu)
- `.rpm` (RedHat/Fedora/CentOS)
- `.tar.gz` (Generic)

**Windows:**
- `.exe` (Installer)
- `.zip` (Portable)

**macOS:**
- `.dmg` (Application Bundle)
- Universal Binary (Intel + Apple Silicon)

### Installation

**Linux (DEB):**
```bash
sudo dpkg -i l7-zerotrust-ui_*_amd64.deb
```

**Windows:**
```powershell
.\l7-zerotrust-ui-installer.exe
```

**macOS:**
```bash
# DMG mounten und App nach /Applications ziehen
open l7-zerotrust-ui.dmg
```

## 🧪 Testing

### Manual Testing Checklist

- [ ] App startet mit korrektem Namen "l7 zero trust"
- [ ] Icons wechseln bei Theme-Change (Hell/Dunkel)
- [ ] Systray zeigt l7-Icons
- [ ] Connected-Status zeigt grünen Punkt (#a0cf4f)
- [ ] Über-Dialog zeigt "l7 zero trust"
- [ ] Update-Mechanismus prüft korrekten Kanal

### Automatisierte Tests

```bash
# Unit Tests
cd client/ui
go test ./...

# Build-Test
go build -o test-binary
./test-binary --version
```

## 🔐 Sicherheit

### Update-Signierung

Für Produktions-Deployments sollten Updates signiert werden:

```bash
# GPG-Key für Signaturen
gpg --gen-key

# In GoReleaser konfigurieren
signs:
  - artifacts: checksum
    signature: "${artifact}.sig"
```

## 📚 Weitere Ressourcen

### Dokumentation
- [Netbird Dokumentation](https://docs.netbird.io/)
- [GoReleaser Docs](https://goreleaser.com/)
- [Fyne UI Framework](https://fyne.io/)

### Support
- Issues: GitHub Issues Tracker
- Team: build@layer7.de

## 🎓 Häufige Probleme

### Icons werden nicht angezeigt
```bash
# Icons neu generieren
cd branding/scripts
./generate-l7-icons.sh

# Prüfen ob Icons existieren
ls -la ../../client/ui/assets/netbird*.png
```

### Branding nicht vollständig angewendet
```bash
# Branding-Script erneut ausführen
./branding/scripts/apply-l7-branding.sh

# Änderungen prüfen
git diff client/ui/client_ui.go
```

### Build-Fehler auf Windows
```powershell
# Go Modules cache löschen
go clean -modcache
go mod download

# Neu builden
go build -v
```

## 📝 Changelog

### Version 1.0.0 (2025-01-06)
- ✨ Initiales l7 zero trust Branding
- 🎨 Theme-aware Icons (schwarz/weiß)
- 🤖 Automatische Upstream-Synchronisation
- 🏗️ Multi-Platform Build-Pipeline
- 📚 Umfassende Dokumentation

---

**Entwickelt von layer7 managed it**
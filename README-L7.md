# l7 zero trust

**Custom Netbird Distribution mit layer7 Branding**

[![Build Status](https://github.com/layer7/l7-netbird/workflows/Build%20l7%20zero%20trust%20UI/badge.svg)](https://github.com/layer7/l7-netbird/actions)
[![Sync Status](https://github.com/layer7/l7-netbird/workflows/Sync%20with%20Upstream%20Netbird/badge.svg)](https://github.com/layer7/l7-netbird/actions)

---

## 🎯 Über l7 zero trust

l7 zero trust ist eine gebrandete Version von [Netbird](https://netbird.io), angepasst für layer7 managed it. Es kombiniert die leistungsstarke Zero-Trust-Netzwerk-Lösung von Netbird mit dem professionellen Branding und den spezifischen Anforderungen von layer7.

### Was ist l7 zero trust?

- **Basis**: Netbird - Open Source Zero Trust VPN
- **Branding**: layer7 managed it Design und Farben
- **Updates**: Automatische Synchronisation mit offizieller Netbird-Version
- **Wartung**: Wöchentliche Updates der neuesten Netbird-Features
- **Support**: layer7 managed it Team

## ✨ Features

### Von Netbird geerbt

- ✅ WireGuard-basiertes VPN
- ✅ Peer-to-Peer Verbindungen
- ✅ Zero-Trust Architektur
- ✅ Management Web-Dashboard
- ✅ Multi-Plattform Support (Windows, macOS, Linux)
- ✅ NAT-Traversal
- ✅ Access Control & Policies

### layer7 Anpassungen

- 🎨 layer7 Branding (Logo, Icons, Farben)
- 🌓 Theme-aware Icons (automatischer Hell/Dunkel-Modus)
- 🔄 Automatische Upstream-Updates
- 📦 Custom Build-Pipeline
- 🏢 layer7 Support & Wartung

## 🚀 Schnellstart

### Installation

**Windows:**
```powershell
# Download latest release
Invoke-WebRequest -Uri "https://releases.layer7.de/l7-zerotrust/latest/windows/l7-zerotrust-ui.exe" -OutFile "l7-zerotrust-ui.exe"
.\l7-zerotrust-ui.exe
```

**macOS:**
```bash
# Download and install
curl -L https://releases.layer7.de/l7-zerotrust/latest/darwin/l7-zerotrust-ui.dmg -o l7-zerotrust-ui.dmg
open l7-zerotrust-ui.dmg
```

**Linux (Ubuntu/Debian):**
```bash
# Add repository
echo "deb [trusted=yes] https://pkgs.layer7.de/debian stable main" | sudo tee /etc/apt/sources.list.d/l7-zerotrust.list

# Install
sudo apt update
sudo apt install l7-zerotrust-ui
```

### Erste Schritte

1. **App starten**: Nach der Installation startet l7 zero trust im System-Tray
2. **Anmelden**: Klicken Sie auf das l7-Icon und wählen Sie "Connect"
3. **Authentifizieren**: Folgen Sie dem SSO-Login-Prozess
4. **Verbinden**: l7 zero trust verbindet sich automatisch mit Ihrem Netzwerk

## 🛠️ Für Entwickler

### Voraussetzungen

```bash
# Go 1.23+
go version

# ImageMagick für Icon-Generierung
convert --version

# Git
git --version
```

### Repository klonen

```bash
git clone https://github.com/layer7/l7-netbird.git
cd l7-netbird
```

### Branding anwenden

```bash
# Branding-Scripts ausführbar machen
chmod +x branding/scripts/*.sh

# Branding anwenden
./branding/scripts/apply-l7-branding.sh
```

### Lokaler Build

```bash
# Desktop UI bauen
cd client/ui
go build -o l7-zerotrust-ui

# Testen
./l7-zerotrust-ui
```

### Vollständige Dokumentation

Siehe [branding/README.md](branding/README.md) für:
- 📋 Detaillierte Build-Anleitung
- 🎨 Icon-Generierung
- 🔄 Upstream-Synchronisation
- 🚀 Deployment-Strategien
- 🧪 Testing-Prozesse

## 🔄 Update-Strategie

### Automatische Upstream-Synchronisation

l7 zero trust synchronisiert automatisch mit dem offiziellen Netbird-Repository:

- **Zeitplan**: Jeden Montag um 1:00 UTC
- **Prozess**: 
  1. Netbird-Updates abrufen
  2. Änderungen mergen
  3. layer7 Branding anwenden
  4. Testen und deployen
- **Konflikt-Handling**: Automatische Issue-Erstellung bei Problemen

### Manuelle Updates

```bash
# Upstream-Remote hinzufügen
git remote add upstream https://github.com/netbirdio/netbird.git

# Updates holen
git fetch upstream
git merge upstream/main

# Branding neu anwenden
./branding/scripts/apply-l7-branding.sh

# Pushen
git push origin main
```

## 📊 Architektur

```
┌─────────────────────────────────────────────────┐
│         l7 zero trust Client (Desktop UI)       │
│    (Fyne Framework, Go, WireGuard)              │
└───────────────┬─────────────────────────────────┘
                │
                ├─→ Management Server
                │   (Go, gRPC, REST API)
                │
                ├─→ Signal Server
                │   (WebRTC ICE negotiation)
                │
                └─→ TURN/STUN Server
                    (Coturn, NAT traversal)
```

### Komponenten

1. **Desktop Client** (`client/ui/`)
   - Fyne-basierte GUI
   - System-Tray Integration
   - Theme-aware Icons
   - Auto-Updates

2. **Management Server** (`management/`)
   - Peer-Verwaltung
   - Access Control
   - REST API
   - Web-Dashboard Backend

3. **Signal Server** (`signal/`)
   - WebRTC Signaling
   - Peer Discovery
   - NAT-Traversal Koordination

4. **Web-Dashboard** (separates Repo)
   - React-basiert
   - Admin-Interface
   - Peer-Management
   - Policy-Konfiguration

## 🎨 Branding-Details

### Farben

- **Primär**: #a0cf4f (layer7 grün)
- **Hover**: #8fb644
- **Active**: #7ea039

### Schriftarten & Namen

- **Produkt**: l7 zero trust (immer kleingeschrieben)
- **Firma**: layer7 managed it (immer kleingeschrieben)

### Icons

- **Light Mode**: Schwarze Icons
- **Dark Mode**: Weiße Icons
- **Automatisch**: Wechsel bei Theme-Änderung

## 📦 Verfügbare Packages

### Desktop Clients

| Plattform | Format | Download |
|-----------|--------|----------|
| Windows | `.exe`, `.zip` | [Latest Release](https://releases.layer7.de/l7-zerotrust/latest/windows/) |
| macOS | `.dmg`, Universal Binary | [Latest Release](https://releases.layer7.de/l7-zerotrust/latest/darwin/) |
| Linux | `.deb`, `.rpm`, `.tar.gz` | [Latest Release](https://releases.layer7.de/l7-zerotrust/latest/linux/) |

### Server Components

Alle Server-Komponenten sind als Docker-Images verfügbar:

```bash
# Management Server
docker pull registry.layer7.de/l7-zerotrust/management:latest

# Signal Server
docker pull registry.layer7.de/l7-zerotrust/signal:latest

# Dashboard
docker pull registry.layer7.de/l7-zerotrust/dashboard:latest
```

## 🤝 Beitragen

### Bug Reports

Bitte erstellen Sie Issues für:
- 🐛 Bugs und Fehler
- 💡 Feature-Requests
- 📝 Dokumentations-Verbesserungen

### Pull Requests

1. Fork das Repository
2. Erstellen Sie einen Feature-Branch
3. Implementieren Sie Ihre Änderungen
4. Stellen Sie sicher, dass Branding intakt bleibt
5. Erstellen Sie einen Pull Request

**Wichtig**: Alle Änderungen müssen das layer7 Branding beibehalten!

## 📄 Lizenz

Dieses Projekt basiert auf [Netbird](https://github.com/netbirdio/netbird):

- **Client Code** (`client/`): BSD-3-Clause Lizenz
- **Management/Signal** (`management/`, `signal/`): AGPLv3 Lizenz
- **layer7 Branding**: Proprietär (layer7 managed it)

Siehe [LICENSE](LICENSE) für Details.

## 🔗 Links

- **layer7 Website**: https://layer7.de
- **Upstream Netbird**: https://netbird.io
- **Dokumentation**: [branding/README.md](branding/README.md)
- **Issue Tracker**: https://github.com/layer7/l7-netbird/issues

## 📞 Support

### Für Endbenutzer

- **E-Mail**: support@layer7.de
- **Telefon**: +49 (0) 123 456789
- **Portal**: https://support.layer7.de

### Für Entwickler

- **E-Mail**: dev@layer7.de
- **GitHub Issues**: https://github.com/layer7/l7-netbird/issues
- **Build-Team**: build@layer7.de

## 🙏 Danksagungen

Besonderer Dank an:
- **Netbird Team** für die exzellente Open-Source VPN-Lösung
- **WireGuard** für das sichere VPN-Protokoll
- **Fyne** für das cross-platform UI Framework
- **Pion** für die WebRTC-Implementation

---

**Entwickelt mit ❤️ von layer7 managed it**

*Basierend auf Netbird - Bringing Zero Trust to any network.*
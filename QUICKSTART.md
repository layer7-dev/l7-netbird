# l7 zero trust - Quickstart Guide

Schnelleinstieg in 5 Minuten.

## 🚀 Für Endbenutzer

### Windows

1. **Download**
   ```powershell
   # Aktuellste Version herunterladen
   # Von: https://releases.layer7.de/l7-zerotrust/latest
   ```

2. **Installation**
   - Doppelklick auf `l7-zerotrust-ui-installer.exe`
   - Installation durchführen
   - l7 zero trust startet automatisch im System-Tray

3. **Verbinden**
   - Klick auf l7-Icon im System-Tray
   - "Connect" wählen
   - Im Browser anmelden
   - Fertig! ✅

### macOS

1. **Download & Installation**
   ```bash
   # Download
   curl -L https://releases.layer7.de/l7-zerotrust/latest/darwin/l7-zerotrust-ui.dmg -o l7-zerotrust.dmg
   
   # Installation
   open l7-zerotrust.dmg
   # App nach /Applications ziehen
   ```

2. **Starten**
   - l7 zero trust aus Applications öffnen
   - Bei Bedarf in Systemeinstellungen > Sicherheit erlauben

3. **Verbinden**
   - Klick auf l7-Icon in Menüleiste
   - "Connect"
   - Anmelden
   - Done! ✅

### Linux (Ubuntu/Debian)

1. **Installation**
   ```bash
   # Repository hinzufügen
   echo "deb [trusted=yes] https://pkgs.layer7.de/debian stable main" | \
     sudo tee /etc/apt/sources.list.d/l7-zerotrust.list
   
   # Installieren
   sudo apt update
   sudo apt install l7-zerotrust-ui
   ```

2. **Starten**
   ```bash
   # Automatisch gestartet, oder manuell:
   l7-zerotrust-ui &
   ```

3. **Verbinden**
   - Klick auf l7-Icon im System-Tray
   - "Connect"
   - Browser-Login
   - Fertig! ✅

## 🛠️ Für Administratoren

### Self-Hosted Deployment (Docker)

```bash
# 1. Repository klonen
git clone https://github.com/layer7/l7-netbird.git
cd l7-netbird

# 2. Environment konfigurieren
cp .env.l7.example .env
nano .env  # Anpassen: Domain, Auth, Passwörter

# 3. Starten
docker-compose -f docker-compose.l7.yml up -d

# 4. Logs prüfen
docker-compose -f docker-compose.l7.yml logs -f

# 5. Zugriff
open https://zerotrust.ihre-domain.de
```

**Mindest-Konfiguration in `.env`:**
```bash
L7_DOMAIN=zerotrust.ihre-domain.de
L7_ADMIN_EMAIL=admin@ihre-domain.de
L7_OIDC_ENDPOINT=https://ihre-auth/.well-known/openid-configuration
L7_AUTH_CLIENT_ID=ihr-client-id
L7_AUTH_CLIENT_SECRET=ihr-secret
L7_DB_PASSWORD=$(openssl rand -base64 32)
L7_SECRET_KEY=$(openssl rand -hex 32)
```

Ausführliche Anleitung: [DEPLOYMENT.md](DEPLOYMENT.md)

## 💻 Für Entwickler

### Lokaler Build

```bash
# 1. Repository klonen
git clone https://github.com/layer7/l7-netbird.git
cd l7-netbird

# 2. Branding anwenden
chmod +x branding/scripts/apply-l7-branding.sh
./branding/scripts/apply-l7-branding.sh

# 3. UI bauen
cd client/ui
go build -o l7-zerotrust-ui

# 4. Testen
./l7-zerotrust-ui
```

### Mit GoReleaser (alle Plattformen)

```bash
# 1. Dependencies installieren
# Linux:
sudo apt install gcc libgl1-mesa-dev xorg-dev imagemagick

# macOS:
brew install imagemagick

# 2. Build
goreleaser release --config .goreleaser_ui.yaml --snapshot --clean

# 3. Binaries finden
ls -la dist/
```

Vollständige Dokumentation: [branding/README.md](branding/README.md)

## 📚 Weitere Ressourcen

| Was | Wo |
|-----|-----|
| **Vollständige Dokumentation** | [README-L7.md](README-L7.md) |
| **Deployment Guide** | [DEPLOYMENT.md](DEPLOYMENT.md) |
| **Branding & Development** | [branding/README.md](branding/README.md) |
| **Support** | support@layer7.de |
| **Issues** | GitHub Issues |

## 🆘 Probleme?

### Client verbindet nicht
```bash
# 1. Status prüfen
# Klick auf l7-Icon → "Status"

# 2. Neu verbinden
# Klick auf "Disconnect" → "Connect"

# 3. Debug-Bundle erstellen
# Settings → "Create Debug Bundle"
# → An support@layer7.de senden
```

### Dashboard nicht erreichbar
```bash
# DNS prüfen
nslookup zerotrust.ihre-domain.de

# Service-Status
docker-compose -f docker-compose.l7.yml ps

# Logs
docker-compose -f docker-compose.l7.yml logs dashboard
```

### Login schlägt fehl
```bash
# OIDC Endpoint testen
curl https://ihre-auth/.well-known/openid-configuration

# Client-ID/Secret prüfen
# In .env und bei Auth-Provider

# Browser-Cache löschen
# Inkognito-Modus testen
```

---

**Weitere Hilfe**: [DEPLOYMENT.md](DEPLOYMENT.md#troubleshooting) oder support@layer7.de
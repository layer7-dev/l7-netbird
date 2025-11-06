# l7 zero trust - Deployment Guide

Kompletter Leitfaden für das Deployment von l7 zero trust (Self-Hosted).

## 📋 Inhaltsverzeichnis

- [Voraussetzungen](#voraussetzungen)
- [Schnellstart](#schnellstart)
- [Detailliertes Setup](#detailliertes-setup)
- [Konfiguration](#konfiguration)
- [SSL/TLS Setup](#ssltls-setup)
- [Authentifizierung](#authentifizierung)
- [Backup & Restore](#backup--restore)
- [Monitoring](#monitoring)
- [Troubleshooting](#troubleshooting)

## Voraussetzungen

### Hardware

**Minimum:**
- CPU: 2 Cores
- RAM: 4 GB
- Disk: 20 GB SSD

**Empfohlen:**
- CPU: 4 Cores
- RAM: 8 GB
- Disk: 50 GB SSD
- Netzwerk: 100 Mbit/s

### Software

- Linux Server (Ubuntu 22.04 LTS empfohlen)
- Docker 24.0+
- Docker Compose 2.20+
- Domain mit DNS-Zugriff
- Firewall-Konfiguration

### Ports

Folgende Ports müssen erreichbar sein:

| Port | Protokoll | Service | Beschreibung |
|------|-----------|---------|--------------|
| 80 | TCP | HTTP | Dashboard (redirects zu HTTPS) |
| 443 | TCP | HTTPS | Dashboard (Web UI) |
| 33073 | TCP | gRPC | Management API |
| 10000 | TCP | gRPC | Signal Server |
| 3478 | UDP/TCP | STUN/TURN | NAT-Traversal |
| 49152-65535 | UDP | TURN | Relay Ports |

## Schnellstart

### 1. Repository klonen

```bash
git clone https://github.com/layer7/l7-netbird.git
cd l7-netbird
```

### 2. Environment konfigurieren

```bash
# .env Datei erstellen
cp .env.l7.example .env

# Wichtige Werte anpassen
nano .env
```

**Mindestens anpassen:**
```bash
L7_DOMAIN=zerotrust.ihre-domain.de
L7_ADMIN_EMAIL=admin@ihre-domain.de
L7_OIDC_ENDPOINT=https://ihre-auth-provider/.well-known/openid-configuration
L7_AUTH_CLIENT_ID=ihr-client-id
L7_AUTH_CLIENT_SECRET=ihr-client-secret
L7_DB_PASSWORD=sicheres-passwort
L7_SECRET_KEY=$(openssl rand -hex 32)
```

### 3. Deployment starten

```bash
# Stack starten
docker-compose -f docker-compose.l7.yml up -d

# Logs prüfen
docker-compose -f docker-compose.l7.yml logs -f
```

### 4. Zugriff testen

```bash
# Dashboard öffnen
open https://zerotrust.ihre-domain.de

# Health Check
curl https://zerotrust.ihre-domain.de/api/health
```

## Detailliertes Setup

### Schritt 1: Server vorbereiten

```bash
# System aktualisieren
sudo apt update && sudo apt upgrade -y

# Docker installieren
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Docker Compose installieren
sudo apt install docker-compose-plugin

# User zu docker-Gruppe hinzufügen
sudo usermod -aG docker $USER
newgrp docker

# Firewall konfigurieren (UFW)
sudo ufw allow 22/tcp      # SSH
sudo ufw allow 80/tcp      # HTTP
sudo ufw allow 443/tcp     # HTTPS
sudo ufw allow 33073/tcp   # Management gRPC
sudo ufw allow 10000/tcp   # Signal
sudo ufw allow 3478/udp    # STUN
sudo ufw allow 3478/tcp    # TURN
sudo ufw allow 49152:65535/udp  # TURN relay
sudo ufw enable
```

### Schritt 2: DNS konfigurieren

Erstellen Sie folgende DNS-Einträge:

```dns
# A Records
zerotrust.layer7.de.        IN  A     <SERVER-IP>
api.zerotrust.layer7.de.    IN  A     <SERVER-IP>
signal.zerotrust.layer7.de. IN  A     <SERVER-IP>
turn.zerotrust.layer7.de.   IN  A     <SERVER-IP>

# Optional: IPv6
zerotrust.layer7.de.        IN  AAAA  <SERVER-IPv6>
```

### Schritt 3: SSL-Zertifikate

#### Option A: Let's Encrypt (Automatisch)

Die Docker Compose Konfiguration verwendet Traefik mit Let's Encrypt:

```yaml
# In docker-compose.l7.yml ist bereits konfiguriert
# Stellen Sie sicher dass:
L7_DOMAIN=zerotrust.layer7.de
L7_ADMIN_EMAIL=admin@layer7.de
```

#### Option B: Eigene Zertifikate

```bash
# Zertifikate ablegen
mkdir -p /etc/l7-zerotrust/ssl
cp ihre-domain.crt /etc/l7-zerotrust/ssl/
cp ihre-domain.key /etc/l7-zerotrust/ssl/

# In docker-compose.l7.yml anpassen:
volumes:
  - /etc/l7-zerotrust/ssl:/etc/ssl/certs:ro

# In .env setzen:
L7_SSL_CERT_PATH=/etc/ssl/certs/ihre-domain.crt
L7_SSL_KEY_PATH=/etc/ssl/certs/ihre-domain.key
```

### Schritt 4: Authentifizierung konfigurieren

#### Mit Authentik

```bash
# In Authentik:
# 1. Application erstellen: "l7 zero trust"
# 2. Provider: OAuth2/OpenID
# 3. Redirect URIs: https://zerotrust.layer7.de/auth/callback

# In .env:
L7_OIDC_ENDPOINT=https://auth.layer7.de/application/o/l7-zerotrust/.well-known/openid-configuration
L7_AUTH_CLIENT_ID=<aus Authentik>
L7_AUTH_CLIENT_SECRET=<aus Authentik>
L7_AUTH_AUDIENCE=l7-zerotrust-api
```

#### Mit Keycloak

```bash
# In Keycloak:
# 1. Realm erstellen oder existierenden verwenden
# 2. Client erstellen: "l7-zerotrust"
# 3. Client Protocol: openid-connect
# 4. Valid Redirect URIs: https://zerotrust.layer7.de/*

# In .env:
L7_OIDC_ENDPOINT=https://keycloak.layer7.de/realms/layer7/.well-known/openid-configuration
L7_AUTH_CLIENT_ID=l7-zerotrust
L7_AUTH_CLIENT_SECRET=<aus Keycloak>
```

#### Mit Zitadel

```bash
# In Zitadel:
# 1. Projekt erstellen
# 2. Application erstellen: Type "Web"
# 3. Redirect URIs konfigurieren

# In .env:
L7_OIDC_ENDPOINT=https://zitadel.layer7.de/.well-known/openid-configuration
L7_AUTH_CLIENT_ID=<Project ID>@<Project Name>
L7_AUTH_CLIENT_SECRET=<aus Zitadel>
```

## Konfiguration

### Management Server konfigurieren

Erstellen Sie `management-config.json`:

```json
{
  "Stuns": [
    {
      "Proto": "udp",
      "URI": "stun:turn.zerotrust.layer7.de:3478"
    }
  ],
  "TURNConfig": {
    "Turns": [
      {
        "Proto": "udp",
        "URI": "turn:turn.zerotrust.layer7.de:3478",
        "Username": "self",
        "Password": null
      }
    ],
    "CredentialsTTL": "12h",
    "Secret": "changeme-turn-secret",
    "TimeBasedCredentials": true
  },
  "Signal": {
    "Proto": "http",
    "URI": "signal.zerotrust.layer7.de:10000",
    "Username": "",
    "Password": null
  },
  "Datadir": "/var/lib/netbird",
  "HttpConfig": {
    "Address": "0.0.0.0:33074",
    "AuthAudience": "l7-zerotrust-api",
    "AuthIssuer": "https://auth.layer7.de",
    "OIDCConfigEndpoint": "https://auth.layer7.de/.well-known/openid-configuration"
  },
  "IdpManagerConfig": {
    "ManagerType": "none"
  }
}
```

### TURN Server konfigurieren

Erstellen Sie `coturn.conf`:

```conf
# TURN Server Konfiguration für l7 zero trust
listening-port=3478
fingerprint
lt-cred-mech
use-auth-secret
static-auth-secret=changeme-turn-secret
realm=layer7.de
total-quota=100
bps-capacity=0
stale-nonce=600
cert=/etc/ssl/certs/turn.crt
pkey=/etc/ssl/private/turn.key
cipher-list="ECDHE-RSA-AES256-GCM-SHA512:DHE-RSA-AES256-GCM-SHA512"
no-sslv3
no-tlsv1
no-tlsv1_1
dh2066
no-stdout-log
log-file=/var/log/coturn.log
verbose
```

## Backup & Restore

### Backup erstellen

```bash
#!/bin/bash
# backup-l7.sh

BACKUP_DIR="/backup/l7-zerotrust"
DATE=$(date +%Y%m%d_%H%M%S)

# Volumes sichern
docker run --rm \
  -v l7_management_data:/data \
  -v $BACKUP_DIR:/backup \
  alpine tar czf /backup/management-$DATE.tar.gz /data

docker run --rm \
  -v l7_postgres_data:/data \
  -v $BACKUP_DIR:/backup \
  alpine tar czf /backup/postgres-$DATE.tar.gz /data

# Konfiguration sichern
tar czf $BACKUP_DIR/config-$DATE.tar.gz \
  .env \
  docker-compose.l7.yml \
  management-config.json \
  coturn.conf

echo "Backup erstellt: $BACKUP_DIR/*-$DATE.tar.gz"
```

### Restore durchführen

```bash
#!/bin/bash
# restore-l7.sh

BACKUP_FILE=$1

# Services stoppen
docker-compose -f docker-compose.l7.yml down

# Daten wiederherstellen
docker run --rm \
  -v l7_management_data:/data \
  -v $(dirname $BACKUP_FILE):/backup \
  alpine sh -c "cd /data && tar xzf /backup/$(basename $BACKUP_FILE)"

# Services starten
docker-compose -f docker-compose.l7.yml up -d
```

## Monitoring

### Prometheus konfigurieren

```yaml
# prometheus.yml
scrape_configs:
  - job_name: 'l7-management'
    static_configs:
      - targets: ['management:9090']
        labels:
          service: 'management'
          
  - job_name: 'l7-signal'
    static_configs:
      - targets: ['signal:9091']
        labels:
          service: 'signal'
```

### Grafana Dashboard

```bash
# Grafana hinzufügen
docker-compose -f docker-compose.l7.yml \
  -f docker-compose.monitoring.yml up -d

# Dashboard importieren
# ID: 15588 (Netbird Dashboard)
```

## Troubleshooting

### Logs anzeigen

```bash
# Alle Services
docker-compose -f docker-compose.l7.yml logs -f

# Spezifischer Service
docker-compose -f docker-compose.l7.yml logs -f management
```

### Häufige Probleme

#### 1. Dashboard nicht erreichbar

```bash
# Ports prüfen
docker ps
netstat -tlnp | grep -E '(80|443)'

# SSL-Zertifikat prüfen
openssl s_client -connect zerotrust.layer7.de:443
```

#### 2. Clients können sich nicht verbinden

```bash
# TURN Server testen
turnutils_uclient -v -u test -w test turn.zerotrust.layer7.de

# Firewall prüfen
sudo ufw status verbose
```

#### 3. Authentifizierung schlägt fehl

```bash
# OIDC Endpoint testen
curl https://auth.layer7.de/.well-known/openid-configuration

# Management Logs prüfen
docker-compose -f docker-compose.l7.yml logs management | grep -i auth
```

### Debug-Modus aktivieren

```bash
# In .env:
L7_LOG_LEVEL=debug
L7_DEBUG=true

# Services neu starten
docker-compose -f docker-compose.l7.yml restart
```

## Wartung

### Updates installieren

```bash
# Images aktualisieren
docker-compose -f docker-compose.l7.yml pull

# Services neu starten
docker-compose -f docker-compose.l7.yml up -d

# Alte Images entfernen
docker image prune -a
```

### Datenbank-Wartung

```bash
# PostgreSQL Vacuum
docker-compose -f docker-compose.l7.yml exec postgres \
  psql -U l7admin -d l7_zerotrust -c "VACUUM ANALYZE;"

# Größe prüfen
docker-compose -f docker-compose.l7.yml exec postgres \
  psql -U l7admin -d l7_zerotrust -c "\l+"
```

## Hochverfügbarkeit

Für Production-Umgebungen:

1. **Load Balancer** für Management/Signal
2. **Replicated Database** (PostgreSQL HA)
3. **Distributed TURN** Server
4. **Monitoring & Alerting**
5. **Automatische Backups**

Siehe [HA-SETUP.md](HA-SETUP.md) für Details.

---

**Support**: support@layer7.de
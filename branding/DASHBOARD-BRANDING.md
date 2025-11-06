# l7 zero trust - Web-Dashboard Branding Guide

Spezifische Anleitung für das Branding des Netbird Web-Dashboards.

## 🎨 Branding-Regel

**WICHTIG**: Nur die Netbird-Orange Farbe wird durch l7 Grün ersetzt!

- ❌ **NICHT** alle Farben ändern
- ❌ **NICHT** das gesamte Design umgestalten
- ✅ **NUR** Orange → Grün (#a0cf4f)
- ✅ Logo austauschen (weißes l7-Logo)
- ✅ Favicon austauschen (weißes l7-Icon)
- ✅ Produktname ändern (NetBird → l7 zero trust)

**Alle anderen Farben und Styles bleiben original Netbird!**

## 📋 Schritt-für-Schritt Anleitung

### 1. Dashboard-Repository klonen

```bash
# Netbird Dashboard forken/klonen
git clone https://github.com/netbirdio/dashboard.git l7-dashboard
cd l7-dashboard
```

### 2. Farben anpassen (NUR Orange → Grün!)

Die Netbird-Orange Farbe ist in verschiedenen Dateien definiert:

#### In Tailwind/CSS Konfiguration

**Datei finden:**
```bash
# Suche nach Orange-Farben
grep -r "#FF7A00" .
grep -r "orange" . --include="*.css" --include="*.tsx" --include="*.ts"
```

**Typische Dateien:**
- `tailwind.config.js` oder `tailwind.config.ts`
- `src/index.css` oder `src/styles/globals.css`
- `src/components/**/*.tsx` (in className Attributen)

**Ersetzen:**
```bash
# VORSICHT: Nur Netbird-Orange ersetzen, nicht alle orange Farben!
# Netbird Orange: #FF7A00 oder #ff7a00
# l7 Grün: #a0cf4f

# Hex-Werte ersetzen
find src -type f \( -name "*.tsx" -o -name "*.ts" -o -name "*.css" \) \
  -exec sed -i 's/#FF7A00/#a0cf4f/ig' {} +
  
find src -type f \( -name "*.tsx" -o -name "*.ts" -o -name "*.css" \) \
  -exec sed -i 's/#ff7a00/#a0cf4f/ig' {} +
```

#### In Tailwind Config

**Beispiel `tailwind.config.js`:**
```javascript
// VORHER
module.exports = {
  theme: {
    extend: {
      colors: {
        primary: {
          DEFAULT: '#FF7A00',  // ← Netbird Orange
          hover: '#E66D00',
          // ...
        }
      }
    }
  }
}

// NACHHER
module.exports = {
  theme: {
    extend: {
      colors: {
        primary: {
          DEFAULT: '#a0cf4f',  // ← l7 Grün
          hover: '#8fb644',    // ← l7 Grün (dunkler)
          // ...
        }
      }
    }
  }
}
```

### 3. Logo und Icons austauschen

```bash
# l7-Assets ins Dashboard kopieren
# Weißes Logo für Dashboard
cp ../l7-assets/layer7_managed_it_white_retina.png public/logo.png
cp ../l7-assets/layer7_managed_it_white_retina.png src/assets/logo.png

# Weißes Icon als Favicon
cp ../l7-assets/layer7_managed_it_icon_white.png public/favicon.png
cp ../l7-assets/layer7_managed_it_icon_white.png public/favicon.ico
```

### 4. Produktname ändern

```bash
# "NetBird" → "l7 zero trust" ersetzen
# Aber VORSICHTIG - nicht in Code-Kommentaren oder technischen Bezeichnern!

# In Titel und UI-Texten
find src -type f \( -name "*.tsx" -o -name "*.ts" \) \
  -exec sed -i 's/NetBird/l7 zero trust/g' {} +

# Meta-Tags in index.html
sed -i 's/<title>NetBird<\/title>/<title>l7 zero trust<\/title>/' public/index.html
sed -i 's/content="NetBird"/content="l7 zero trust"/' public/index.html
```

### 5. Validierung

**Prüfen Sie folgende Dateien manuell:**

```bash
# 1. Tailwind Config
cat tailwind.config.js | grep -i "primary\|orange"

# 2. CSS Dateien
grep -r "#a0cf4f" src/

# 3. Logo-Referenzen
grep -r "logo.png" src/

# 4. Produktname
grep -r "l7 zero trust" src/ | head -20
```

### 6. Build testen

```bash
# Dependencies installieren
npm install

# Development-Server starten
npm run dev

# Im Browser öffnen
open http://localhost:3000
```

**Was zu prüfen:**
- ✅ Logo zeigt l7 (weiß)
- ✅ Primärfarbe ist Grün (#a0cf4f)
- ✅ Buttons sind grün (nicht orange)
- ✅ Hover-Effekte sind dunkelgrün
- ✅ Titel zeigt "l7 zero trust"
- ❌ KEINE anderen Farben geändert!

### 7. Production Build

```bash
# Build erstellen
npm run build

# Testen
npm run preview
```

## 🎨 Farbpalette-Referenz

### l7 Farben (NUR diese verwenden!)

| Verwendung | Hex | RGB |
|------------|-----|-----|
| **Primary** | #a0cf4f | rgb(160, 207, 79) |
| **Primary Hover** | #8fb644 | rgb(143, 182, 68) |
| **Primary Active** | #7ea039 | rgb(126, 160, 57) |

### Netbird Farben (NICHT ändern!)

Alles andere bleibt original Netbird:
- Grautöne
- Blautöne (für Links, Info)
- Erfolgs-Grün (Success States)
- Fehler-Rot (Error States)
- Warn-Gelb (Warning States)
- Hintergrundfarben
- Textfarben
- Border-Farben
- Shadow-Farben

**Nur Orange (#FF7A00) → Grün (#a0cf4f)!**

## 📝 Beispiel-Änderungen

### CSS/Tailwind

```css
/* VORHER */
.btn-primary {
  background-color: #FF7A00;
  border-color: #FF7A00;
}

.btn-primary:hover {
  background-color: #E66D00;
}

/* NACHHER */
.btn-primary {
  background-color: #a0cf4f;
  border-color: #a0cf4f;
}

.btn-primary:hover {
  background-color: #8fb644;
}
```

### React Component

```tsx
// VORHER
<button className="bg-[#FF7A00] hover:bg-[#E66D00]">
  Connect
</button>

// NACHHER
<button className="bg-[#a0cf4f] hover:bg-[#8fb644]">
  Connect
</button>
```

## 🔍 Automatische Farb-Suche und -Ersetzung

### Script erstellen

```bash
#!/bin/bash
# replace-colors.sh

# Netbird Orange Varianten
ORANGE_COLORS=(
  "#FF7A00"
  "#ff7a00"
  "#E66D00"
  "#e66d00"
  "rgb(255, 122, 0)"
  "rgb(230, 109, 0)"
)

# l7 Grün Varianten
L7_COLORS=(
  "#a0cf4f"
  "#a0cf4f"
  "#8fb644"
  "#8fb644"
  "rgb(160, 207, 79)"
  "rgb(143, 182, 68)"
)

# Ersetzen
for i in "${!ORANGE_COLORS[@]}"; do
  orange="${ORANGE_COLORS[$i]}"
  green="${L7_COLORS[$i]}"
  
  echo "Replacing $orange with $green..."
  find src -type f \( -name "*.tsx" -o -name "*.ts" -o -name "*.css" \) \
    -exec sed -i "s/$orange/$green/gi" {} +
done

echo "✅ Color replacement complete!"
```

### Ausführen

```bash
chmod +x replace-colors.sh
./replace-colors.sh
```

## 📦 Docker Build

### Dockerfile erstellen

```dockerfile
FROM node:18-alpine as builder

WORKDIR /app
COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build

FROM nginx:alpine
COPY --from=builder /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

### Build und Deploy

```bash
# Image bauen
docker build -t l7-dashboard:latest .

# Testen
docker run -p 8080:80 l7-dashboard:latest

# Im Browser: http://localhost:8080
```

## ✅ Checkliste

Vor dem Deployment prüfen:

- [ ] Nur Orange-Farben wurden geändert
- [ ] l7-Logo (weiß) ist sichtbar
- [ ] Favicon zeigt l7-Icon (weiß)
- [ ] Primärfarbe ist #a0cf4f (grün)
- [ ] Hover ist #8fb644 (dunkelgrün)
- [ ] Produktname ist "l7 zero trust"
- [ ] Alle anderen Netbird-Farben unverändert
- [ ] Keine Layout-Änderungen
- [ ] Keine Style-Änderungen (außer Farbe)
- [ ] Build funktioniert ohne Fehler
- [ ] Alle Features funktionieren

## 🚨 Häufige Fehler

### ❌ Zu viele Farben geändert

```css
/* FALSCH - nicht alle grünen Farben ändern! */
.success-badge {
  background: #a0cf4f;  /* War Netbird-Grün für Success-States */
}

/* RICHTIG - Success-Grün bleibt! */
.success-badge {
  background: #10b981;  /* Original Netbird Success-Grün */
}
```

### ❌ Layout verändert

```tsx
/* FALSCH */
<div className="flex flex-col gap-8">  /* gap geändert */

/* RICHTIG */
<div className="flex flex-col gap-4">  /* Original-Gap beibehalten */
```

## 📚 Weitere Ressourcen

- **Netbird Dashboard**: https://github.com/netbirdio/dashboard
- **Tailwind CSS**: https://tailwindcss.com/docs
- **React**: https://react.dev/

---

**Wichtig**: Bei Unsicherheit → **NUR Orange durch Grün ersetzen!**
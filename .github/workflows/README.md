# l7 zero trust - GitHub Actions Workflows

## Active Workflows (l7-spezifisch)

### ✅ l7-sync-upstream.yml
**Zweck**: Wöchentliche Synchronisation mit dem Upstream Netbird-Repository  
**Trigger**: 
- Jeden Montag 1:00 UTC (automatisch)
- Manuell über GitHub UI

**Was macht es**:
1. Holt Updates von netbirdio/netbird
2. Merged Änderungen
3. Wendet l7 Branding automatisch an
4. Pusht Änderungen
5. Erstellt Issue bei Konflikten

### ✅ l7-build-ui.yml
**Zweck**: Build der l7 zero trust Desktop-UI für alle Plattformen  
**Trigger**:
- Push zu main (wenn UI-Dateien geändert wurden)
- Pull Requests
- Manuell über GitHub UI
- Bei Releases

**Was macht es**:
1. Baut für Windows, macOS, Linux
2. Verifiziert l7 Branding
3. Erstellt Binaries
4. Lädt Artifacts hoch

## Deaktivierte Workflows (Original Netbird)

Die folgenden Workflows wurden deaktiviert (`.yml.disabled`), da sie:
- Docker Hub Credentials benötigen (die nicht gesetzt sind)
- Für Netbird-spezifische Tests/Builds gedacht sind
- Durch l7-spezifische Workflows ersetzt wurden

**Deaktivierte Workflows:**
- `check-license-dependencies.yml.disabled`
- `docs-ack.yml.disabled`
- `forum.yml.disabled`
- `git-town.yml.disabled`
- `golang-test-*.yml.disabled` (darwin, freebsd, linux, windows)
- `golangci-lint.yml.disabled`
- `install-script-test.yml.disabled`
- `mobile-build-validation.yml.disabled`
- `release.yml.disabled`
- `sync-main.yml.disabled`
- `sync-tag.yml.disabled`
- `test-infrastructure-files.yml.disabled`
- `update-docs.yml.disabled`
- `wasm-build-validation.yml.disabled`

## Workflows reaktivieren

Falls Sie einen deaktivierten Workflow reaktivieren möchten:

```bash
# Beispiel: golang-test-linux reaktivieren
cd .github/workflows
mv golang-test-linux.yml.disabled golang-test-linux.yml
git add golang-test-linux.yml
git commit -m "Reaktiviere golang-test-linux workflow"
git push
```

**Hinweis**: Einige Workflows benötigen zusätzliche Secrets:
- Docker Hub: `DOCKERHUB_USERNAME`, `DOCKERHUB_TOKEN`
- Andere Credentials je nach Workflow

## Neue Workflows hinzufügen

Alle neuen l7-spezifischen Workflows sollten mit `l7-` prefix benannt werden:
- ✅ `l7-build-ui.yml`
- ✅ `l7-sync-upstream.yml`
- ✅ `l7-deploy-prod.yml` (wenn benötigt)
- ✅ `l7-test-*.yml` (wenn benötigt)

## Upstream Sync

Der `l7-sync-upstream.yml` Workflow hält Ihr Repository automatisch aktuell mit dem offiziellen Netbird-Repository. Bei Merge-Konflikten wird automatisch ein Issue erstellt.

**Manueller Sync (falls erforderlich)**:
```bash
git remote add upstream https://github.com/netbirdio/netbird.git
git fetch upstream
git merge upstream/main
./branding/scripts/apply-l7-branding.sh
git add -A
git commit -m "Sync with upstream and apply l7 branding"
git push
```

## Support

Bei Fragen zu den Workflows:
- **E-Mail**: dev@layer7.de
- **GitHub Issues**: https://github.com/layer7-dev/l7-netbird/issues
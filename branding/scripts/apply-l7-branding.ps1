# l7 zero trust - PowerShell Branding Script für Windows
# Führt das gleiche aus wie apply-l7-branding.sh, aber für PowerShell

Write-Host "🎨 l7 zero trust - Branding Application (PowerShell)" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan

$ProjectRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
Set-Location $ProjectRoot

Write-Host "📍 Working directory: $ProjectRoot" -ForegroundColor Blue

# 1. Icons generieren
Write-Host "`n🎨 Step 1: Generating l7 icons..." -ForegroundColor Blue
if (Test-Path "branding\scripts\generate-l7-icons.sh") {
    # Icons über Git Bash generieren (kommt mit Git für Windows)
    $gitBash = "C:\Program Files\Git\bin\bash.exe"
    if (Test-Path $gitBash) {
        & $gitBash branding/scripts/generate-l7-icons.sh
        Write-Host "  ✓ Icons generated via Git Bash" -ForegroundColor Green
    } else {
        Write-Host "  ⚠️  Git Bash not found at $gitBash" -ForegroundColor Yellow
        Write-Host "     Please install Git for Windows or run generate-l7-icons.sh manually" -ForegroundColor Yellow
    }
}

# 2. Code-Anpassungen (mit PowerShell sed-Ersatz)
Write-Host "`n✏️  Step 2: Updating code references..." -ForegroundColor Blue

# App-ID ändern
Write-Host "  • Updating App ID..." -ForegroundColor White
$clientUiPath = "client\ui\client_ui.go"
if (Test-Path $clientUiPath) {
    $content = Get-Content $clientUiPath -Raw
    $content = $content -replace 'app\.NewWithID\("NetBird"\)', 'app.NewWithID("l7zerotrust")'
    $content = $content -replace 'NetBird', 'l7 zero trust'
    $content = $content -replace 'version\.NewUpdate\("nb/client-ui"\)', 'version.NewUpdate("l7/zerotrust-ui")'
    Set-Content $clientUiPath -Value $content -NoNewline
    Write-Host "    ✓ App ID updated to 'l7zerotrust'" -ForegroundColor Green
}

#  GoReleaser Konfiguration
Write-Host "  • Updating GoReleaser config..." -ForegroundColor White
$goreleaserPath = ".goreleaser_ui.yaml"
if (Test-Path $goreleaserPath) {
    $content = Get-Content $goreleaserPath -Raw
    $content = $content -replace 'project_name: netbird-ui', 'project_name: l7-zerotrust-ui'
    $content = $content -replace 'netbird-ui', 'l7-zerotrust-ui'
    $content = $content -replace 'Netbird <dev@netbird.io>', 'layer7 managed it <dev@layer7.de>'
    $content = $content -replace 'netbird.io', 'layer7.de'
    Set-Content $goreleaserPath -Value $content -NoNewline
    Write-Host "    ✓ GoReleaser config updated" -ForegroundColor Green
}

Write-Host "`n✅ l7 zero trust branding applied successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Blue
Write-Host "  1. Review changes: git status"
Write-Host "  2. Commit changes: git add -A && git commit -m 'Apply l7 branding'"
Write-Host "  3. Push to repo: git push origin main"
Write-Host ""
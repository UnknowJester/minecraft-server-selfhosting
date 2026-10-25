<#
.SYNOPSIS
    Seleziona un'istanza Prism Launcher, un mondo del client, e lo copia nel server; poi avvia il server.

.DESCRIPTION
    Script generico e interattivo: nessun modpack preimpostato.
    L'utente sceglie l'istanza Prism e il mondo a runtime.
    Configurabile tramite variabili d'ambiente:
      PRISM_INSTANCES_ROOT -> cartella radice delle istanze Prism (default: %APPDATA%\PrismLauncher\instances)
      SERVER_DIR           -> cartella del server (default: cartella dello script)
#>

# ---------- CONFIGURAZIONE ----------
$PrismInstancesRoot = if ($env:PRISM_INSTANCES_ROOT) { $env:PRISM_INSTANCES_ROOT } else { Join-Path $env:APPDATA "PrismLauncher\instances" }
$ServerDir          = if ($env:SERVER_DIR)           { $env:SERVER_DIR }           else { Split-Path -Parent $MyInvocation.MyCommand.Path }
# ------------------------------------

if (-not (Test-Path $PrismInstancesRoot)) {
    Write-Host "Cartella istanze Prism non trovata: $PrismInstancesRoot" -ForegroundColor Red
    Write-Host "Imposta PRISM_INSTANCES_ROOT se usi un percorso diverso." -ForegroundColor Yellow
    pause
    exit 1
}

$Instances = Get-ChildItem -Path $PrismInstancesRoot -Directory
if ($Instances.Count -eq 0) {
    Write-Host "Nessuna istanza Prism trovata in $PrismInstancesRoot" -ForegroundColor Red
    pause
    exit 1
}

Write-Host "Istanze Prism disponibili:" -ForegroundColor Cyan
for ($i = 0; $i -lt $Instances.Count; $i++) {
    Write-Host ("  {0}. {1}" -f ($i + 1), $Instances[$i].Name)
}
$InstanceChoice = Read-Host "Scegli il numero dell'istanza (modpack) da usare"
if ($InstanceChoice -notmatch '^\d+$' -or [int]$InstanceChoice -lt 1 -or [int]$InstanceChoice -gt $Instances.Count) {
    Write-Host "Scelta non valida." -ForegroundColor Red
    pause
    exit 1
}
$InstanceName = $Instances[[int]$InstanceChoice - 1].Name
$SavesPath    = Join-Path $PrismInstancesRoot (Join-Path $InstanceName "minecraft\saves")

if (-not (Test-Path $SavesPath)) {
    Write-Host "Cartella saves non trovata per l'istanza '$InstanceName': $SavesPath" -ForegroundColor Red
    pause
    exit 1
}

$Worlds = Get-ChildItem -Path $SavesPath -Directory
if ($Worlds.Count -eq 0) {
    Write-Host "Nessun mondo trovato in $SavesPath" -ForegroundColor Red
    pause
    exit 1
}

Write-Host "Istanza selezionata: $InstanceName" -ForegroundColor DarkCyan
Write-Host "Mondi disponibili:" -ForegroundColor Cyan
for ($i = 0; $i -lt $Worlds.Count; $i++) {
    Write-Host ("  {0}. {1}" -f ($i + 1), $Worlds[$i].Name)
}
$WorldChoice = Read-Host "Scegli il numero del mondo da usare come server"
if ($WorldChoice -notmatch '^\d+$' -or [int]$WorldChoice -lt 1 -or [int]$WorldChoice -gt $Worlds.Count) {
    Write-Host "Scelta non valida." -ForegroundColor Red
    pause
    exit 1
}
$Selected = $Worlds[[int]$WorldChoice - 1]
Write-Host "Mondo selezionato: $($Selected.Name)" -ForegroundColor Green

$WorldDir = Join-Path $ServerDir "world"

# Backup del mondo attuale del server
if (Test-Path $WorldDir) {
    $Backup = Join-Path $ServerDir ("world_backup_" + (Get-Date -Format "yyyyMMdd_HHmmss"))
    Write-Host "Backup del mondo attuale in: $Backup"
    Copy-Item -Path $WorldDir -Destination $Backup -Recurse -Force
    Remove-Item -Path $WorldDir -Recurse -Force
}

# Copia del mondo scelto
Write-Host "Copio il mondo nel server..."
Copy-Item -Path $Selected.FullName -Destination $WorldDir -Recurse -Force
Write-Host "Mondo copiato." -ForegroundColor Green

# Avvio server
$RunBat = Join-Path $ServerDir "run.bat"
if (-not (Test-Path $RunBat)) {
    Write-Host "run.bat non trovato in $ServerDir. Avvia il server manualmente." -ForegroundColor Yellow
    pause
    exit 0
}

Write-Host "Avvio del server..." -ForegroundColor Green
Start-Process -FilePath $RunBat -ArgumentList "nogui" -WorkingDirectory $ServerDir

# requires admin
Write-Host "=== AI Cache Migrator ===" -ForegroundColor Cyan

$config = Get-Content "config.json" | ConvertFrom-Json
$root = $config.target_root

if (!(Test-Path $root)) {
    New-Item -ItemType Directory -Path $root | Out-Null
}

foreach ($name in $config.items.PSObject.Properties.Name) {
    $item = $config.items.$name

    $src = [Environment]::ExpandEnvironmentVariables($item.src)
    $dst = Join-Path $root $item.dst

    Write-Host "`n[$name]" -ForegroundColor Yellow
    Write-Host "SRC: $src"
    Write-Host "DST: $dst"

    if (Test-Path $src) {
        if (!(Test-Path $dst)) {
            Write-Host "→ Migrating files..."
            Move-Item $src $dst
        } else {
            Write-Host "→ Target already exists, skipping move."
        }
    } else {
        Write-Host "→ Source not found, skipping."
    }

    foreach ($envName in $item.env) {
        Write-Host "→ Setting env: $envName"
        setx $envName $dst | Out-Null
    }
}

Write-Host "`n✔ Migration done. Please restart terminal / IDE." -ForegroundColor Green

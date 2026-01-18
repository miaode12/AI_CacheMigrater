Write-Host "=== Rollback AI Cache Env ===" -ForegroundColor Red

$envs = @(
    "HF_HOME",
    "HUGGINGFACE_HUB_CACHE",
    "MODELSCOPE_CACHE",
    "TORCH_HOME"
)

foreach ($e in $envs) {
    Write-Host "Removing $e"
    reg delete "HKCU\Environment" /v $e /f | Out-Null
}

Write-Host "✔ Environment variables removed. Restart terminal."

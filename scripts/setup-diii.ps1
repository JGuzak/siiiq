if (-not (Get-Command uv -ErrorAction SilentlyContinue)) {
    Write-Host "❌ UV not found. Please install UV (https://docs.astral.sh/uv/#installation) before continuing."
    exit 1
}

if (Test-Path ".venv") {
    try {
        $venvVersion = .\.venv\Scripts\python.exe -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')" 
    } catch {
        $venvVersion = "none"
    }
    if ($venvVersion -ne "3.11") {
        Write-Host "⚠️  Existing .venv uses $venvVersion. Recreating..."
        Remove-Item -Recurse -Force ".venv"
    }
}

uv venv
.\.venv\Scripts\Activate.ps1

uv pip install -r requirements.txt

Write-Host "Setup complete!"

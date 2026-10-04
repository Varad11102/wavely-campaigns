$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "Wavely easy setup" -ForegroundColor Cyan
Write-Host "This window will prepare and start Wavely for you."
Write-Host ""

$nodeCommand = Get-Command node -ErrorAction SilentlyContinue

if (-not $nodeCommand) {
    Write-Host "Node.js is not installed. Windows will install it now." -ForegroundColor Yellow
    $wingetCommand = Get-Command winget -ErrorAction SilentlyContinue

    if (-not $wingetCommand) {
        Write-Host "Windows Package Manager (winget) was not found." -ForegroundColor Red
        Write-Host "Please install Node.js LTS from https://nodejs.org and run this command again."
        Read-Host "Press Enter to close"
        exit 1
    }

    winget install --id OpenJS.NodeJS.LTS --exact --accept-package-agreements --accept-source-agreements
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Node.js could not be installed automatically." -ForegroundColor Red
        Write-Host "Please install Node.js LTS from https://nodejs.org and run this command again."
        Read-Host "Press Enter to close"
        exit 1
    }

    $nodeFolder = Join-Path $env:ProgramFiles "nodejs"
    if (Test-Path -LiteralPath $nodeFolder) {
        $env:Path = "$nodeFolder;$env:Path"
    }

    $nodeCommand = Get-Command node -ErrorAction SilentlyContinue
    if (-not $nodeCommand) {
        Write-Host "Node.js was installed, but Windows needs a restart." -ForegroundColor Yellow
        Write-Host "Restart the computer, then run the same command again."
        Read-Host "Press Enter to close"
        exit 0
    }
}

Write-Host "Node.js is ready: $(node --version)" -ForegroundColor Green

$settingsPath = Join-Path $PSScriptRoot ".env"
if (-not (Test-Path -LiteralPath $settingsPath)) {
    Write-Host ""
    Write-Host "Paste your private MudBot API key below." -ForegroundColor Yellow
    Write-Host "The letters will be hidden while you type or paste."
    $secureKey = Read-Host "MudBot API key" -AsSecureString
    $keyPointer = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureKey)

    try {
        $plainKey = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($keyPointer)
        if ([string]::IsNullOrWhiteSpace($plainKey)) {
            throw "No API key was entered. Run the command again and paste the key."
        }

        @(
            "MUDBOT_API_KEY=$($plainKey.Trim())"
            "MUDBOT_BASE_URL=https://api.watobot.xyz"
            "PORT=3000"
        ) | Set-Content -LiteralPath $settingsPath -Encoding UTF8
    }
    finally {
        if ($keyPointer -ne [IntPtr]::Zero) {
            [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($keyPointer)
        }
        $plainKey = $null
    }

    Write-Host "Private settings were saved on this computer." -ForegroundColor Green
}
else {
    Write-Host "Existing private settings were found and kept." -ForegroundColor Green
}

Write-Host ""
Write-Host "Wavely is starting." -ForegroundColor Cyan
Write-Host "Your browser will open at http://127.0.0.1:3000"
Write-Host "Keep this window open. To stop Wavely, press Ctrl+C here."

Start-Process "http://127.0.0.1:3000"
Set-Location -LiteralPath $PSScriptRoot
node server.js

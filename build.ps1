# Parent dir is root
$scriptDir = Get-Location
$rootDir = Split-Path -Path $scriptDir -Parent
$outDir = Join-Path -Path $scriptDir -ChildPath "/out"

## Backend
Set-Location $rootDir/legocerthub-backend

# Include config example
Copy-Item -Path $rootDir/legocerthub-backend/config.default.yaml -Destination $outDir

# Windows x64
set GOARCH=amd64
set GOOS=windows
go build -o $outDir/lego-amd64.exe ./cmd/api-server

# Linux x64
set GOARCH=amd64
set GOOS=linux
go build -o $outDir/lego-amd64-linux ./cmd/api-server

## Frontend
Set-Location $rootDir/legocerthub-frontend
npm run build

Move-Item -Path $rootDir/legocerthub-frontend/build -Destination $outDir/frontend_build

# Return to original path
Set-Location $scriptDir

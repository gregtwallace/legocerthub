# Parent dir is root
$scriptDir = Get-Location
$rootDir = Split-Path -Path $scriptDir -Parent
$outDir = Join-Path -Path $scriptDir -ChildPath "/out"

## Backend
Set-Location $rootDir/legocerthub-backend

# Include config example
Copy-Item -Path $rootDir/legocerthub-backend/config.default.yaml -Destination $outDir

# Mandatory env flag for sqlite
$env:CGO_ENABLED = 1

# Windows x64
$env:GOARCH = "amd64"
$env:GOOS = "windows"
go build -o $outDir/lego-amd64.exe ./cmd/api-server

# Linux x64
# Currently unable to cross-compile with CGO_ENABLED
# $env:GOARCH = "amd64"
# $env:GOOS = "linux"
# go build -o $outDir/lego-amd64-linux ./cmd/api-server

## Frontend
Set-Location $rootDir/legocerthub-frontend
npm run build

# remove old build
Remove-Item -Path $outDir/frontend_build -recurse
New-Item -ItemType Directory -Force -Path $outDir/frontend_build

# move to out
Move-Item -Path $rootDir/legocerthub-frontend/build/* -Destination $outDir/frontend_build

# Return to original path
Set-Location $scriptDir

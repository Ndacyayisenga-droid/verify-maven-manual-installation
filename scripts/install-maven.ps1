param(
    [string]$MavenVersion = "3.9.16",
    [string]$InstallDir = "C:\Tools"
)

$ErrorActionPreference = "Stop"

$MavenDir = "apache-maven-$MavenVersion"
$ZipFile = "$MavenDir-bin.zip"
$Url = "https://archive.apache.org/dist/maven/maven-3/$MavenVersion/binaries/$ZipFile"
$Destination = "$InstallDir\$MavenDir"

Write-Host "🚀 Installing Maven $MavenVersion on Windows"

# -----------------------------
# 1. Check Java
# -----------------------------
if (-not (Get-Command java -ErrorAction SilentlyContinue)) {
    throw "❌ Java is not installed"
}

Write-Host "☕ Java version:"
java -version

# -----------------------------
# 2. Prepare folder
# -----------------------------
New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null

# -----------------------------
# 3. Download Maven
# -----------------------------
$ZipPath = "$InstallDir\$ZipFile"

if (!(Test-Path $ZipPath)) {
    Write-Host "📥 Downloading Maven..."
    Invoke-WebRequest -Uri $Url -OutFile $ZipPath
} else {
    Write-Host "ℹ️ Maven archive already exists"
}

# -----------------------------
# 4. Extract
# -----------------------------
if (Test-Path $Destination) {
    Write-Host "🧹 Removing old installation..."
    Remove-Item -Recurse -Force $Destination
}

Write-Host "📦 Extracting Maven..."
Expand-Archive -Path $ZipPath -DestinationPath $InstallDir -Force

# -----------------------------
# 5. Set environment variables (User scope)
# -----------------------------
Write-Host "🧠 Setting JAVA_HOME and MAVEN_HOME"

$MavenHome = $Destination

[Environment]::SetEnvironmentVariable("MAVEN_HOME", $MavenHome, "User")

# Append to PATH safely
$oldPath = [Environment]::GetEnvironmentVariable("Path", "User")
$newPath = "$oldPath;$MavenHome\bin"

[Environment]::SetEnvironmentVariable("Path", $newPath, "User")

# -----------------------------
# 6. Verify
# -----------------------------
Write-Host "🧪 Verifying Maven install..."

$env:MAVEN_HOME = $MavenHome
$env:Path = "$MavenHome\bin;$env:Path"

mvn -v

Write-Host "🎉 Maven $MavenVersion installed successfully"

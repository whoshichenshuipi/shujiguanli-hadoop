# Fix Hadoop Configuration for Windows
# This script updates hadoop-env.cmd with correct JAVA_HOME

$HADOOP_HOME = "B:\hadoop\hadoop-3.3.6"
$JAVA_HOME = "C:\Program Files\Java\jdk-17"
$configFile = "$HADOOP_HOME\etc\hadoop\hadoop-env.cmd"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Fix Hadoop Configuration" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if config file exists
if (!(Test-Path $configFile)) {
    Write-Host "ERROR: Config file not found: $configFile" -ForegroundColor Red
    exit 1
}

Write-Host "Found config file: $configFile" -ForegroundColor Green

# Backup original file
$backupFile = "$configFile.backup"
if (!(Test-Path $backupFile)) {
    Copy-Item $configFile $backupFile
    Write-Host "Created backup: $backupFile" -ForegroundColor Yellow
}

# Read current content
$content = Get-Content $configFile

# Find and update JAVA_HOME line
$updated = $false
$newContent = @()

foreach ($line in $content) {
    if ($line -match "^\s*set\s+JAVA_HOME\s*=") {
        # Replace with correct JAVA_HOME
        $newContent += "set JAVA_HOME=$JAVA_HOME"
        $updated = $true
        Write-Host "Updated JAVA_HOME line" -ForegroundColor Green
    } else {
        $newContent += $line
    }
}

# If JAVA_HOME not found, add it at the beginning
if (!$updated) {
    $newContent = @("set JAVA_HOME=$JAVA_HOME") + $newContent
    Write-Host "Added JAVA_HOME line" -ForegroundColor Green
}

# Write updated content
$newContent | Set-Content $configFile -Encoding ASCII

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Configuration Updated" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "JAVA_HOME set to: $JAVA_HOME" -ForegroundColor Green
Write-Host ""
Write-Host "Now testing Hadoop..." -ForegroundColor Yellow

# Set environment variables for current session
$env:JAVA_HOME = $JAVA_HOME
$env:HADOOP_HOME = $HADOOP_HOME
$env:Path = "$env:Path;$HADOOP_HOME\bin;$HADOOP_HOME\sbin"

# Test Hadoop
Write-Host ""
try {
    & "$HADOOP_HOME\bin\hadoop.cmd" version 2>&1 | Select-String "Hadoop" | Select-Object -First 1
    Write-Host ""
    Write-Host "SUCCESS! Hadoop is now working!" -ForegroundColor Green
} catch {
    Write-Host ""
    Write-Host "ERROR: Hadoop still not working" -ForegroundColor Red
    Write-Host "Error: $_" -ForegroundColor Red
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Next Steps" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Close and reopen PowerShell" -ForegroundColor White
Write-Host "2. Or run this to refresh current session:" -ForegroundColor White
Write-Host ""
Write-Host '   $env:JAVA_HOME = "C:\Program Files\Java\jdk-17"' -ForegroundColor Gray
Write-Host '   $env:HADOOP_HOME = "B:\hadoop\hadoop-3.3.6"' -ForegroundColor Gray
Write-Host '   $env:Path = "$env:Path;B:\hadoop\hadoop-3.3.6\bin;B:\hadoop\hadoop-3.3.6\sbin"' -ForegroundColor Gray
Write-Host ""
Write-Host "3. Verify: hadoop version" -ForegroundColor White
Write-Host ""

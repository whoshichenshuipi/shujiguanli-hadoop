# Complete Hadoop + Java Environment Setup
# Run this script to configure both Java and Hadoop

$JAVA_HOME = "C:\Program Files\Java\jdk-17"
$HADOOP_HOME = "B:\hadoop\hadoop-3.3.6"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Hadoop + Java Environment Setup" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check Java
Write-Host "[1/4] Checking Java..." -ForegroundColor Yellow
if (!(Test-Path $JAVA_HOME)) {
    Write-Host "ERROR: Java not found at: $JAVA_HOME" -ForegroundColor Red
    exit 1
}
Write-Host "Found Java at: $JAVA_HOME" -ForegroundColor Green

# Check Hadoop
Write-Host ""
Write-Host "[2/4] Checking Hadoop..." -ForegroundColor Yellow
if (!(Test-Path $HADOOP_HOME)) {
    Write-Host "ERROR: Hadoop not found at: $HADOOP_HOME" -ForegroundColor Red
    exit 1
}
Write-Host "Found Hadoop at: $HADOOP_HOME" -ForegroundColor Green

# Set JAVA_HOME
Write-Host ""
Write-Host "[3/4] Setting JAVA_HOME..." -ForegroundColor Yellow
[System.Environment]::SetEnvironmentVariable('JAVA_HOME', $JAVA_HOME, 'User')
Write-Host "JAVA_HOME set to: $JAVA_HOME" -ForegroundColor Green

# Set HADOOP_HOME
Write-Host ""
Write-Host "[4/4] Setting HADOOP_HOME and PATH..." -ForegroundColor Yellow
[System.Environment]::SetEnvironmentVariable('HADOOP_HOME', $HADOOP_HOME, 'User')

$userPath = [System.Environment]::GetEnvironmentVariable('Path', 'User')
$hadoopBin = "$HADOOP_HOME\bin"
$hadoopSbin = "$HADOOP_HOME\sbin"

if ($userPath -notlike "*$hadoopBin*") {
    $newPath = "$userPath;$hadoopBin;$hadoopSbin"
    [System.Environment]::SetEnvironmentVariable('Path', $newPath, 'User')
    Write-Host "Added Hadoop to PATH" -ForegroundColor Green
} else {
    Write-Host "Hadoop already in PATH" -ForegroundColor Yellow
}

# Refresh current session
$env:JAVA_HOME = $JAVA_HOME
$env:HADOOP_HOME = $HADOOP_HOME
$env:Path = "$env:Path;$hadoopBin;$hadoopSbin"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Verification" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Environment Variables:" -ForegroundColor Cyan
Write-Host "  JAVA_HOME   = $env:JAVA_HOME" -ForegroundColor Gray
Write-Host "  HADOOP_HOME = $env:HADOOP_HOME" -ForegroundColor Gray

Write-Host ""
Write-Host "Testing commands..." -ForegroundColor Yellow

# Test Java
Write-Host ""
Write-Host "Java version:" -ForegroundColor Cyan
java -version 2>&1 | Select-Object -First 1

# Test Hadoop
Write-Host ""
Write-Host "Hadoop version:" -ForegroundColor Cyan
try {
    & "$HADOOP_HOME\bin\hadoop.cmd" version 2>&1 | Select-String "Hadoop" | Select-Object -First 1
    Write-Host "SUCCESS: Hadoop is working!" -ForegroundColor Green
} catch {
    Write-Host "ERROR: Hadoop command failed" -ForegroundColor Red
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Setup Complete!" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "NEXT STEPS:" -ForegroundColor Yellow
Write-Host "  1. Close and reopen PowerShell (or run a new terminal)" -ForegroundColor White
Write-Host "  2. Verify with: hadoop version" -ForegroundColor White
Write-Host "  3. Run MapReduce jobs: .\run-jobs.ps1" -ForegroundColor White
Write-Host ""

# Hadoop Diagnostic and Fix Script
# This script diagnoses and fixes Hadoop configuration issues

$JAVA_HOME_PATH = "C:\Program Files\Java\jdk-17"
$HADOOP_HOME_PATH = "B:\hadoop\hadoop-3.3.6"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Hadoop Diagnostic Tool" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Check Java
Write-Host "[1/5] Checking Java..." -ForegroundColor Yellow
if (Test-Path "$JAVA_HOME_PATH\bin\java.exe") {
    Write-Host "  Java found at: $JAVA_HOME_PATH" -ForegroundColor Green
    & "$JAVA_HOME_PATH\bin\java.exe" -version 2>&1 | Select-Object -First 1
} else {
    Write-Host "  ERROR: Java not found!" -ForegroundColor Red
    exit 1
}

# Step 2: Check Hadoop
Write-Host ""
Write-Host "[2/5] Checking Hadoop..." -ForegroundColor Yellow
if (Test-Path "$HADOOP_HOME_PATH\bin\hadoop.cmd") {
    Write-Host "  Hadoop found at: $HADOOP_HOME_PATH" -ForegroundColor Green
} else {
    Write-Host "  ERROR: Hadoop not found!" -ForegroundColor Red
    exit 1
}

# Step 3: Fix hadoop-env.cmd
Write-Host ""
Write-Host "[3/5] Fixing hadoop-env.cmd..." -ForegroundColor Yellow
$hadoopEnvFile = "$HADOOP_HOME_PATH\etc\hadoop\hadoop-env.cmd"

# Create a completely new hadoop-env.cmd
$newContent = @"
@echo off
rem Licensed to the Apache Software Foundation (ASF) under one or more
rem contributor license agreements.  See the NOTICE file distributed with
rem this work for additional information regarding copyright ownership.

rem Set Hadoop-specific environment variables here.

rem The only required environment variable is JAVA_HOME.  All others are
rem optional.  When running a distributed configuration it is best to
rem set JAVA_HOME in this file, so that it is correctly defined on
rem remote nodes.

rem The java implementation to use.
set JAVA_HOME=$JAVA_HOME_PATH

rem Extra Java CLASSPATH elements.  Optional.
rem set HADOOP_CLASSPATH=

rem The maximum amount of heap to use, in MB. Default is 1000.
rem set HADOOP_HEAPSIZE=1000

rem Extra Java runtime options.  Empty by default.
rem set HADOOP_OPTS=%HADOOP_OPTS% -Djava.net.preferIPv4Stack=true
"@

# Backup and replace
if (Test-Path $hadoopEnvFile) {
    Copy-Item $hadoopEnvFile "$hadoopEnvFile.old" -Force
    Write-Host "  Backed up old file" -ForegroundColor Yellow
}

$newContent | Out-File -FilePath $hadoopEnvFile -Encoding ASCII -Force
Write-Host "  Created new hadoop-env.cmd" -ForegroundColor Green

# Step 4: Test Hadoop
Write-Host ""
Write-Host "[4/5] Testing Hadoop..." -ForegroundColor Yellow

# Set environment for test
$env:JAVA_HOME = $JAVA_HOME_PATH
$env:HADOOP_HOME = $HADOOP_HOME_PATH

try {
    $output = & "$HADOOP_HOME_PATH\bin\hadoop.cmd" version 2>&1
    $hadoopLine = $output | Select-String "Hadoop" | Select-Object -First 1
    
    if ($hadoopLine) {
        Write-Host "  $hadoopLine" -ForegroundColor Green
        Write-Host "  SUCCESS!" -ForegroundColor Green
    } else {
        Write-Host "  WARNING: Unexpected output" -ForegroundColor Yellow
        Write-Host $output
    }
} catch {
    Write-Host "  ERROR: $_" -ForegroundColor Red
}

# Step 5: Create helper script
Write-Host ""
Write-Host "[5/5] Creating helper script..." -ForegroundColor Yellow

$helperScript = @"
# Quick Hadoop Environment Setup
# Run this before using Hadoop commands

`$env:JAVA_HOME = "$JAVA_HOME_PATH"
`$env:HADOOP_HOME = "$HADOOP_HOME_PATH"
`$env:Path = "`$env:Path;$HADOOP_HOME_PATH\bin;$HADOOP_HOME_PATH\sbin"

Write-Host "Hadoop environment ready!" -ForegroundColor Green
Write-Host "Try: hadoop version" -ForegroundColor Cyan
"@

$helperScript | Out-File -FilePath ".\activate-hadoop.ps1" -Encoding UTF8 -Force
Write-Host "  Created activate-hadoop.ps1" -ForegroundColor Green

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Summary" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "To use Hadoop in this session:" -ForegroundColor Yellow
Write-Host "  . .\activate-hadoop.ps1" -ForegroundColor White
Write-Host "  hadoop version" -ForegroundColor White
Write-Host ""
Write-Host "Or in a new PowerShell window:" -ForegroundColor Yellow
Write-Host "  1. Close this window" -ForegroundColor White
Write-Host "  2. Open new PowerShell" -ForegroundColor White
Write-Host "  3. cd b:\jproject\tushu-hadoop\hadoop-jobs" -ForegroundColor White
Write-Host "  4. . .\activate-hadoop.ps1" -ForegroundColor White
Write-Host "  5. hadoop version" -ForegroundColor White
Write-Host ""

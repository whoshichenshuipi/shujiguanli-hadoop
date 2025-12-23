# Final Hadoop Fix - Using Short Path Names
# This resolves issues with spaces in JAVA_HOME path

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Final Hadoop Configuration Fix" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Get short path for Java (no spaces)
$longJavaPath = "C:\Program Files\Java\jdk-17"
$fso = New-Object -ComObject Scripting.FileSystemObject
$shortJavaPath = $fso.GetFolder($longJavaPath).ShortPath

Write-Host "Long Java path:  $longJavaPath" -ForegroundColor Gray
Write-Host "Short Java path: $shortJavaPath" -ForegroundColor Green

# Update hadoop-env.cmd with short path
$hadoopEnvFile = "B:\hadoop\hadoop-3.3.6\etc\hadoop\hadoop-env.cmd"

$newContent = @"
@echo off
rem Hadoop environment configuration
rem Using short path to avoid issues with spaces

set JAVA_HOME=$shortJavaPath

rem The maximum amount of heap to use, in MB. Default is 1000.
set HADOOP_HEAPSIZE=1000

rem Extra Java runtime options.
set HADOOP_OPTS=-Djava.net.preferIPv4Stack=true
"@

# Backup and write
if (Test-Path $hadoopEnvFile) {
    Copy-Item $hadoopEnvFile "$hadoopEnvFile.bak" -Force
}

$newContent | Out-File -FilePath $hadoopEnvFile -Encoding ASCII -Force

Write-Host ""
Write-Host "Updated hadoop-env.cmd with short path" -ForegroundColor Green

# Update activate script
$activateScript = @"
# Hadoop Environment Activation Script
# Source this script: . .\activate-hadoop.ps1

`$env:JAVA_HOME = "$shortJavaPath"
`$env:HADOOP_HOME = "B:\hadoop\hadoop-3.3.6"
`$env:Path = "`$env:Path;B:\hadoop\hadoop-3.3.6\bin;B:\hadoop\hadoop-3.3.6\sbin"

Write-Host "Hadoop environment activated!" -ForegroundColor Green
Write-Host "  JAVA_HOME   = `$env:JAVA_HOME" -ForegroundColor Gray
Write-Host "  HADOOP_HOME = `$env:HADOOP_HOME" -ForegroundColor Gray
Write-Host ""
Write-Host "Test with: hadoop version" -ForegroundColor Cyan
"@

$activateScript | Out-File -FilePath ".\activate-hadoop.ps1" -Encoding UTF8 -Force

Write-Host "Updated activate-hadoop.ps1" -ForegroundColor Green

# Test immediately
Write-Host ""
Write-Host "Testing Hadoop now..." -ForegroundColor Yellow
$env:JAVA_HOME = $shortJavaPath
$env:HADOOP_HOME = "B:\hadoop\hadoop-3.3.6"
$env:Path = "$env:Path;B:\hadoop\hadoop-3.3.6\bin"

Write-Host ""
& "B:\hadoop\hadoop-3.3.6\bin\hadoop.cmd" version 2>&1 | Select-Object -First 3

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Configuration Complete!" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Hadoop is now ready to use!" -ForegroundColor Green
Write-Host ""
Write-Host "Quick start:" -ForegroundColor Yellow
Write-Host "  hadoop version" -ForegroundColor White
Write-Host "  .\run-jobs.ps1" -ForegroundColor White
Write-Host ""

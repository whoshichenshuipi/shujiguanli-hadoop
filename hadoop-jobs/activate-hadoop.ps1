# Hadoop Environment Activation Script
# Source this script: . .\activate-hadoop.ps1

$env:JAVA_HOME = "C:\PROGRA~1\Java\jdk-17"
$env:HADOOP_HOME = "B:\hadoop\hadoop-3.3.6"
$env:Path = "$env:Path;B:\hadoop\hadoop-3.3.6\bin;B:\hadoop\hadoop-3.3.6\sbin"

Write-Host "Hadoop environment activated!" -ForegroundColor Green
Write-Host "  JAVA_HOME   = $env:JAVA_HOME" -ForegroundColor Gray
Write-Host "  HADOOP_HOME = $env:HADOOP_HOME" -ForegroundColor Gray
Write-Host ""
Write-Host "Test with: hadoop version" -ForegroundColor Cyan

# Download and Install winutils.exe for Hadoop on Windows

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Installing winutils.exe" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$HADOOP_HOME = "B:\hadoop\hadoop-3.3.6"
$binDir = "$HADOOP_HOME\bin"

Write-Host "Hadoop bin directory: $binDir" -ForegroundColor Gray
Write-Host ""

# Check if winutils.exe already exists
if (Test-Path "$binDir\winutils.exe") {
    Write-Host "winutils.exe already exists!" -ForegroundColor Green
    Write-Host "Location: $binDir\winutils.exe" -ForegroundColor Gray
} else {
    Write-Host "winutils.exe not found. Downloading..." -ForegroundColor Yellow
    Write-Host ""
    
    # Download winutils for Hadoop 3.3.x
    $winutilsUrl = "https://github.com/cdarlint/winutils/raw/master/hadoop-3.3.1/bin/winutils.exe"
    $hadoopDllUrl = "https://github.com/cdarlint/winutils/raw/master/hadoop-3.3.1/bin/hadoop.dll"
    
    try {
        Write-Host "Downloading winutils.exe..." -ForegroundColor Yellow
        Invoke-WebRequest -Uri $winutilsUrl -OutFile "$binDir\winutils.exe" -UseBasicParsing
        Write-Host "Downloaded winutils.exe" -ForegroundColor Green
        
        Write-Host "Downloading hadoop.dll..." -ForegroundColor Yellow
        Invoke-WebRequest -Uri $hadoopDllUrl -OutFile "$binDir\hadoop.dll" -UseBasicParsing
        Write-Host "Downloaded hadoop.dll" -ForegroundColor Green
    } catch {
        Write-Host ""
        Write-Host "ERROR: Failed to download files" -ForegroundColor Red
        Write-Host "Error: $_" -ForegroundColor Red
        Write-Host ""
        Write-Host "Manual download instructions:" -ForegroundColor Yellow
        Write-Host "1. Visit: https://github.com/cdarlint/winutils/tree/master/hadoop-3.3.1/bin" -ForegroundColor White
        Write-Host "2. Download: winutils.exe and hadoop.dll" -ForegroundColor White
        Write-Host "3. Copy to: $binDir" -ForegroundColor White
        exit 1
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Verification" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

if (Test-Path "$binDir\winutils.exe") {
    Write-Host "winutils.exe: Found" -ForegroundColor Green
} else {
    Write-Host "winutils.exe: Missing" -ForegroundColor Red
}

if (Test-Path "$binDir\hadoop.dll") {
    Write-Host "hadoop.dll:   Found" -ForegroundColor Green
} else {
    Write-Host "hadoop.dll:   Missing" -ForegroundColor Red
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Setup Complete!" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Now you can run MapReduce jobs!" -ForegroundColor Green
Write-Host ""
Write-Host "Try running:" -ForegroundColor Yellow
Write-Host "  .\run-jobs.ps1" -ForegroundColor White
Write-Host ""

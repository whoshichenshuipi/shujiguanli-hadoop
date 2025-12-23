# Hadoop MapReduce 快速启动脚本
# 适用于 Windows PowerShell

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  图书管理系统 - Hadoop MapReduce 任务" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 检查 Hadoop 是否可用
Write-Host "[1/5] 检查 Hadoop 环境..." -ForegroundColor Yellow
try {
    $hadoopVersion = hadoop version 2>&1 | Select-String "Hadoop" | Select-Object -First 1
    Write-Host "✓ Hadoop 已安装: $hadoopVersion" -ForegroundColor Green
} catch {
    Write-Host "✗ Hadoop 未安装或未配置到 PATH" -ForegroundColor Red
    Write-Host "  请先安装 Hadoop 并配置环境变量" -ForegroundColor Red
    exit 1
}

# 检查 JAR 文件是否存在
Write-Host "[2/5] 检查 JAR 文件..." -ForegroundColor Yellow
$jarPath = "target\library-hadoop-jobs-0.0.1-SNAPSHOT.jar"
if (Test-Path $jarPath) {
    Write-Host "✓ JAR 文件已存在: $jarPath" -ForegroundColor Green
} else {
    Write-Host "✗ JAR 文件不存在，开始编译..." -ForegroundColor Yellow
    mvn clean package
    if ($LASTEXITCODE -ne 0) {
        Write-Host "✗ 编译失败" -ForegroundColor Red
        exit 1
    }
    Write-Host "✓ 编译成功" -ForegroundColor Green
}

# 创建 HDFS 目录
Write-Host "[3/5] 创建 HDFS 目录..." -ForegroundColor Yellow
hdfs dfs -mkdir -p /library/logs 2>&1 | Out-Null
hdfs dfs -mkdir -p /library/output 2>&1 | Out-Null
Write-Host "✓ HDFS 目录已创建" -ForegroundColor Green

# 检查是否有日志数据
Write-Host "[4/5] 检查 HDFS 日志数据..." -ForegroundColor Yellow
$logFiles = hdfs dfs -ls /library/logs 2>&1 | Select-String "borrow_"
if ($logFiles) {
    Write-Host "✓ 发现日志文件" -ForegroundColor Green
    $logFiles | ForEach-Object { Write-Host "  $_" -ForegroundColor Gray }
} else {
    Write-Host "⚠ 未发现日志文件" -ForegroundColor Yellow
    Write-Host "  提示：请先运行后端应用并进行借阅操作以生成日志" -ForegroundColor Yellow
    Write-Host "  或者手动创建测试数据：" -ForegroundColor Yellow
    Write-Host "    echo '1,11,2,2025-12-18T16:54:46,,borrowed' > test.csv" -ForegroundColor Gray
    Write-Host "    hdfs dfs -put test.csv /library/logs/" -ForegroundColor Gray
}

# 显示菜单
Write-Host ""
Write-Host "[5/5] 选择要运行的任务:" -ForegroundColor Yellow
Write-Host "  1. HotBookJob       - 热门图书统计" -ForegroundColor Cyan
Write-Host "  2. BorrowTrendJob   - 借阅趋势统计" -ForegroundColor Cyan
Write-Host "  3. ReaderBehaviorJob - 读者行为统计" -ForegroundColor Cyan
Write-Host "  4. 运行所有任务" -ForegroundColor Cyan
Write-Host "  0. 退出" -ForegroundColor Gray
Write-Host ""

$choice = Read-Host "请输入选项 (0-4)"

function Run-MapReduceJob {
    param(
        [string]$JobName,
        [string]$JobClass,
        [string]$OutputPath
    )
    
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "  运行任务: $JobName" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    
    # 删除旧的输出目录
    Write-Host "清理旧输出目录..." -ForegroundColor Yellow
    hdfs dfs -rm -r $OutputPath 2>&1 | Out-Null
    
    # 运行任务
    Write-Host "提交 MapReduce 任务..." -ForegroundColor Yellow
    $startTime = Get-Date
    
    hadoop jar $jarPath $JobClass /library/logs $OutputPath
    
    if ($LASTEXITCODE -eq 0) {
        $endTime = Get-Date
        $duration = $endTime - $startTime
        Write-Host ""
        Write-Host "✓ 任务完成！耗时: $($duration.TotalSeconds) 秒" -ForegroundColor Green
        
        # 显示结果
        Write-Host ""
        Write-Host "========================================" -ForegroundColor Cyan
        Write-Host "  任务结果" -ForegroundColor Cyan
        Write-Host "========================================" -ForegroundColor Cyan
        hdfs dfs -cat "$OutputPath/part-r-00000"
        Write-Host ""
    } else {
        Write-Host ""
        Write-Host "✗ 任务失败" -ForegroundColor Red
    }
}

switch ($choice) {
    "1" {
        Run-MapReduceJob -JobName "热门图书统计" `
                        -JobClass "com.example.library.mr.HotBookJob" `
                        -OutputPath "/library/output/hot-books"
    }
    "2" {
        Run-MapReduceJob -JobName "借阅趋势统计" `
                        -JobClass "com.example.library.mr.BorrowTrendJob" `
                        -OutputPath "/library/output/borrow-trend"
    }
    "3" {
        Run-MapReduceJob -JobName "读者行为统计" `
                        -JobClass "com.example.library.mr.ReaderBehaviorJob" `
                        -OutputPath "/library/output/reader-behavior"
    }
    "4" {
        Run-MapReduceJob -JobName "热门图书统计" `
                        -JobClass "com.example.library.mr.HotBookJob" `
                        -OutputPath "/library/output/hot-books"
        
        Run-MapReduceJob -JobName "借阅趋势统计" `
                        -JobClass "com.example.library.mr.BorrowTrendJob" `
                        -OutputPath "/library/output/borrow-trend"
        
        Run-MapReduceJob -JobName "读者行为统计" `
                        -JobClass "com.example.library.mr.ReaderBehaviorJob" `
                        -OutputPath "/library/output/reader-behavior"
    }
    "0" {
        Write-Host "退出" -ForegroundColor Gray
        exit 0
    }
    default {
        Write-Host "无效选项" -ForegroundColor Red
        exit 1
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  完成" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "提示：" -ForegroundColor Yellow
Write-Host "  - 查看所有输出: hdfs dfs -ls /library/output" -ForegroundColor Gray
Write-Host "  - 查看任务日志: yarn logs -applicationId <app_id>" -ForegroundColor Gray
Write-Host "  - 访问前端查看统计: http://localhost:5173/dashboard" -ForegroundColor Gray
Write-Host ""

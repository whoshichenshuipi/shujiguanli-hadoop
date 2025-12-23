# ✅ Hadoop 环境配置成功！

## 🎉 恭喜！你的 Hadoop 环境已经配置完成

### 当前配置

- **Hadoop 版本**: 3.3.6
- **Java 版本**: JDK 17
- **安装路径**: `B:\hadoop\hadoop-3.3.6`
- **JAVA_HOME**: `C:\PROGRA~1\Java\jdk-17` (短路径格式)

### 🚀 快速开始

#### 每次使用前激活环境

```powershell
# 进入项目目录
cd b:\jproject\tushu-hadoop\hadoop-jobs

# 激活 Hadoop 环境（必须）
. .\activate-hadoop.ps1

# 验证
hadoop version
```

#### 运行 MapReduce 任务

```powershell
# 方式 1: 使用交互式脚本（推荐）
.\run-jobs.ps1

# 方式 2: 手动运行单个任务
hadoop jar target/library-hadoop-jobs-0.0.1-SNAPSHOT.jar `
  com.example.library.mr.HotBookJob `
  /library/logs `
  /library/output/hot-books
```

### 📝 重要提示

1. **每次打开新的 PowerShell 窗口都需要激活环境**
   ```powershell
   cd b:\jproject\tushu-hadoop\hadoop-jobs
   . .\activate-hadoop.ps1
   ```

2. **如果遇到 "找不到 hadoop 命令" 错误**
   - 确保已运行 `. .\activate-hadoop.ps1`
   - 或者重新运行 `.\final-fix.ps1`

3. **Windows 上 Hadoop 的限制**
   - HDFS 功能可能受限
   - 建议仅用于开发测试
   - 生产环境推荐使用 Linux 或云服务

### 🔧 故障排除

#### 问题 1: "JAVA_HOME is incorrectly set"
**解决方案**:
```powershell
.\final-fix.ps1
```

#### 问题 2: 命令找不到
**解决方案**:
```powershell
. .\activate-hadoop.ps1
```

#### 问题 3: 权限错误
**解决方案**:
以管理员身份运行 PowerShell

### 📚 下一步

#### 1. 准备测试数据

```powershell
# 创建测试 CSV 文件
@"
1,11,2,2025-12-18T16:54:46,,borrowed
2,12,3,2025-12-09T16:54:46,2025-12-21T16:54:46,returned
3,11,3,2025-12-10T10:00:00,2025-12-15T10:00:00,returned
4,13,2,2025-12-20T14:30:00,,borrowed
5,12,4,2025-12-22T09:15:00,,borrowed
"@ | Out-File -FilePath test_borrow.csv -Encoding UTF8
```

#### 2. 启动 Hadoop（可选 - 用于 HDFS）

```powershell
# 注意：Windows 上启动 Hadoop 可能会遇到问题
# 如果只是运行 MapReduce 任务，可以使用本地文件系统

# 格式化 NameNode（仅第一次）
hdfs namenode -format

# 启动 HDFS
start-dfs.cmd

# 启动 YARN
start-yarn.cmd
```

#### 3. 运行 MapReduce 任务（本地模式）

```powershell
# 使用本地文件系统（推荐用于测试）
hadoop jar target/library-hadoop-jobs-0.0.1-SNAPSHOT.jar `
  com.example.library.mr.HotBookJob `
  file:///b:/jproject/tushu-hadoop/hadoop-jobs/test_borrow.csv `
  file:///b:/jproject/tushu-hadoop/hadoop-jobs/output/hot-books

# 查看结果
Get-Content output\hot-books\part-r-00000
```

### 🎯 完整工作流程示例

```powershell
# 1. 激活环境
cd b:\jproject\tushu-hadoop\hadoop-jobs
. .\activate-hadoop.ps1

# 2. 创建测试数据（如果还没有）
@"
1,11,2,2025-12-18T16:54:46,,borrowed
2,12,3,2025-12-09T16:54:46,2025-12-21T16:54:46,returned
3,11,3,2025-12-10T10:00:00,2025-12-15T10:00:00,returned
"@ | Out-File -FilePath test_data.csv -Encoding UTF8

# 3. 运行热门图书统计
hadoop jar target/library-hadoop-jobs-0.0.1-SNAPSHOT.jar `
  com.example.library.mr.HotBookJob `
  file:///$(Get-Location)/test_data.csv `
  file:///$(Get-Location)/output/hot-books

# 4. 查看结果
Write-Host "`n=== 热门图书统计结果 ===" -ForegroundColor Cyan
Get-Content output\hot-books\part-r-00000

# 5. 运行借阅趋势统计
hadoop jar target/library-hadoop-jobs-0.0.1-SNAPSHOT.jar `
  com.example.library.mr.BorrowTrendJob `
  file:///$(Get-Location)/test_data.csv `
  file:///$(Get-Location)/output/borrow-trend

# 6. 查看结果
Write-Host "`n=== 借阅趋势统计结果 ===" -ForegroundColor Cyan
Get-Content output\borrow-trend\part-r-00000
```

### 📖 相关文档

- **安装指南**: `INSTALL_HADOOP_WINDOWS.md`
- **运行指南**: `RUN.md`
- **激活脚本**: `activate-hadoop.ps1`
- **修复脚本**: `final-fix.ps1`
- **启动脚本**: `run-jobs.ps1`

### 💡 提示

- 使用 `file:///` 协议可以直接在本地文件系统运行 MapReduce，无需启动 HDFS
- 输出目录必须不存在，否则会报错
- 每次运行前删除旧的输出目录：`Remove-Item -Recurse -Force output`

---

**祝你使用愉快！** 🎊

如有问题，请查看故障排除部分或重新运行 `.\final-fix.ps1`

# Hadoop MapReduce 任务运行指南

## 📋 概述

本项目包含 3 个 MapReduce 任务，用于分析图书馆借阅日志数据：

1. **HotBookJob** - 统计热门图书（按借阅次数排序）
2. **BorrowTrendJob** - 统计借阅趋势（按月份统计借阅量）
3. **ReaderBehaviorJob** - 统计读者行为（每个读者的借阅次数）

## 🔧 前置条件

### 1. Hadoop 环境
确保已安装并启动 Hadoop（伪分布式或完全分布式）：

```bash
# 检查 Hadoop 版本
hadoop version

# 启动 Hadoop（伪分布式）
start-dfs.sh
start-yarn.sh

# 验证 HDFS 是否正常
hdfs dfs -ls /
```

### 2. 编译项目
```bash
cd b:\jproject\tushu-hadoop\hadoop-jobs
mvn clean package
```

编译成功后会生成：`target/library-hadoop-jobs-0.0.1-SNAPSHOT.jar`

## 📊 数据格式

MapReduce 任务读取的 CSV 格式借阅日志（由后端 `HdfsLogAppender` 写入）：

```csv
borrowId,bookId,readerId,borrowTime,returnTime,status
1,11,2,2025-12-18T16:54:46,null,borrowed
2,12,3,2025-12-09T16:54:46,2025-12-21T16:54:46,returned
```

## 🚀 运行 MapReduce 任务

### 准备工作

1. **创建 HDFS 目录**：
```bash
hdfs dfs -mkdir -p /library/logs
hdfs dfs -mkdir -p /library/output
```

2. **上传测试数据**（可选，如果后端还没有生成日志）：
```bash
# 创建本地测试数据
echo "1,11,2,2025-12-18T16:54:46,,borrowed" > test_borrow.csv
echo "2,12,3,2025-12-09T16:54:46,2025-12-21T16:54:46,returned" >> test_borrow.csv
echo "3,11,3,2025-12-10T10:00:00,2025-12-15T10:00:00,returned" >> test_borrow.csv

# 上传到 HDFS
hdfs dfs -put test_borrow.csv /library/logs/
```

### 任务 1: 热门图书统计 (HotBookJob)

统计每本图书的借阅次数：

```bash
# 删除旧的输出目录（如果存在）
hdfs dfs -rm -r /library/output/hot-books

# 运行任务
hadoop jar target/library-hadoop-jobs-0.0.1-SNAPSHOT.jar \
  com.example.library.mr.HotBookJob \
  /library/logs \
  /library/output/hot-books

# 查看结果
hdfs dfs -cat /library/output/hot-books/part-r-00000
```

**输出示例**：
```
11	2
12	1
```
（表示：图书ID 11 被借阅 2 次，图书ID 12 被借阅 1 次）

### 任务 2: 借阅趋势统计 (BorrowTrendJob)

按月份统计借阅量：

```bash
# 删除旧的输出目录
hdfs dfs -rm -r /library/output/borrow-trend

# 运行任务
hadoop jar target/library-hadoop-jobs-0.0.1-SNAPSHOT.jar \
  com.example.library.mr.BorrowTrendJob \
  /library/logs \
  /library/output/borrow-trend

# 查看结果
hdfs dfs -cat /library/output/borrow-trend/part-r-00000
```

**输出示例**：
```
2025-12	3
```
（表示：2025年12月有 3 次借阅）

### 任务 3: 读者行为统计 (ReaderBehaviorJob)

统计每个读者的借阅次数：

```bash
# 删除旧的输出目录
hdfs dfs -rm -r /library/output/reader-behavior

# 运行任务
hadoop jar target/library-hadoop-jobs-0.0.1-SNAPSHOT.jar \
  com.example.library.mr.ReaderBehaviorJob \
  /library/logs \
  /library/output/reader-behavior

# 查看结果
hdfs dfs -cat /library/output/reader-behavior/part-r-00000
```

**输出示例**：
```
2	1
3	2
```
（表示：读者ID 2 借阅 1 次，读者ID 3 借阅 2 次）

## 🔄 与后端集成

### 后端自动写入日志到 HDFS

后端 Spring Boot 应用在每次借阅/归还操作时，会通过 `HdfsLogAppender` 自动将日志追加到 HDFS：

```
/library/logs/borrow_2025-12-23.csv
/library/logs/borrow_2025-12-24.csv
...
```

### 定期运行 MapReduce 任务

可以使用 cron 或 Hadoop 的 Oozie 来定期运行这些任务：

```bash
# 示例：每天凌晨 2 点运行热门图书统计
0 2 * * * /path/to/run_hot_book_job.sh
```

## 📝 常见问题

### 1. 如果 Hadoop 未安装

这些 MapReduce 任务需要 Hadoop 环境。如果本地没有 Hadoop：

- **选项 A**：安装 Hadoop 伪分布式（推荐用于开发测试）
  - Windows: 使用 WSL2 或虚拟机
  - Linux/Mac: 参考 [Hadoop 官方文档](https://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-common/SingleCluster.html)

- **选项 B**：使用云服务（如 AWS EMR、阿里云 MaxCompute）

- **选项 C**：本地模拟运行（仅用于测试）
  ```bash
  # 设置为本地模式
  export HADOOP_CONF_DIR=/path/to/local/conf
  hadoop jar target/library-hadoop-jobs-0.0.1-SNAPSHOT.jar \
    com.example.library.mr.HotBookJob \
    file:///path/to/local/input \
    file:///path/to/local/output
  ```

### 2. 权限问题

如果遇到 HDFS 权限错误：

```bash
# 修改目录权限
hdfs dfs -chmod -R 777 /library
```

### 3. 查看任务日志

```bash
# 查看 YARN 应用列表
yarn application -list

# 查看特定应用的日志
yarn logs -applicationId <application_id>
```

## 🎯 下一步

1. **将 MapReduce 结果导入 MySQL**：
   - 编写脚本读取 HDFS 输出文件
   - 插入到 `stat_book_popular`、`stat_reader_behavior` 表

2. **前端展示统计结果**：
   - 访问 `http://localhost:5173/dashboard`
   - 查看 ECharts 图表展示

3. **优化任务性能**：
   - 使用 Combiner 减少网络传输
   - 调整 Reducer 数量
   - 启用压缩

## 📚 参考资料

- [Hadoop MapReduce 教程](https://hadoop.apache.org/docs/stable/hadoop-mapreduce-client/hadoop-mapreduce-client-core/MapReduceTutorial.html)
- [HDFS 命令指南](https://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-common/FileSystemShell.html)
- [YARN 资源管理](https://hadoop.apache.org/docs/stable/hadoop-yarn/hadoop-yarn-site/YARN.html)

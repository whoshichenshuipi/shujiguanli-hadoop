# 环境搭建速览（伪分布式可运行）

## 1. 准备
- JDK 1.8+
- Maven 3.8+
- MySQL 8（库名 `library_db`）
- Hadoop 3.3.x（伪分布式即可）

## 2. 初始化数据库
```bash
mysql -u root -p
CREATE DATABASE library_db DEFAULT CHARACTER SET utf8mb4;
-- 执行 /backend 下的 DDL（见 README 或 application.yml 中的库名）
```

## 3. Hadoop 伪分布式
核心配置示例：
```
core-site.xml: fs.defaultFS=hdfs://localhost:9000
hdfs-site.xml: dfs.replication=1
```
启动：
```bash
start-dfs.sh
hdfs dfs -mkdir -p /library/logs /library/out
```

## 4. 启动后端
```bash
cd backend
mvn package
java -jar target/library-backend-0.0.1-SNAPSHOT.jar
```

## 5. 运行 MapReduce 任务
```bash
cd hadoop-jobs
mvn package
hadoop jar target/library-hadoop-jobs-0.0.1-SNAPSHOT.jar \
  com.example.library.mr.HotBookJob /library/logs /library/out/hot_book
```
`BorrowTrendJob` 与 `ReaderBehaviorJob` 同理。

## 6. 前端开发
参考 `frontend/README.md` 使用 Vite + Vue3 + ElementPlus + ECharts，开发时代理到 `http://localhost:8080`.


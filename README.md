# tushu-hadoop

基于 Spring Boot + Vue + Hadoop (HDFS+MapReduce) + MySQL 的图书管理与大数据统计示例。聚焦核心功能：图书/读者管理、借阅归还、HDFS 日志采集、MapReduce 统计（热门图书、借阅趋势、读者行为）。

## 目录
- `backend/` Spring Boot 可运行后端（REST + HDFS 追加日志）
- `hadoop-jobs/` MapReduce 任务源码（打 jar 提交）
- `frontend/` Vue 前端骨架说明
- `docs/SETUP.md` 快速部署说明

## 快速开始
1) 配置 MySQL，执行 `backend` 的 DDL（见 `application.yml` 库名 `library_db`）。  
2) 启动 Hadoop 伪分布式，创建 `/library/logs`。  
3) 运行后端：`cd backend && mvn package && java -jar target/library-backend-0.0.1-SNAPSHOT.jar`。  
4) 运行 MR：`cd hadoop-jobs && mvn package && hadoop jar target/...HotBookJob /library/logs /library/out/hot_book`。  
5) 前端参考 `frontend/README.md`。

## 关键端点
- `GET /api/books`、`POST /api/books`
- `GET /api/readers`、`POST /api/readers`
- `POST /api/borrow`（借阅）、`POST /api/borrow/return/{id}`（归还）
- `GET /api/stat/hot-books`、`GET /api/stat/reader-behavior`


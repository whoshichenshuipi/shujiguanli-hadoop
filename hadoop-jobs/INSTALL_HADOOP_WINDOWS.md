# Windows 上安装配置 Hadoop 3.3.6 指南

## 📋 概述

本指南将帮助你在 Windows 上安装和配置 Hadoop 3.3.6 伪分布式环境。

## ⚠️ 重要提示

**Hadoop 在 Windows 上的运行并不是官方推荐的方式**。如果可能，建议使用以下替代方案：

### 推荐替代方案

1. **WSL2 (Windows Subsystem for Linux)** ⭐ 推荐
   - 在 Windows 上运行完整的 Linux 环境
   - Hadoop 运行更稳定
   - 配置更简单

2. **Docker Desktop**
   - 使用 Hadoop Docker 镜像
   - 一键启动，无需复杂配置

3. **虚拟机 (VirtualBox/VMware)**
   - 安装 Ubuntu/CentOS
   - 完整的 Linux 环境

4. **云服务**
   - 阿里云 MaxCompute
   - AWS EMR
   - Azure HDInsight

## 🔧 方案 1: 使用 WSL2 (推荐)

### 步骤 1: 安装 WSL2

```powershell
# 以管理员身份运行 PowerShell

# 启用 WSL
wsl --install

# 重启电脑后，安装 Ubuntu
wsl --install -d Ubuntu-22.04

# 进入 WSL
wsl
```

### 步骤 2: 在 WSL 中安装 Hadoop

```bash
# 更新系统
sudo apt update && sudo apt upgrade -y

# 安装 Java
sudo apt install openjdk-8-jdk -y

# 验证 Java 安装
java -version

# 下载 Hadoop
cd ~
wget https://dlcdn.apache.org/hadoop/common/hadoop-3.3.6/hadoop-3.3.6.tar.gz

# 解压
tar -xzf hadoop-3.3.6.tar.gz
sudo mv hadoop-3.3.6 /usr/local/hadoop

# 配置环境变量
echo 'export HADOOP_HOME=/usr/local/hadoop' >> ~/.bashrc
echo 'export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin' >> ~/.bashrc
echo 'export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64' >> ~/.bashrc
source ~/.bashrc

# 验证安装
hadoop version
```

### 步骤 3: 配置 Hadoop 伪分布式

```bash
# 配置 hadoop-env.sh
echo 'export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64' >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh

# 配置 core-site.xml
cat > $HADOOP_HOME/etc/hadoop/core-site.xml << 'EOF'
<?xml version="1.0"?>
<configuration>
    <property>
        <name>fs.defaultFS</name>
        <value>hdfs://localhost:9000</value>
    </property>
</configuration>
EOF

# 配置 hdfs-site.xml
cat > $HADOOP_HOME/etc/hadoop/hdfs-site.xml << 'EOF'
<?xml version="1.0"?>
<configuration>
    <property>
        <name>dfs.replication</name>
        <value>1</value>
    </property>
    <property>
        <name>dfs.namenode.name.dir</name>
        <value>file:///home/hadoop/data/namenode</value>
    </property>
    <property>
        <name>dfs.datanode.data.dir</name>
        <value>file:///home/hadoop/data/datanode</value>
    </property>
</configuration>
EOF

# 创建数据目录
mkdir -p ~/data/namenode
mkdir -p ~/data/datanode

# 配置 SSH 免密登录
sudo apt install openssh-server -y
sudo service ssh start
ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

# 格式化 NameNode
hdfs namenode -format

# 启动 Hadoop
start-dfs.sh

# 验证
hdfs dfs -ls /
```

### 步骤 4: 在 WSL 中运行 MapReduce 任务

```bash
# 创建 HDFS 目录
hdfs dfs -mkdir -p /library/logs
hdfs dfs -mkdir -p /library/output

# 从 Windows 访问 WSL 文件
# Windows 路径: \\wsl$\Ubuntu-22.04\home\<username>

# 复制 JAR 文件到 WSL
# 在 Windows PowerShell 中:
# cp b:\jproject\tushu-hadoop\hadoop-jobs\target\*.jar \\wsl$\Ubuntu-22.04\home\<username>\

# 在 WSL 中运行任务
hadoop jar library-hadoop-jobs-0.0.1-SNAPSHOT.jar \
  com.example.library.mr.HotBookJob \
  /library/logs \
  /library/output/hot-books
```

## 🐳 方案 2: 使用 Docker (简单快速)

### 步骤 1: 安装 Docker Desktop

1. 下载并安装 [Docker Desktop for Windows](https://www.docker.com/products/docker-desktop/)
2. 启动 Docker Desktop

### 步骤 2: 运行 Hadoop 容器

```powershell
# 拉取 Hadoop 镜像
docker pull apache/hadoop:3.3.6

# 运行 Hadoop 容器
docker run -d --name hadoop-dev `
  -p 9870:9870 `
  -p 8088:8088 `
  -p 9000:9000 `
  -v b:\jproject\tushu-hadoop\hadoop-jobs:/opt/hadoop-jobs `
  apache/hadoop:3.3.6

# 进入容器
docker exec -it hadoop-dev bash

# 在容器内运行 MapReduce 任务
cd /opt/hadoop-jobs
hadoop jar target/library-hadoop-jobs-0.0.1-SNAPSHOT.jar \
  com.example.library.mr.HotBookJob \
  /library/logs \
  /library/output/hot-books
```

## 💻 方案 3: 原生 Windows 安装 (不推荐)

如果你坚持在原生 Windows 上安装 Hadoop，请按以下步骤操作：

### 前置要求

1. **Java JDK 8**
   ```powershell
   # 检查 Java 版本
   java -version
   
   # 如果没有，下载安装 JDK 8
   # https://www.oracle.com/java/technologies/javase/javase8-archive-downloads.html
   ```

2. **配置 JAVA_HOME**
   ```powershell
   # 设置环境变量
   [System.Environment]::SetEnvironmentVariable('JAVA_HOME', 'C:\Program Files\Java\jdk1.8.0_xxx', 'Machine')
   ```

### 安装步骤

#### 1. 下载 Hadoop

```powershell
# 创建安装目录
New-Item -Path "C:\hadoop" -ItemType Directory -Force

# 下载 Hadoop 3.3.6
# 访问: https://dlcdn.apache.org/hadoop/common/hadoop-3.3.6/
# 下载: hadoop-3.3.6.tar.gz

# 解压到 C:\hadoop
# 使用 7-Zip 或 WinRAR 解压
```

#### 2. 下载 Windows 补丁文件

```powershell
# Hadoop 需要额外的 Windows 二进制文件
# 下载 winutils.exe 和 hadoop.dll

# 访问: https://github.com/cdarlint/winutils
# 下载对应版本的文件到 C:\hadoop\hadoop-3.3.6\bin\
```

#### 3. 配置环境变量

```powershell
# 设置 HADOOP_HOME
[System.Environment]::SetEnvironmentVariable('HADOOP_HOME', 'C:\hadoop\hadoop-3.3.6', 'Machine')

# 添加到 PATH
$path = [System.Environment]::GetEnvironmentVariable('Path', 'Machine')
$newPath = $path + ';C:\hadoop\hadoop-3.3.6\bin;C:\hadoop\hadoop-3.3.6\sbin'
[System.Environment]::SetEnvironmentVariable('Path', $newPath, 'Machine')

# 重启 PowerShell 使环境变量生效
```

#### 4. 配置 Hadoop

编辑配置文件（位于 `C:\hadoop\hadoop-3.3.6\etc\hadoop\`）：

**core-site.xml**:
```xml
<configuration>
    <property>
        <name>fs.defaultFS</name>
        <value>hdfs://localhost:9000</value>
    </property>
</configuration>
```

**hdfs-site.xml**:
```xml
<configuration>
    <property>
        <name>dfs.replication</name>
        <value>1</value>
    </property>
    <property>
        <name>dfs.namenode.name.dir</name>
        <value>file:///C:/hadoop/data/namenode</value>
    </property>
    <property>
        <name>dfs.datanode.data.dir</name>
        <value>file:///C:/hadoop/data/datanode</value>
    </property>
</configuration>
```

**hadoop-env.cmd**:
```cmd
set JAVA_HOME=C:\Program Files\Java\jdk1.8.0_xxx
```

#### 5. 格式化并启动

```powershell
# 创建数据目录
New-Item -Path "C:\hadoop\data\namenode" -ItemType Directory -Force
New-Item -Path "C:\hadoop\data\datanode" -ItemType Directory -Force

# 格式化 NameNode
hdfs namenode -format

# 启动 HDFS (需要管理员权限)
start-dfs.cmd

# 验证
hdfs dfs -ls /
```

## 🎯 推荐方案对比

| 方案 | 难度 | 稳定性 | 性能 | 推荐度 |
|------|------|--------|------|--------|
| WSL2 | ⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| Docker | ⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ |
| 原生 Windows | ⭐⭐⭐⭐⭐ | ⭐⭐ | ⭐⭐ | ⭐ |
| 云服务 | ⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ |

## 📝 我的建议

**对于你的项目，我强烈推荐使用 WSL2 方案**，原因如下：

1. ✅ 配置简单，一次性完成
2. ✅ 稳定性高，完全兼容 Hadoop
3. ✅ 可以直接访问 Windows 文件系统
4. ✅ 性能接近原生 Linux
5. ✅ 便于开发和调试

## 🚀 快速开始 (WSL2)

```powershell
# 1. 安装 WSL2
wsl --install

# 2. 重启电脑

# 3. 打开 Ubuntu 终端，运行安装脚本
# (我可以为你生成一个自动化安装脚本)
```

需要我帮你：
1. 生成 WSL2 自动化安装脚本？
2. 配置 Docker 方案？
3. 还是继续尝试原生 Windows 安装？

请告诉我你的选择，我会提供详细的步骤指导！

@echo off
REM Hadoop Wrapper Script for Windows
REM This script sets JAVA_HOME before calling hadoop

set JAVA_HOME=C:\Program Files\Java\jdk-17
set HADOOP_HOME=B:\hadoop\hadoop-3.3.6
set PATH=%HADOOP_HOME%\bin;%HADOOP_HOME%\sbin;%PATH%

REM Call the actual hadoop command
"%HADOOP_HOME%\bin\hadoop.cmd" %*

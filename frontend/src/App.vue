<template>
  <el-container class="app-container">
    <el-header class="header">
      <div class="brand">图书管理 · Hadoop统计</div>
      <el-menu mode="horizontal" router :default-active="activePath" class="menu">
        <el-menu-item index="/books">图书管理</el-menu-item>
        <el-menu-item index="/readers">读者管理</el-menu-item>
        <el-menu-item index="/borrow">借阅归还</el-menu-item>
        <el-menu-item index="/dashboard">统计看板</el-menu-item>
      </el-menu>
    </el-header>
    <el-main>
      <router-view />
    </el-main>
  </el-container>
</template>

<script setup>
import { computed } from 'vue';
import { useRoute } from 'vue-router';

const route = useRoute();
const activePath = computed(() => route.path);
</script>

<style scoped>
.app-container {
  height: 100vh;
}

.header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  border-bottom: 1px solid #dcdfe6;
  padding: 0 20px;
  background-color: #fff;
}

.brand {
  font-weight: 600;
  font-size: 1.2rem;
  color: #409eff;
  margin-right: 40px;
}

.menu {
  flex-grow: 1;
  border-bottom: none !important;
}

.el-main {
  background-color: #f5f7fa;
  padding: 20px;
}
</style>

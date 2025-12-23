<template>
  <el-card>
    <div class="toolbar">
      <el-button type="primary" @click="openForm()">新增读者</el-button>
    </div>
    <el-table :data="readers" size="small" style="width:100%">
      <el-table-column prop="id" label="ID" width="80"/>
      <el-table-column prop="name" label="姓名"/>
      <el-table-column prop="phone" label="电话"/>
      <el-table-column prop="email" label="邮箱"/>
      <el-table-column prop="type" label="类型"/>
      <el-table-column label="操作" width="160">
        <template #default="scope">
          <el-button size="small" @click="openForm(scope.row)">编辑</el-button>
          <el-button size="small" type="danger" @click="remove(scope.row)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
  </el-card>

  <el-dialog v-model="visible" title="读者信息" width="480px">
    <el-form :model="form">
      <el-form-item label="姓名"><el-input v-model="form.name"/></el-form-item>
      <el-form-item label="电话"><el-input v-model="form.phone"/></el-form-item>
      <el-form-item label="邮箱"><el-input v-model="form.email"/></el-form-item>
      <el-form-item label="类型"><el-input v-model="form.type" placeholder="student/teacher/other"/></el-form-item>
    </el-form>
    <template #footer>
      <el-button @click="visible=false">取消</el-button>
      <el-button type="primary" @click="submit">保存</el-button>
    </template>
  </el-dialog>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { listReaders, saveReader, updateReader, deleteReader } from '../api';

const readers = ref([]);
const visible = ref(false);
const form = ref({});

const load = async () => { readers.value = await listReaders(); };

const openForm = (row) => {
  form.value = row ? { ...row } : {};
  visible.value = true;
};

const submit = async () => {
  if (form.value.id) await updateReader(form.value.id, form.value);
  else await saveReader(form.value);
  visible.value = false;
  await load();
};

const remove = async (row) => {
  await deleteReader(row.id);
  await load();
};

onMounted(load);
</script>

<style scoped>
.toolbar { margin-bottom: 12px; }
</style>


<template>
  <el-row :gutter="16">
    <el-col :span="10">
      <el-card>
        <h3>借阅/归还</h3>
        <el-form :model="form">
          <el-form-item label="图书ID">
            <el-input v-model="form.bookId" />
          </el-form-item>
          <el-form-item label="读者ID">
            <el-input v-model="form.readerId" />
          </el-form-item>
          <el-form-item label="应还时间">
            <el-date-picker v-model="form.dueTime" type="datetime" />
          </el-form-item>
        </el-form>
        <el-button type="primary" @click="doBorrow">借阅</el-button>
      </el-card>
    </el-col>
    <el-col :span="14">
      <el-card>
        <h3>借阅记录</h3>
        <el-table :data="records" size="small" style="width:100%">
          <el-table-column prop="id" label="ID" width="80"/>
          <el-table-column prop="book.id" label="图书ID"/>
          <el-table-column prop="reader.id" label="读者ID"/>
          <el-table-column prop="borrowTime" label="借出时间"/>
          <el-table-column prop="returnTime" label="归还时间"/>
          <el-table-column prop="status" label="状态"/>
          <el-table-column label="操作" width="120">
            <template #default="scope">
              <el-button size="small" type="success" :disabled="scope.row.status==='returned'" @click="doReturn(scope.row)">归还</el-button>
            </template>
          </el-table-column>
        </el-table>
      </el-card>
    </el-col>
  </el-row>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { listBorrow, borrowBook, returnBook } from '../api';

const form = ref({ dueTime: '' });
const records = ref([]);

const load = async () => { records.value = await listBorrow(); };

const doBorrow = async () => {
  await borrowBook({
    bookId: form.value.bookId,
    readerId: form.value.readerId,
    dueTime: form.value.dueTime
  });
  await load();
};

const doReturn = async (row) => {
  await returnBook(row.id);
  await load();
};

onMounted(load);
</script>


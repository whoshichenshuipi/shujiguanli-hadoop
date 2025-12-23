<template>
  <el-card>
    <div class="toolbar">
      <el-button type="primary" @click="openForm()">新增图书</el-button>
    </div>
    <el-table :data="books" style="width: 100%" size="small">
      <el-table-column prop="id" label="ID" width="80" />
      <el-table-column prop="isbn" label="ISBN" />
      <el-table-column prop="title" label="书名" />
      <el-table-column prop="author" label="作者" />
      <el-table-column prop="category.name" label="分类" />
      <el-table-column label="操作" width="160">
        <template #default="scope">
          <el-button size="small" @click="openForm(scope.row)">编辑</el-button>
          <el-button size="small" type="danger" @click="remove(scope.row)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
  </el-card>

  <el-dialog v-model="visible" title="图书信息" width="500px">
    <el-form :model="form">
      <el-form-item label="ISBN">
        <el-input v-model="form.isbn" />
      </el-form-item>
      <el-form-item label="书名">
        <el-input v-model="form.title" />
      </el-form-item>
      <el-form-item label="作者">
        <el-input v-model="form.author" />
      </el-form-item>
      <el-form-item label="分类ID">
        <el-input v-model="form.categoryId" />
      </el-form-item>
    </el-form>
    <template #footer>
      <el-button @click="visible=false">取消</el-button>
      <el-button type="primary" @click="submit">保存</el-button>
    </template>
  </el-dialog>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { listBooks, saveBook, updateBook, deleteBook } from '../api';

const books = ref([]);
const visible = ref(false);
const form = ref({});

const load = async () => {
  books.value = await listBooks();
};

const openForm = (row) => {
  form.value = row ? {
    id: row.id,
    isbn: row.isbn,
    title: row.title,
    author: row.author,
    categoryId: row.category?.id
  } : {};
  visible.value = true;
};

const submit = async () => {
  const payload = {
    isbn: form.value.isbn,
    title: form.value.title,
    author: form.value.author,
    category: { id: form.value.categoryId }
  };
  if (form.value.id) {
    await updateBook(form.value.id, payload);
  } else {
    await saveBook(payload);
  }
  visible.value = false;
  await load();
};

const remove = async (row) => {
  await deleteBook(row.id);
  await load();
};

onMounted(load);
</script>

<style scoped>
.toolbar {
  margin-bottom: 12px;
}
</style>


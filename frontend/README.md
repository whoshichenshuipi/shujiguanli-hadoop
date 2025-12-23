# Vue 前端最小骨架

建议使用 Vite + Vue3 + ElementPlus + ECharts：

```bash
npm create vite@latest frontend -- --template vue
cd frontend
npm install element-plus echarts axios
npm run dev
```

核心页面建议：
- `views/Books.vue`：图书 CRUD（表格 + 弹窗）
- `views/Readers.vue`：读者 CRUD
- `views/Borrow.vue`：借阅/归还操作、记录列表
- `views/Dashboard.vue`：热门图书 TopN 柱状图、借阅趋势折线图、读者活跃度条形图

API 示例（`src/api/request.ts` 封装 axios 后）：
```ts
export const listBooks = (params?: any) => request.get('/api/books', { params });
export const saveBook = (data: any) => request.post('/api/books', data);
export const updateBook = (id: number, data: any) => request.put(`/api/books/${id}`, data);
export const deleteBook = (id: number) => request.delete(`/api/books/${id}`);
export const borrow = (data: any) => request.post('/api/borrow', data);
export const returnBook = (id: number) => request.post(`/api/borrow/return/${id}`);
export const statHotBooks = (params?: any) => request.get('/api/stat/hot-books', { params });
export const statBorrowTrend = (params?: any) => request.get('/api/stat/borrow-trend', { params });
export const statReaderBehavior = (params?: any) => request.get('/api/stat/reader-behavior', { params });
```

ECharts 例子：
```ts
const option = {
  tooltip: { trigger: 'axis' },
  xAxis: { type: 'category', data: data.map(d => d.title || d.key) },
  yAxis: { type: 'value' },
  series: [{ type: 'bar', data: data.map(d => d.borrowCnt || d.value) }]
};
```


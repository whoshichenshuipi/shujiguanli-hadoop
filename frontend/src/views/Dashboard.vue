<template>
  <el-row :gutter="16">
    <el-col :span="12">
      <el-card>
        <h3>热门图书 TopN</h3>
        <div ref="hotRef" style="height:320px"></div>
      </el-card>
    </el-col>
    <el-col :span="12">
      <el-card>
        <h3>借阅趋势</h3>
        <div ref="trendRef" style="height:320px"></div>
      </el-card>
    </el-col>
  </el-row>
  <el-row :gutter="16" style="margin-top:16px">
    <el-col :span="12">
      <el-card>
        <h3>读者活跃度</h3>
        <div ref="readerRef" style="height:320px"></div>
      </el-card>
    </el-col>
  </el-row>
</template>

<script setup>
import { onMounted, ref } from 'vue';
import * as echarts from 'echarts';
import { statHotBooks, statBorrowTrend, statReaderBehavior } from '../api';

const hotRef = ref();
const trendRef = ref();
const readerRef = ref();

const renderHot = (data) => {
  const chart = echarts.init(hotRef.value);
  chart.setOption({
    xAxis: { type: 'category', data: data.map(d => d.book?.title || d.book?.id) },
    yAxis: { type: 'value' },
    tooltip: { trigger: 'axis' },
    series: [{ type: 'bar', data: data.map(d => d.borrowCnt || 0) }]
  });
};

const renderTrend = (data) => {
  const chart = echarts.init(trendRef.value);
  chart.setOption({
    xAxis: { type: 'category', data: data.map(d => d.period || d.key) },
    yAxis: { type: 'value' },
    tooltip: { trigger: 'axis' },
    series: [{ type: 'line', data: data.map(d => d.value || d.count || 0) }]
  });
};

const renderReader = (data) => {
  const chart = echarts.init(readerRef.value);
  chart.setOption({
    xAxis: { type: 'category', data: data.map(d => d.reader?.id) },
    yAxis: { type: 'value' },
    tooltip: { trigger: 'axis' },
    series: [{ type: 'bar', data: data.map(d => d.borrowCnt || 0) }]
  });
};

onMounted(async () => {
  const hot = await statHotBooks();
  const trend = await statBorrowTrend();
  const reader = await statReaderBehavior();
  renderHot(hot || []);
  renderTrend(trend || []);
  renderReader(reader || []);
});
</script>


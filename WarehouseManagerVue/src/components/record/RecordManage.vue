<template>
    <div class="record-page">
      <div style="margin-bottom: 5px">
        <el-input
          v-model="name"
          placeholder="请输入物品名"
          suffix-icon="el-icon-a-042"
          style="width: 200px"
          @keyup.enter.native="loadPost"
        ></el-input>
        <el-select
          v-model="storage"
          placeholder="请选择仓库"
          style="margin-left: 5px"
        >
          <el-option
            v-for="item in storageData"
            :key="item.id"
            :label="item.name"
            :value="item.id"
          >
          </el-option>
        </el-select>
        <el-select
          v-model="goodstype"
          placeholder="请选择分类"
          style="margin-left: 5px"
        >
          <el-option
            v-for="item in goodstypeData"
            :key="item.id"
            :label="item.name"
            :value="item.id"
          >
          </el-option>
        </el-select>
        <el-button
          type="primary"
          style="margin-left: 5px; font-size: 18px"
          @click="loadPost"
        >
          查询</el-button
        >
        <el-button
          type="warning"
          style="font-size: 18px"
          @click="resetParam"
        >
          重置</el-button
        >
      </div>
      <div class="table-pagination-container">
        <div class="table">
            <el-table
            :data="tableData"
            :header-cell-style="{ background: '#f2f5fc', color: '#555555' }"
            border
            >
            <el-table-column prop="id" label="ID" width="60"></el-table-column>
            <el-table-column prop="goodsname" label="物品名" width="150"></el-table-column>
            <el-table-column prop="storagename" label="仓库" width="150"></el-table-column>
            <el-table-column prop="goodstypename" label="分类" width="150"></el-table-column>
            <el-table-column prop="adminname" label="操作人" width="150"></el-table-column>
            <el-table-column prop="username" label="申请人" width="150"></el-table-column>
            <el-table-column prop="count" label="数量" width="150"></el-table-column>
            <el-table-column prop="createtime" label="操作时间" width="180"></el-table-column>
            <el-table-column prop="remark" label="备注"></el-table-column>
            </el-table>
        </div>
        <div class="pagination-size" style="margin-top: 5px; margin-left: 30%;">
            <el-pagination
            @size-change="handleSizeChange"
            @current-change="handleCurrentChange"
            :current-page="pageNum"
            :page-sizes="[5, 10, 20, 30]"
            :page-size="pageSize"
            layout="total, sizes, prev, pager, next, jumper"
            :total="total"
            ></el-pagination>
        </div>
        <div class="chart-container">
            <div id="chart-in" style="width: 600px; height: 400px;"></div>
            <div id="chart-out" style="width: 600px; height: 400px;"></div>
        </div>
      </div>
    </div>
</template>

<script>
import * as echarts from 'echarts';

export default {
  name: "RecordManage",
  data() {
    return {
      user: JSON.parse(sessionStorage.getItem("CurUser")),
      storageData: [],
      goodstypeData: [],
      tableData: [],
      pageSize: 10,
      pageNum: 1,
      total: 0,
      name: "",
      storage: "",
      goodstype: "",
      chartIn: null,
      chartOut: null,
      centerDialogVisible: false,
      form: {
        id: "",
        name: "",
        storage: "",
        goodstype: "",
        count: "",
        remark: "",
      },
    };
  },
  methods: {
    formatStorage(row) {
      let temp = this.storageData.find((item) => {
        return item.id == row.storage;
      });

      return temp && temp.name;
    },
    formatGoodstype(row) {
      let temp = this.goodstypeData.find((item) => {
        return item.id == row.goodstype;
      });

      return temp && temp.name;
    },
    resetForm() {
      this.$refs.form.resetFields();
    },
    handleSizeChange(val) {
      console.log(`每页 ${val} 条`);
      this.pageNum = 1;
      this.pageSize = val;
      this.loadPost();
    },
    handleCurrentChange(val) {
      console.log(`当前页: ${val}`);
      this.pageNum = val;
      this.loadPost();
    },
    resetParam() {
      this.name = "";
      this.storage = "";
      this.goodstype = "";
    },
    loadStorage() {
      this.$axios
        .get(this.$httpUrl + "/storage/list")
        .then((res) => res.data)
        .then((res) => {
          console.log(res);
          if (res.code == 200) {
            this.storageData = res.data;
          } else {
            alert("获取数据失败");
          }
        });
    },
    loadGoodstype() {
      this.$axios
        .get(this.$httpUrl + "/goodstype/list")
        .then((res) => res.data)
        .then((res) => {
          console.log(res);
          if (res.code == 200) {
            this.goodstypeData = res.data;
          } else {
            alert("获取数据失败");
          }
        });
    },
    loadPost() {
      this.$axios
        .post(this.$httpUrl + "/record/listPage", {
          pageSize: this.pageSize,
          pageNum: this.pageNum,
          param: {
            name: this.name,
            goodstype: this.goodstype + "",
            storage: this.storage + "",
            roleId: this.user.roleId + "",
            userId: this.user.id + "",
          },
        })
        .then((res) => res.data)
        .then((res) => {
          console.log(res);
          if (res.code == 200) {
            this.tableData = res.data;
            this.total = res.total;
            this.createChart();
          } else {
            alert("获取数据失败");
          }
        });
    },
    createChart() {
      if (!this.chartIn) {
        this.chartIn = echarts.init(document.getElementById('chart-in'));
      }
      if (!this.chartOut) {
        this.chartOut = echarts.init(document.getElementById('chart-out'));
      }

      const dataIn = {};
      const dataOut = {};
      this.tableData.forEach(item => {
        if (item.count > 0) {
          if (!dataIn[item.goodsname]) {
            dataIn[item.goodsname] = 0;
          }else{}
          dataIn[item.goodsname] += item.count;
        } else {
          if (!dataOut[item.goodsname]) {
            dataOut[item.goodsname] = 0;
          }
          dataOut[item.goodsname] += Math.abs(item.count);
        }
      });

      const chartDataIn = Object.keys(dataIn).map(key => ({
        name: key,
        value: dataIn[key]
      }));
      const chartDataOut = Object.keys(dataOut).map(key => ({
        name: key,
        value: dataOut[key]
      }));

      const optionIn = {
        title: {
          text: '入库',
          left: 'center'
        },
        tooltip: {
          trigger: 'item'
        },
        legend: {
          orient: 'vertical',
          left: 'left'
        },
        series: [
          {
            name: '入库数量',
            type: 'pie',
            radius: '50%',
            data: chartDataIn,
            emphasis: {
              itemStyle: {
                shadowBlur: 10,
                shadowOffsetX: 0,
                shadowColor: 'rgba(0, 0, 0, 0.5)'
              }
            }
          }
        ]
      };

      const optionOut = {
        title: {
          text: '出库',
          left: 'center'
        },
        tooltip: {
          trigger: 'item'
        },
        legend: {
          orient: 'vertical',
          left: 'left'
        },
        series: [
          {
            name: '出库数量',
            type: 'pie',
            radius: '50%',
            data: chartDataOut,
            emphasis: {
              itemStyle: {
                shadowBlur: 10,
                shadowOffsetX: 0,
                shadowColor: 'rgba(0, 0, 0, 0.5)'
              }
            }
          }
        ]
      };

      this.chartIn.setOption(optionIn);
      this.chartOut.setOption(optionOut);
    }
  },
  beforeMount() {
    this.loadStorage();
    this.loadGoodstype();
    this.loadPost();
  }
};
</script>

<style scoped>
.table {
   max-height: 320px; 
   overflow-y: auto;
   &::-webkit-scrollbar {
    width: 5px; 
  }

  &::-webkit-scrollbar-track {
    background: transparent; 
  }

  &::-webkit-scrollbar-thumb {
    background: rgba(0, 0, 0, 0.1); 
    border-radius: 5px; 
  }

  &::-webkit-scrollbar-thumb:hover {
    background: rgba(0, 0, 0, 0.2);
  }
}
.record-page {
  overflow: auto;
  height: 610px;
  &::-webkit-scrollbar {
    width: 0; 
  }

  &::-webkit-scrollbar-track {
    background: transparent; 
  }

  &::-webkit-scrollbar-thumb {
    background: rgba(0, 0, 0, 0.1); 
    border-radius: 5px; 
  }

  &::-webkit-scrollbar-thumb:hover {
    background: rgba(0, 0, 0, 0.2);
  }
}
.chart-container {
  display: flex;
  justify-content: space-between;
  margin-top: 50px;
  margin-left: 5%;
}
</style>
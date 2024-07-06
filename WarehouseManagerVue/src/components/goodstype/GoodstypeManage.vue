<template>
    <div>
        <div style="margin-bottom: 5px">
            <el-input
                v-model="name"
                placeholder="请输入分类名"
                suffix-icon="el-icon-a-042"
                style="width: 200px"
                @keyup.enter.native="loadPost"
            ></el-input>
            <el-button
                type="primary"
                style="margin-left: 5px; font-size: 18px"
                @click="loadPost"
            >
                查询</el-button
            >
            <el-button
                type="warning"
                @click="resetParam"
                style="font-size: 18px"
            >
                重置</el-button
            >

            <el-button
                type="primary"
                style="margin-left: 5px; font-size: 18px"
                @click="add"
            >
                新增</el-button
            >
        </div>
        <div class="table">
            <el-table
                :data="tableData"
                :header-cell-style="{ background: '#f2f5fc', color: '#555555' }"
                border
            >
                <el-table-column prop="id" label="ID" width="60"> </el-table-column>
                <el-table-column prop="name" label="分类名" width="180">
                </el-table-column>
                <el-table-column prop="remark" label="备注"> </el-table-column>
                <el-table-column
                    prop="operate"
                    label="操作"
                    width="240"
                    fixed="right"
                >
                    <template slot-scope="scope">
                        <el-button
                            style="font-size: 18px"
                            type="success"
                            @click="mod(scope.row)"
                        >
                            编辑</el-button
                        >
                        <el-popconfirm
                            title="确定删除吗？"
                            @confirm="del(scope.row.id)"
                            style="margin-left: 5px"
                        >
                            <el-button
                                slot="reference"
                                style="font-size: 18px"
                                type="danger"
                            >
                                删除</el-button
                            >
                        </el-popconfirm>
                    </template>
                </el-table-column>
            </el-table>
        </div>
        <div calss="pagination-size" style="margin-top: 5px; right: 36%; overflow: hidden; position: fixed;">
            <el-pagination
                @size-change="handleSizeChange"
                @current-change="handleCurrentChange"
                :current-page="pageNum"
                :page-sizes="[5, 10, 20, 30]"
                :page-size="pageSize"
                layout="total, sizes, prev, pager, next, jumper"
                :total="total"
            >
            </el-pagination>
        </div>

        <el-dialog
            title="提示"
            :visible.sync="centerDialogVisible"
            width="30%"
            center
        >
            <el-form ref="form" :rules="rules" :model="form" label-width="80px">
                <el-form-item label="分类名" prop="name">
                    <el-col :span="20">
                        <el-input v-model="form.name"></el-input>
                    </el-col>
                </el-form-item>
                <el-form-item label="备注" prop="remark">
                    <el-col :span="20">
                        <el-input
                            type="textarea"
                            v-model="form.remark"
                        ></el-input>
                    </el-col>
                </el-form-item>
            </el-form>
            <span slot="footer" class="dialog-footer">
                <el-button
                    @click="centerDialogVisible = false"
                    style="font-size: 18px"
                    >
                    取 消</el-button
                >
                <el-button type="primary" @click="save" style="font-size: 18px"
                    >
                    确 定</el-button
                >
            </span>
        </el-dialog>
    </div>
</template>

<script>
export default {
    name: "GoodstypeManage",
    data() {
        return {
            tableData: [],
            pageSize: 10,
            pageNum: 1,
            total: 0,
            name: "",
            centerDialogVisible: false,
            form: {
                id: "",
                name: "",
                remark: "",
            },
            rules: {
                name: [
                    {
                        required: true,
                        message: "请输入分类名",
                        trigger: "blur",
                    },
                ],
            },
        };
    },
    methods: {
        resetForm() {
            this.$refs.form.resetFields();
        },
        del(id) {
            console.log(id);

            this.$axios
                .get(this.$httpUrl + "/goodstype/del?id=" + id)
                .then((res) => res.data)
                .then((res) => {
                    console.log(res);
                    if (res.code == 200) {
                        this.$message({
                            message: "操作成功！",
                            type: "success",
                        });
                        this.loadPost();
                    } else {
                        this.$message({
                            message: "操作失败！",
                            type: "error",
                        });
                    }
                });
        },
        mod(row) {
            this.centerDialogVisible = true;
            this.$nextTick(() => {
                //赋值到表单
                this.form.id = row.id;
                this.form.name = row.name;
                this.form.remark = row.remark;
            });
        },
        add() {
            this.centerDialogVisible = true;
            this.$nextTick(() => {
                this.resetForm();
            });
        },
        doSave() {
            this.$axios
                .post(this.$httpUrl + "/goodstype/save", this.form)
                .then((res) => res.data)
                .then((res) => {
                    console.log(res);
                    if (res.code == 200) {
                        this.$message({
                            message: "操作成功！",
                            type: "success",
                        });
                        this.centerDialogVisible = false;
                        this.loadPost();
                        this.resetForm();
                    } else {
                        this.$message({
                            message: "操作失败！",
                            type: "error",
                        });
                    }
                });
        },
        doMod() {
            this.$axios
                .post(this.$httpUrl + "/goodstype/update", this.form)
                .then((res) => res.data)
                .then((res) => {
                    console.log(res);
                    if (res.code == 200) {
                        this.$message({
                            message: "操作成功！",
                            type: "success",
                        });
                        this.centerDialogVisible = false;
                        this.loadPost();
                        this.resetForm();
                    } else {
                        this.$message({
                            message: "操作失败！",
                            type: "error",
                        });
                    }
                });
        },
        save() {
            this.$refs.form.validate((valid) => {
                if (valid) {
                    if (this.form.id) {
                        this.doMod();
                    } else {
                        this.doSave();
                    }
                } else {
                    console.log("error submit!!");
                    return false;
                }
            });
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
        },
        loadPost() {
            this.$axios
                .post(this.$httpUrl + "/goodstype/listPage", {
                    pageSize: this.pageSize,
                    pageNum: this.pageNum,
                    param: {
                        name: this.name,
                    },
                })
                .then((res) => res.data)
                .then((res) => {
                    console.log(res);
                    if (res.code == 200) {
                        this.tableData = res.data;
                        this.total = res.total;
                    } else {
                        alert("获取数据失败");
                    }
                });
        },
    },
    beforeMount() {
        this.loadPost();
    },
};
</script>

<style scoped>
.table {
   max-height: 500px; 
   overflow-y: auto;
   &::-webkit-scrollbar {
    width: 6px; 
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
</style>
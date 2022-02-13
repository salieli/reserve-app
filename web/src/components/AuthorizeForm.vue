<template>
<div>
    <el-dialog :title="`授权${user.name}`" :visible.sync="visible" center>
        <el-form label-width="100px" center>
            <el-form-item label="设置为管理员:" v-if="isSuperuser">
                <el-radio-group v-model="isStaff">
                    <el-radio label="1">是</el-radio>
                    <el-radio label="0">否</el-radio>
                </el-radio-group>
            </el-form-item>
            <el-form-item label="只能查看场地:">
                <el-select v-model="placeList" multiple placeholder="请选择该用户只能查看的场地" @remove-tag="removeTag">
                    <el-option v-for="item in placeOption" :key="item.id" :label="item.name" :value="item.id" :disabled="item.disabled">
                    </el-option>
                </el-select>
            </el-form-item>
        </el-form>
        <span slot="footer" class="dialog-footer">
            <el-button @click="hide(false)">取 消</el-button>
            <el-button type="primary" @click="onSubmit">确 定</el-button>
        </span>
    </el-dialog>
</div>
</template>

<script>
export default {
    props: {
        isSuperuser: Boolean,
        placeListOption: Array,
        visible: Boolean,
        user: Object,
    },
    watch: {
        user(newUser) {
            this.isStaff = newUser.isStaff === true ? "1" : "0";
            this.placeList = newUser.placeIdList;

            let placeOptionIdList = this.placeListOption.map(v => {
                return v.id
            });
            let list = this.allPlaceList.filter(v => (this.placeList.indexOf(v.id) != -1 && placeOptionIdList.indexOf(v.id) === -1)).map(v => {
                v.disabled = true;
                return v;
            });
            this.placeOption = list.concat(this.placeListOption);
        }
    },
    data() {
        return {
            placeOption: this.placeListOption,
            isStaff: this.user.isStaff === true ? "1" : "0",
            placeList: this.user.placeIdList,
            ownPlaceIdList: [],
            allPlaceList: []
        }
    },
    async mounted() {
        await this.$exec(async () => {
            this.ownPlaceIdList = await this.$exec(async () => await this.$PlaceManager.getPlaceList(), false, false) || [];
            this.allPlaceList = await this.$exec(async () => await this.$PlaceManager.getAll(), false, false) || [];
        });
    },
    methods: {
        async onSubmit() {
            let res = await this.$exec(async () => await this.$UserManager.authorize({
                isStaff: this.isStaff === "1" ? true : false,
                userId: this.user.id,
                placeIdList: this.placeList.length > 0 ? this.placeList.join(",") : '0'
            }));

            if (res) {
                this.hide(true);
            }
        },
        hide(changed) {
            this.$emit("hide", changed);
        },
        removeTag(tag) {
            let canRemoved = false;
            this.ownPlaceIdList.forEach(e => {
                if (e.id === tag) {
                    canRemoved = true;
                }
            });

            if (!canRemoved) {
                this.$message.warning("没有该场地操作权限！");
                this.placeList = this.placeList.concat([tag]);
            }

        }
    }
}
</script>

<style scoped>
.el-select {
    width: 90%;
}
</style>

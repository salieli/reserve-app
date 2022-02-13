<template>
<div class="image-content">
    <div class="image-content-title">主页图片修改</div>
    <el-upload action="https://jsonplaceholder.typicode.com/posts/" ref="upload" list-type="picture-card" :on-success="uploadSuccess" :http-request="httpRequest" accept="image/jpeg,image/gif,image/png" multiple :file-list="fileList" :auto-upload="false" :on-preview="handlePictureCardPreview" :before-upload="beforeUploadFile" :on-remove="handleRemove">
        <i class="el-icon-plus"></i>
    </el-upload>
    <el-button size="small" type="primary" @click="uploadFile">立即上传</el-button>
    <el-dialog :visible.sync="dialogVisible">
        <img width="100%" :src="dialogImageUrl" alt="">
    </el-dialog>
</div>
</template>

<script>
export default {
    props: {
        data: Object,
    },
    data() {
        return {
            fileList: this.data.content,
            formData: [],
            dialogImageUrl: '',
            dialogVisible: false
        };
    },
    methods: {
        beforeUploadFile(file) {
            if (file.size / 1024 / 1024 > 2) {
                this.$message.warning('上传文件不超过2M');
                return false;
            }
            let ext = file.name.substring(file.name.lastIndexOf('.') + 1);
            const extension =
                ext === 'jpeg' ||
                ext === 'gif' ||
                ext === 'png' ||
                ext === 'jpg'
            if (!extension) {
                this.$message.warning('上传文件格式只能为jpeg、gif、png');
                return false;
            }

            if (this.formData.length == 0) {
                this.formData = new FormData();
            }
            this.formData.append('file', file);
        },
        async httpRequest(opt) {
            let res = await this.$exec(async () => await this.$ContentManager.uploadImage(this.formData));
        },
        uploadFile() {
            this.$refs.upload.submit();
        },
        async uploadSuccess(response, file, fileList) {
            let list = await this.$exec(async () => await this.$ContentManager.getAll());
            this.fileList = (list[1].content.split("|")).map(v => {
                return {
                    url: v
                }
            });
        },
        async handleRemove(file, fileList) {
            if (file.status === "success") {
                await this.$exec(async () => await this.$ContentManager.deleteImage(file.url));
            }
        },
        handlePictureCardPreview(file) {
            this.dialogImageUrl = file.url;
            this.dialogVisible = true;
        }
    }
}
</script>

<style>
.el-upload--picture-card {
    margin-bottom: 8px;
}

.image-content {
    width: 80%;
}

.image-content-title {
    padding-bottom: 20px;
    font-size: 2rem;

}

.image-list {
    display: flex;
}
</style>

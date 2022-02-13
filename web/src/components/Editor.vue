<template>
<div class="wrapper">
    <div class="editor-title">场地使用须知编辑</div>
    <div class="input-wrapper">
        <quill-editor class="editor" v-model="content" :options="editorOption" ref="myQuillEditor">
        </quill-editor>
    </div>
    <div class="editor-btn">
        <el-button type="primary" @click="submit" size="small">提交修改</el-button>
    </div>

</div>
</template>

<script>
export default {
    props: {
        data: Object,
    },
    components: {},
    data() {
        return {
            content: this.data.content,
            editorOption: {
                modules: {
                    toolbar: [
                        ["bold", "italic", "underline", "strike"], // 加粗 斜体 下划线 删除线
                        ["blockquote", "code-block"], // 引用  代码块
                        [{
                            header: 1
                        }, {
                            header: 2
                        }], // 1、2 级标题
                        [{
                            list: "ordered"
                        }, {
                            list: "bullet"
                        }], // 有序、无序列表
                        [{
                            script: "sub"
                        }, {
                            script: "super"
                        }], // 上标/下标
                        [{
                            indent: "-1"
                        }, {
                            indent: "+1"
                        }], // 缩进
                        // [{'direction': 'rtl'}],                         // 文本方向
                        [{
                            size: ["small", false, "large", "huge"]
                        }], // 字体大小
                        [{
                            header: [1, 2, 3, 4, 5, 6, false]
                        }], // 标题
                        [{
                            color: []
                        }, {
                            background: []
                        }], // 字体颜色、字体背景颜色
                        [{
                            font: []
                        }], // 字体种类
                        [{
                            align: []
                        }], // 对齐方式
                        ["clean"], // 清除文本格式
                    ], //工具菜单栏配置
                },
                placeholder: '请在这里添加描述', //提示
                readyOnly: false, //是否只读
                theme: 'snow', //主题 snow/bubble
                syntax: true, //语法检测
            }
        }
    },

    methods: {
        async submit() {
            await this.$exec(async () => await this.$ContentManager.update(this.data.id, this.content), "更新成功");
        }
    }
}
</script>

<style>

@media screen and (min-width: 800px) {
    .input-wrapper {
        width: 70%;
    }

}

@media screen and (max-width: 800px) {
    .input-wrapper {
        width: 100%;
    }
}

.editor {
    line-height: normal !important;
}

.editor-btn {
    margin-top: 10px;
}

.ql-container {
    height: 400px !important;
}

.editor-title {
    font-size: 2rem;
    padding: 0 0 20px 0;
}

.ql-snow .ql-tooltip.ql-editing a.ql-action::after {
    border-right: 0px;
    content: '保存';
    padding-right: 0px;
}

.ql-snow .ql-picker.ql-size .ql-picker-label::before,
.ql-snow .ql-picker.ql-size .ql-picker-item::before {
    content: '14px' !important;
}

.ql-snow .ql-picker.ql-size .ql-picker-label[data-value=small]::before,
.ql-snow .ql-picker.ql-size .ql-picker-item[data-value=small]::before {
    content: '10px' !important;
}

.ql-snow .ql-picker.ql-size .ql-picker-label[data-value=large]::before,
.ql-snow .ql-picker.ql-size .ql-picker-item[data-value=large]::before {
    content: '18px' !important;
}

.ql-snow .ql-picker.ql-size .ql-picker-label[data-value=huge]::before,
.ql-snow .ql-picker.ql-size .ql-picker-item[data-value=huge]::before {
    content: '32px' !important;
}

.ql-snow .ql-picker.ql-header .ql-picker-label::before,
.ql-snow .ql-picker.ql-header .ql-picker-item::before {
    content: '普通文本' !important;
}

.ql-snow .ql-picker.ql-header .ql-picker-label[data-value="1"]::before,
.ql-snow .ql-picker.ql-header .ql-picker-item[data-value="1"]::before {
    content: '标题1' !important;
}

.ql-snow .ql-picker.ql-header .ql-picker-label[data-value="2"]::before,
.ql-snow .ql-picker.ql-header .ql-picker-item[data-value="2"]::before {
    content: '标题2' !important;
}

.ql-snow .ql-picker.ql-header .ql-picker-label[data-value="3"]::before,
.ql-snow .ql-picker.ql-header .ql-picker-item[data-value="3"]::before {
    content: '标题3' !important;
}

.ql-snow .ql-picker.ql-header .ql-picker-label[data-value="4"]::before,
.ql-snow .ql-picker.ql-header .ql-picker-item[data-value="4"]::before {
    content: '标题4' !important;
}

.ql-snow .ql-picker.ql-header .ql-picker-label[data-value="5"]::before,
.ql-snow .ql-picker.ql-header .ql-picker-item[data-value="5"]::before {
    content: '标题5' !important;
}

.ql-snow .ql-picker.ql-header .ql-picker-label[data-value="6"]::before,
.ql-snow .ql-picker.ql-header .ql-picker-item[data-value="6"]::before {
    content: '标题6' !important;
}

.ql-snow .ql-picker.ql-font .ql-picker-label::before,
.ql-snow .ql-picker.ql-font .ql-picker-item::before {
    content: '标准字体' !important;
}

.ql-snow .ql-picker.ql-font .ql-picker-label[data-value=serif]::before,
.ql-snow .ql-picker.ql-font .ql-picker-item[data-value=serif]::before {
    content: '衬线字体' !important;
}

.ql-snow .ql-picker.ql-font .ql-picker-label[data-value=monospace]::before,
.ql-snow .ql-picker.ql-font .ql-picker-item[data-value=monospace]::before {
    content: '等宽字体' !important;
}
</style>

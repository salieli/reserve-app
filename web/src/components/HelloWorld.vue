<template>
  <div :class="`${bgColor + ' box-border-radius'}`">
    <div class="el-card-header-1 text-white text-mmd">
      <div style="display: flex; align-items: center">
        <span>{{ reserveData.place }} </span>
      </div>
      <el-date-picker
        v-model="usageDate"
        type="date"
        style="float: right; padding: 3px 0"
        value-format="yyyy-MM-dd"
        :default-value="usageDate"
        :size="`${screenWidth < 550 ? 'mini' : 'medium'}`"
      >
      </el-date-picker>
    </div>
    <div class="el-card-body">
      <el-row :gutter="20" v-if="typeof reserveData.list != 'string'">
        <el-col :xs="12" :sm="6" v-for="o in reserveData.list" :key="o.username"
          ><span class="info"
            >{{ o.username }} {{ o.usageStartTime }}~{{ o.usageEndTime }}
            <div class="tip" v-if="isAdmin">
              {{ o.usageReason }}
              <div class="popper__arrow"></div></div
          ></span>
        </el-col>
      </el-row>
      <el-row v-else> 无预约 </el-row>
    </div>
  </div>
</template>

<script>
export default {
  name: "HelloWorld",
  props: {
    isAdmin: Boolean,
    reserveData: Object,
    bgColor: String,
  },
  mounted() {
    window.addEventListener("resize", () => {
      this.screenWidth = document.body.offsetWidth;
    });
  },
  data() {
    return {
      pickerOptions: {
        disabledDate(time) {
          const date = new Date();
          date.setTime(date.getTime() + 3600 * 1000 * 24 * 14);
          return time.getTime() < Date.now() || time.getTime() > date.getTime();
        },
      },
      usageDate: new Date(),
      screenWidth: document.documentElement.clientWidth,
    };
  },
  methods: {},
  watch: {
    async usageDate(newUsageDate) {
      let res = await this.$exec(
        async () =>
          await this.$ReserveManager.getReserveData(
            new Date(newUsageDate).toLocaleDateString().split("/").join("-"),
            this.reserveData.placeId
          ),
        false
      );
      if (res) {
        this.reserveData.list = res;
      }
    },
  },
};
</script>

<style>
@media (min-width: 550px) {
  .text-mmd {
    font-size: 2rem;
  }

  .el-card-header-1 {
    padding: 10px 20px;
  }

  .el-card-body {
    padding: 20px;
  }
}
@media (max-width: 550px) {
  .el-message-box {
    width: auto;
  }

  .el-dialog {
    width: 90%;
  }
  .text-mmd {
    font-size: 1rem;
  }
  .el-card-header-1 {
    padding: 5px;
  }

  .el-select,
  .el-date-editor.el-input,
  .el-date-editor.el-input__inner,
  .el-textarea__inner {
    width: 130px;
  }

  .el-card-body {
    padding: 10px;
  }
}
.box-border-radius {
  box-shadow: 0 2px 12px 0 rgb(0 0 0 / 10%);
  border-radius: 3px;
}

.el-card-header-1 {
  border-bottom: 1px solid #ebeef5;
  display: flex;
  justify-content: space-between;
}

.text-white {
  color: white;
}

.el-col {
  margin-top: 8px;
  margin-bottom: 8px;
}
.info {
  position: relative;
}
.tip {
  display: none;
  position: absolute;
  width: 100px;
  top: 130%;
  left: 50%;
  background-color: white;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
  word-break: break-all;
  transform: translateX(-50%);
  border-radius: 4px;
  border: 1px solid #000;
  padding: 12px;
  z-index: 88;
  color: #606266;
  line-height: 1.4;
  text-align: justify;
  transition: 0.5s;
}

.popper__arrow {
  border-width: 6px;
  filter: drop-shadow(0 2px 12px rgba(0, 0, 0, 0.03));
}
.info:hover .tip {
  display: block;
}

.popper__arrow,
.popper__arrow:after {
  position: absolute;
  display: block;
  width: 0;
  height: 0;
  border-color: transparent;
  border-style: solid;
}
.popper__arrow {
  top: -6px;
  left: 46%;
  margin-right: 3px;
  border-top-width: 0;
  border-bottom-color: #000;
}
.popper__arrow:after {
  content: " ";
  border-width: 6px;
}
.popper__arrow:after {
  top: 1px;
  margin-left: -6px;
  border-top-width: 0;
  border-bottom-color: #fff;
}

.bg-red {
  box-shadow: 0 0 1px 2px #e63a00;
}
.bg-red > .el-card-header-1 {
  background-color: #e63a00;
}
.bg-gray {
  box-shadow: 0 0 1px 2px #ccbdb8;
}
.bg-gray > .el-card-header-1 {
  background-color: #ccbdb8;
}
</style>

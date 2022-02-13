<template>
<div id="app">
    <div id="overlay"></div>
    <Calendar v-on:showForm="displayForm(true)" />
    <ReserveForm v-if="!min && showReserveForm" class="reserve-form" v-on:closeForm="displayForm(false)" :data="data" v-on:refresh="refresh" />
    <ReserveFormMin v-else-if="min && showReserveForm" class="reserve-form" v-on:closeForm="displayForm(false)" :data="data" v-on:refresh="refresh" />
</div>
</template>

<script>
import Calendar from "@/components/Calendar.vue";
import ReserveForm from "@/components/ReserveForm.vue";
import ReserveFormMin from "@/components/ReserveFormMin.vue";

export default {
    name: "app",
    components: {
        Calendar,
        ReserveForm,
        ReserveFormMin
    },
    data() {
        return {
            showReserveForm: false,
            screenWidth: document.body.clientWidth,
            data: {}
        };
    },
    computed: {
        min: {
            get() {
                return this.screenWidth < 750
            },
            set() {}
        },
    },
    watch: {
        screenWidth(val) {
            this.screenWidth = val;
            if (this.screenWidth < 750) {
                this.min = true;
            } else {
                this.min = false;
            }
        }
    },
    async mounted() {

        window.onresize = () => {
            return (() => {
                this.screenWidth = document.body.clientWidth;
            })()
        }
    },
    methods: {
        displayForm(show) {
            this.showReserveForm = show;
            document.body.style.overflow = show ? "hidden" : "";
            document.querySelector("#overlay").style.display = show ?
                "block" :
                "none";
        },
    }
};
</script>

<style>
html {
    height: 100vh;
}

body {
    font-weight: 300;
    font-size: 15px;
    color: #333;
    height: 100%;
}

#app {
    width: 100%;
    height: 100%;
}

#overlay {
    background: #000;
    filter: alpha(opacity=50);
    opacity: 0.5;
    display: none;
    position: absolute;
    top: 0px;
    left: 0px;
    width: 100%;
    height: 100%;
    z-index: 100;
    display: none;
}

.reserve-form {
    top: 50%;
    z-index: 1999;
    position: fixed;
    background-color: white;
    left: 50%;
    transform: translateX(-50%) translateY(-50%);
}
</style>

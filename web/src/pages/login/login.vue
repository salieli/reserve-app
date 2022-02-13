<template>
	<div id="app">
		<Login />
		<CopyRight />
	</div>
</template>

<script>
import Login from "@/components/LoginNew.vue";
import CopyRight from "@/components/CopyRight.vue";

export default {
	name: "app",
	components: {
		Login,
		CopyRight,
	},
};
</script>

<style>
html {
	font-size: 62.5%;
}
body {
	font-family: "Avenir", Helvetica, Arial, sans-serif;
	-webkit-font-smoothing: antialiased;
	-moz-osx-font-smoothing: grayscale;
	font-size: 1.4rem;
	margin: 0;
	overflow: hidden;
	height: 100vh;
}
#app {
	height: 100%;
}
</style>

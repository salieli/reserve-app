<template>
	<div id="app">
		<el-container style="height:100%; border: 1px solid #eee">
			<el-header style="font-size: 12px;height:initial; border-bottom: 1px solid #ebebeb;">
				<HeaderBar />
			</el-header>
			<el-container style="height:calc(100% - 161px);">
				<el-aside style="background-color: rgb(238, 241, 246);overflow-x:hidden;">
					<LeftMenu :active="active" />
				</el-aside>
				<el-container>
					<el-main style="padding-top:20px;">
						<div class="index-contain">
							<div style="display:flex;flex-direction:column;width:800px">
								<div style="position:relative">
									<div class="carousel-card">
										<el-carousel
											trigger="click"
											:autoplay="true"
										>
											<el-carousel-item
												v-for="item in imageList"
												:key="item.url"
											>
												<img
													:src="item.url"
													class="img"
												/>
											</el-carousel-item>
										</el-carousel>
									</div>
								</div>

								<el-card class="notice-card">
									<div
										slot="header"
										class="clearfix"
									>
										<span class="solid-border">场地使用须知</span>
									</div>
									<div>
										<NoticeContent
											v-if="noticeData"
											:data="noticeData"
										/>
									</div>
								</el-card>
							</div>
							<div class="index-place-list">
								<el-card class="place-card">
									<div
										slot="header"
										class="clearfix"
									>
										<span class="solid-border">场地列表</span>
									</div>
									<div
										v-for="o in list"
										:key="o.id"
										class="text item"
										@click="onTap(o)"
									>
										{{o.name}}
									</div>
								</el-card>
							</div>
						</div>
					</el-main>
				</el-container>
			</el-container>
		</el-container>
	</div>
</template>

<script>
import HeaderBar from "@/components/HeaderBar.vue";
import LeftMenu from "@/components/LeftMenu.vue";
import NoticeContent from "@/components/NoticeContent.vue";
// import * as Fake from "@/common/fakeData.js";

export default {
	name: "app",
	components: {
		HeaderBar,
		LeftMenu,
		NoticeContent
	},
	data() {
		return {
			active: "-1",
			imageList: [],
			list: [],
			noticeData: null
		};
	},
	async mounted() {
		await this.$exec(async () => {
			this.list = await this.$exec(async () => await this.$PlaceManager.getPlaceList(), false, false) || [];
			let content = await this.$exec(async () => await this.$ContentManager.getAll(), false, false);
			this.noticeData = content[0].content;
			this.imageList = (content[1].content.split('|')).map(v => {
				return {
					url: v
				}
			});
		})

		// this.list = Fake.placeList();
		// this.noticeData = Fake.notice();

		// this.imageList = (Fake.imageList().split('|')).map(v => {
		//     return {
		//         url: v
		//     }
		// });

	},
	methods: {
		onTap(o) {
			sessionStorage.setItem("place", JSON.stringify(o));
			window.location.href = "reserve";
		}
	}
};
</script>

<style>
.solid-border {
	display: inline-block;
	height: 45px;
	padding: 0 10px;
	font-weight: bold;
	line-height: 49px;
	font-size: 1.6rem;
	color: #409eff;
	border: 2px #409eff solid;
}

.el-carousel {
	position: absolute !important;
	width: 100%;
	height: 100%;
	padding: 5px;
	box-sizing: border-box;
}

.carousel-card {
	border: 1px solid #ebeef5;
	background-color: #fff;
	color: #303133;
	transition: 0.3s;
	box-shadow: 0 2px 12px 0 rgb(0 0 0 / 10%);
}

.index-contain {
	display: flex;
	flex-wrap: wrap;
	align-items: stretch;
}

.el-carousel__container {
	height: 100% !important;
}

.el-carousel__item h3 {
	color: #475669;
	font-size: 18px;
	opacity: 0.75;
	line-height: 300px;
	margin: 0;
}

.text {
	font-size: 1.3rem;
}
.text:hover {
	font-size: 1.4rem;
	color: #409eff;
}
.item {
	margin-bottom: 18px;
	cursor: pointer;
	border-bottom: 1px #eee solid;
}

.clearfix:before,
.clearfix:after {
	display: table;
	content: "";
}

.clearfix:after {
	clear: both;
}

html {
	height: 100vh;
}

@media only screen and (min-width: 550px) {
	html {
		font-size: 62.5% !important;
	}
}

@media only screen and (max-width: 550px) {
	html {
		font-size: 40% !important;
	}
}

body {
	font-family: "Avenir", Helvetica, Arial, sans-serif;
	-webkit-font-smoothing: antialiased;
	-moz-osx-font-smoothing: grayscale;
	font-size: 1.4rem;
	margin: 0;
	height: 100%;
	overflow: hidden;
}

#app {
	width: 100%;
	height: 100%;
}

.img {
	width: 100%;
	height: 100%;
	max-width: 100%;
	max-height: 100%;
	display: block;
	margin: auto;
}

@media (min-width: 1135px) {
	.place-card {
		margin-left: 20px;
	}

	.place-card {
		max-width: 480px;
		height: 100%;
	}

	.notice-card {
		margin-top: 20px;
		width: 100%;
	}
}

.place-card {
	height: 100%;
}

.carousel-card {
	width: 100%;
	height: 0;
	padding-bottom: 50%;
}

@media (max-width: 1135px) {
	.place-card {
		margin-left: 0;
		margin-top: 20px;
		max-width: 800px;
		width: 100%;
	}

	.notice-card {
		margin-top: 20px;
		width: 100%;
	}
}

/* 
@media (max-width: 1135px) {

    .place-card {
        margin-top: 20px;
        width: 100%;
        margin-left: 0;
    }
} */

.index-place-list {
	flex: 1;
}

@media (max-width: 550px) {
	.el-aside {
		width: auto !important;
	}

	.el-main {
		padding: 0 10px 10px 10px !important;
	}

	.margin-bottom-item {
		margin-bottom: 10px;
	}

	.notice-card,
	.place-card {
		margin-top: 10px;
	}
}

@media (min-width: 550px) {
	.el-aside {
		width: 200px !important;
	}

	.margin-bottom-item {
		margin-bottom: 20px;
	}
}

.el-card__header {
	padding: 0 !important;
}
</style>

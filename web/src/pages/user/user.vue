<template>
	<div id="app">
		<el-container style="height: 100%; border: 1px solid #eee">
			<el-header style="font-size: 12px; height: initial; border-bottom: 1px solid #ebebeb">
				<HeaderBar />
			</el-header>
			<el-container style="height: calc(100% - 161px)">
				<el-aside style="background-color: rgb(238, 241, 246); overflow-x: hidden">
					<LeftMenu :active="active" />
				</el-aside>
				<el-container>
					<el-header style="font-size: 2rem; height: 30px; margin-top: 20px">
						用户管理<span class="text-md text-gray">
							<el-button
								style="padding: 3px 0; width: auto"
								type="text"
								@click="dialogFormVisible = true"
							>添加用户</el-button>
						</span>
						<UserIdentity :user="user" />
					</el-header>
					<el-main style="padding-top: 10px">
						<ManagerItem
							v-for="o in list"
							:key="o.id"
							:data="o"
							class="margin-bottom-item"
							v-on:refresh="dataChange"
							:user="user"
							:isUser="true"
							v-on:showAuthorizeDialog="showAuthorizeDialog"
						/>
					</el-main>
				</el-container>
			</el-container>
		</el-container>

		<el-dialog
			title="添加用户"
			:visible.sync="dialogFormVisible"
		>
			<el-form
				:model="form"
				:rules="rules"
				ref="form"
			>
				<el-form-item
					label="用户名称"
					required
					prop="name"
				>
					<el-input
						v-model="form.name"
						autocomplete="off"
						placeholder="输入用户名，密码默认123456"
					></el-input>
				</el-form-item>
			</el-form>
			<div
				slot="footer"
				class="dialog-footer"
			>
				<el-button @click="dialogFormVisible = false">取 消</el-button>
				<el-button
					type="primary"
					@click="submitForm('form')"
				>确 定</el-button>
			</div>
		</el-dialog>

		<AuthorizeForm
			:placeListOption="placeListOption"
			:visible="authorizeDialogVisible"
			v-on:hide="hideAuthorizeDialog"
			:user="otherUser"
			:isSuperuser="user.isSuperuser"
		/>
	</div>
</template>

<script>
import ManagerItem from "@/components/ManagerItem.vue";
import LeftMenu from "@/components/LeftMenu.vue";
import HeaderBar from "@/components/HeaderBar.vue";
import AuthorizeForm from "@/components/AuthorizeForm.vue";
import UserIdentity from "@/components/UserIdentity.vue";
import EventBus from "@/common/eventBus.js";

export default {
	name: "app",
	components: {
		ManagerItem,
		LeftMenu,
		HeaderBar,
		AuthorizeForm,
		UserIdentity,
	},
	data() {
		return {
			user: {},
			otherUser: {},
			active: "2-2",
			list: [],
			placeListOption: [],
			authorizeDialogVisible: false,
			dialogFormVisible: false,
			form: {
				name: "",
			},
			rules: {
				name: [
					{
						required: true,
						message: "请输入用户名",
						trigger: "blur",
					},
				],
			},
		};
	},
	created() {
		EventBus.$on("setUser", (args) => {
			this.user = args
		});
	},
	async mounted() {
		await this.$exec(async () => {
			await this.getData(false);
			this.placeListOption =
				(await this.$exec(
					async () => await this.$PlaceManager.getPlaceList(),
					false,
					false
				)) || [];
		});

		// this.user = Util.fakeUser();
		// let res = Util.fakeUserList(10);
		// this.list = res
		//     .filter((v) => v.isStaff === true)
		//     .concat(res.filter((v) => v.isStaff === false));
	},
	methods: {
		async dataChange() {
			await this.getData();
		},
		async hideAuthorizeDialog(changed) {
			this.authorizeDialogVisible = false;
			if (changed) {
				await this.getData();
			}
		},
		showAuthorizeDialog(user) {
			this.authorizeDialogVisible = true;
			this.otherUser = user;
		},
		async getData(loading = true) {
			let res = await this.$exec(
				async () => await this.$UserManager.getAll(),
				false,
				loading
			);
			if (res) {
				this.list = res
					.filter((v) => v.isStaff === true)
					.concat(res.filter((v) => v.isStaff === false && v.placeIdList.length > 0))
					.concat(res.filter((v) => v.isStaff === false && v.placeIdList.length === 0));
			}
		},
		async submitForm(formName) {
			this.$refs[formName].validate(async (valid) => {
				if (valid) {
					let res = await this.$exec(
						async () => await this.$UserManager.add(this.form.name),
						"添加用户成功"
					);
					if (res) {
						this.$refs[formName].resetFields();
						this.getData();
					}
				} else {
					console.log("error submit!!");
					return false;
				}
			});
		},
	},
};
</script>

<style>
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
	height: 100%;
}

.el-pagination {
	text-align: center;
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
}

@media (min-width: 550px) {
	.el-aside {
		width: 200px !important;
	}

	.margin-bottom-item {
		margin-bottom: 20px;
	}
}
</style>

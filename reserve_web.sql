/*
 Navicat Premium Data Transfer

 Source Server         : localhost_3306
 Source Server Type    : MySQL
 Source Server Version : 80028
 Source Host           : localhost:3306
 Source Schema         : reserve_web

 Target Server Type    : MySQL
 Target Server Version : 80028
 File Encoding         : 65001

 Date: 13/02/2022 23:06:02
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for account_login_log
-- ----------------------------
DROP TABLE IF EXISTS `account_login_log`;
CREATE TABLE `account_login_log`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `login_time` datetime(6) NOT NULL,
  `ip` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3704 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of account_login_log
-- ----------------------------
INSERT INTO `account_login_log` VALUES (3708, '高级管理员', '2022-02-13 23:00:50.712229', '127.0.0.1', '注销成功');
INSERT INTO `account_login_log` VALUES (3709, '校团委', '2022-02-13 23:01:00.168083', '127.0.0.1', '密码错误');
INSERT INTO `account_login_log` VALUES (3710, '高级管理员', '2022-02-13 23:01:30.369395', '127.0.0.1', '登录成功');
INSERT INTO `account_login_log` VALUES (3711, '高级管理员', '2022-02-13 23:03:41.283674', '127.0.0.1', '注销成功');

-- ----------------------------
-- Table structure for auth_group
-- ----------------------------
DROP TABLE IF EXISTS `auth_group`;
CREATE TABLE `auth_group`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `name`(`name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of auth_group
-- ----------------------------

-- ----------------------------
-- Table structure for auth_group_permissions
-- ----------------------------
DROP TABLE IF EXISTS `auth_group_permissions`;
CREATE TABLE `auth_group_permissions`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `group_id` int(0) NOT NULL,
  `permission_id` int(0) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `auth_group_permissions_group_id_permission_id_0cd325b0_uniq`(`group_id`, `permission_id`) USING BTREE,
  INDEX `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm`(`permission_id`) USING BTREE,
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of auth_group_permissions
-- ----------------------------

-- ----------------------------
-- Table structure for auth_permission
-- ----------------------------
DROP TABLE IF EXISTS `auth_permission`;
CREATE TABLE `auth_permission`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `content_type_id` int(0) NOT NULL,
  `codename` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `auth_permission_content_type_id_codename_01ab375a_uniq`(`content_type_id`, `codename`) USING BTREE,
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 44 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of auth_permission
-- ----------------------------
INSERT INTO `auth_permission` VALUES (1, 'Can add log entry', 1, 'add_logentry');
INSERT INTO `auth_permission` VALUES (2, 'Can change log entry', 1, 'change_logentry');
INSERT INTO `auth_permission` VALUES (3, 'Can delete log entry', 1, 'delete_logentry');
INSERT INTO `auth_permission` VALUES (4, 'Can view log entry', 1, 'view_logentry');
INSERT INTO `auth_permission` VALUES (5, 'Can add permission', 2, 'add_permission');
INSERT INTO `auth_permission` VALUES (6, 'Can change permission', 2, 'change_permission');
INSERT INTO `auth_permission` VALUES (7, 'Can delete permission', 2, 'delete_permission');
INSERT INTO `auth_permission` VALUES (8, 'Can view permission', 2, 'view_permission');
INSERT INTO `auth_permission` VALUES (9, 'Can add group', 3, 'add_group');
INSERT INTO `auth_permission` VALUES (10, 'Can change group', 3, 'change_group');
INSERT INTO `auth_permission` VALUES (11, 'Can delete group', 3, 'delete_group');
INSERT INTO `auth_permission` VALUES (12, 'Can view group', 3, 'view_group');
INSERT INTO `auth_permission` VALUES (13, 'Can add content type', 4, 'add_contenttype');
INSERT INTO `auth_permission` VALUES (14, 'Can change content type', 4, 'change_contenttype');
INSERT INTO `auth_permission` VALUES (15, 'Can delete content type', 4, 'delete_contenttype');
INSERT INTO `auth_permission` VALUES (16, 'Can view content type', 4, 'view_contenttype');
INSERT INTO `auth_permission` VALUES (17, 'Can add session', 5, 'add_session');
INSERT INTO `auth_permission` VALUES (18, 'Can change session', 5, 'change_session');
INSERT INTO `auth_permission` VALUES (19, 'Can delete session', 5, 'delete_session');
INSERT INTO `auth_permission` VALUES (20, 'Can view session', 5, 'view_session');
INSERT INTO `auth_permission` VALUES (21, 'Can add user', 6, 'add_user');
INSERT INTO `auth_permission` VALUES (22, 'Can change user', 6, 'change_user');
INSERT INTO `auth_permission` VALUES (23, 'Can delete user', 6, 'delete_user');
INSERT INTO `auth_permission` VALUES (24, 'Can view user', 6, 'view_user');
INSERT INTO `auth_permission` VALUES (25, 'Can add place', 7, 'add_place');
INSERT INTO `auth_permission` VALUES (26, 'Can change place', 7, 'change_place');
INSERT INTO `auth_permission` VALUES (27, 'Can delete place', 7, 'delete_place');
INSERT INTO `auth_permission` VALUES (28, 'Can view place', 7, 'view_place');
INSERT INTO `auth_permission` VALUES (29, 'Can add place_ permission', 8, 'add_place_permission');
INSERT INTO `auth_permission` VALUES (30, 'Can change place_ permission', 8, 'change_place_permission');
INSERT INTO `auth_permission` VALUES (31, 'Can delete place_ permission', 8, 'delete_place_permission');
INSERT INTO `auth_permission` VALUES (32, 'Can view place_ permission', 8, 'view_place_permission');
INSERT INTO `auth_permission` VALUES (33, 'Can add content', 9, 'add_content');
INSERT INTO `auth_permission` VALUES (34, 'Can change content', 9, 'change_content');
INSERT INTO `auth_permission` VALUES (35, 'Can delete content', 9, 'delete_content');
INSERT INTO `auth_permission` VALUES (36, 'Can view content', 9, 'view_content');
INSERT INTO `auth_permission` VALUES (37, 'Can add reserve', 10, 'add_reserve');
INSERT INTO `auth_permission` VALUES (38, 'Can change reserve', 10, 'change_reserve');
INSERT INTO `auth_permission` VALUES (39, 'Can delete reserve', 10, 'delete_reserve');
INSERT INTO `auth_permission` VALUES (40, 'Can view reserve', 10, 'view_reserve');
INSERT INTO `auth_permission` VALUES (41, 'Can add login_ log', 11, 'add_login_log');
INSERT INTO `auth_permission` VALUES (42, 'Can change login_ log', 11, 'change_login_log');
INSERT INTO `auth_permission` VALUES (43, 'Can delete login_ log', 11, 'delete_login_log');
INSERT INTO `auth_permission` VALUES (44, 'Can view login_ log', 11, 'view_login_log');

-- ----------------------------
-- Table structure for auth_user
-- ----------------------------
DROP TABLE IF EXISTS `auth_user`;
CREATE TABLE `auth_user`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `password` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `last_login` datetime(6) NULL DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `first_name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `last_name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `email` varchar(254) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  `add_by` int(0) NOT NULL,
  `delete_by` int(0) NOT NULL,
  `delete_time` datetime(6) NULL DEFAULT NULL,
  `session_key` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `place_id_list` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 59 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of auth_user
-- ----------------------------
INSERT INTO `auth_user` VALUES (2, 'pbkdf2_sha256$216000$PUeLAHDZieR3$9fqhqS5oe0+CXh81BZ1MRTkVtp9LaqctDODePksMgc8=', '2022-02-13 23:01:30.364409', 1, '高级管理员', '', '', '', 1, 1, '2021-01-05 17:10:44.129152', 1, 0, NULL, 'zjrh081pyvns9mwdd2yoq2i78na1z8t7', '1,2,4,5,13');
INSERT INTO `auth_user` VALUES (58, 'pbkdf2_sha256$260000$ZbRD4bOIYI3WiuGTrgkcBf$Eo26s5aHX5uPOvlPQ7BhgG3Ih3RLM8NSmcgFnac7vV8=', '2022-02-12 20:35:33.912355', 0, 'root', '', '', '', 0, 1, '2022-02-08 18:08:53.433250', 2, 0, NULL, '6jys0r9oxjua9mxo9etjii91478xbpt3', '1,2');

-- ----------------------------
-- Table structure for auth_user_groups
-- ----------------------------
DROP TABLE IF EXISTS `auth_user_groups`;
CREATE TABLE `auth_user_groups`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `user_id` int(0) NOT NULL,
  `group_id` int(0) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `auth_user_groups_user_id_group_id_94350c0c_uniq`(`user_id`, `group_id`) USING BTREE,
  INDEX `auth_user_groups_group_id_97559544_fk_auth_group_id`(`group_id`) USING BTREE,
  CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of auth_user_groups
-- ----------------------------

-- ----------------------------
-- Table structure for auth_user_user_permissions
-- ----------------------------
DROP TABLE IF EXISTS `auth_user_user_permissions`;
CREATE TABLE `auth_user_user_permissions`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `user_id` int(0) NOT NULL,
  `permission_id` int(0) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq`(`user_id`, `permission_id`) USING BTREE,
  INDEX `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm`(`permission_id`) USING BTREE,
  CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of auth_user_user_permissions
-- ----------------------------

-- ----------------------------
-- Table structure for content_content
-- ----------------------------
DROP TABLE IF EXISTS `content_content`;
CREATE TABLE `content_content`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `data_type` int(0) NOT NULL,
  `data_content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `add_time` datetime(6) NOT NULL,
  `update_time` datetime(6) NOT NULL,
  `is_used` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of content_content
-- ----------------------------
INSERT INTO `content_content` VALUES (1, 1, '<h2><strong>球场使用须知</strong></h2><p>&nbsp;</p><p>1. 只能申请2周内的场地。</p><p>2.场内保持清洁，不把口香糖吐在地上；含糖饮料不得带入饮用。</p>', '2021-01-05 16:22:34.723480', '2021-01-05 16:22:34.723480', 1);
INSERT INTO `content_content` VALUES (2, 2, 'https://img1.baidu.com/it/u=75218222,1869310848&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=375', '2021-01-05 16:22:48.813224', '2021-01-05 16:22:48.813224', 1);

-- ----------------------------
-- Table structure for django_admin_log
-- ----------------------------
DROP TABLE IF EXISTS `django_admin_log`;
CREATE TABLE `django_admin_log`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `object_repr` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `action_flag` smallint(0) UNSIGNED NOT NULL,
  `change_message` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `content_type_id` int(0) NULL DEFAULT NULL,
  `user_id` int(0) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `django_admin_log_content_type_id_c4bce8eb_fk_django_co`(`content_type_id`) USING BTREE,
  INDEX `django_admin_log_user_id_c564eba6_fk_auth_user_id`(`user_id`) USING BTREE,
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of django_admin_log
-- ----------------------------

-- ----------------------------
-- Table structure for django_content_type
-- ----------------------------
DROP TABLE IF EXISTS `django_content_type`;
CREATE TABLE `django_content_type`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `model` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `django_content_type_app_label_model_76bd3d3b_uniq`(`app_label`, `model`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of django_content_type
-- ----------------------------
INSERT INTO `django_content_type` VALUES (11, 'account', 'login_log');
INSERT INTO `django_content_type` VALUES (6, 'account', 'user');
INSERT INTO `django_content_type` VALUES (1, 'admin', 'logentry');
INSERT INTO `django_content_type` VALUES (3, 'auth', 'group');
INSERT INTO `django_content_type` VALUES (2, 'auth', 'permission');
INSERT INTO `django_content_type` VALUES (9, 'content', 'content');
INSERT INTO `django_content_type` VALUES (4, 'contenttypes', 'contenttype');
INSERT INTO `django_content_type` VALUES (7, 'place', 'place');
INSERT INTO `django_content_type` VALUES (8, 'place', 'place_permission');
INSERT INTO `django_content_type` VALUES (10, 'reserve', 'reserve');
INSERT INTO `django_content_type` VALUES (5, 'sessions', 'session');

-- ----------------------------
-- Table structure for django_migrations
-- ----------------------------
DROP TABLE IF EXISTS `django_migrations`;
CREATE TABLE `django_migrations`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `app` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 30 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of django_migrations
-- ----------------------------
INSERT INTO `django_migrations` VALUES (1, 'contenttypes', '0001_initial', '2021-01-05 16:12:47.325431');
INSERT INTO `django_migrations` VALUES (2, 'contenttypes', '0002_remove_content_type_name', '2021-01-05 16:12:47.700349');
INSERT INTO `django_migrations` VALUES (3, 'auth', '0001_initial', '2021-01-05 16:12:48.326277');
INSERT INTO `django_migrations` VALUES (4, 'auth', '0002_alter_permission_name_max_length', '2021-01-05 16:12:48.972485');
INSERT INTO `django_migrations` VALUES (5, 'auth', '0003_alter_user_email_max_length', '2021-01-05 16:12:49.055199');
INSERT INTO `django_migrations` VALUES (6, 'auth', '0004_alter_user_username_opts', '2021-01-05 16:12:49.137132');
INSERT INTO `django_migrations` VALUES (7, 'auth', '0005_alter_user_last_login_null', '2021-01-05 16:12:49.219593');
INSERT INTO `django_migrations` VALUES (8, 'auth', '0006_require_contenttypes_0002', '2021-01-05 16:12:49.298716');
INSERT INTO `django_migrations` VALUES (9, 'auth', '0007_alter_validators_add_error_messages', '2021-01-05 16:12:49.384517');
INSERT INTO `django_migrations` VALUES (10, 'auth', '0008_alter_user_username_max_length', '2021-01-05 16:12:49.467256');
INSERT INTO `django_migrations` VALUES (11, 'auth', '0009_alter_user_last_name_max_length', '2021-01-05 16:12:49.549851');
INSERT INTO `django_migrations` VALUES (12, 'auth', '0010_alter_group_name_max_length', '2021-01-05 16:12:49.748711');
INSERT INTO `django_migrations` VALUES (13, 'auth', '0011_update_proxy_permissions', '2021-01-05 16:12:49.943548');
INSERT INTO `django_migrations` VALUES (14, 'auth', '0012_alter_user_first_name_max_length', '2021-01-05 16:12:50.026763');
INSERT INTO `django_migrations` VALUES (15, 'account', '0001_initial', '2021-01-05 16:12:51.003125');
INSERT INTO `django_migrations` VALUES (16, 'account', '0002_auto_20210103_1720', '2021-01-05 16:12:52.107586');
INSERT INTO `django_migrations` VALUES (17, 'account', '0003_user_session_key', '2021-01-05 16:12:52.314261');
INSERT INTO `django_migrations` VALUES (18, 'admin', '0001_initial', '2021-01-05 16:12:52.769490');
INSERT INTO `django_migrations` VALUES (19, 'admin', '0002_logentry_remove_auto_add', '2021-01-05 16:12:53.096022');
INSERT INTO `django_migrations` VALUES (20, 'admin', '0003_logentry_add_action_flag_choices', '2021-01-05 16:12:53.181215');
INSERT INTO `django_migrations` VALUES (21, 'content', '0001_initial', '2021-01-05 16:12:53.556637');
INSERT INTO `django_migrations` VALUES (22, 'place', '0001_initial', '2021-01-05 16:12:53.896080');
INSERT INTO `django_migrations` VALUES (23, 'place', '0002_auto_20201231_1331', '2021-01-05 16:12:54.314140');
INSERT INTO `django_migrations` VALUES (24, 'place', '0003_auto_20210103_1655', '2021-01-05 16:12:54.562715');
INSERT INTO `django_migrations` VALUES (25, 'place', '0004_auto_20210103_1720', '2021-01-05 16:12:54.980471');
INSERT INTO `django_migrations` VALUES (26, 'reserve', '0001_initial', '2021-01-05 16:12:55.510619');
INSERT INTO `django_migrations` VALUES (27, 'reserve', '0002_auto_20201231_1330', '2021-01-05 16:12:55.696284');
INSERT INTO `django_migrations` VALUES (28, 'reserve', '0003_reserve_cancel_by', '2021-01-05 16:12:55.946345');
INSERT INTO `django_migrations` VALUES (29, 'sessions', '0001_initial', '2021-01-05 16:12:56.205397');
INSERT INTO `django_migrations` VALUES (30, 'account', '0004_login_log', '2021-01-05 16:53:53.106135');

-- ----------------------------
-- Table structure for django_session
-- ----------------------------
DROP TABLE IF EXISTS `django_session`;
CREATE TABLE `django_session`  (
  `session_key` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `session_data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`) USING BTREE,
  INDEX `django_session_expire_date_a5c62663`(`expire_date`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of django_session
-- ----------------------------
INSERT INTO `django_session` VALUES ('08muntfe00o0nsiskl71ehbq0g8d3wnq', '.eJxVjDEPgjAQhf9LZ9O0hdKem-6OzuS464lKaEIhDsb_LiQMurzhvfd9b9XiMvftUtLU3lkdla3V4bfskJ5p3BZ-4HjLmvI4T_dObxe9r0WfhiG_1riuTLlkTsN5B_9sPZZ-VaFlqitIJN51gVw0TpwREyyjaQICSsVipRIwLByil-gJogdqwACqzxeUnz2j:1n0aOX:5nnM1vGvWVJtpjd3Ql8E1Numd-yTOnntTWNtYEkj_NU', '2022-01-07 10:33:21.548622');
INSERT INTO `django_session` VALUES ('0mem83atkj8g3saejq7tf0sa1e6squj7', '.eJxVjLEOwiAURf-F2ZD2FQq46e7o3Dx4T6k2kJQ2DsZ_lyYddLnDvfectxhwXeKwFp6HkcRRaCMOv6XH8OS0LfTAdM8y5LTMo5fbRe5rkadpyq8a18qUSyaezjv4Z4tYYlW1qJVhAusssdKGTXDOemxs7ygQYdP2TnnwHrruhtAqxRagh46V0Uji8wWCiz0Q:1mkeNk:7HIom1TXocETar7HXd_J6JqLdtqWgejHaS5p5xs3jbU', '2021-11-24 11:34:40.385806');
INSERT INTO `django_session` VALUES ('1epg8q9wb8i3l7b3as4zs8ukt5c73w6l', '.eJxVjLEOwiAURf-F2RCggOCmu6Nz8x48pNpAUto4GP_dNumgyx3uvee8WQ_LnPul0dQPkZ2Y0uzwWyKEJ5VtiQ8o98pDLfM0IN8ufF8bP49jfa1xW5l2rZHGyw7-2TK0vKqkswpAx6NOyhhFyVLwnU_opEouakNWWJG8hATCoJHBI6AVnYoWfSD2-QJ_Nz2R:1my4Ag:EADf5q1d_OVOXfyJLIqoATcw_-F3LqjS4VU51Z0kcik', '2021-12-31 11:44:38.452089');
INSERT INTO `django_session` VALUES ('27bch796xg6z7vd86nk6oye9c7fm3g0i', '.eJxVjLsOwjAQBP_FNbJw7PODDnpK6uic85FAFEtxIgrEv-NIKaDZYndn3qLFdenbtaS5HUicBIA4_JYRu2eatoUeON2z7PK0zEOU20Xua5HnccyvGrfKlGumNF528M_WY-mrisl4G7WNhi3bpKFTDKjJqiZAgOiT44AK2TcOHQEafVQ2EHrNJoVGfL6M3z1Q:1n4KFX:2IuMHDal7OUD45LIUMlpsQeDoiPp1aydULZPAnDwblw', '2022-01-17 18:07:31.577043');
INSERT INTO `django_session` VALUES ('3uh255v8vptd2ehci36k2tk8x9vfg1tb', '.eJxVjLsOwjAQBP_FNbL8ONsHHfSU1NHF55BAZEtxIgrEv5NIKaDZYndn3qKhZe6bpaapGVicBBhx-C1bis-Ut4UflO9FxpLnaWjldpH7WuV5HMtrjdvK1GvhNF528M_WU-1XleHktYtsAyd0Co1j5Qm7GGzkEL0GUh5CQuwAyWqnoEUH0LmjMdpq8fkCdmU8Rg:1mu3kM:gSRCgiTdAtdwXJ7dI2DuL_zw5lHp8aaJVKAdgvqteE0', '2021-12-20 10:28:54.674226');
INSERT INTO `django_session` VALUES ('43cr0tzaf9up9e2xqm0eotwrq4ugkfij', '.eJxVjDsPwiAUhf8LsyFQKA83uzs6N7fci602kJQ2Dsb_Lk06aHJyhvP43qyHbR37rdDST8jOTEt2-g0HCE9Ke4MPSPfMQ07rMg18n_CjLfwyz_lV7VY_5ZqR5u44_tFGKGNFtQ510G20RpCsjEFGZ1EaQmuMMFIhKOehqVIoGgrgNWlqrYrBeYXs8wWERz1p:1mxRvd:6ERGkACifP2QeJEQhucGa5Gtqm-5kYVUKmngjJlXiFc', '2021-12-29 18:54:33.772261');
INSERT INTO `django_session` VALUES ('43f5q4c18oeabzs00ndn5ds4ijtq4rv4', '.eJxVjL0OwjAQg98lM4qaXHNN2OjOyBxd_mihaqSmFQPi3UmlDjDYgz_bb2ZpWwe7lbjYMbAzQ3b6zRz5Z5x3EB403zP3eV6X0fG9wg9a-GWa8qvarW7KNYc49cfw722gMtSrSBo9eqOVAUUGW2kwdVXGSZVQG6claXAeUlIgOiEaJ2QDqdUAHgX7fAFCiTwB:1n15Pr:codZn9FX7IZRyJQu156VwpD8JIox-cLhrgyKKHf_l1o', '2022-01-08 19:40:47.576356');
INSERT INTO `django_session` VALUES ('4t468lo94s9lc01motjgfnikizfw663p', '.eJxVjLsOwjAQBP_FNbKCn2c66CmpLdt3JoEoluJEFIh_J5ZSQLPF7s68mQ_r0vu10uwHZCemNDv8ljGkJ01twUeY7oWnMi3zEHm78H2t_DyO5bXFbWPqtSCNlx38s_Wh9k2lBELMYCkIjdEYq7LELoMR0YBRHYC0R-GcRIGOMmJS0KUgtaUkQbDPF4IqPSI:1lq8x3:bfbRisoOf1LKJuhIhMIPUVz0Ug-yDdetKzflqxssUH0', '2021-06-21 14:41:33.383574');
INSERT INTO `django_session` VALUES ('4tt5tq2j5v004h3glnwoedm4ywakfku4', '.eJxVjD0PwiAURf8LsyEP2ofUTXdH5-bxJVUCSWnjYPzv0qSDLne45577ZiOtSxzX6udxcuzE-o4dfktD9unzRtyD8r1wW_IyT4ZvE77Tys8plVeLW3PqtTifLrv49xapxnYFQBqU8DaQkmgQEMEpGJRXKKTyQjQSBOHRWNTBgdN9gDB00pDQvWSfL227POk:1mxjkV:zpD8L6XH9TYxZqGEUBcgATOX3H9KZrsoWMX1z8s3zMU', '2021-12-30 13:56:15.713512');
INSERT INTO `django_session` VALUES ('5ij46rinv6vbsa0s4tiqsyzyal0iw5mt', '.eJxVjLEOwiAURf-F2ZBCgQdudnd0bh7wsNUGktLGwfjvtkkHXe5w7z3nzXpcl6FfK839GNmZqYadfkuP4Ul5X-ID873wUPIyj57vF36slV-mqby2uG1MvZZIU3eAf7YB67CpLMZWxABOCAWJZEAhrWvAgEykjW5BuUYgqGTBRY_GKRKkU5DahdYk9vkCZ_Q8vA:1mmVsy:bIIUEl0fyz6jubzGWoimbpRMPsuPsXM01vJSjMUHgAM', '2021-11-29 14:54:36.887995');
INSERT INTO `django_session` VALUES ('5oh0vlip0hz9bvbciw27keam4pztr8b5', '.eJxVjLEOgkAQRP_lanPZ3ePwsNPe0post4ughEs4iIXx34WEQpspZua9t6l5mbt6yTrVvZiTcWQOv2XD8anjtsiDx3uyMY3z1Dd2u9h9zfY8DOm1xm1l8jWJDpcd_LN1nLtVBU4RWo8E2rIjDwGKiFRwKQLMWFaKEktqCV0ICL4iOSoEH5kbV3nz-QJeVDx2:1mtnso:gci0Ujj-TV2jQF7wZ6UjtN60mztcfkCXQgDKac42Uj8', '2021-12-19 17:32:34.352743');
INSERT INTO `django_session` VALUES ('a32yvfpw1dp8r8w78jiqxwbkk4ieycvx', '.eJxVjLEOgjAURf-ls2lKC6_UTXZHZ_JeXxG0aRMKcTD-u5Aw6HKHe-85b9Hjuoz9WsLcTyzOQoM4_ZaE_hnSvvAD0z1Ln9MyTyT3izzWIi8x5tcWt40p18whdgf4ZxuxjJsKVfBuIGOc8djWTK2rvGGqIIBVrGplrVOBAKrGEhA5pTWYobFoEMCJzxeHETzU:1n20Yn:hP3NbfVC_ynZXpkvDbUoQFlhkraQo4EKwrBiMmHkgTo', '2022-01-11 08:41:49.250373');
INSERT INTO `django_session` VALUES ('d8296ggnvh0fj7p2cglnjtak6ealqa6e', '.eJxVjDEPgjAQhf9LZ9O0cKXgJrujM7neHYKSNqEQB-N_FxIGXd7w3vu-t-pwXYZuzTJ3I6uzKqw6_ZYB6SlxX_iB8Z40pbjMY9D7RR9r1pdpSq8tbhuTr4llag_wzzZgHjYVlcZA6RoBqMhWXPc1Yl-BiHVeqCkg-GDYWgoAbE0pyMaJeHLOeV-rzxd4Cz0p:1mzvJp:qjvXiepc5LO2Afu3HMGCr6lYgrHkc9s5T9QljBH3OM8', '2022-01-05 14:41:45.554514');
INSERT INTO `django_session` VALUES ('euoimh07pafgtgq7uzz0bbhuerjcvhi3', '.eJxVjLsOwjAQBP_FNbIS5-IzdNBTUlt3fpBAZEtxIgrEv-NIKaDZYnd23sLSugx2LWG2oxcnASAOvyWTe4a0Lf5B6Z6ly2mZR5YbIve1yPM05VeNW_2Ua_ZhuuzHP9tAZagq6hkjaiZwIWJUOroWPIFGNr5j58Cg4Sao2EODAMhgYgV1W6FOHcXnC6p9PdU:1mwwX9:ZK0zBCZFcHnnCVTiHG42V48M1yVXaUujPeWBUQYqr_w', '2021-12-28 09:23:11.517891');
INSERT INTO `django_session` VALUES ('ev0908l4yw44qzz8p7vi80qiy7llw56j', '.eJxVjDEPgjAQhf9LZ9PUtnDUTXdHZ3LXuwpKaEIhDsb_LiQMurzhvfd9b9XiMnftUmRqe1YndazU4bckjE8Zt4UfON6zjnmcp570dtH7WvR5GPJrjdvKlGtmGS47-GfrsHSrirwkSx5RAMXWBokEo-eaAxpgl8SEkBqwyNZBAkrRi_MhVsk3JKA-X8jOPuc:1n18Z5:-KBEhi3IhNhp5udgBKCqvt8cm9tx-RJBPT7sBOzD0tQ', '2022-01-08 23:02:31.135159');
INSERT INTO `django_session` VALUES ('f5tm6362ftxhym8lua1mqhfvs7jy115j', '.eJxVjDEPgjAQhf9LZ9NAey3VTXdHZ3K9OyxKaEIhDsb_LiQMurzhvfd9b9XiMqd2KTK1PauTMkYdfsuI9JRxW_iB4z1ryuM89VFvF72vRZ-HIb_WuK1MuWaW4bKDf7aEJa0qTx4EgrdOuiMTNRAqx8R1HRtgslQhh8CEFVhAV5vobUNRQue5cxLU5wuPKT32:1n50ex:Gqqm1CEWgE2Y8W3Mn9xoSpJ4U2ERlPdGhrDukhisRvE', '2022-01-19 15:24:35.181639');
INSERT INTO `django_session` VALUES ('frb2wyl72hyndv2dqtiil7lw0og4g337', '.eJxVjDsPgjAYRf9LZ9NAH9C6ye7oTL5HY1FCEwpxMP5324RBlzvcc899ixH2LY57Dus4sTgL3YrTb4lAz7BUwg9Y7klSWrZ1Qlkn8qBZXuY5vUrcipOvicM8HOLfW4Qcy5W1ABZ6bsh3BqlvrdbEpLh3GjCAMh61M5oDeetUB6pxHh11WInx4vMFiCE9NA:1mz8ga:B7u7p7IUzG2aVVzIlNbMZfWC0h30wTIc72m4JcGyUgA', '2022-01-03 10:46:00.287418');
INSERT INTO `django_session` VALUES ('ie7k25170fg1cv0rwt89dzjco4ifpvwv', '.eJxVjDEPgjAQhf9LZ9Nw7RWom-yOzuSuB4ISmlCIg_G_WxIGXd7w3vu-t2ppW4d2S93SjqLOypXq9FsyhWc374s8aL5HHeK8LiPr_aKPNenLNMVXjltm0jVKNzUH-GcbKA1ZVRuW3jgoAVxfCVIIAB6tEQaofWV93RuLiEwFsYcKgQuLUgYhb4NVny9nLjyQ:1mwfWp:srw3KnbMHnTUt6qLI4dYTzZZ0LJbqaQvJ4lfx5lZOWA', '2021-12-27 15:13:43.869456');
INSERT INTO `django_session` VALUES ('izhuindrgrbkjk1monz3cl6ypo7j41i7', '.eJxVjT8PwiAUxL8LsyEUyh_ddHd0Jo_3wFYbSEobB-N3tyQddLnh7n53b-ZhXQa_1jj7kdiJdezw6wXAZ8wtoAfke-FY8jKPgbcK39PKz9NUXpvcNqZeC8XpsoN_awPUoX0kUimq2PUOOlAhmeCCsFZoY5AI8Si01b1CiaidSxDJBZOklkjWArLPF3HmPe4:1n7Rt7:nRk2f8jmYsNHqjSMStM3VP3taSeLh30Tg4duJ-rpvOc', '2022-01-26 08:53:17.232749');
INSERT INTO `django_session` VALUES ('jt10uy9ex85kgv6lptpiyoor39lkzh9v', '.eJxVjLEOwiAURf-F2RCEQsXN7o7OzXu8h1QbSEobB-O_2yYddLnDvfect-hhmVO_VJ76gcRZaC8OvyVCeHLeFnpAvhcZSp6nAeV2kfta5WUcy2uN28rUayEeux38syWoaVWdMETDQQOSagGM99YohOaoQbNvXausB2e4AWRLRmmlKTBgE13E6J34fAGdvD4S:1n15GT:lxONjn8qg5s1p26H05GOldaYMb--N9cqMccb4-j24Zo', '2022-01-08 19:31:05.133433');
INSERT INTO `django_session` VALUES ('k4zjp4r9g86vqxg9uelqjb7v2a8lnmbb', '.eJxVjDEPgjAQhf9LZ9P0ytkWN90dncm1dwhKaEIhDsb_LiQMurzhvfd9b9XQMnfNUmRqelYnhUEdfstI6SnjtvCDxnvWKY_z1Ee9XfS-Fn0ehvxa47Yy5ZpZhssO_tk6Kt2qAofeGMEavEMJUCUUJlsBSguRvXFcQbIIjMcQHLQYwZpILliuybfq8wVWwzxm:1lMk7Q:VUMLxjHfl7eQlyfjcuu2Kbh5E222BvLlKsTGV6UaATA', '2021-04-01 12:18:44.603289');
INSERT INTO `django_session` VALUES ('m07aebzsp0kf06dsybcpvxqjhtrs7zhu', '.eJxVjDEPgjAQhf9LZ9MUKr3WTXdHZ3K9uwpKaEIhDsb_LiQMurzhvfd9b9XiMnftUmRqe1YnVVt1-C0j0lPGbeEHjvesKY_z1Ee9XfS-Fn0ehvxa47Yy5ZpZhssO_tk6LN2qAmQnEMgyJesADSA6Aqx81YRA3HiIiQ2zGPGBGpssVNE4n7A-Cjj1-QKeZz3W:1muWEl:EM7k3Nt3IQNtgxjgcuAfLCl6rUpG3128d4eJA2os2zA', '2021-12-21 16:54:11.999752');
INSERT INTO `django_session` VALUES ('msyelkxhet6kbt3pgmjfqjmvsua3by4q', '.eJxVjD0PgjAURf9LZ9P0i0dxk93Rmby2r4I2bUIhDsb_LiQMutzh3nvOmw24LuOwVpqHKbAz0w07_ZYO_ZPyvoQH5nvhvuRlnhzfL_xYK7-kVF5b3DamXkug1B_gn23EOm4qR0QSyQiL3hpvVWuiMijBImHrnQDjJAgVWwHQaRmVjdg50EgqNN6yzxeXFj2L:1n4fHu:VF_tQz4D8nAYU_-wrEZVJk6rZYCLxD6xaMV4QDk_es0', '2022-01-18 16:35:22.618509');

-- ----------------------------
-- Table structure for place_place
-- ----------------------------
DROP TABLE IF EXISTS `place_place`;
CREATE TABLE `place_place`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `add_time` datetime(6) NOT NULL,
  `is_delete` tinyint(1) NOT NULL,
  `delete_time` datetime(6) NULL DEFAULT NULL,
  `add_by` int(0) NOT NULL,
  `delete_by` int(0) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of place_place
-- ----------------------------

-- ----------------------------
-- Table structure for place_place_permission
-- ----------------------------
DROP TABLE IF EXISTS `place_place_permission`;
CREATE TABLE `place_place_permission`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `user_id` int(0) NOT NULL,
  `place_id_list` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `add_time` datetime(6) NOT NULL,
  `update_time` datetime(6) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of place_place_permission
-- ----------------------------

-- ----------------------------
-- Table structure for reserve_reserve
-- ----------------------------
DROP TABLE IF EXISTS `reserve_reserve`;
CREATE TABLE `reserve_reserve`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `user_id` int(0) NOT NULL,
  `place_id` int(0) NOT NULL,
  `usage_start_time` time(6) NOT NULL,
  `usage_end_time` time(6) NOT NULL,
  `usage_date` date NOT NULL,
  `usage_reason` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `reserve_time` datetime(6) NOT NULL,
  `cancel_time` datetime(6) NULL DEFAULT NULL,
  `status` int(0) NOT NULL,
  `cancel_by` int(0) NOT NULL,
  `contact_man_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `contact_man_telephone` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 48 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of reserve_reserve
-- ----------------------------

SET FOREIGN_KEY_CHECKS = 1;

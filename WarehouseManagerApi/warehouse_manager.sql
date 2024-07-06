/*
 Navicat Premium Data Transfer

 Source Server         : localhost
 Source Server Type    : MySQL
 Source Server Version : 80019
 Source Host           : localhost:3306
 Source Schema         : warehouse_manager

 Target Server Type    : MySQL
 Target Server Version : 80019
 File Encoding         : 65001

 Date: 16/08/2023 00:46:47
*/

SET NAMES utf8;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for goods
-- ----------------------------
DROP TABLE IF EXISTS `goods`;
CREATE TABLE `goods`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '货名',
  `storage` int(0) NOT NULL COMMENT '仓库',
  `goodsType` int(0) NOT NULL COMMENT '分类',
  `count` int(0) NULL DEFAULT NULL COMMENT '数量',
  `remark` varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of goods
-- ----------------------------
INSERT INTO `goods` VALUES (1, 'iPhone14', 2, 2, 95, '货物不可以挤压');
INSERT INTO `goods` VALUES (4, '洁面乳', 1, 1, 1047, '货物不可以挤压');
INSERT INTO `goods` VALUES (5, '葡萄', 5, 5, 500, '货物不可以挤压');
INSERT INTO `goods` VALUES (6, '西红柿', 5, 6, 800, '货物不可以挤压');
INSERT INTO `goods` VALUES (7, '皮皮虾', 4, 4, 500, '货物不可以挤压');
INSERT INTO `goods` VALUES (8, 'AD钙', 3, 3, 400, '货物不可以挤压');
INSERT INTO `goods` VALUES (11, 'iPad Air5', 2, 2, 800, '货物不可以挤压');
INSERT INTO `goods` VALUES (12, '旺仔牛奶', 3, 3, 1550, '');

-- ----------------------------
-- Table structure for goodstype
-- ----------------------------
DROP TABLE IF EXISTS `goodstype`;
CREATE TABLE `goodstype`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '分类名',
  `remark` varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of goodstype
-- ----------------------------
INSERT INTO `goodstype` VALUES (1, '日用品', '日常生活用品');
INSERT INTO `goodstype` VALUES (2, '数码产品', '数码产品');
INSERT INTO `goodstype` VALUES (3, '食品', '食品');
INSERT INTO `goodstype` VALUES (4, '冷冻品', '冷冻食品');
INSERT INTO `goodstype` VALUES (5, '水果', '水果产品');
INSERT INTO `goodstype` VALUES (6, '蔬菜', '蔬菜产品');

-- ----------------------------
-- Table structure for menu
-- ----------------------------
DROP TABLE IF EXISTS `menu`;
CREATE TABLE `menu`  (
  `id` int(0) NOT NULL COMMENT '主键',
  `menuCode` varchar(8) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '菜单编码',
  `menuName` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '菜单名字',
  `menuLevel` varchar(2) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '菜单级别',
  `menuParentCode` varchar(8) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '菜单的父code',
  `menuClick` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '点击触发的函数',
  `menuRight` varchar(8) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '权限 0超级管理员，1表示管理员，2表示普通用户，可以用逗号组合使用',
  `menuComponent` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '对应Vue菜单组件',
  `menuIcon` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '菜单图标',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of menu
-- ----------------------------
INSERT INTO `menu` VALUES (1, '001', '管理员信息管理', '1', NULL, 'Admin', '0', 'admin/AdminManage.vue', 'el-icon-a-031');
INSERT INTO `menu` VALUES (2, '002', '用户信息管理', '1', NULL, 'User', '0,1', 'user/UserManage.vue', 'el-icon-a-01');
INSERT INTO `menu` VALUES (3, '003', '仓库信息管理', '1', NULL, 'Storage', '0,1', 'storage/StorageManage', 'el-icon-a-021');
INSERT INTO `menu` VALUES (4, '004', '物品分类管理', '1', NULL, 'Goodstype', '0,1', 'goodstype/GoodstypeManage', 'el-icon-a-041');
INSERT INTO `menu` VALUES (5, '005', '物品信息管理 ', '1', NULL, 'Goods', '0,1,2', 'goods/GoodsManage', 'el-icon-a-02');
INSERT INTO `menu` VALUES (6, '006', '操作日志', '1', NULL, 'Record', '0,1,2', 'record/RecordManage', 'el-icon-a-061');

-- ----------------------------
-- Table structure for record
-- ----------------------------
DROP TABLE IF EXISTS `record`;
CREATE TABLE `record`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `goods` int(0) NOT NULL COMMENT '货品id',
  `userId` int(0) NULL DEFAULT NULL COMMENT '取货人/补货人',
  `admin_id` int(0) NULL DEFAULT NULL COMMENT '操作人id',
  `count` int(0) NULL DEFAULT NULL COMMENT '数量',
  `createtime` datetime NULL DEFAULT NULL COMMENT '操作时间',
  `remark` varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 19 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of record
-- ----------------------------
INSERT INTO `record` VALUES (1, 1, 3, 2, 100, '2023-01-06 20:46:48', '取货');
INSERT INTO `record` VALUES (12, 1, 3, 1, -5, '2023-01-19 15:32:27', '');
INSERT INTO `record` VALUES (15, 4, 3, 1, 100, '2023-06-11 21:08:13', '');
INSERT INTO `record` VALUES (16, 4, 3, 1, -50, '2023-06-11 21:08:25', '');
INSERT INTO `record` VALUES (17, 4, 3, 1, 100, '2023-06-11 21:17:24', '');
INSERT INTO `record` VALUES (18, 4, 3, 1, -200, '2023-06-11 21:17:33', '');
INSERT INTO `record` VALUES (19, 4, 3, 1, 100, '2023-08-06 11:15:11', '');

-- ----------------------------
-- Table structure for storage
-- ----------------------------
DROP TABLE IF EXISTS `storage`;
CREATE TABLE `storage`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '仓库名',
  `remark` varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of storage
-- ----------------------------
INSERT INTO `storage` VALUES (1, '日用品仓库', '用于存放日用品');
INSERT INTO `storage` VALUES (2, '数码仓库', '用于存放数码产品');
INSERT INTO `storage` VALUES (3, '食品仓库', '用于存放食品');
INSERT INTO `storage` VALUES (4, '冷冻仓库', '用于存放冷冻食品');
INSERT INTO `storage` VALUES (5, '果蔬仓库', '用于存放水果和蔬菜');
INSERT INTO `storage` VALUES (6, '服装仓库', '用于存放服装');
INSERT INTO `storage` VALUES (7, '水产仓库', '用于存放水产品');

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `no` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '账号',
  `name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '名字',
  `password` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '密码',
  `age` int(0) NULL DEFAULT NULL COMMENT '年龄',
  `sex` int(0) NULL DEFAULT NULL COMMENT '性别',
  `phone` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '电话',
  `role_id` int(0) NULL DEFAULT NULL COMMENT '角色 0超级管理员，1管理员，2普通账号',
  `isValid` varchar(4) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT 'Y' COMMENT '是否有效，Y有效，其他无效',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 18 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (1, 'superadmin', '张三', '123456', 18, 1, '18855079621', 0, 'Y');
INSERT INTO `user` VALUES (2, 'admin', '李四', '123456', 19, 0, '18855079621', 1, 'Y');
INSERT INTO `user` VALUES (3, 'user', '王五', '123456', 23, 0, '13333333333', 2, 'Y');

SET FOREIGN_KEY_CHECKS = 1;

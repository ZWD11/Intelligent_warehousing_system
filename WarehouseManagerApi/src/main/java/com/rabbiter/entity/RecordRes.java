package com.rabbiter.entity;

public class RecordRes extends  Record{

    private String username;
    private String adminname;
    private String goodsname;
    private String storagename;
    private String goodstypename;

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getAdminname() {
        return adminname;
    }

    public void setAdminname(String adminname) {
        this.adminname = adminname;
    }

    public String getGoodsname() {
        return goodsname;
    }

    public void setGoodsname(String goodsname) {
        this.goodsname = goodsname;
    }

    public String getStoragename() {
        return storagename;
    }

    public void setStoragename(String storagename) {
        this.storagename = storagename;
    }

    public String getGoodstypename() {
        return goodstypename;
    }

    public void setGoodstypename(String goodstypename) {
        this.goodstypename = goodstypename;
    }

    @Override
    public String toString() {
        return "RecordRes{" +
                "username='" + username + '\'' +
                ", adminname='" + adminname + '\'' +
                ", goodsname='" + goodsname + '\'' +
                ", storagename='" + storagename + '\'' +
                ", goodstypename='" + goodstypename + '\'' +
                '}';
    }
}

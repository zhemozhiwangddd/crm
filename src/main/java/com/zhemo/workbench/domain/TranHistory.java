package com.zhemo.workbench.domain;

public class TranHistory {
    private String id;

    private String stage;

    private String money;

    private String expecteddate;

    private String createtime;

    private String createby;

    private String tranid;

    private String possibility;

    public String getPossibility() {
        return possibility;
    }

    public void setPossibility(String possibility) {
        this.possibility = possibility;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id == null ? null : id.trim();
    }

    public String getStage() {
        return stage;
    }

    public void setStage(String stage) {
        this.stage = stage == null ? null : stage.trim();
    }

    public String getMoney() {
        return money;
    }

    public void setMoney(String money) {
        this.money = money == null ? null : money.trim();
    }

    public String getExpecteddate() {
        return expecteddate;
    }

    public void setExpecteddate(String expecteddate) {
        this.expecteddate = expecteddate == null ? null : expecteddate.trim();
    }

    public String getCreatetime() {
        return createtime;
    }

    public void setCreatetime(String createtime) {
        this.createtime = createtime == null ? null : createtime.trim();
    }

    public String getCreateby() {
        return createby;
    }

    public void setCreateby(String createby) {
        this.createby = createby == null ? null : createby.trim();
    }

    public String getTranid() {
        return tranid;
    }

    public void setTranid(String tranid) {
        this.tranid = tranid == null ? null : tranid.trim();
    }

    @Override
    public String toString() {
        return "TranHistory{" +
                "id='" + id + '\'' +
                ", stage='" + stage + '\'' +
                ", money='" + money + '\'' +
                ", expecteddate='" + expecteddate + '\'' +
                ", createtime='" + createtime + '\'' +
                ", createby='" + createby + '\'' +
                ", tranid='" + tranid + '\'' +
                ", possibility='" + possibility + '\'' +
                '}';
    }
}
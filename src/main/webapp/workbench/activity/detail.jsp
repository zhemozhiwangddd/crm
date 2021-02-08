<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String APP_PATH = request.getScheme() + "://"
            + request.getServerName() + ":"
            + request.getServerPort()
            + request.getContextPath() + "/";
%>
<!DOCTYPE html>
<html>
<head>
    <base href="<%=APP_PATH%>">
    <meta charset="UTF-8">
    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet"/>
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

    <script type="text/javascript">

        //默认情况下取消和保存按钮是隐藏的
        var cancelAndSaveBtnDefault = true;

        $(function () {
            $("#remark").focus(function () {
                if (cancelAndSaveBtnDefault) {
                    //设置remarkDiv的高度为130px
                    $("#remarkDiv").css("height", "130px");
                    //显示
                    $("#cancelAndSaveBtn").show("2000");
                    cancelAndSaveBtnDefault = false;
                }
            });

            $("#cancelBtn").click(function () {
                //显示
                $("#cancelAndSaveBtn").hide();
                //设置remarkDiv的高度为130px
                $("#remarkDiv").css("height", "90px");
                cancelAndSaveBtnDefault = true;
            });

            $(".remarkDiv").mouseover(function () {
                $(this).children("div").children("div").show();
            });

            $(".remarkDiv").mouseout(function () {
                $(this).children("div").children("div").hide();
            });

            $(".myHref").mouseover(function () {
                $(this).children("span").css("color", "red");
            });

            $(".myHref").mouseout(function () {
                $(this).children("span").css("color", "#E6E6E6");
            });

            build_remark_list();

            //点击保存按钮新创建一个备注
            $("#saveBtn").click(function () {
                if($("#remark").val() == "" || $("#remark").val() == null){
                    alert("备注信息不能为空");
                    return false;
                }
                var aId = "${activity.id}"
                $.ajax({
                    url: "workbench/activity/remark",
                    type: "post",
                    dataType: "json",
                    data: {
                        "noteContent": $("#remark").val(),
                        "aId": aId
                    },
                    success: function (result) {
                        alert(result.status);
                        if (result.code == 100) {
                            var ar = result.extendInfo.ar;

                            var html = "";
                            html += ' <div id="d' + ar.id + '" class="remarkDiv" style="height: 60px;">';
                            html += ' <img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
                            html += ' <div style="position: relative; top: -40px; left: 40px;">';
                            html += ' <h5 id="' + ar.id + '">' + ar.noteContent + '</h5>';
                            html += ' <font color="gray">市场活动</font> <font color="gray">-</font> <b>${activity.name}</b> <small style="color: gray;" id="s' + ar.id + '">' + ar.createTime + ' 由' + ar.createBy + '创建</small>';
                            html += ' <div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
                            html += ' <a class="myHref" href="javascript:void(0);" onclick="updateRemark(\'' + ar.id + '\')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>';
                            html += '&nbsp;&nbsp;&nbsp;&nbsp;';
                            html += ' <a class="myHref" href="javascript:void(0);" onclick="deleteRemark(\'' + ar.id + '\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>';
                            html += ' </div>';
                            html += ' </div>';
                            html += ' </div>';
                            $("#remark").val("");
                            $("#remarkTitle").after(html);
                        }
                    }
                })
            })

            //事件（动态绑定）：光标移动到备注栏时可以显示图标（动态绑定）
            $("#remarkBody").on("mouseover", ".remarkDiv", function () {
                $(this).children("div").children("div").show();
            })
            $("#remarkBody").on("mouseout", ".remarkDiv", function () {
                $(this).children("div").children("div").hide();
            })

            //点击更新，吧里面的内容更新到后台，并重新显示到页面中
            $("#updateRemarkBtn").click(function () {
                if($("#noteContent").val() == "" || $("#noteContent").val() == null){
                    alert("备注信息不能为空");
                    return false;
                }
                var id = $("#remarkId").val();
                $.ajax({
                    url: "workbench/activity/remark",
                    type: "put",
                    dataType: "json",
                    data: $("#editRemarkModal form").serialize(),
                    success: function (result) {
                        alert(result.status)
                        if (result.code == 100) {
                            $("#" + id).html($("#noteContent").val())
                            $("#s" + id).html(result.extendInfo.ar.editTime + ' 由' + result.extendInfo.ar.editBy + '修改');
                        }
                        $("#noteContent").val("")
                        $("#editRemarkModal").modal('hide')
                    }
                })
            })

        });


        //更新标签
        function updateRemark(id) {
            //把id的值传到隐藏域中
            $("#remarkId").val(id);
            $("#noteContent").val($("#" + id).html());
            //打开模态窗口
            $("#editRemarkModal").modal('show');
        }

        //删除标签
        function deleteRemark(id) {
            if (confirm("你确定要删除备注【" + $("#" + id).html() + "】吗?")) {
                $.ajax({
                    url: "workbench/activity/remark",
                    type: "delete",
                    dataType: "json",
                    data: {
                        "id": id
                    },
                    success: function (result) {
                        alert(result.status)
                        $("#d" + id).remove();
                    }
                })
            }
        }

        //把备注列表展示出来
        function build_remark_list() {
            var aId = "${activity.id}"
            $.ajax({
                url: "workbench/activity/remark",
                type: "get",
                dataType: "json",
                data: {
                    "aId": aId
                },
                success: function (result) {
                    $.each(result.extendInfo.ars, function (index, ar) {
                        var html = "";
                        html += ' <div id="d' + ar.id + '" class="remarkDiv" style="height: 60px;">';
                        html += ' <img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
                        html += ' <div style="position: relative; top: -40px; left: 40px;">';
                        html += ' <h5 id="' + ar.id + '">' + ar.noteContent + '</h5>';
                        html += ' <font color="gray">市场活动</font> <font color="gray">-</font> <b>${activity.name}</b> <small style="color: gray;" id="s' + ar.id + '" >' + (ar.editFlag == 0 ? ar.createTime : ar.editTime) + ' 由' + (ar.editFlag == 0 ? ar.createBy : ar.editBy) + (ar.editFlag == 0 ? "创建" : "修改") + '</small>';
                        html += ' <div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
                        html += ' <a class="myHref" href="javascript:void(0);" onclick="updateRemark(\'' + ar.id + '\')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>';
                        html += '&nbsp;&nbsp;&nbsp;&nbsp;';
                        html += ' <a class="myHref" href="javascript:void(0);" onclick="deleteRemark(\'' + ar.id + '\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>';
                        html += ' </div>';
                        html += ' </div>';
                        html += ' </div>';
                        $("#remarkTitle").after(html);
                    })
                }
            })
        }
    </script>


</head>
<body>

<!-- 修改市场活动备注的模态窗口 -->
<div class="modal fade" id="editRemarkModal" role="dialog">

    <div class="modal-dialog" role="document" style="width: 40%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">修改备注</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">
                    <%-- 备注的id --%>
                    <input type="hidden" id="remarkId" name="id">
                    <div class="form-group">
                        <label for="edit-describe" class="col-sm-2 control-label">内容</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="noteContent" name="noteContent"></textarea>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="updateRemarkBtn">更新</button>
            </div>
        </div>
    </div>
</div>

<!-- 修改市场活动的模态窗口 -->
<div class="modal fade" id="editActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">修改市场活动</h4>
            </div>
            <div class="modal-body">

                <form class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-marketActivityOwner">
                                <option>zhangsan</option>
                                <option>lisi</option>
                                <option>wangwu</option>
                            </select>
                        </div>
                        <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-marketActivityName" value="发传单">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-startTime" value="2020-10-10">
                        </div>
                        <label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-endTime" value="2020-10-20">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-cost" class="col-sm-2 control-label">成本</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-cost" value="5,000">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="edit-describe">市场活动Marketing，是指品牌主办或参与的展览会议与公关市场活动，包括自行主办的各类研讨会、客户交流会、演示会、新产品发布会、体验会、答谢会、年会和出席参加并布展或演讲的展览会、研讨会、行业交流会、颁奖典礼等</textarea>
                        </div>
                    </div>

                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" data-dismiss="modal">更新</button>
            </div>
        </div>
    </div>
</div>

<!-- 返回按钮 -->
<div style="position: relative; top: 35px; left: 10px;">
    <a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left"
                                                                         style="font-size: 20px; color: #DDDDDD"></span></a>
</div>

<!-- 大标题 -->
<div style="position: relative; left: 40px; top: -30px;">
    <div class="page-header">
        <h3>市场活动-${activity.name} <small>${activity.startDate} ~ ${activity.endDate}</small></h3>
    </div>
    <div style="position: relative; height: 50px; width: 250px;  top: -72px; left: 700px;">
        <button type="button" class="btn btn-default" data-toggle="modal" data-target="#editActivityModal"><span
                class="glyphicon glyphicon-edit"></span> 编辑
        </button>
        <button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
    </div>
</div>

<!-- 详细信息 -->
<div style="position: relative; top: -70px;">
    <div style="position: relative; left: 40px; height: 30px;">
        <div style="width: 300px; color: gray;">所有者</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.owner}&nbsp;</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">名称</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${activity.name}&nbsp;</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>

    <div style="position: relative; left: 40px; height: 30px; top: 10px;">
        <div style="width: 300px; color: gray;">开始日期</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.startDate}&nbsp;</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">结束日期</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${activity.endDate}&nbsp;</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 20px;">
        <div style="width: 300px; color: gray;">成本</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.cost}&nbsp;</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 30px;">
        <div style="width: 300px; color: gray;">创建者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${activity.createBy}&nbsp; </b><small
                style="font-size: 10px; color: gray;">${activity.createTime}&nbsp;</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 40px;">
        <div style="width: 300px; color: gray;">修改者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${activity.editBy}&nbsp; </b><small
                style="font-size: 10px; color: gray;">${activity.editTime}&nbsp;</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 50px;">
        <div style="width: 300px; color: gray;">描述</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>${activity.description}&nbsp;</b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
</div>

<!-- 备注 -->
<div style="position: relative; top: 30px; left: 40px;" id="remarkBody">
    <div class="page-header" id="remarkTitle">
        <h4>备注</h4>
    </div>

    <!-- 备注1 -->

    <div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
        <form role="form" style="position: relative;top: 10px; left: 10px;">
            <textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"
                      placeholder="添加备注..."></textarea>
            <p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
                <button id="cancelBtn" type="button" class="btn btn-default">取消</button>
                <button type="button" class="btn btn-primary" id="saveBtn">保存</button>
            </p>
        </form>
    </div>
</div>
<div style="height: 200px;"></div>
</body>
</html>
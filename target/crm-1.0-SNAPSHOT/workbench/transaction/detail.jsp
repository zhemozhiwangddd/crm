<%@ page import="com.zhemo.settings.domain.DicValue" %>
<%@ page import="java.util.List" %>
<%@ page import="com.zhemo.workbench.domain.Tran" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String APP_PATH = request.getScheme() + "://"
            + request.getServerName() + ":"
            + request.getServerPort()
            + request.getContextPath() + "/";
%>
<%
    List<DicValue> stages = (List<DicValue>) application.getAttribute("stage");
    Tran t = (Tran) request.getAttribute("t");
    Map<String, String> possMap = (Map<String, String>) application.getAttribute("possMap");//阶段-可能性

    String currentStage = t.getStage();//当前阶段
    String currentPoss = t.getPossibility();
    int point = 0;//分界点
    int currentPoint = 0;//当前阶段对应的点
    boolean flagP = false;//point设置完成的标记
    boolean flagC = false;
    //获取分界点
    for (int i = 0; i < stages.size(); i++) {
        DicValue dv = stages.get(i);//获取当前遍历到的stage数据字典值
        String iStage = dv.getValue();//从数据字典值中取出value

        if ("0".equals(possMap.get(iStage)) && !flagP) {
            point = i;
            flagP = true;
        }
        if (iStage.equals(currentStage)) {
            currentPoint = i;
            flagC = true;
        }
        //当point和currentPoint都设定好了，跳出循环
        if (flagP && flagC) {
            break;
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <base href="<%=APP_PATH%>">
    <meta charset="UTF-8">

    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet"/>

    <style type="text/css">
        .mystage {
            font-size: 20px;
            vertical-align: middle;
            cursor: pointer;
        }

        .closingDate {
            font-size: 15px;
            cursor: pointer;
            vertical-align: middle;
        }
    </style>

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


            //阶段提示框
            $(".mystage").popover({
                trigger: 'manual',
                placement: 'bottom',
                html: 'true',
                animation: false
            }).on("mouseenter", function () {
                var _this = this;
                $(this).popover("show");
                $(this).siblings(".popover").on("mouseleave", function () {
                    $(_this).popover('hide');
                });
            }).on("mouseleave", function () {
                var _this = this;
                setTimeout(function () {
                    if (!$(".popover:hover").length) {
                        $(_this).popover("hide")
                    }
                }, 100);
            });

            build_tran_history();


        });

        //点击阶段图标，修改对应的图标和内容
        //stage
        //clickPoint:用户点击的阶段对应的坐标
        function refresh_detail(stage, clickPoint) {

            $.ajax({
                url: "workbench/transaction/detail",
                type: "put",
                dataType: "json",
                data: {
                    stage: stage,
                    id: "${t.id}",
                    money: "${t.money}",
                    expecteddate: "${t.expecteddate}"
                },
                success: function (result) {
                    var t = result.extendInfo.t;
                    alert(result.status);
                    $("#stage").html(t.stage);
                    $("#possibility").html(t.possibility);
                    $("#editby").html(t.editby);
                    $("#edittime").html(t.edittime);
                    //刷新交易历史栏
                    build_tran_history();

                    //更新阶段图标
                    refresh_stage_icon(clickPoint);

                }
            })

        }

        //更新阶段图标
        function refresh_stage_icon(clickPoint) {

            //分成可能性大于0和可能性小于0两种情况
            var point = "<%=point%>";//可能性分界点
            var currentPoint = clickPoint;//当前点击的阶段的下标
            var stagesSize = "<%=stages.size()%>";//阶段的长度

            //当前阶段可能性为0
            if(currentPoint >= point){

                //分界点之前
                for (var i = 0; i < point; i++) {
                    $("#" + i).removeClass();
                    $("#" + i).addClass("glyphicon glyphicon-ok-circle mystage");
                    $("#" + i).css("color","#90F790")
                }
                //分界点之后
                for (var i = point; i < stagesSize; i++) {
                    if(i == currentPoint){
                        $("#" + i).removeClass();
                        $("#" + i).addClass("glyphicon glyphicon-remove mystage");
                        $("#" + i).css("color","#FF0000")
                    }else{
                        $("#" + i).removeClass();
                        $("#" + i).addClass("glyphicon glyphicon-remove mystage");
                        $("#" + i).css("color","#000000")
                    }
                }

                //当前阶段可能性不为0
            }else{

                for (var i = 0; i < currentPoint; i++) {
                    $("#" + i).removeClass();
                    $("#" + i).addClass("glyphicon glyphicon-ok-circle mystage");
                    $("#" + i).css("color","#90F790")
                }

                $("#" + currentPoint).removeClass();
                $("#" + currentPoint).addClass("glyphicon glyphicon-map-marker mystage");
                $("#" + currentPoint).css("color","#90F790")

                for (var i = Number(currentPoint) + 1; i < point; i++) {
                    $("#" + i).removeClass();
                    $("#" + i).addClass("glyphicon glyphicon-record mystage");
                    $("#" + i).css("color","#000000")
                }

                for (var i = point; i < stagesSize; i++) {
                    $("#" + i).removeClass();
                    $("#" + i).addClass("glyphicon glyphicon-remove mystage");
                    $("#" + i).css("color","#000000")
                }
            }

        }

        //交易历史的显示函数
        function build_tran_history() {

            $.ajax({
                url: "workbench/transaction/detail/tranHistory",
                type: "get",
                dataType: "json",
                data: {
                    tranId: "${t.id}"
                },
                success: function (result) {
                    html = "";
                    $.each(result, function (index, item) {
                        html += '<tr>';
                        html += '<td>' + item.stage + '</td>';
                        html += '<td>' + item.money + '</td>';
                        html += '<td>' + item.possibility + '</td>';
                        html += '<td>' + item.expecteddate + '</td>';
                        html += '<td>' + item.createtime + '</td>';
                        html += '<td>' + item.createby + '</td>';
                        html += '</tr>';
                    })
                    $("#activityTable tbody").html(html);
                }
            })

        }


    </script>

</head>
<body>

<!-- 返回按钮 -->
<div style="position: relative; top: 35px; left: 10px;">
    <a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left"
                                                                         style="font-size: 20px; color: #DDDDDD"></span></a>
</div>

<!-- 大标题 -->
<div style="position: relative; left: 40px; top: -30px;">
    <div class="page-header">
        <h3>${t.customerid}-${t.name} <small>￥${t.money}</small></h3>
    </div>
    <div style="position: relative; height: 50px; width: 250px;  top: -72px; left: 700px;">
        <button type="button" class="btn btn-default" onclick="window.location.href='edit.html';"><span
                class="glyphicon glyphicon-edit"></span> 编辑
        </button>
        <button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
    </div>
</div>

<!-- 阶段状态 -->
<div style="position: relative; left: 40px; top: -50px;">
    阶段&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <%


        //当前阶段可能性等于0的情况
        if ("0".equals(currentPoss)) {

            //从开头遍历到分界点都是绿√
            for (int i = 0; i < point; i++) {
                //绿√-------------------------------------------------------
    %>
    <span onclick="refresh_detail('<%=stages.get(i).getValue()%>', '<%=i%>')"
          class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom"
          data-content="<%=stages.get(i).getText()%>" style="color: #90F790;"></span>
    -----------
    <%

        }

        //从分界点到结尾，当遇到当前阶段为红×，其它都为绿×
        for (int i = point; i < stages.size(); i++) {
            if (stages.get(i).getValue().equals(currentStage)) {

                //红×-------------------------------------------------------
    %>
    <span id="<%=i%>" onclick="refresh_detail('<%=stages.get(i).getValue()%>', '<%=i%>')" class="glyphicon glyphicon-remove mystage"
          style="color: red;" data-toggle="popover" data-placement="bottom"
          data-content="<%=stages.get(i).getText()%>"></span>
    -----------
    <%

    } else {

        //黑×-------------------------------------------------------
    %>
    <span id="<%=i%>" onclick="refresh_detail('<%=stages.get(i).getValue()%>', '<%=i%>')" class="glyphicon glyphicon-remove mystage"
          data-toggle="popover" data-placement="bottom"
          data-content="<%=stages.get(i).getText()%>"></span>
    -----------
    <%
            }

        }

        //当前阶段可能性大于0的情况
    } else {

        for (int i = 0; i < currentPoint; i++) {
            //绿√-------------------------------------------------------
    %>
    <span id="<%=i%>" onclick="refresh_detail('<%=stages.get(i).getValue()%>', '<%=i%>')"
          class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom"
          data-content="<%=stages.get(i).getText()%>" style="color: #90F790;"></span>
    -----------
    <%

        }
        //绿色当前标记-------------------------------------------------------
    %>
    <span id="<%=currentPoint%>" onclick="refresh_detail('<%=stages.get(currentPoint).getValue()%>','<%=currentPoint%>')"
          class="glyphicon glyphicon-map-marker mystage" data-toggle="popover" data-placement="bottom"
          data-content="<%=currentStage%>" style="color: #90F790;"></span>
    -----------
    <%


        for (int i = currentPoint + 1; i < point; i++) {
            //黑○-------------------------------------------------------
    %>
    <span id="<%=i%>" onclick="refresh_detail('<%=stages.get(i).getValue()%>', '<%=i%>')" class="glyphicon glyphicon-record mystage"
          data-toggle="popover" data-placement="bottom"
          data-content="<%=stages.get(i).getText()%>"></span>
    -----------
    <%

        }

        for (int i = point; i < stages.size(); i++) {
            //黑×-------------------------------------------------------
    %>
    <span id="<%=i%>" onclick="refresh_detail('<%=stages.get(i).getValue()%>', '<%=i%>')" class="glyphicon glyphicon-remove mystage"
          data-toggle="popover" data-placement="bottom"
          data-content="<%=stages.get(i).getText()%>"></span>
    -----------
    <%
            }

        }


    %>
    <%--    <span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom"--%>
    <%--          data-content="资质审查" style="color: #90F790;"></span>--%>
    <%--    -------------%>
    <%--    <span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom"--%>
    <%--          data-content="需求分析" style="color: #90F790;"></span>--%>
    <%--    -------------%>
    <%--    <span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom"--%>
    <%--          data-content="价值建议" style="color: #90F790;"></span>--%>
    <%--    -------------%>
    <%--    <span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom"--%>
    <%--          data-content="确定决策者" style="color: #90F790;"></span>--%>
    <%--    -------------%>
    <%--    <span class="glyphicon glyphicon-map-marker mystage" data-toggle="popover" data-placement="bottom"--%>
    <%--          data-content="提案/报价" style="color: #90F790;"></span>--%>
    <%--    -------------%>
    <%--    <span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom"--%>
    <%--          data-content="谈判/复审"></span>--%>
    <%--    -------------%>
    <%--    <span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom"--%>
    <%--          data-content="成交"></span>--%>
    <%--    -------------%>
    <%--    <span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom"--%>
    <%--          data-content="丢失的线索"></span>--%>
    <%--    -------------%>
    <%--    <span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom"--%>
    <%--          data-content="因竞争丢失关闭"></span>--%>
    <%--    -------------%>
    <span class="closingDate">${t.expecteddate}</span>
</div>

<!-- 详细信息 -->
<div style="position: relative; top: 0px;">
    <div style="position: relative; left: 40px; height: 30px;">
        <div style="width: 300px; color: gray;">所有者</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${t.owner}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">金额</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${t.money}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 10px;">
        <div style="width: 300px; color: gray;">名称</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${t.name}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">预计成交日期</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${t.expecteddate}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 20px;">
        <div style="width: 300px; color: gray;">客户名称</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${t.customerid}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">阶段</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="stage">${t.stage}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 30px;">
        <div style="width: 300px; color: gray;">类型</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${t.type}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">可能性</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="possibility">${t.possibility}</b>
        </div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 40px;">
        <div style="width: 300px; color: gray;">来源</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${t.source}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">市场活动源</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${t.activityid}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 50px;">
        <div style="width: 300px; color: gray;">联系人名称</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${t.contactsid}</b></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 60px;">
        <div style="width: 300px; color: gray;">创建者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${t.createby}&nbsp;&nbsp;</b><small
                style="font-size: 10px; color: gray;">${t.createtime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 70px;">
        <div style="width: 300px; color: gray;">修改者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b
                id="editby">${t.editby}&nbsp;&nbsp;</b><small
                style="font-size: 10px; color: gray;" id="edittime">${t.edittime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 80px;">
        <div style="width: 300px; color: gray;">描述</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${t.description}&nbsp;
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 90px;">
        <div style="width: 300px; color: gray;">联系纪要</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${t.contactsummary}&nbsp;
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 100px;">
        <div style="width: 300px; color: gray;">下次联系时间</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${t.nextcontacttime}&nbsp;</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
</div>

<!-- 备注 -->
<div style="position: relative; top: 100px; left: 40px;">
    <div class="page-header">
        <h4>备注</h4>
    </div>

    <!-- 备注1 -->
    <div class="remarkDiv" style="height: 60px;">
        <img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
        <div style="position: relative; top: -40px; left: 40px;">
            <h5>哎呦！</h5>
            <font color="gray">交易</font> <font color="gray">-</font> <b>动力节点-交易01</b> <small style="color: gray;">
            2017-01-22 10:10:10 由zhangsan</small>
            <div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
                <a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit"
                                                                   style="font-size: 20px; color: #E6E6E6;"></span></a>
                &nbsp;&nbsp;&nbsp;&nbsp;
                <a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove"
                                                                   style="font-size: 20px; color: #E6E6E6;"></span></a>
            </div>
        </div>
    </div>

    <!-- 备注2 -->
    <div class="remarkDiv" style="height: 60px;">
        <img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
        <div style="position: relative; top: -40px; left: 40px;">
            <h5>呵呵！</h5>
            <font color="gray">交易</font> <font color="gray">-</font> <b>动力节点-交易01</b> <small style="color: gray;">
            2017-01-22 10:20:10 由zhangsan</small>
            <div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
                <a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit"
                                                                   style="font-size: 20px; color: #E6E6E6;"></span></a>
                &nbsp;&nbsp;&nbsp;&nbsp;
                <a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove"
                                                                   style="font-size: 20px; color: #E6E6E6;"></span></a>
            </div>
        </div>
    </div>

    <div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
        <form role="form" style="position: relative;top: 10px; left: 10px;">
            <textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"
                      placeholder="添加备注..."></textarea>
            <p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
                <button id="cancelBtn" type="button" class="btn btn-default">取消</button>
                <button type="button" class="btn btn-primary">保存</button>
            </p>
        </form>
    </div>
</div>

<!-- 阶段历史 -->
<div>
    <div style="position: relative; top: 100px; left: 40px;">
        <div class="page-header">
            <h4>阶段历史</h4>
        </div>
        <div style="position: relative;top: 0px;">
            <table id="activityTable" class="table table-hover" style="width: 900px;">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td>阶段</td>
                    <td>金额</td>
                    <td>可能性</td>
                    <td>预计成交日期</td>
                    <td>创建时间</td>
                    <td>创建人</td>
                </tr>
                </thead>
                <tbody>
                </tbody>
            </table>
        </div>

    </div>
</div>

<div style="height: 200px;"></div>

</body>
</html>
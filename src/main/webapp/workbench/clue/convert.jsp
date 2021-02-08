<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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


    <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css"
          rel="stylesheet"/>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript"
            src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

    <script type="text/javascript">
        $(function () {
            $("#isCreateTransaction").click(function () {
                if (this.checked) {
                    $("#create-transaction2").show(200);
                } else {
                    $("#create-transaction2").hide(200);
                }
            });
            //时间控件
            $(".time").datetimepicker({
                minView: "month",
                language: 'zh-CN',
                format: 'yyyy-mm-dd',
                autoclose: true,
                todayBtn: true,
                pickerPosition: "top-left"
            });

            //点击市场活动源的放大镜，打开模态窗口
            $("#activity-source").click(function () {
                //清空搜索栏的内容
                $("#input-activity-name").val("");
                //设置状态为打开状态
                $("#searchActivityModal").attr("status", "open")
                search_Activity();
            })

            //按回车模糊查询
            $(window).keydown(function (event) {
                if (event.keyCode == 13 && $("#searchActivityModal").attr("status") == "open") {
                    search_Activity($("#input-activity-name").val());
                    return false;
                }
            })

            //点击提交，将选中的客户名字放到下方的输入栏中，并且获取activityid的值存到隐藏域中
            $("#submitActivityBtn").click(function () {
                //放id
                $("#convert-form input[name=activityid]").val($("#activityTable input[name=activity]:checked").val());
                //放Name
                $("#activity").val($("#" + $("#activityTable input:checked").val()).html());
                set_status_close();
                $("#searchActivityModal").modal('hide');
            })


            //点击转换按钮，删掉线索的所有内容，创建客户，联系人和交易（选择）
            $("#convertBtn").click(function () {
                //用户友好提示
                var confirmStr = "本次即将新建的客户为：【${param.company}】,联系人为：【${param.fullname}${param.appellation}】";
                if ($("#isCreateTransaction").prop("checked") == true) {
                    confirmStr += ",交易名为：【" + $("#tradeName").val() + "】";
                }
                confirmStr += "。确定要进行转换吗?";

                //进行线索转换的后台处理：删掉线索的所有内容，创建客户，联系人和交易（选择）
                //并且跳转到clue下的index.jsp
                if (confirm(confirmStr)) {
                    //把线索的id传入表单的隐藏域中
                    $("#convert-form input[name=clueId]").val("${param.id}");
                    $("#convert-form input[name=flag]").val($("#isCreateTransaction").prop("checked"));
                    $("#convert-form").submit();
                    return false;
                }
            })


        });

        //对传单进行模糊查询,获取市场活动源表单
        function search_Activity(aName) {
            $.ajax({
                url: "workbench/clue/detail/convert",
                type: "get",
                dataType: "json",
                data: {
                    "aName": aName
                },
                success: function (result) {
                    var html = "";
                    $.each(result.extendInfo.activityList, function (index, item) {
                        html += '<tr>';
                        html += '<td><input type="radio" value="' + item.id + '" name="activity"/></td>';
                        html += '<td id="' + item.id + '">' + item.name + '</td>';
                        html += '<td>' + item.startDate + '</td>';
                        html += '<td>' + item.endDate + '</td>';
                        html += '<td>' + item.owner + '</td>';
                        html += '</tr>';
                    })
                    $("#activityTable tbody").html(html);
                }
            })

            $("#searchActivityModal").modal('show');
        }

        function set_status_close() {
            $("#searchActivityModal").attr("status", "close");
        }
    </script>

</head>
<body>

<!-- 搜索市场活动的模态窗口 -->
<div class="modal fade" id="searchActivityModal" role="dialog" status="close">
    <div class="modal-dialog" role="document" style="width: 90%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">搜索市场活动</h4>
            </div>
            <div class="modal-body">
                <div class="btn-group" style="position: relative; top: 18%; left: 8px;">
                    <form class="form-inline" role="form">
                        <div class="form-group has-feedback">
                            <input type="text" class="form-control" id="input-activity-name" style="width: 300px;"
                                   placeholder="请输入市场活动名称，支持模糊查询">
                            <span class="glyphicon glyphicon-search form-control-feedback"></span>
                        </div>
                    </form>
                </div>
                <table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
                    <thead>
                    <tr style="color: #B3B3B3;">
                        <td></td>
                        <td>名称</td>
                        <td>开始日期</td>
                        <td>结束日期</td>
                        <td>所有者</td>
                        <td></td>
                    </tr>
                    </thead>
                    <tbody>
                    <%--							<tr>--%>
                    <%--								<td><input type="radio" name="activity"/></td>--%>
                    <%--								<td>发传单</td>--%>
                    <%--								<td>2020-10-10</td>--%>
                    <%--								<td>2020-10-20</td>--%>
                    <%--								<td>zhangsan</td>--%>
                    <%--							</tr>--%>
                    <%--							<tr>--%>
                    <%--								<td><input type="radio" name="activity"/></td>--%>
                    <%--								<td>发传单</td>--%>
                    <%--								<td>2020-10-10</td>--%>
                    <%--								<td>2020-10-20</td>--%>
                    <%--								<td>zhangsan</td>--%>
                    <%--							</tr>--%>
                    </tbody>
                </table>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal" onclick="set_status_close()">取消
                </button>
                <button type="button" class="btn btn-primary" id="submitActivityBtn">提交</button>
            </div>
        </div>
    </div>
</div>

<div id="title" class="page-header" style="position: relative; left: 20px;">
    <h4>转换线索 <small>${param.fullname}${param.appellation}-${param.company}</small></h4>
</div>
<div id="create-customer" style="position: relative; left: 40px; height: 35px;">
    新建客户：${param.company}
</div>
<div id="create-contact" style="position: relative; left: 40px; height: 35px;">
    新建联系人：${param.fullname}${param.appellation}
</div>
<div id="create-transaction1" style="position: relative; left: 40px; height: 35px; top: 25px;">
    <input type="checkbox" id="isCreateTransaction"/>
    为客户创建交易
</div>
<div id="create-transaction2"
     style="position: relative; left: 40px; top: 20px; width: 80%; background-color: #F7F7F7; display: none;">
    <form id="convert-form" method="post" action="workbench/clue/detail/convert">
        <input type="hidden" name="activityid"/>
        <input type="hidden" name="clueId"/>
        <input type="hidden" name="flag" value="false"/>
        <div class="form-group" style="width: 400px; position: relative; left: 20px;">
            <label for="amountOfMoney">金额</label>
            <input type="text" class="form-control" id="amountOfMoney" name="money">
        </div>
        <div class="form-group" style="width: 400px;position: relative; left: 20px;">
            <label for="tradeName">交易名称</label>
            <input type="text" class="form-control" id="tradeName" name="name" value="动力节点-">
        </div>
        <div class="form-group" style="width: 400px;position: relative; left: 20px;">
            <label for="expectedClosingDate">预计成交日期</label>
            <input type="text" name="expecteddate" class="form-control time" id="expectedClosingDate">
        </div>
        <div class="form-group" style="width: 400px;position: relative; left: 20px;">
            <label for="stage">阶段</label>
            <select id="stage" class="form-control" name="stage">
                <c:forEach items="${stage}" var="s">
                    <option>${s.value}</option>
                </c:forEach>
            </select>
        </div>
        <div class="form-group" style="width: 400px;position: relative; left: 20px;">
            <label for="activity">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" id="activity-source"
                                                      style="text-decoration: none;"><span
                    class="glyphicon glyphicon-search"></span></a></label>
            <input type="text" class="form-control" id="activity" placeholder="点击上面搜索" readonly>
        </div>
    </form>

</div>

<div id="owner" style="position: relative; left: 40px; height: 35px; top: 50px;">
    记录的所有者：<br>
    <b>${param.owner}</b>
</div>
<div id="operation" style="position: relative; left: 40px; height: 35px; top: 100px;">
    <input class="btn btn-primary" type="button" id="convertBtn" value="转换">
    <input class="btn btn-default" type="button" value="取消">
</div>
</body>
</html>
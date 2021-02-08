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
    <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css"
          rel="stylesheet"/>

    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript"
            src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript"
            src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
    <script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>
<body>

<!-- 查找市场活动 -->
<div class="modal fade" id="findMarketActivity" role="dialog" status="">
    <div class="modal-dialog" role="document" style="width: 80%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">查找市场活动</h4>
            </div>
            <div class="modal-body">
                <div class="btn-group" style="position: relative; top: 18%; left: 8px;">
                    <form class="form-inline" role="form">
                        <div class="form-group has-feedback">
                            <input type="text" class="form-control" style="width: 300px;"
                                   placeholder="请输入市场活动名称，支持模糊查询">
                            <span class="glyphicon glyphicon-search form-control-feedback"></span>
                        </div>
                    </form>
                </div>
                <table id="activityTable3" class="table table-hover"
                       style="width: 900px; position: relative;top: 10px;">
                    <thead>
                    <tr style="color: #B3B3B3;">
                        <td></td>
                        <td>名称</td>
                        <td>开始日期</td>
                        <td>结束日期</td>
                        <td>所有者</td>
                    </tr>
                    </thead>
                    <tbody>
                    <%--                    <tr>--%>
                    <%--                        <td><input type="radio" name="activity"/></td>--%>
                    <%--                        <td>发传单</td>--%>
                    <%--                        <td>2020-10-10</td>--%>
                    <%--                        <td>2020-10-20</td>--%>
                    <%--                        <td>zhangsan</td>--%>
                    <%--                    </tr>--%>
                    <%--                    <tr>--%>
                    <%--                        <td><input type="radio" name="activity"/></td>--%>
                    <%--                        <td>发传单</td>--%>
                    <%--                        <td>2020-10-10</td>--%>
                    <%--                        <td>2020-10-20</td>--%>
                    <%--                        <td>zhangsan</td>--%>
                    <%--                    </tr>--%>
                    </tbody>
                </table>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消
                </button>
                <button type="button" class="btn btn-primary" id="submitActivityBtn">提交</button>
            </div>
        </div>
    </div>
</div>

<!-- 查找联系人 -->
<div class="modal fade" id="findContacts" role="dialog" status="">
    <div class="modal-dialog" role="document" style="width: 80%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">查找联系人</h4>
            </div>
            <div class="modal-body">
                <div class="btn-group" style="position: relative; top: 18%; left: 8px;">
                    <form class="form-inline" role="form">
                        <div class="form-group has-feedback">
                            <input type="text" class="form-control" style="width: 300px;" placeholder="请输入联系人名称，支持模糊查询">
                            <span class="glyphicon glyphicon-search form-control-feedback"></span>
                        </div>
                    </form>
                </div>
                <table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
                    <thead>
                    <tr style="color: #B3B3B3;">
                        <td></td>
                        <td>名称</td>
                        <td>邮箱</td>
                        <td>手机</td>
                    </tr>
                    </thead>
                    <tbody>
                    <%--                    <tr>--%>
                    <%--                        <td><input type="radio" name="activity"/></td>--%>
                    <%--                        <td>李四</td>--%>
                    <%--                        <td>lisi@bjpowernode.com</td>--%>
                    <%--                        <td>12345678901</td>--%>
                    <%--                    </tr>--%>
                    <%--                    <tr>--%>
                    <%--                        <td><input type="radio" name="activity"/></td>--%>
                    <%--                        <td>李四</td>--%>
                    <%--                        <td>lisi@bjpowernode.com</td>--%>
                    <%--                        <td>12345678901</td>--%>
                    <%--                    </tr>--%>
                    </tbody>
                </table>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消
                </button>
                <button type="button" class="btn btn-primary" id="submitContactsName">提交</button>
            </div>
        </div>
    </div>
</div>


<div style="position:  relative; left: 30px;">
    <h3>创建交易</h3>
    <div style="position: relative; top: -40px; left: 70%;">
        <button type="button" class="btn btn-primary" id="saveBtn">保存</button>
        <button type="button" class="btn btn-default">取消</button>
    </div>
    <hr style="position: relative; top: -40px;">
</div>
<form id="tran-form" action="workbench/transaction/save" method="post"
      class="form-horizontal" role="form" style="position: relative; top: -30px;">
    <div class="form-group">
        <label for="create-transactionOwner" class="col-sm-2 control-label">所有者<span
                style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="create-transactionOwner" name="owner">
                <option></option>
                <c:forEach items="${userList}" var="u">
                    <option value="${u.id}" ${loginUser.id eq u.id?"selected":""}>${u.name}</option>
                </c:forEach>
            </select>
        </div>
        <label for="create-amountOfMoney" class="col-sm-2 control-label">金额</label>
        <div class="col-sm-10" style="width: 300px;">
            <input name="money" type="text" class="form-control" id="create-amountOfMoney">
        </div>
    </div>

    <div class="form-group">
        <label for="create-transactionName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <input name="name" type="text" class="form-control" id="create-transactionName">
        </div>
        <label for="create-expectedClosingDate" class="col-sm-2 control-label">预计成交日期<span
                style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <input name="expecteddate" type="text" class="form-control" id="create-expectedClosingDate">
        </div>
    </div>

    <div class="form-group">
        <label for="create-accountName" class="col-sm-2 control-label">客户名称<span
                style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <input name="customerid" type="text" class="form-control" id="create-accountName"
                   placeholder="支持自动补全，输入客户不存在则新建">
        </div>
        <label for="create-transactionStage" class="col-sm-2 control-label">阶段<span
                style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="create-transactionStage" name="stage">
                <option></option>
                <c:forEach items="${stage}" var="s">
                    <option value="${s.value}">${s.text}</option>
                </c:forEach>
            </select>
        </div>
    </div>

    <div class="form-group">
        <label for="create-transactionType" class="col-sm-2 control-label">类型</label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="create-transactionType" name="type">
                <option></option>
                <c:forEach items="${transactionType}" var="tt">
                    <option value="${tt.value}">${tt.text}</option>
                </c:forEach>
            </select>
        </div>
        <label for="create-possibility" class="col-sm-2 control-label">可能性</label>
        <div class="col-sm-10" style="width: 300px;">
            <input name="possibility" type="text" class="form-control" id="create-possibility" readonly>
        </div>
    </div>

    <div class="form-group">
        <label for="create-clueSource" class="col-sm-2 control-label">来源</label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="create-clueSource" name="source">
                <option></option>
                <c:forEach items="${source}" var="src">
                    <option value="${src.value}">${src.text}</option>
                </c:forEach>
            </select>
        </div>
        <label for="create-activitySrc" class="col-sm-2 control-label">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);"
                                                                                           data-toggle="modal"
                                                                                           data-target="#findMarketActivity"
                                                                                           id="searchActivityBtn"><span
                class="glyphicon glyphicon-search"></span></a></label>
        <div class="col-sm-10" style="width: 300px;">
            <input name="activityName" type="text" class="form-control" id="create-activitySrc" readonly>
            <input type="hidden" name="activityid" id="create-activitySrc-id"/>
        </div>
    </div>

    <div class="form-group">
        <label for="create-contactsName" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;<a href="javascript:void(0);"
                                                                                            data-toggle="modal"
                                                                                            data-target="#findContacts"
                                                                                            id="searchContactsBtn"><span
                class="glyphicon glyphicon-search"></span></a></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-contactsName" readonly>
            <input type="hidden" id="create-contactsName-id" name="contactsid">
        </div>
    </div>

    <div class="form-group">
        <label for="create-describe" class="col-sm-2 control-label">描述</label>
        <div class="col-sm-10" style="width: 70%;">
            <textarea name="description" class="form-control" rows="3" id="create-describe"></textarea>
        </div>
    </div>

    <div class="form-group">
        <label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
        <div class="col-sm-10" style="width: 70%;">
            <textarea name="contactsummary" class="form-control" rows="3" id="create-contactSummary"></textarea>
        </div>
    </div>

    <div class="form-group">
        <label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
        <div class="col-sm-10" style="width: 300px;">
            <input name="nextcontacttime" type="text" class="form-control time" id="create-nextContactTime">
        </div>
    </div>

</form>


<script type="text/javascript">
    $(function () {

        //时间控件
        $(".time").datetimepicker({
            minView: "month",
            language: 'zh-CN',
            format: 'yyyy-mm-dd',
            autoclose: true,
            todayBtn: true,
            pickerPosition: "top-left"
        });

        do_search_activity("searchActivityBtn", "findMarketActivity");
        do_search_activity("searchContactsBtn", "findContacts");

        //自动补全客户名称
        $("#create-accountName").typeahead({
            source: function (query, process) {
                $.get(
                    "workbench/transaction/customer/search",
                    {"name": query},
                    function (data) {
                        //alert(data);
                        process(data);
                    },
                    "json"
                );
            },
            delay: 500
        });

        //可能性随阶段的变化而变化
        $("#create-transactionStage").change(function () {
            var stage = $(this).val();
            var possJSON = JSON.parse('${possJSON}');
            $("#create-possibility").val(possJSON[stage])
        })

        //保存交易，通过后台跳转到index页面
        $("#saveBtn").click(function () {
            $("#tran-form").submit();
        })

        //市场活动源点击提交按钮，关闭模态窗口
        $("#submitActivityBtn").click(function () {
            $("#create-activitySrc").val($(".activityItem:checked").parent().parent().find("td:eq(1)").html());
            $("#create-activitySrc-id").val($(".activityItem:checked").val())
            $("#findMarketActivity").modal('hide');
        })

        //联系人名称点击提交按钮，关闭模态窗口
        $("#submitContactsName").click(function () {
            $("#create-contactsName").val($(".contactsItem:checked").parent().parent().find("td:eq(1)").html());
            $("#create-contactsName-id").val($(".contactsItem:checked").val())
            $("#findContacts").modal('hide');
        })

    })

    //封装了联系人查询和时长活动源查询的所有逻前端逻辑
    function do_search_activity(searchBtnId, modalId) {
        //市场活动源模糊查询
        $("#" + searchBtnId).click(function () {
            //模态框状态属性设置为打开
            $("#" + modalId).attr("status", "open");
            if (searchBtnId == "searchActivityBtn") {
                search_activity_like($("#" + modalId + " input").val());
            } else if (searchBtnId == "searchContactsBtn") {
                search_contacts_like($("#" + modalId + " input").val())
            }
        })

        $(window).keydown(function (event) {
            //判断一下模态窗在打开的情况下，按了回车
            if ($("#" + modalId).attr("status") == "open" && event.keyCode == 13) {
                if (searchBtnId == "searchActivityBtn") {
                    search_activity_like($("#" + modalId + " input").val());
                } else if (searchBtnId == "searchContactsBtn") {
                    search_contacts_like($("#" + modalId + " input").val())
                }
                return false;
            }
        })

        //查找市场活动模态窗口关闭时，让status为close
        $("#" + modalId).on('hide.bs.modal', function () {
            $("#" + modalId).attr("status", "close");
            //清空搜索栏
            $("#" + modalId + " input").val("")
        })


    }

    function search_activity_like(name) {
        $.ajax({
            url: "workbench/transaction/activity/search",
            type: "get",
            dataType: "json",
            data: {
                name: name
            },
            success: function (result) {
                html = "";
                $.each(result, function (index, item) {
                    html += '<tr>';
                    html += '<td><input class="activityItem" type="radio" name="activity" value="' + item.id + '"/></td>';
                    html += '<td>' + item.name + '</td>';
                    html += '<td>' + item.startDate + '</td>';
                    html += '<td>' + item.endDate + '</td>';
                    html += '<td>' + item.owner + '</td>';
                    html += '</tr>';
                })
                $("#findMarketActivity tbody").html(html);

            }
        })
    }

    function search_contacts_like(name) {
        $.ajax({
            url: "workbench/transaction/contacts/search",
            type: "get",
            dataType: "json",
            data: {
                name: name
            },
            success: function (result) {
                html = "";
                $.each(result, function (index, item) {
                    html += '<tr>';
                    html += '<td><input class="contactsItem" type="radio" name="activity" value="' + item.id + '"/></td>';
                    html += '<td>' + item.fullname + '</td>';
                    html += '<td>' + item.email + '</td>';
                    html += '<td>' + item.mphone + '</td>';
                    html += '</tr>';
                })
                $("#findContacts tbody").html(html);

            }
        })
    }
</script>
</body>
</html>
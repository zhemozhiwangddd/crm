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
    <link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript"
            src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript"
            src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination/en.js"></script>

    <script type="text/javascript">

        $(function () {

            //点击创建，弹出模态框
            $("#addBtn").click(function () {
                //清空表单
                // $("#create-activity-form")[0].reset();
                //清空下拉框中的内容
                $("#create-marketActivityOwner").empty();
                //获取表单中的所有者列表，并默认选择登录用户
                $.ajax({
                    url: "workbench/activity/users",
                    type: "get",
                    dataType: "json",
                    success: function (result) {
                        $.each(result, function (index, item) {
                            $("#create-marketActivityOwner").append($("<option></option>").html(item.name).val(item.id));
                        })
                        $("#create-marketActivityOwner").val("${sessionScope.loginUser.id}")
                    }
                })

                //弹出模态框
                $("#create-activity-modal").modal('show');
            })

            //时间控件
            $(".time").datetimepicker({
                minView: "month",
                language: 'zh-CN',
                format: 'yyyy-mm-dd',
                autoclose: true,
                todayBtn: true,
                pickerPosition: "bottom-left"
            });

            //点击保存按钮时创建市场活动
            $("#saveBtn").click(function () {

                $.ajax({
                    url: "workbench/activity",
                    type: "post",
                    dataType: "json",
                    data: $("#create-activity-form").serialize(),
                    success: function (result) {
                        alert(result.status);
                        //关闭模态框
                        $("#create-activity-modal").modal('hide');
                        page_to(1, $("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
                    }
                })
            })

            //分页
            //前端：在页面刷新时就自动执行一个分页的ajax请求（写到函数中方便调用）。to_page(1)
            //后端：利用pageHelper在查完以后进行分页，分页结果利用PageInfo包装后返回到页面中
            //什么情况下？
            //1、在页面加载完成后
            //2、创建，修改，删除模态创库欧关闭后
            //3、执行完查询操作后
            page_to(1, 10);

            //点击查询按钮后，将搜索栏中的内容保存到隐藏域中，并执行分页操作
            $("#search-activities").click(function () {

                $("#hidden-name").val($.trim($("#search-name").val()));
                $("#hidden-owner").val($.trim($("#search-owner").val()));
                $("#hidden-startDate").val($.trim($("#search-startDate").val()));
                $("#hidden-endDate").val($.trim($("#search-endDate").val()));
                page_to(1, $("#activityPage").bs_pagination('getOption', 'rowsPerPage'));

            })

            //点击选中所有的按钮
            $("#check-all").click(function () {
                $(".checkbox-item").prop("checked", this.checked);
            })

            //动态绑定单选选项
            $(document).on("click", ".checkbox-item", function () {
                var flag = $(".checkbox-item").length == $(".checkbox-item:checked").length;
                $("#check-all").prop("checked", flag);
            })

            //点击删除，删掉选中的按钮
            $("#delBtn").click(function () {
                var checked_items = $(".checkbox-item:checked");
                var param_str = "";
                var act_name_str = "";
                //需要获取需要删除的活动的id
                $.each(checked_items, function (index, item) {
                    if (index == checked_items.length - 1) {
                        param_str += "id=" + item.value;
                        act_name_str += $(item).parents("tr").find("td:eq(1)").find("a").html()
                    }else{
                        param_str += "id=" + item.value + "&";
                        act_name_str += $(item).parents("tr").find("td:eq(1)").find("a").html() + ", ";
                    }
                })
                //确认删除
                if(confirm("你确定要删除【" + act_name_str + "】吗?")){
                    $.ajax({
                        url:"workbench/activity?" + param_str,
                        type:"delete",
                        dataType:"json",
                        success:function (result) {
                            alert(result.status);
                            page_to($("#activityPage").bs_pagination('getOption', 'currentPage'),
                                $("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
                        }
                    })
                }
            })
            
            //点击修改，将信息传到模态窗口上，并打开模态窗
            $("#editBtn").click(function () {
                if($(".checkbox-item:checked").length == 0){
                    alert("请选择需要修改的活动");
                }else if($(".checkbox-item:checked").length > 1){
                    alert("只能选择一个活动进行修改");
                }else{

                    //先清空表单中的内容
                    $("#edit-activity-form")[0].reset();
                    $("#edit-marketActivityOwner").empty();
                    
                    var id = $(".checkbox-item:checked").val();
                    //阿贾克斯请求获取活动信息
                    $.ajax({
                        url:"workbench/activity/edit",
                        type:"get",
                        dataType:"json",
                        data:{
                          "id":id
                        },
                        success:function (result) {
                            //所有者下拉菜单
                            $.each(result.users, function (index, item) {
                                $("#edit-marketActivityOwner").append($("<option></option>").val(item.id).html(item.name));
                            })
                            $("#edit-marketActivityOwner").val("${sessionScope.loginUser.id}")
                            $("#edit-marketActivityName").val(result.activity.name);
                            $("#edit-startDate").val(result.activity.startDate);
                            $("#edit-endDate").val(result.activity.endDate);
                            $("#edit-cost").val(result.activity.cost);
                            $("#edit-describe").val(result.activity.description);
                            $("#edit-id").val(id);
                            $("#edit-activity-modal").modal('show');
                        }
                    })

                }
            })

            //点击更改后，更新信息，并且关闭模态框，在当前活动进行分页
            //（3）更新后，在哪一页还回到哪一页
            // 关键代码
            // pageList($("#activityPage").bs_pagination('getOption', 'currentPage')
            //     ,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));

            $("#editConfirmBtn").click(function () {
                $.ajax({
                    url: "workbench/activity",
                    type: "put",
                    dataType: "json",
                    data: $("#edit-activity-form").serialize(),
                    success: function (result) {
                        alert(result.status);
                        //关闭模态框
                        $("#edit-activity-modal").modal('hide');
                        page_to($("#activityPage").bs_pagination('getOption', 'currentPage'),
                            $("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
                    }
                })
            })

        });


        //函数：获取分页信息并在页面上显示
        function page_to(pageNum, pageSize) {
            $("#search-name").val($.trim($("#hidden-name").val()));
            $("#search-owner").val($.trim($("#hidden-owner").val()));
            $("#search-startDate").val($.trim($("#hidden-startDate").val()));
            $("#search-endDate").val($.trim($("#hidden-endDate").val()));
            $.ajax({
                url: "workbench/activity/page",
                type: "get",
                dataType: "json",
                data: {
                    "pageNum": pageNum,
                    "pageSize": pageSize,
                    "name": $("#search-name").val(),
                    "owner": $("#search-owner").val(),
                    "startDate": $("#search-startDate").val(),
                    "endDate": $("#search-endDate").val()
                },
                success: function (result) {
                    var pageInfo = result.extendInfo.pageInfo;//分页信息
                    var actList = pageInfo.list;//获取的传单对象
                    $("#hidden-pageNum").val(pageInfo.pageNum);
                    //信息列表：循环，将数据在列表中列出来
                    build_activity_table(actList);
                    //分页栏：把pageInfo里的信息展示出来
                    build_page_nav(pageInfo);
                }
            })
        }

        //活动列表的创建
        function build_activity_table(actList) {
            //清空活动列表
            $("#activity_table tbody").empty();
            //信息列表：循环，将数据在列表中列出来
            $.each(actList, function (index, item) {
                var td_checkBox = $("<td><input type='checkbox' class='checkbox-item' value='" + item.id + "'/></td>");
                var td_name = $("<td></td>").append($("<a style=\"text-decoration: none; cursor: pointer;\" " +
                    "onclick=\"window.location.href='workbench/activity/detail?id=" + item.id + "'\"></a>").html(item.name));
                var td_owner = $("<td></td>").html(item.owner);
                var td_start_date = $("<td></td>").html(item.startDate);
                var td_end_date = $("<td></td>").html(item.endDate);
                $("<tr></tr>").addClass("active").append(td_checkBox)
                    .append(td_name).append(td_owner).append(td_start_date)
                    .append(td_end_date).appendTo($("#activity_table tbody"));
            })
        }

        //分页栏的创建
        function build_page_nav(pageInfo) {
            $("#activityPage").bs_pagination({
                currentPage: pageInfo.pageNum, // 页码
                rowsPerPage: pageInfo.pageSize, // 每页显示的记录条数
                maxRowsPerPage: 20, // 每页最多显示的记录条数
                totalPages: pageInfo.pages, // 总页数
                totalRows: pageInfo.total, // 总记录条数

                visiblePageLinks: pageInfo.navigatePages, // 显示几个卡片

                showGoToPage: true,
                showRowsPerPage: true,
                showRowsInfo: true,
                showRowsDefaultInfo: true,

                //点击分页栏中的内容后的回调函数
                onChangePage: function (event, data) {
                    page_to(data.currentPage, data.rowsPerPage);
                }
            });
        }


    </script>
</head>
<body>
<%--隐藏域--%>
<input type="hidden" id="hidden-name"/>
<input type="hidden" id="hidden-owner"/>
<input type="hidden" id="hidden-startDate"/>
<input type="hidden" id="hidden-endDate"/>
<input type="hidden" id="hidden-pageNum"/>

<!-- 创建市场活动的模态窗口 -->
<div class="modal fade" id="create-activity-modal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
            </div>
            <div class="modal-body">

                <form class="form-horizontal" role="form" id="create-activity-form">

                    <div class="form-group">
                        <label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-marketActivityOwner" name="owner">
                            </select>
                        </div>
                        <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-marketActivityName" name="name">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-startDate" class="col-sm-2 control-label">开始日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" id="create-startDate" name="startDate">
                        </div>
                        <label for="create-endDate" class="col-sm-2 control-label">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" id="create-endDate" name="endDate">
                        </div>
                    </div>
                    <div class="form-group">

                        <label for="create-cost" class="col-sm-2 control-label">成本</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-cost" name="cost">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="create-describe" name="description"></textarea>
                        </div>
                    </div>

                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="saveBtn">保存</button>
            </div>
        </div>
    </div>
</div>

<!-- 修改市场活动的模态窗口 -->
<div class="modal fade" role="dialog" id="edit-activity-modal">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
            </div>
            <div class="modal-body">

                <form class="form-horizontal" role="form" id="edit-activity-form">
                    <input type="hidden" name="id" id="edit-id"/>
                    <div class="form-group">
                        <label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-marketActivityOwner" name="owner">
                                <option>zhangsan</option>
                                <option>lisi</option>
                                <option>wangwu</option>
                            </select>
                        </div>
                        <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" name = "name" id="edit-marketActivityName" value="发传单">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-startDate" class="col-sm-2 control-label">开始日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" name="startDate" id="edit-startDate" value="2020-10-10">
                        </div>
                        <label for="edit-endDate" class="col-sm-2 control-label">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" name="endDate" id="edit-endDate" value="2020-10-20">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-cost" class="col-sm-2 control-label">成本</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" name="cost" id="edit-cost" value="5,000">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" name="description" id="edit-describe"></textarea>
                        </div>
                    </div>

                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="editConfirmBtn">更新</button>
            </div>
        </div>
    </div>
</div>


<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>市场活动列表</h3>
        </div>
    </div>
</div>
<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
    <div style="width: 100%; position: absolute;top: 5px; left: 10px;">

        <div class="btn-toolbar" role="toolbar" style="height: 80px;">
            <form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">名称</div>
                        <input class="form-control" type="text" id="search-name">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">所有者</div>
                        <input class="form-control" type="text" id="search-owner">
                    </div>
                </div>


                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">开始日期</div>
                        <input class="form-control time" type="text" id="search-startDate"/>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">结束日期</div>
                        <input class="form-control time" type="text" id="search-endDate">
                    </div>
                </div>
                <button type="button" class="btn btn-default" id="search-activities">查询</button>
            </form>
        </div>
        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-primary" id="addBtn">
                    <span class="glyphicon glyphicon-plus"></span> 创建
                </button>
                <button type="button" class="btn btn-default" id="editBtn">
                    <span class="glyphicon glyphicon-pencil"></span> 修改
                </button>
                <button type="button" class="btn btn-danger" id="delBtn"><span class="glyphicon glyphicon-minus"></span>
                    删除
                </button>
            </div>

        </div>
        <div style="position: relative;top: 10px;" id="activity_table">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input type="checkbox" id="check-all"/></td>
                    <td>名称</td>
                    <td>所有者</td>
                    <td>开始日期</td>
                    <td>结束日期</td>
                </tr>
                </thead>
                <tbody>
                </tbody>
            </table>
        </div>

        <%--分页栏--%>
        <div style="height: 50px; position: relative;top: 30px;" id="activity_page_nav">
            <div id="activityPage"></div>
        </div>

    </div>

</div>
</body>
</html>
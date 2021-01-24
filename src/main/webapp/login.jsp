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
</head>
<body>
<div style="position: absolute; top: 0px; left: 0px; width: 60%;">
    <img src="image/IMG_7114.JPG" style="width: 100%; height: 90%; position: relative; top: 50px;">
</div>
<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
    <div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">
        CRM &nbsp;<span style="font-size: 12px;">&copy;2017&nbsp;动力节点</span></div>
</div>

<div style="position: absolute; top: 120px; right: 100px;width:450px;height:400px;border:1px solid #D5D5D5">
    <div style="position: absolute; top: 0px; right: 60px;">
        <div class="page-header">
            <h1>登录</h1>
        </div>
        <form action="workbench/index.jsp" class="form-horizontal" role="form">
            <div class="form-group form-group-lg">
                <div style="width: 350px;">
                    <input class="form-control" type="text" placeholder="用户名" id="input_name">
                </div>
                <div style="width: 350px; position: relative;top: 20px;">
                    <input class="form-control" type="password" placeholder="密码" id="input_password">
                </div>
                <div class="checkbox" style="position: relative;top: 30px; left: 10px;color: red;">

                    <span id="msg"></span>

                </div>
                <button type="button" id="login_btn" class="btn btn-primary btn-lg btn-block"
                        style="width: 350px; position: relative;top: 45px;">登录
                </button>
            </div>
        </form>
    </div>
</div>

<script type="text/javascript">

    //使login.jsp始终在顶层窗口中打开
    if(window.top!=window){
        window.top.location=window.location;
    }

    $(function () {
        //进入网页，用户名上直接给个焦点事件
        $("#input_name").focus();

        //点击登录可以登录
        $("#login_btn").click(function () {
            login();
        })
        //点击回车也可以登录
        $(window).keydown(function (event) {
            //按下按键后，从该事件中获取键码
            if(event.keyCode == 13){
                login();
            }
        })

    })

    //登录函数，需求：
    // 验证用户名密码正确
    // 验证失效时间
    // 验证锁定状态
    // 验证ip地址
    // 登录成功后跳转到workbench/index.jsp
    // 在工作台初始页展现用户名
    function login() {

        //处理一下输入栏中的内容
        //1.去除前后空格
        var username = $.trim($("#input_name").val());
        var password = $.trim($("#input_password").val());

        if(username == "" || password == ""){
            $("#msg").html("账号或密码不能为空")
            return false;
        }

        $.ajax({
            url:"settings/user/login",
            type:"get",
            dataType:"json",
            data:{
                "name":username,
                "loginPwd":password
            },
            success:function (result) {
                if(result.code == "200"){
                    $("#msg").html(result.status);
                    return false;
                }
                document.location.href = "workbench/index.jsp";
            }
        })
    }

</script>

</body>
</html>
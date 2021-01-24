<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2021/1/19 0019
  Time: 14:38
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String APP_PATH = request.getScheme() + "://"
            + request.getServerName() + ":"
            + request.getServerPort()
            + request.getContextPath() + "/";
%>
<html>
<head>
    <base href="<%=APP_PATH%>">
    <title>Title</title>
</head>
<body>
zhemozhiwang
<script type="text/javascript">
    //ajax模板
    $.ajax({
        url:"",
        type:"",
        dataType:"json",
        data:"",
        success:function (result) {

        }
    })
</script>
</body>
</html>

<%--
Created by IntelliJ IDEA.
User: Administrator
Date: 2021/1/31 0031
Time: 1:21
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
    <title>市场活动统计图表</title>
    <script src="ECharts/echarts.min.js"></script>
    <script src="jquery/jquery-1.11.1-min.js"></script>
    <script>

        $(function () {
            getCharts()
        })

        function getCharts() {

            $.ajax({
                url:"workbench/transaction/chart",
                type:"get",
                dataType:"json",
                success:function (result) {
                    // 基于准备好的dom，初始化echarts实例
                    var myChart = echarts.init(document.getElementById('main'));

                    // 指定图表的配置项和数据
                    option = {
                        title: {
                            text: '漏斗图',
                            subtext: '纯属虚构'
                        },

                        series: [
                            {
                                name:'漏斗图',
                                type:'funnel',
                                left: '0%',
                                top: 60,
                                //x2: 80,
                                width: '80%',
                                // height: {totalHeight} - y - y2,
                                min: 0,
                                max: result.total,
                                minSize: '0%',
                                maxSize: '100%',
                                sort: 'descending',
                                gap: 2,
                                label: {
                                    show: true,
                                    position: 'inside'
                                },
                                labelLine: {
                                    length: 10,
                                    lineStyle: {
                                        width: 1,
                                        type: 'solid'
                                    }
                                },
                                itemStyle: {
                                    borderColor: '#fff',
                                    borderWidth: 1
                                },
                                emphasis: {
                                    label: {
                                        fontSize: 20
                                    }
                                },
                                data:result.stageCount
                            }
                        ]
                    };

                    // 使用刚指定的配置项和数据显示图表。
                    myChart.setOption(option);
                }
            })


        }
    </script>
</head>
<body>
<!-- 为 ECharts 准备一个具备大小（宽高）的 DOM -->
<div id="main" style="width: 600px;height:400px;">dds</div>
</body>
</html>

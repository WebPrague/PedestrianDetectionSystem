<%--
  Created by IntelliJ IDEA.
  User: ZhangPeng
  Date: 2018/9/14
  Time: 10:15
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Pedestrian Detection</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <link href="static/css/bootstrap.min.css" rel="stylesheet" type="text/css"/>
    <script src="static/dist/echarts.js"></script>
</head>
<body>
<script type="text/javascript" src="static/js/jquery-2.2.4.min.js"></script>
<script src="static/js/bootstrap.min.js"></script>
<script src="static/js/holder.min.js"></script>
<script src="static/js/popper.min.js"></script>

<div>


<div  class="d-flex flex-column flex-md-row align-items-center p-3 px-md-4 mb-3 bg-white border-bottom box-shadow">
    <h5 class="my-0 mr-md-auto font-weight-normal">基于行人检测的视频监控系统</h5>
    <nav class="my-2 my-md-0 mr-md-3">

        <a class="p-2 text-dark">Hello!&nbsp;<%=session.getAttribute("username")%></a>
    </nav>
    <form id="logout_form" action="logout" method="post">
        <button class="btn btn-outline-primary"  type="submit" onclick="signup()">Sign up</button>
    </form>
</div>



</div>

<script type="text/javascript" src="static/js/swfobject.js"></script>
<script type="text/javascript" src="static/js/ParsedQueryString.js"></script>
<script type="text/javascript">
    function signup() {

        logout_form = document.getElementById('logout_form');
        logout_form.submit();
    }

    var player = null;

    function loadStream(url) {
        player.setMediaResourceURL(url);
    }

    function getlink(url) {
        return "/index?src=" + encodeURIComponent(url);
    }

    function jsbridge(playerId, event, data) {
        if (player == null) {
            player = document.getElementById(playerId);
        }
        switch (event) {
            case "onJavaScriptBridgeCreated":
                listStreams(teststreams, "streamlist");
                break;
            case "timeChange":
            case "timeupdate":
            case "progress":
                break;
            default:
                console.log(event, data);
        }
    }

    // Collect query parameters in an object that we can
    // forward to SWFObject:

    var pqs = new ParsedQueryString();
    var parameterNames = pqs.params(false);
    var parameters = {
        src:"rtmp://183.175.12.160:1935/live/stream",
        //src:"rtmp://127.0.0.1/live/test",
        //src: "rtmp://pull-g.kktv8.com/livekktv/100987038",
        autoPlay: "true",
        verbose: true,
        controlBarAutoHide: "true",
        controlBarPosition: "bottom",
        poster: "images/poster.png",
        javascriptCallbackFunction: "jsbridge",
        plugin_hls: "static/flashlsOSMF.swf",
        hls_minbufferlength: -1,
        hls_maxbufferlength: 30,
        hls_lowbufferlength: 3,
        hls_seekmode: "KEYFRAME",
        hls_startfromlevel: -1,
        hls_seekfromlevel: -1,
        hls_live_flushurlcache: false,
        hls_info: true,
        hls_debug: false,
        hls_debug2: false,
        hls_warn: true,
        hls_error: true,
        hls_fragmentloadmaxretry: -1,
        hls_manifestloadmaxretry: -1,
        hls_capleveltostage: false,
        hls_maxlevelcappingmode: "downscale"
    };

    for (var i = 0; i < parameterNames.length; i++) {
        var parameterName = parameterNames[i];
        parameters[parameterName] = pqs.param(parameterName) ||
            parameters[parameterName];
    }

    var wmodeValue = "direct";
    var wmodeOptions = ["direct", "opaque", "transparent", "window"];
    if (parameters.hasOwnProperty("wmode")) {
        if (wmodeOptions.indexOf(parameters.wmode) >= 0) {
            wmodeValue = parameters.wmode;
        }
        delete parameters.wmode;
    }

    // Embed the player SWF:
    swfobject.embedSWF(
        "static/GrindPlayer.swf"
        , "GrindPlayer"
        , 640
        , 480
        , "10.1.0"
        , "expressInstall.swf"
        , parameters
        , {
            allowFullScreen: "true",
            wmode: wmodeValue
        }
        , {
            name: "GrindPlayer"
        }
    );

</script>

<div class="container">
    <div class="row">
        <div class="col-sm">
            <div id="GrindPlayer">
                <p>
                    Alternative content
                </p>
            </div>
        </div>
        <div class="col-sm">
            <div class="card mb-3 box-shadow">
                <div class="card-header text-center">
                    <h4 class="my-0 font-weight-normal">控制台</h4>
                </div>
                <div class="card-body text-center">
                    <h2 class="card-title pricing-card-title" style="margin-top: 50px;">进站访客：<a><%=session.getServletContext().getAttribute("onlineCount")%><a/>
                        <small class="text-muted">/ 人次</small>
                    </h2>
                    <div style="margin-top: 30px;"></div>
                    <h2 class="card-title pricing-card-title" style="margin-top: 20px;" >人流统计：<a id="number">0</a>
                        <small class="text-muted">/ 人次</small>
                    </h2>
                    <%--<button id="peopleNumber">点击请求人流统计人数</button>--%>

                    <div style="margin-top: 90px;"></div>
                    <h3>请选择播放通道:</h3>
                    <div class="btn-group" role="group" aria-label="...">
                        <button onclick="set_channel(0)" type="button" class="btn btn-default">监控服务器源</button>
                        <button onclick="set_channel(1)" type="button" class="btn btn-default">内网服务器源</button>
                        <button onclick="set_channel(2)" type="button" class="btn btn-default">公网服务器端</button>
                    </div>
                    <div style="margin-top: 10px;"></div>
                    <button type="button" class="btn btn-lg btn-block btn-primary" onclick="userSubmit()">
                        重新加载页面
                    </button>
                </div>
            </div>
        </div>

    </div>

    <hr>
    <h2 style="text-align: center" >人流统计数据分析</h2>
    <br>
    <br>
    <div >
    <div id="main_left" style="margin-left:150px; width: 800px;height:400px;"></div>

    <div id="main_right" style="margin-left:150px; width: 800px;height:400px; margin-top: 30px"></div>
        <br>
        <br>
    </div>


<footer class="pt-4 my-md-5 pt-md-5 border-top" style="clear: both; margin-top: 40px;">
    <div class="row">
        <div class="col-12 col-md">
            <small class="d-block mb-3 text-muted">Copyright &copy;2018 <a href="http://zhangpeng.ai/">zhangpeng.ai</a>
            </small>
        </div>
        <div class="col-6 col-md">
            <h5>行人检测</h5>
            <ul class="list-unstyled text-small">
                <li><a class="text-muted">实时检测</a></li>
                <li><a class="text-muted">深度学习</a></li>
                <li><a class="text-muted">Fast R-CNN</a></li>
                <li><a class="text-muted">MobileNet</a></li>
            </ul>
        </div>
        <div class="col-6 col-md">
            <h5>人流统计</h5>
            <ul class="list-unstyled text-small">
                <li><a class="text-muted" href="#">精确</a></li>
                <li><a class="text-muted" href="#">高效</a></li>
                <li><a class="text-muted" href="#">快速</a></li>
            </ul>
        </div>
        <div class="col-6 col-md">
            <h5>About</h5>
            <ul class="list-unstyled text-small">
                <li><a class="text-muted" href="http://zhangpeng.ai/">Team</a></li>
                <li><a class="text-muted" href="https://github.com/zhangpengpengpeng">GitHub</a></li>
                <li><a class="text-muted" href="#">Privacy</a></li>
            </ul>
        </div>
    </div>
</footer>
</div>
<p>

    <!-- 为ECharts准备一个具备大小（宽高）的Dom -->


    <script type="text/javascript">
        // 基于准备好的dom，初始化echarts实例
        var myChart = echarts.init(document.getElementById('main_right'));

        var data_temp = <%=session.getAttribute("monthnum")%>

        option = {
            title : {
                text: '大数据量人流统计（月视图）',
                subtext: '',
                x:'center'
            },
            tooltip : {
                trigger: 'item',
                formatter: "{a} <br/>{b} : {c} ({d}%)"
            },
            legend: {
                x : 'center',
                y : 'bottom',
                data:['1月','2月','3月','4月','5月','6月','7月','8月', '9月', '10月', '11月', '12月']
            },
            toolbox: {
                show : true,
                feature : {
                    mark : {show: true},
                    dataView : {show: true, readOnly: false},
                    magicType : {
                        show: true,
                        type: ['pie', 'funnel']
                    },
                    restore : {show: true},
                    saveAsImage : {show: true}
                }
            },
            calculable : true,
            series : [

                {
                    name:'月人流统计表示',
                    type:'pie',
                    radius : [50, 150],
                    center : ['50%', '50%'],
                    roseType : 'area',
                    data:[
                        {value:data_temp[0], name:'1月'},
                        {value:data_temp[1], name:'2月'},
                        {value:data_temp[2], name:'3月'},
                        {value:data_temp[3], name:'4月'},
                        {value:data_temp[4], name:'5月'},
                        {value:data_temp[5], name:'6月'},
                        {value:data_temp[6], name:'7月'},
                        {value:data_temp[7], name:'8月'},
                        {value:data_temp[8], name:'9月'},
                        {value:data_temp[9], name:'10月'},
                        {value:data_temp[10], name:'11月'},
                        {value:data_temp[11], name:'12月'}
                    ]
                }
            ]
        };


        // 使用刚指定的配置项和数据显示图表。
        myChart.setOption(option);
    </script>


    <script type="text/javascript">
        var myChart = echarts.init(document.getElementById('main_left'));

        var base = +new Date(2018, 11, 1); // 得到月份减1，显示12月，应该写11月
        var oneDay = 24 * 3600;
        var date = [];

        var data =  <%=session.getAttribute("daynum")%>; //得到一个月的数据,根据月份*1000 31000

        for (var i = 1; i < 31*1000; i++) { // 判断是该月多少天
            var now = new Date(base += oneDay);
            date.push([now.getFullYear(), now.getMonth() + 1, now.getDate()].join('/'));
            data.push(Math.round((Math.random() - 0.5) * 20 + data[i - 1]));
        }

        option = {
            tooltip: {
                trigger: 'axis',
                position: function (pt) {
                    return [pt[0], '10%'];
                }
            },
            title: {
                left: 'center',
                text: '大数据量人流统计（日统计）',
            },
            toolbox: {
                feature: {
                    dataZoom: {
                        yAxisIndex: 'none'
                    },
                    restore: {},
                    saveAsImage: {}
                }
            },
            xAxis: {
                type: 'category',
                boundaryGap: false,
                data: date
            },
            yAxis: {
                type: 'value',
                boundaryGap: [0, '100%']
            },
            dataZoom: [{
                type: 'inside',
                start: 0,
                end: 10
            }, {
                start: 0,
                end: 10,
                handleIcon: 'M10.7,11.9v-1.3H9.3v1.3c-4.9,0.3-8.8,4.4-8.8,9.4c0,5,3.9,9.1,8.8,9.4v1.3h1.3v-1.3c4.9-0.3,8.8-4.4,8.8-9.4C19.5,16.3,15.6,12.2,10.7,11.9z M13.3,24.4H6.7V23h6.6V24.4z M13.3,19.6H6.7v-1.4h6.6V19.6z',
                handleSize: '80%',
                handleStyle: {
                    color: '#fff',
                    shadowBlur: 3,
                    shadowColor: 'rgba(0, 0, 0, 0.6)',
                    shadowOffsetX: 2,
                    shadowOffsetY: 2
                }
            }],
            series: [
                {
                    name:'日统计',
                    type:'line',
                    smooth:true,
                    symbol: 'none',
                    sampling: 'average',
                    itemStyle: {
                        color: 'rgb(255, 70, 131)'
                    },
                    areaStyle: {
                        color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{
                            offset: 0,
                            color: 'rgb(255, 158, 68)'
                        }, {
                            offset: 1,
                            color: 'rgb(255, 70, 131)'
                        }])
                    },
                    data: data
                }
            ]
        };

        // 使用刚指定的配置项和数据显示图表。
        myChart.setOption(option);
    </script>

    <script type="text/javascript">
        function userSubmit() {
            window.location.reload()
        }
    </script>


    <script>
        function reloadView(){
            $.ajax({
                type: "post",
                async: true,
                url: "/PeopleDetection/getPeopleNumber",
                success:function (data) {
                    $("#number").html(data);
                },
                error: function (jqObj) {
                    console.log(jqObj.status)
                }
            });
        }
        setInterval('reloadView()', 2000); //每2秒刷新一次页面下边显示的数据
        
        Holder.addTheme('thumb', {
            bg: '#55595c',
            fg: '#eceeef',
            text: 'Thumbnail'
        });
    </script>

    <script>
        function set_channel(x) {
            $.ajax({
                url: '/PeopleDetection/set_channel',
                type: 'GET',
                data: 'use_channel=' + x,
                async: true,
                cache: false,
                contentType: false,
                processData: false,
                success: function (returndata) {
                    alert('切换成功！');
                },
                error: function (returndata) {
                    alert('请求发送失败');
                }
            });
        }
    </script>
</body>
</html>

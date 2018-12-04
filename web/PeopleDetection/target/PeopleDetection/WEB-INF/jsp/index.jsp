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

</head>
<body>
<script type="text/javascript" src="static/js/jquery-2.2.4.min.js"></script>
<script src="static/js/bootstrap.min.js"></script>
<script src="static/js/holder.min.js"></script>
<script src="static/js/popper.min.js"></script>
<div class="d-flex flex-column flex-md-row align-items-center p-3 px-md-4 mb-3 bg-white border-bottom box-shadow">
    <h5 class="my-0 mr-md-auto font-weight-normal">基于行人检测的视频监控系统</h5>
    <nav class="my-2 my-md-0 mr-md-3">

        <a class="p-2 text-dark">Hello!&nbsp;<%=session.getAttribute("username")%></a>
    </nav>
    <form id="logout_form" action="logout" method="post">
        <button class="btn btn-outline-primary"  type="submit" onclick="signup()">Sign up</button>
    </form>
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
<footer class="pt-4 my-md-5 pt-md-5 border-top">
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

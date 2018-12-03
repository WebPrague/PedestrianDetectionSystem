<%--
  Created by IntelliJ IDEA.
  User: ZhangPeng
  Date: 2018/9/11
  Time: 11:48
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; " charset="UTF-8">
    <title>Pedestrian Detection</title>
    <script src="static/js/jquery-2.2.4.min.js"></script>
    <style type="text/css">
        body {
            text-align: center;
            overflow: hidden;
            background: #fff;
        }

        * {
            margin: 0;
            padding: 0;
            font-family: "微软雅黑";
        }

        .form {
            position: absolute;
            top: 50%;
            left: 50%;
            margin-left: -185px;
            margin-top: -210px;
            height: 420px;
            width: 340px;
            font-size: 18px;
            -webkit-box-shadow: 0px 0px 10px #A6A6A6;
            background: #fff;
        }

        .border-btn {
            border-bottom: 1px solid #ccc;
        }

        #landing,
        #registered {
            float: left;
            text-align: center;
            width: 170px;
            padding: 15px 0;
            color: #545454;
        }

        #landing-content {
            clear: both;
        }

        .inp {
            height: 30px;
            margin: 0 auto;
            margin-bottom: 30px;
            width: 200px;
        }

        .inp > input {
            text-align: center;
            height: 30px;
            width: 200px;
            margin: 0 auto;
            transition: all 0.3s ease-in-out;
        }

        .login {
            border: 1px solid #A6A6A6;
            color: #a6a6a6;
            height: 30px;
            width: 202px;
            text-align: center;
            font-size: 13.333333px;
            margin-left: 0px;
            line-height: 30px;
            margin-top: 0px;
            transition: all 0.3s ease-in-out;
        }

        .login:hover {
            background: #A6A6A6;
            color: #fff;
        }

        #bottom {
            margin-top: 30px;
            font-size: 13.333333px;
            color: #a6a6a6;
        }

        #registeredtxt {
            float: left;
            margin-left: 80px;
        }

        #forgotpassword {
            float: right;
            margin-right: 80px;
        }

        #photo {
            border-radius: 80px;
            border: 1px solid #ccc;
            height: 80px;
            width: 80px;
            margin: 0 auto;
            overflow: hidden;
            clear: both;
            margin-top: 30px;
            margin-bottom: 30px;
        }

        #photo > img:hover {
            -webkit-transform: rotateZ(360deg);
            -moz-transform: rotateZ(360deg);
            -o-transform: rotateZ(360deg);
            -ms-transform: rotateZ(360deg);
            transform: rotateZ(360deg);
        }

        #photo > img {
            height: 80px;
            width: 80px;
            -webkit-background-size: 220px 220px;
            border-radius: 60px;
            -webkit-transition: -webkit-transform 1s linear;
            -moz-transition: -moz-transform 1s linear;
            -o-transition: -o-transform 1s linear;
            -ms-transition: -ms-transform 1s linear;
        }

        #registered-content {
            margin-top: 40px;
            display: none;
        }

        .fix {
            clear: both;
        }

        .form {
            display: none;
        }
    </style>
</head>
<body>

<div class="form">
    <div id="landing">登陆</div>
    <div id="registered">注册</div>
    <div class="fix"></div>
    <div id="landing-content">
        <form id="login_form" action="login" method="post" name="login"
              onkeypress="if(event.keyCode==13||event.which==13){login();}">
            <div id="photo"><img src="static/images/detection.png"
                                 style="width: 60px; height: 60px; margin-top: 10px;"></div>
            <div class="inp"><input type="text" name="username" placeholder="用户名"></div>
            <div class="inp"><input type="password" name="password" placeholder="密码"></div>
            <input class="login" type="submit" onclick="login()" value="登录"/>
            <div id="bottom"><span id="registeredtxt">立即注册</span><span id="forgotpassword">忘记密码？</span></div>
        </form>
    </div>
    <div id="registered-content">
        <form id="register_form" action="register" method="post" name="register"
              onkeypress="if(event.keyCode==13||event.which==13){register();}">
            <div class="inp"><input type="text" name="username" placeholder="请输入用户名"></div>
            <div class="inp"><input type="password" name="password" placeholder="请输入密码"></div>
            <div class="inp"><input type="password" name="repeat_password" placeholder="请再次输入密码"></div>
            <div class="inp"><input type="text" name="phonenumber" placeholder="请输入手机号码"></div>
            <input class="login" type="submit" onclick="register()" value="立即注册"/>
        </form>
    </div>
</div>

<canvas id="Mycanvas"></canvas>
<script>


    function login() {
        login_form = document.getElementById('login_form');
        login_form.submit();
    }

    function register() {
        register_form = document.getElementById('register_form');
        register_form.submit();
    }

    $(document).ready(function () {

        $(".form").slideDown(500);

        $("#landing").addClass("border-btn");

        $("#registered").click(function () {
            $("#landing").removeClass("border-btn");
            $("#landing-content").hide(500);
            $(this).addClass("border-btn");
            $("#registered-content").show(500);

        });

        $("#landing").click(function () {
            $("#registered").removeClass("border-btn");
            $(this).addClass("border-btn");

            $("#landing-content").show(500);
            $("#registered-content").hide(500);
        });
    });

    //定义画布宽高和生成点的个数
    var WIDTH = window.innerWidth, HEIGHT = window.innerHeight, POINT = 35;

    var canvas = document.getElementById('Mycanvas');
    canvas.width = WIDTH,
        canvas.height = HEIGHT;
    var context = canvas.getContext('2d');
    context.strokeStyle = 'rgba(0,0,0,0.02)',
        context.strokeWidth = 1,
        context.fillStyle = 'rgba(0,0,0,0.05)';
    var circleArr = [];

    //线条：开始xy坐标，结束xy坐标，线条透明度
    function Line(x, y, _x, _y, o) {
        this.beginX = x,
            this.beginY = y,
            this.closeX = _x,
            this.closeY = _y,
            this.o = o;
    }

    //点：圆心xy坐标，半径，每帧移动xy的距离
    function Circle(x, y, r, moveX, moveY) {
        this.x = x,
            this.y = y,
            this.r = r,
            this.moveX = moveX,
            this.moveY = moveY;
    }

    //生成max和min之间的随机数
    function num(max, _min) {
        var min = arguments[1] || 0;
        return Math.floor(Math.random() * (max - min + 1) + min);
    }

    // 绘制原点
    function drawCricle(cxt, x, y, r, moveX, moveY) {
        var circle = new Circle(x, y, r, moveX, moveY)
        cxt.beginPath()
        cxt.arc(circle.x, circle.y, circle.r, 0, 2 * Math.PI)
        cxt.closePath()
        cxt.fill();
        return circle;
    }

    //绘制线条
    function drawLine(cxt, x, y, _x, _y, o) {
        var line = new Line(x, y, _x, _y, o)
        cxt.beginPath()
        cxt.strokeStyle = 'rgba(0,0,0,' + o + ')'
        cxt.moveTo(line.beginX, line.beginY)
        cxt.lineTo(line.closeX, line.closeY)
        cxt.closePath()
        cxt.stroke();

    }

    //初始化生成原点
    function init() {
        circleArr = [];
        for (var i = 0; i < POINT; i++) {
            circleArr.push(drawCricle(context, num(WIDTH), num(HEIGHT), num(15, 2), num(10, -10) / 40, num(10, -10) / 40));
        }
        draw();
    }

    //每帧绘制
    function draw() {
        context.clearRect(0, 0, canvas.width, canvas.height);
        for (var i = 0; i < POINT; i++) {
            drawCricle(context, circleArr[i].x, circleArr[i].y, circleArr[i].r);
        }
        for (var i = 0; i < POINT; i++) {
            for (var j = 0; j < POINT; j++) {
                if (i + j < POINT) {
                    var A = Math.abs(circleArr[i + j].x - circleArr[i].x),
                        B = Math.abs(circleArr[i + j].y - circleArr[i].y);
                    var lineLength = Math.sqrt(A * A + B * B);
                    var C = 1 / lineLength * 7 - 0.009;
                    var lineOpacity = C > 0.03 ? 0.03 : C;
                    if (lineOpacity > 0) {
                        drawLine(context, circleArr[i].x, circleArr[i].y, circleArr[i + j].x, circleArr[i + j].y, lineOpacity);
                    }
                }
            }
        }
    }

    //调用执行
    window.onload = function () {
        init();
        setInterval(function () {
            for (var i = 0; i < POINT; i++) {
                var cir = circleArr[i];
                cir.x += cir.moveX;
                cir.y += cir.moveY;
                if (cir.x > WIDTH) cir.x = 0;
                else if (cir.x < 0) cir.x = WIDTH;
                if (cir.y > HEIGHT) cir.y = 0;
                else if (cir.y < 0) cir.y = HEIGHT;

            }
            draw();
        }, 16);
    }
</script>
</body>
</html>
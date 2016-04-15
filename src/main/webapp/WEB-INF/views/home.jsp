<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getServerName() + ":"
			+ request.getServerPort() + path + "/";
	String basePath2 = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN"
"http://www.w3.org/TR/html4/strict.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title></title>
<script type="text/javascript" src="<%=basePath2%>resources/jquery.js"></script>
<script type="text/javascript" src="<%=basePath2%>resources/sockjs-0.3.min.js"></script>
<script>
	var path = '<%=basePath%>';
	var uid=${uid eq null?-1:uid};
	if(uid==-1){
		location.href="<%=basePath2%>";
	}
	var from=uid;
	var fromName='${name}';
	var to=uid==1?2:1;

	var socketClient;
	if ('WebSocket' in window) {
		socketClient = new WebSocket("ws://" + path + "/ws?uid="+uid);
	} else if ('MozWebSocket' in window) {
		socketClient = new MozWebSocket("ws://" + path + "/ws"+uid);
	} else {
		socketClient = new SockJS("http://" + path + "/ws/sockjs"+uid);
	}
	socketClient.onopen = function(event) {
		console.log("WebSocket:已连接" + socketClient.protocol);
		console.log(event);
	};
	socketClient.onmessage = function(event) {
		var data=JSON.parse(event.data);
		console.log("WebSocket:收到一条消息",data);
		$("#msgs").text(data);
	};
	socketClient.onerror = function(event) {
		console.log("WebSocket:发生错误 ");
		console.log(event);
	};
	socketClient.onclose = function(event) {
		console.log("WebSocket:已关闭");
		console.log(event);
	}
</script>
</head>
<body>
	欢迎：${sessionScope.name }
	<span id="msgs"></span>
</body>
</html>

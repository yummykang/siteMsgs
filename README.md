# siteMsgs

## 1.用spring websocket做的一个站内信的demon

## 2.使用该技术也可以实现web聊天，或者数据实时更新等类似的功能

## 3.spring websocket的使用的方法

### a.依赖配置，及使用的配置
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-messaging</artifactId>
            <version>4.0.5.RELEASE</version>
        </dependency>
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-websocket</artifactId>
            <version>4.0.5.RELEASE</version>
        </dependency>
        
       使用的配置：
       @Component
       @EnableWebSocket
       public class WebSocketConfig extends WebMvcConfigurerAdapter implements WebSocketConfigurer {
       
       	@Resource
       	MyWebSocketHandler handler;
       
       	public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {
       		registry.addHandler(handler, "/ws").addInterceptors(new HandShake());
       		registry.addHandler(handler, "/ws/sockjs").addInterceptors(new HandShake()).withSockJS();
       	}
       
       }
### b.写对应的消息处理handler,及websocket连接interceptor
        // websocket连接需要实现接口HandshakeInterceptor，类似于socket的握手
        public class HandShake implements HandshakeInterceptor {
        
        	public boolean beforeHandshake(ServerHttpRequest request, ServerHttpResponse response, WebSocketHandler wsHandler, Map<String, Object> attributes) throws Exception {
        		System.out.println("Websocket:用户[ID:" + ((ServletServerHttpRequest) request).getServletRequest().getSession(false).getAttribute("uid") + "]已经建立连接");
        		if (request instanceof ServletServerHttpRequest) {
        			ServletServerHttpRequest servletRequest = (ServletServerHttpRequest) request;
        			HttpSession session = servletRequest.getServletRequest().getSession(false);
        			// 标记用户
        			Long uid = (Long) session.getAttribute("uid");
        			if(uid!=null){
        				attributes.put("uid", uid);
        			}else{
        				return false;
        			}
        		}
        		return true;
        	}
        
        	public void afterHandshake(ServerHttpRequest request, ServerHttpResponse response, WebSocketHandler wsHandler, Exception exception) {
        	}
        
        }
        
        // 消息处理需要实现接口WebSocketHandler
        代码太多就不贴了

### c.前端的连接代码，需要引入sockjs-0.3.min.js，版本的话可以自己定
##### sockjs是用来在前端模拟websocket的，如果浏览器不支持的websocket，sockjs模拟对 WebSocket 的支持,实现浏览器和 Web 服务器之间低延迟、全双工、跨域的通讯通道，不过好像并没有效果如果在ie9下
        var websocket;
        if ('WebSocket' in window) {
            websocket = new WebSocket("ws://" + path + "/ws?uid="+uid);
        } else if ('MozWebSocket' in window) {
            websocket = new MozWebSocket("ws://" + path + "/ws"+uid);
        } else {
            websocket = new SockJS("http://" + path + "/ws/sockjs"+uid);
        }
        websocket.onopen = function(event) {
            console.log("WebSocket:已连接");
            console.log(event);
        };
        websocket.onmessage = function(event) {
            // TODO 具体的业务正理
        };
        websocket.onerror = function(event) {
            console.log("WebSocket:发生错误 ");
            console.log(event);
        };
        websocket.onclose = function(event) {
            console.log("WebSocket:已关闭");
            console.log(event);
        }
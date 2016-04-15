package me.yummykang.websocket.websocket;

import javax.annotation.Resource;

import org.springframework.stereotype.Component;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;
import org.springframework.web.socket.config.annotation.EnableWebSocket;
import org.springframework.web.socket.config.annotation.WebSocketConfigurer;
import org.springframework.web.socket.config.annotation.WebSocketHandlerRegistry;

/**
 * websocket配置，添加监听的地址，前台页面会订阅这两个地址
 *
 * @author demon
 */
@Component
@EnableWebSocket
public class WebSocketConfig extends WebMvcConfigurerAdapter implements WebSocketConfigurer {

	@Resource
	WebSocketMsgsHandler handler;

	public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {
		registry.addHandler(handler, "/ws").addInterceptors(new HandShake());
		registry.addHandler(handler, "/ws/sockjs").addInterceptors(new HandShake()).withSockJS();
	}

}

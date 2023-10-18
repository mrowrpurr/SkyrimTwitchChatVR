#pragma once

#include <_Log_.h>

#include <functional>
#include <thread>
#include <websocketpp/common/connection_hdl.hpp>
#include <websocketpp/config/asio_no_tls.hpp>
#include <websocketpp/server.hpp>

namespace WebSockets {

    typedef websocketpp::server<websocketpp::config::asio> WebSocketServerType;
    typedef WebSocketServerType::message_ptr               WebSocketMessagePtrType;
    typedef WebSocketServerType::message_handler           WebSocketMessageHandlerType;

    class WebSocketServer {
        WebSocketServerType              _server;
        std::thread                      _thread;
        std::function<void(const char*)> _messageHandler;

        void _runBlocking() {
            _server.set_message_handler([&](websocketpp::connection_hdl connection,
                                            WebSocketMessagePtrType     message) {
                auto messageText = message->get_payload();
                _messageHandler(messageText.c_str());
            });

            _server.set_access_channels(websocketpp::log::alevel::all);
            _server.init_asio();
            _server.listen(6969);
            _server.start_accept();
            _server.run();
        }

    public:
        WebSocketServer(std::function<void(const char*)> messageHandler)
            : _messageHandler(messageHandler) {}

        void Run() {
            _thread = std::thread(&WebSocketServer::_runBlocking, this);
            _thread.detach();
        }
    };
}
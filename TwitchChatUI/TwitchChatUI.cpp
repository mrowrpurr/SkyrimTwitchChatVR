#include <RE/Skyrim.h>
#include <SKSE/SKSE.h>

#include <memory>

#include "Logging.h"
#include "WebSocketServer.h"

std::unique_ptr<WebSockets::WebSocketServer> server;

void OnWebSocketMessage(const char* message) {
    _Log_("Received message: {}", message);
    auto*       vm = RE::BSScript::Internal::VirtualMachine::GetSingleton();
    std::string messageText{message};
    auto*       args = RE::MakeFunctionArguments(std::move(message));
    RE::BSTSmartPointer<RE::BSScript::IStackCallbackFunctor> callback{};
    vm->DispatchStaticCall("TwitchChatWidgetManager", "AddChatMessageLine", args, callback);
    delete args;
}

extern "C" __declspec(dllexport) bool SKSEPlugin_Load(const SKSE::LoadInterface* skse) {
    SKSE::Init(skse);
    SetupLog("TwitchChatUI");
    _Log_("Init");
    server = std::make_unique<WebSockets::WebSocketServer>(OnWebSocketMessage);
    server->Run();
    _Log_("Server running");
    return true;
}

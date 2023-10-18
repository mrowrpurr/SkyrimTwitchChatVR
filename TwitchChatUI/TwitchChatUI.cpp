#include <RE/Skyrim.h>
#include <SKSE/SKSE.h>

#include <memory>
#include <sstream>
#include <string>

#include "Logging.h"
#include "WebSocketServer.h"

bool _playerIsInTheGame = false;

std::unique_ptr<WebSockets::WebSocketServer> server;

void SendChatMessageToPapyrus(std::string message, int color = 0xf) {
    // if (!_playerIsInTheGame) {
    //     _Log_("Player is not in the game, not dispatching message: {}", message);
    //     return;
    // }

    _Log_("Sending message: {} (color: {:x})", message, color);
    auto* vm = RE::BSScript::Internal::VirtualMachine::GetSingleton();

    // How to check if VM is ready / Papyrus is running ?

    auto* args = RE::MakeFunctionArguments(std::move(message), std::move(color));
    RE::BSTSmartPointer<RE::BSScript::IStackCallbackFunctor> callback{};
    vm->DispatchStaticCall("MP_TwitchChatAPI", "AddMessage", args, callback);
    delete args;
}

// Comes to us in the format "0x<hex>|<message>"
void OnWebSocketMessage(const char* message) {
    // if (!_playerIsInTheGame) {
    //     _Log_("Player is not in the game, ignoring message: {}", message);
    //     return;
    // }

    std::string messageText{message};  // e.g. "0xffeecc|some text here";
    _Log_("Message received: {}", messageText);

    // Find the position of the '|' character
    size_t pipePos = messageText.find('|');

    if (pipePos != std::string::npos) {
        // Extract the hex string before the '|'
        std::string hexString = messageText.substr(0, pipePos);

        // Check if the hex string starts with "0x"
        if (hexString.substr(0, 2) == "0x") {
            // Convert the hex string to an integer
            int intValue;
            std::istringstream(hexString) >> std::hex >> intValue;

            // Extract the text after the '|'
            std::string restOfString = messageText.substr(pipePos + 1);

            SendChatMessageToPapyrus(restOfString, intValue);
        } else {
            _Log_("Invalid hex format in message: {}", messageText);
        }
    } else {
        _Log_("No '|' character found in the messageText: {}", messageText);
    }
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

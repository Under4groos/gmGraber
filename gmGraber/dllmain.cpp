
#include "pch.h"
#include "dll_import.cpp"
HANDLE atThread;

namespace game_interface {
    ILuaInterface* pClientLuaInterface;
    ILuaInterface* pClientLuaMenuInterface;
    ILuaShared* LuaShared;
    HMODULE LuaShared_modhandle;
    IEngineClient* EngineClient;
    typedef void* (*CreateInterfaceFn)(const char* name, int* returncode);
    CreateInterfaceFn LuaShared_createinter;
}
namespace DLLimport {
    template <typename T>
    T* CaptureInterface(std::string strModule, std::string strInterface)
    {
        typedef T* (*CreateInterfaceFn)(const char* szName, int iReturn);
        CreateInterfaceFn CreateInterface = (CreateInterfaceFn)GetProcAddress(GetModuleHandleA(strModule.c_str()), "CreateInterface");
        return CreateInterface(strInterface.c_str(), 0);
    }
}


void _init() {

    game_interface::EngineClient = DLLimport::CaptureInterface<IEngineClient>("engine.dll", "VEngineClient013");
    game_interface::LuaShared_modhandle = GetModuleHandle(L"lua_shared.dll");
    
    if (game_interface::EngineClient && game_interface::LuaShared_modhandle) {

        typedef void* (*CreateInterfaceFn)(const char* name, int* returncode);
        game_interface::LuaShared_createinter = (CreateInterfaceFn)GetProcAddress(game_interface::LuaShared_modhandle, "CreateInterface");

        if (game_interface::LuaShared_createinter) {


            game_interface::LuaShared = (ILuaShared*)game_interface::LuaShared_createinter(LUASHARED_INTERFACE_VERSION, NULL);
            if (game_interface::LuaShared) {
                game_interface::pClientLuaInterface = game_interface::LuaShared->GetLuaInterface(LuaInterfaceType::LUAINTERFACE_CLIENT);
               // game_interface::pClientLuaMenuInterface = game_interface::LuaShared->GetLuaInterface(LuaInterfaceType::LUAINTERFACE_MENU);
                std::string script = "";

                script += "print(\"inject\")";

                game_interface::pClientLuaInterface->RunString("RunString", "", script.c_str(), true, true);
                 
                MessageBox(
                    NULL,
                    (LPCWSTR)L"inject Cheat",
                    (LPCWSTR)L"inject Cheat",
                    MB_ICONWARNING | MB_CANCELTRYCONTINUE | MB_DEFBUTTON2
                );

              //  game_interface::pClientLuaMenuInterface->RunString("RunString", "", script.c_str(), true, true);
            }
        }
    }
}


BOOL APIENTRY DllMain( HMODULE hModule,
                       DWORD  ul_reason_for_call,
                       LPVOID lpReserved
                     )
{
    switch (ul_reason_for_call)
    {
    case DLL_PROCESS_ATTACH:
        atThread = CreateThread(NULL, 0, (LPTHREAD_START_ROUTINE)_init, NULL, 0, NULL);

         

    case DLL_THREAD_ATTACH:
    case DLL_THREAD_DETACH:

         
        
     /*   if (atThread)
            CloseHandle(atThread);
        FreeLibrary(hModule);*/
        
            
        break;
    case DLL_PROCESS_DETACH:
        break;
    }

    
    return TRUE;
}


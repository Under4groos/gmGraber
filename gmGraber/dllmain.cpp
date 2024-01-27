
#include "pch.h"
#include "dll_import.cpp"
HANDLE atThread;

namespace game_interface {
    ILuaInterface* pClientLuaInterface;
    ILuaShared* LuaShared;
    HMODULE LuaShared_modhandle;
    IEngineClient* EngineClient;
    typedef void* (*CreateInterfaceFn)(const char* name, int* returncode);
    CreateInterfaceFn LuaShared_createinter;
}



void _init() {

    game_interface::EngineClient = DLLimport::CaptureInterface<IEngineClient>("engine.dll", "VEngineClient013");
    game_interface::LuaShared_modhandle = GetModuleHandle(L"lua_shared.dll");
   



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
        if (!CloseHandle(atThread))
            MessageBox(
                NULL,
                (LPCWSTR)L"Uninject Cheat",
                (LPCWSTR)L"Uninject Cheat",
                MB_ICONWARNING | MB_CANCELTRYCONTINUE | MB_DEFBUTTON2
            );

        break;
    case DLL_PROCESS_DETACH:
        break;
    }

    
    return TRUE;
}


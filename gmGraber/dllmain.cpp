
#include "pch.h"
 
HANDLE atThread;
HMODULE hModule;
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


namespace LUA_Console {
    std::string scripts = R"V0G0N(
function file.ReadString( filename, path )

	if ( path == true ) then path = "GAME" end
	if ( path == nil || path == false ) then path = "DATA" end


    if( !file.Exists( filename, path )) then 
        print("File nor fount")
        print( filename )
        return
    end 

	local f = file.Open( filename, "rb", path )
	if ( !f ) then return end

	local str = f:Read( f:Size() )

	f:Close()

	if ( !str ) then str = "" end
	return str

end
concommand.Append = function(remove, name, callback)  

    if(remove) then 
        concommand.Remove( name )
    end 
    concommand.Add( name, callback)
end
concommand.Append(true, "RunFile", function( ply, cmd, args, str )    
    var_ = file.ReadString( "scripts/" ..  args[1], false )
    if(var_) then 
        RunString(var_)  
    end 
end)
)V0G0N";
};

std::string scripts = R"V0G0N(
 
)V0G0N";

void _init() {

    

 
     

    game_interface::EngineClient = DLLimport::CaptureInterface<IEngineClient>("engine.dll", "VEngineClient013");
    game_interface::LuaShared_modhandle = GetModuleHandle(L"lua_shared.dll");
   
    if (game_interface::EngineClient && game_interface::LuaShared_modhandle && game_interface::EngineClient->IsInGame()) {

        typedef void* (*CreateInterfaceFn)(const char* name, int* returncode);
        game_interface::LuaShared_createinter = (CreateInterfaceFn)GetProcAddress(game_interface::LuaShared_modhandle, "CreateInterface");

        if (game_interface::LuaShared_createinter) {
            

            game_interface::LuaShared = (ILuaShared*)game_interface::LuaShared_createinter(LUASHARED_INTERFACE_VERSION, NULL);
            if (game_interface::LuaShared) {
                game_interface::pClientLuaInterface = game_interface::LuaShared->GetLuaInterface(LuaInterfaceType::LUAINTERFACE_CLIENT);
                game_interface::pClientLuaMenuInterface = game_interface::LuaShared->GetLuaInterface(LuaInterfaceType::LUAINTERFACE_MENU);
                

                if (game_interface::pClientLuaMenuInterface) {

                    
                    game_interface::pClientLuaMenuInterface->RunString("RunString", "", "print(\"[UC] Inject\")", true, true);

                    if (game_interface::pClientLuaInterface) {
                        game_interface::pClientLuaInterface->RunString("RunString", "", LUA_Console::scripts.c_str(), true, true);
                    }

                   
                
                }
                
  
                
               
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
        hModule = hModule;
         

    case DLL_THREAD_ATTACH:
    case DLL_THREAD_DETACH:

       
        
       
            
        
        
            
        break;
    case DLL_PROCESS_DETACH:
        break;
    }

    
    return TRUE;
}


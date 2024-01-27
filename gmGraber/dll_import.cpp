

#include <string>
#include "Windows.h"

namespace DLLimport {
    template <typename T>
    T* CaptureInterface(std::string strModule, std::string strInterface)
    {
        typedef T* (*CreateInterfaceFn)(const char* szName, int iReturn);
        CreateInterfaceFn CreateInterface = (CreateInterfaceFn)GetProcAddress(GetModuleHandleA(strModule.c_str()), "CreateInterface");
        return CreateInterface(strInterface.c_str(), 0);
    }
}
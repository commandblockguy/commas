/*
 *--------------------------------------
 * Program Name:
 * Author:
 * License:
 * Description:
 *--------------------------------------
*/

#include <capnhook.h>
#include <fileioc.h>
#include <debug.h>

extern void hook;

#define RAM_START ((void*)0xD00000)
#define PRGM_ADDR ((void*)0xD1A87F)

#define HOOK_ID 0x000910

int main(int argc, const char **argv)
{
    if(!argc) return 1;

    // It's time to reflect upon one of the great mysteries of life
    // How does one find themselves?
    ti_var_t slot = ti_OpenVar(argv[0], "r", TI_PRGM_TYPE);
    if(!slot) return 1;
    void *self = ti_GetDataPtr(slot);
    if(!self) return 1;
    ti_Close(slot);
    // It's that simple.

    if(self >= RAM_START) {
        // Sometimes you find yourself in RAM.
        // RAM is a terrible place to be, let's not be there.
        return 1;
    }

    dbg_printf("Program at %p, running at %p, hook at %p/%p\n", self, PRGM_ADDR, &hook - PRGM_ADDR + self, &hook);

    hook_error_t err;
    bool was_enabled = false;

    err = hook_IsEnabled(HOOK_ID, &was_enabled);
    dbg_printf("Err %u checking hook status\n", err);

    if (was_enabled) {
        err = hook_Disable(HOOK_ID);
        dbg_printf("Err %u disabling hook\n", err);
    } else {
        err = hook_Install(HOOK_ID, &hook - PRGM_ADDR + self, 0, HOOK_TYPE_HOMESCREEN, 5, "Comma display hook");
        dbg_printf("Err %u installing hook at %p\n", err, &hook - PRGM_ADDR + self);
    }

    hook_Sync();

    return 0;
}

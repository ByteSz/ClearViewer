#ifndef SDL_build_config_mingw_h_
#define SDL_build_config_mingw_h_

//SDL's Windows config assumes the Windows SDK, so disable the features whose headers MinGW does not ship
#include <build_config/SDL_build_config_windows.h>

#undef HAVE_GAMEINPUT_H
#undef SDL_JOYSTICK_GAMEINPUT
#undef HAVE_WINDOWS_GAMING_INPUT_H
#undef SDL_JOYSTICK_WGI

#endif

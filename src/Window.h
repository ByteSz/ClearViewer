#pragma once

//App headers
#include "Settings.h"

//Forward declarations
struct SDL_Window;
union SDL_Event;

namespace ClearViewer
{
	//State of a single SDL window
	struct WindowData
	{
		SDL_Window* handle = nullptr;
		bool closeRequested = false;
	};

	namespace Window
	{
		//Creates an SDL window from the given settings
		bool Create(WindowData& window, const WindowSettings& settings);

		//Updates the window state from an SDL event
		void HandleEvent(WindowData& window, const SDL_Event& event);

		//Destroys the SDL window if it exists
		void Destroy(WindowData& window);
	}
}
